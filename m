Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640A21A3029;
	Tue, 21 Oct 2025 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077437; cv=none; b=rqP573HpDGuGCcA66Ucoqn5EJ/xuxirQmfJbMDjo6QaeRKmzIgTIQ7rtgXemIRnMREX5ll7pUdmakHSngrf7VNwokyymHuv8XglVch4khMu+bIiyPDJ/b++R2rHPMXhnp+hUDOd5CUUNHk2euo3uamF76sWD5XTy/907/OmO0hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077437; c=relaxed/simple;
	bh=aCn26m7nvRcf3yqLmIrFgSfHUH0lioQ497g1YsSvQsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odzfGHeiAC4M6asTUNHJ1nIZB+63872HRyC26nZDClvWbr8mVN2KYGliDaU5dhH6aIoRukXqFd3JEhU+2HiaL1DSmhKWMj6Dwr+X7Ym2GCrjKVARAPAOOVD5RTNoZU+rBLtCsbwnqMvqK5oLPvcsi3B/R6IGmbzddReWbdcl6b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JHf8pGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JHf8pGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58F2C4CEF1;
	Tue, 21 Oct 2025 20:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077437;
	bh=aCn26m7nvRcf3yqLmIrFgSfHUH0lioQ497g1YsSvQsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JHf8pGokK9APLpXFIkJ9g1dFX+lFfzqLSaxQg9E/boJ9DtA7DwXVTr1B195c+o31
	 sOky88KCnA8NwCBs+PlFzPkdv/MSyV1X1bMFx7269xMVUWbBd+iM5sTXMzcdoqBiKw
	 Y4uDmeD/52MspjGCpe6pQC97lNOccr6WqE/KRKWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 088/159] tls: wait for pending async decryptions if tls_strp_msg_hold fails
Date: Tue, 21 Oct 2025 21:51:05 +0200
Message-ID: <20251021195045.304563825@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1478d515badc8..e3d852091e7a4 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1641,8 +1641,10 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 
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



