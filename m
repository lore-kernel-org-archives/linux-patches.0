Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49F643DA56;
	Tue, 16 Jun 2026 15:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622979; cv=none; b=khVZSDOXkyJbKKkgSEMIWqUWXEmhf7D2/4v0JIMpRKWB0+CKdPTHF5Kfi8YN8vU8hwxLaV0ouvxNPIPIdeVz62JBd0wukGvGa/BsfeKeb2oH1qDnYEtzUc79J8cIJE/5xuKwoLPmZcrnlf72T1KGVELHtyjAEkNcZwvOwLnWTws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622979; c=relaxed/simple;
	bh=FH+Bpg34dxsiKk/ut7ahbxLkuzBwxn5zvIZTG5jbImU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHd3+HmASAxsbdxog1FUoyaN4flBZWM9cnw90ilFDkeF9UYm9FsVIK7Sew4JFpaJzsAFRvz4N+45KJ/wbuc5vE9eh3mXph6ykDInAEm6JZ8/hQu1suqCcpznL+O37UVXhWfp96KQywnGnFDolUO3WkXaB4zkL651KACoUnSxLjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVRSLWqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVRSLWqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96211F00A3D;
	Tue, 16 Jun 2026 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622978;
	bh=bcMnjSkIPr/lirGiFQ2BE8EKdCcb8S+R/ezVm3ZjIUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVRSLWqRC6WsbZZCuezTnMYoOKVNnM3TDOBdSuaGAXhaq+WLzKo53WWMfL5o0sNlk
	 0RtWxNtP7VQPszjM2rp8HzYWfPaT9hGdKE3R8liYej69JRQymrPka7ndxr8X1ocbvM
	 vgio2ydkCw00qu1eYCP+0yLMulu9ZnOn8s6Z0NNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Geffon <bgeffon@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 064/378] sctp: validate cached peer INIT chunk length in COOKIE_ECHO processing
Date: Tue, 16 Jun 2026 20:24:55 +0530
Message-ID: <20260616145113.386211152@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 0861615c28de668669d748ef4eb913ea9262d13b ]

When a listening SCTP server processes a COOKIE_ECHO chunk, the cached
peer INIT chunk embedded after the cookie is parsed and its parameters
are later walked by sctp_process_init() using sctp_walk_params().

However, the chunk header length of this cached INIT chunk was not
validated against the remaining buffer in the COOKIE_ECHO payload. If
the length field is inflated, the parameter walk can run beyond the
actual received data, leading to out-of-bounds reads and potential
memory corruption during later parameter handling (e.g. STATE_COOKIE
processing and kmemdup() copies).

Add a bounds check in sctp_unpack_cookie() to ensure the cached INIT
chunk length does not exceed the available data in the COOKIE_ECHO
buffer before it is used.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/eb60825fa22d6f9e663c7d4dbb69f397b5d34d42.1780362366.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 2c0017d058d409..9014b095f52ddb 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1730,6 +1730,7 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sctp_signed_cookie *cookie;
 	struct sk_buff *skb = chunk->skb;
 	struct sctp_cookie *bear_cookie;
+	struct sctp_chunkhdr *ch;
 	enum sctp_scope scope;
 	unsigned int len;
 	ktime_t kt;
@@ -1759,6 +1760,10 @@ struct sctp_association *sctp_unpack_cookie(
 	cookie = chunk->subh.cookie_hdr;
 	bear_cookie = &cookie->c;
 
+	ch = (struct sctp_chunkhdr *)(bear_cookie + 1);
+	if (ntohs(ch->length) > len - fixed_size)
+		goto malformed;
+
 	/* Verify the cookie's MAC, if cookie authentication is enabled. */
 	if (sctp_sk(ep->base.sk)->cookie_auth_enable) {
 		u8 mac[SHA256_DIGEST_SIZE];
-- 
2.53.0



