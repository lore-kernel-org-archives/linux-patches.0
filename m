Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD96F3F3265;
	Mon, 17 Aug 2026 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977192; cv=none; b=pPhjb8n2VA/aA5WE8QHIUSbD4m5XsT4g9+T0MAwxHzKko/3q+IxR5dBOv8OD4E/M8HNtAsDoYG1vXKrS2/21nrr3T9BeGBVO141l9q7THyf9z9JwPEzgeN6V6hJqqEDEI+FNID/Vmr65XNP6jKrQrZpP+VUSw4vf/6vSe9zI+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977192; c=relaxed/simple;
	bh=5T8JOK4yE4yvzrtnPL/3Oa3fUxR+9pU/T6Ab+xBu7Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB60/d4t5SSN/INQ1UMOh+MDMjJdzpOrF1rCB9aGChBHD8XLEJIm/NcEDzOafui99Q35rB5ju+sxkg0L++07iajXzGmGU02bfwqFZqyNzune6Mac+vJ5D2gwjPoznf6BbGqqp+0SeSus0Z4yOhI6x4adk60mfPDHX0twk5T6NDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2ggxCKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2ggxCKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6D61F000E9;
	Mon, 17 Aug 2026 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977191;
	bh=0L1A20SVU+33DACMU1LIn5uFh5j8tb5NoPIwcr5jWq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2ggxCKzEw8j8TnIx12KvHq6gEJFSBJNxh1YIENWt3FaGNlg54xBPGIGOwOjq+NW3
	 J0b5gf0p19QnN0OZtQ3uGX5xT29orWERe8EDlSkH4oRRpMgSgmuCx6eIli0CgejEbJ
	 kgEsKSdJah/SoBfb9bliEo7EU5qTtGXQfNtBiHzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Wengang Wang <wen.gang.wang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/456] tls: separate no-async decryption request handling from async
Date: Mon, 17 Aug 2026 15:30:35 +0200
Message-ID: <20260817132549.665551573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/tls/tls_sw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 389597bd7ae52..0cdc9131aff22 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -278,9 +278,15 @@ static int tls_do_decryption(struct sock *sk,
 		BUILD_BUG_ON_INVALID(atomic_read(&ctx->decrypt_pending) < 1);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
+		DECLARE_CRYPTO_WAIT(wait);
+
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  crypto_req_done, &ctx->async_wait);
+					  crypto_req_done, &wait);
+		ret = crypto_aead_decrypt(aead_req);
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			ret = crypto_wait_req(ret, &wait);
+		return ret;
 	}
 
 	ret = crypto_aead_decrypt(aead_req);
@@ -289,10 +295,7 @@ static int tls_do_decryption(struct sock *sk,
 		ret = ret ?: -EINPROGRESS;
 	}
 	if (ret == -EINPROGRESS) {
-		if (darg->async)
-			return 0;
-
-		ret = crypto_wait_req(ret, &ctx->async_wait);
+		return 0;
 	} else if (darg->async) {
 		atomic_dec(&ctx->decrypt_pending);
 	}
-- 
2.53.0



