Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AFA442131;
	Thu, 30 Jul 2026 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423994; cv=none; b=iW6t/oVyYDyoK2VLsOAcimcwuYbpKZdoT6oB9VC3dccWRpTTFv+6I9If3K50ZnHW5lX6MIZscu+ej/on/FXqjEwsp6pAn88gDxXDNew7nUKkLq8Gg/gpIJ7wQAmIIqOdJALUmTr1be+7wJv2ihJjjTbbnxeJE282PaxB2WPtyQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423994; c=relaxed/simple;
	bh=Zcoayn9w/oO6/YSZUzMu06NLv520gPJkRM8qMYZnK40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxUnJ6vsLyqZdt1cOHksnXqu7+f0S+NHqWkepLp825PQFGsDz2eOBMCIp/C9U77FSoYXu+QGl7WnqGaqrEwKRsJxV+DAAniJoXDPe+1RcYLLUeMPGg2aHXDpaTkQxpxkrBCWYgUYCRKWPWDV7UgaAB/67bRk6bUlGwvzvzVWDto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtfJAPCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtfJAPCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7801F000E9;
	Thu, 30 Jul 2026 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423993;
	bh=Nik2aRO66UGbHXrGzIw/CpR1a3dh/8kqPOzPKB4W/N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtfJAPCYwIZqEc2FRONNvrwW30TT2IxvcG4kPLEDa4g9Qgg7eYjc5wbM53YL5CT+L
	 pKhGFwb2GlgrC3/VKt3K72m1fhXSh7r3MQ2VvVWfM36HcJMxD58SnH0Iqo5QKIJiuW
	 +BTBj65XQLYHRqbhqH1RS760E9NaD5MMwn8JA8FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/675] sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid
Date: Thu, 30 Jul 2026 16:09:28 +0200
Message-ID: <20260730141450.194018786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HanQuan <eilaimemedsnaimel@gmail.com>

[ Upstream commit ff04b26794a16a8a879eb4fd2c02c2d6b03850e9 ]

sctp_auth_ep_add_chunkid() uses SCTP_NUM_CHUNK_TYPES (20) as the
capacity limit for ep->auth_chunk_list, allowing it to hold up to
20 chunk entries (param_hdr.length up to 24). However, the copy
destination asoc->c.auth_chunks in struct sctp_cookie is only
SCTP_AUTH_MAX_CHUNKS (16) entries (20 bytes). When more than 16
chunks are added, sctp_association_init() memcpy overflows the
destination by up to 4 bytes.

Fix by using SCTP_AUTH_MAX_CHUNKS as the capacity limit, matching
the destination capacity.

Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260713032021.3491702-1-zhoujian.zja@antgroup.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 82aad477590e2e..fbbfa0c2795523 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -672,7 +672,7 @@ int sctp_auth_ep_add_chunkid(struct sctp_endpoint *ep, __u8 chunk_id)
 	/* Check if we can add this chunk to the array */
 	param_len = ntohs(p->param_hdr.length);
 	nchunks = param_len - sizeof(struct sctp_paramhdr);
-	if (nchunks == SCTP_NUM_CHUNK_TYPES)
+	if (nchunks == SCTP_AUTH_MAX_CHUNKS)
 		return -EINVAL;
 
 	p->chunks[nchunks] = chunk_id;
-- 
2.53.0



