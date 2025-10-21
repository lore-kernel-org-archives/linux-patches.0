Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC672749DC;
	Tue, 21 Oct 2025 19:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076490; cv=none; b=q96hc5eYCBzZor58dMbwMYLhrGzGBLinjWYvewjol+ct3Ag8ZCtQiSjCZROhfMUKZPOKz6bLGTH6KlPlYN8gKLUUBTbrr/oZvTMtimHeCboMFzfpoc7Jee0HDLUIQngcYQFbEKqYESXYawijN3+1lPSHiiCPPsExbfed/b273s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076490; c=relaxed/simple;
	bh=6pZzjieTnjvSem/glb3XK7kG4UmsO+0OEH2hokZgbmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcFAUvVX9FVAIRWBJTktY/XOD3SjfuNoPFwDgLxEMMrdS8+1rKKnGdUWdEGe0PL1zVvoC1eId3b+tLaity0OFFFdmdMP4p1wgk/0LrFhIuHEXHjQJlg10k6kTkMV5hoJkuBCbRdIXF7hoAW6i/089Q9zA/6AbSvbetjY5Cyv9tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD2YWJlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD2YWJlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F401DC4CEF1;
	Tue, 21 Oct 2025 19:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076489;
	bh=6pZzjieTnjvSem/glb3XK7kG4UmsO+0OEH2hokZgbmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OD2YWJlFe2nLwL27ljpg4qajVFOdydB8EJuSu+r9a24rbkyvQNZRQ62qxueY1HDgo
	 /gjUZh/W4LdP7Ldbtkot33zAE1aHIMRNgzYL2Cb1U9qUuEQTnyMrAtTTLftYrXFjCj
	 0kmCYkfUoiVGMFJNLeOSxgBFApUcxLLen8eFDEvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/105] tls: wait for pending async decryptions if tls_strp_msg_hold fails
Date: Tue, 21 Oct 2025 21:50:57 +0200
Message-ID: <20251021195022.823800236@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b8a6ff84abbcbbc445463de58704686011edc8e1 ]

Async decryption calls tls_strp_msg_hold to create a clone of the
input skb to hold references to the memory it uses. If we fail to
allocate that clone, proceeding with async decryption can lead to
various issues (UAF on the skb, writing into userspace memory after
the recv() call has returned).

In this case, wait for all pending decryption requests.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/b9fe61dcc07dab15da9b35cf4c7d86382a98caf2.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d3bf2dbc297ae..6ea557ebab171 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1637,8 +1637,10 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 
 	if (unlikely(darg->async)) {
 		err = tls_strp_msg_hold(&ctx->strp, &ctx->async_hold);
-		if (err)
-			__skb_queue_tail(&ctx->async_hold, darg->skb);
+		if (err) {
+			err = tls_decrypt_async_wait(ctx);
+			darg->async = false;
+		}
 		return err;
 	}
 
-- 
2.51.0



