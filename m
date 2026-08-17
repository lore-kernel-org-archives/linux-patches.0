Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A0F303C97;
	Mon, 17 Aug 2026 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975940; cv=none; b=f6NALYaROq3Li+izTXNyJtjaj1XAvSYT/1tJ9E38+vJwa7nof+sCj/ZEJEPXGLd09OUiq09fyO+kccCrIMwMe+cmcWI6li7pZQd4meQ2JQcgn8YCFbr5gsEH9N++SkuzqiNphHYfFVkSlD1azeDVvds9AWpn4mLEj8KimTcAHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975940; c=relaxed/simple;
	bh=M1nsz+W1in7NXtXS0p2pyvHVGIvphsH7/AVep4ankYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbOi7vy5zbnifx4SFSpSx7JylOJCbXh6g0lLjBi3RRlws+uMYWZkYQoPcfWc3ZtOrv38IUJgXYuaK3W1K1xLijpERktNdSZ8ATC6IEJAkK/LPLU6hUP5o1t0VAxpxPqLimSnGOxqEyO8e3vM1fzC+dhUvK/gOhYd4cOTf+cHJs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/O+Iqc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/O+Iqc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD7F1F000E9;
	Mon, 17 Aug 2026 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975939;
	bh=cn2FW8YHTQN1oR61FzU8MRgM36lpC7FPsUoSY2bXLZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/O+Iqc68qaPQC1JX6gnCITgQuPoNQ2oIw+3f7e2xLPGo7+xyCbEdOECwKvUIEnOw
	 2tVA5RAiLzJS+qaAdmBjzQHipHcO3td2mLfPRuhrjG8SoQjeCOJkxONtcg2cRCW2J5
	 g9g4YrcpFdwxeJgeFHARarqoyW9VZEZXPIdhoZ58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Wengang Wang <wen.gang.wang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/389] tls: separate no-async decryption request handling from async
Date: Mon, 17 Aug 2026 15:30:41 +0200
Message-ID: <20260817132547.091935110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit 41532b785e9d79636b3815a64ddf6a096647d011 upstream.

If we're not doing async, the handling is much simpler. There's no
reference counting, we just need to wait for the completion to wake us
up and return its result.

We should preferably also use a separate crypto_wait. I'm not seeing a
UAF as I did in the past, I think aec7961916f3 ("tls: fix race between
async notify and socket close") took care of it.

This will make the next fix easier.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/47bde5f649707610eaef9f0d679519966fc31061.1709132643.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1732e3549a578..29650fa546664 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -257,18 +257,21 @@ static int tls_do_decryption(struct sock *sk,
 					  tls_decrypt_done, skb);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
+		DECLARE_CRYPTO_WAIT(wait);
+
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  crypto_req_done, &ctx->async_wait);
+					  crypto_req_done, &wait);
+
+		ret = crypto_aead_decrypt(aead_req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			ret = crypto_wait_req(ret, &wait);
+		return ret;
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
-	if (ret == -EINPROGRESS) {
-		if (async)
-			return ret;
-
-		ret = crypto_wait_req(ret, &ctx->async_wait);
-	}
+	if (ret == -EINPROGRESS)
+		return ret;
 
 	if (async)
 		atomic_dec(&ctx->decrypt_pending);
-- 
2.53.0



