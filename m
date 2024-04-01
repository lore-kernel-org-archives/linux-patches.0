Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4A7C129;
	Mon,  1 Apr 2024 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988621; cv=none; b=bIhgQPIaQsuzi9fxueM4iRnv3p5bsQ3+Y42Ujo5qXhnR8iHiAdmBrg+skiakyrneCoWm4LfM8JKDYBBWmj6KBIpyjRbG3JSljZ6PCLDjnKzL5442xNwtyMrB/dmTcJE+s7w/8AHaMyeb76AAIT3JtWDIndz6qPQ7xvf4ZuTw6Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988621; c=relaxed/simple;
	bh=QiWjT8XiyoM+onmgaGnGI7YLoD3jh09QPBF1h7jl8sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwtDeAddpbljPwhRjkjASz0l1nTWrmZwgiIKrqWjeRUTrHMgB200wYmSb2NBTOILMZu5b/Mpe2i3fUuq/2sC6ZiW0XLSb4z/Bipv2Hz2FVvNZr+ucVfn/HbKNPDHh3np/9iK4/ZHck2ric88tp/v4ZKa+OwotZqQtd2Li5G9o+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKrMoqj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKrMoqj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF24CC433C7;
	Mon,  1 Apr 2024 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988621;
	bh=QiWjT8XiyoM+onmgaGnGI7YLoD3jh09QPBF1h7jl8sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKrMoqj2/+mG0aZRlzSsvLdMPrGtvi3wc/YkjbpBBmKEegCrOGHm0ZeIBB+EiCt2Y
	 rpC3131O3YTVHMFYHgCmpy6rSaDmz5P2wX+1kCgjcvemHlJvypL+VTpkRUHr3wasvP
	 igsWirmvBriqtg0oYfWN9qpE0lHsWfiR/PMe+fJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.7 240/432] crypto: rk3288 - Fix use after free in unprepare
Date: Mon,  1 Apr 2024 17:43:47 +0200
Message-ID: <20240401152600.296074022@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c0afb6b88fbbc177fa322a835f874be217bffe45 upstream.

The unprepare call must be carried out before the finalize call
as the latter can free the request.

Fixes: c66c17a0f69b ("crypto: rk3288 - Remove prepare/unprepare request")
Reported-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -332,12 +332,12 @@ static int rk_hash_run(struct crypto_eng
 theend:
 	pm_runtime_put_autosuspend(rkc->dev);
 
+	rk_hash_unprepare(engine, breq);
+
 	local_bh_disable();
 	crypto_finalize_hash_request(engine, breq, err);
 	local_bh_enable();
 
-	rk_hash_unprepare(engine, breq);
-
 	return 0;
 }
 


