Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED231DFFB;
	Thu, 15 Aug 2024 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732517; cv=none; b=uB1Zi3fxDf6z9WqwUawp3AM72O9Iz6nqfgs+JTU1bqMFUSbDZOW3e9UEk8vLQBtN0u3bccpqLjRzoVrQDd4jTUl1//J27hjfuE2dxy8QQrYrw/QlJMY9NX/yTyVMOzljx9yX8BhKHr+6M4cOLvagdxWeQ88ickttKJw+ZOYNeU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732517; c=relaxed/simple;
	bh=10jqKBjSgVyT92RxEa9I7bSQmq2xF0ipyWZnpcuCkps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdDRCkmPgN2iKjFwcTJLHmyC5ioGslEnx6Zkfg34QD77yS89sqFwAXKmLkGSsa6XtZHEJXg50L5eel1+97fnOD7Pf4lJNHhDxqcgm8rfsFgOjdNjXooI+44Tz8KAWrnQwjpnKNDHtuUUnuP+NQSr0s7oP5Ox8QIsmaYUYTrtD5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn9tZdxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn9tZdxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEF0C32786;
	Thu, 15 Aug 2024 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732517;
	bh=10jqKBjSgVyT92RxEa9I7bSQmq2xF0ipyWZnpcuCkps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn9tZdxvsF9+JWQNo/VzvUjnEYAPDQIyQjQh2cra+4V4x8AD+74M/sQc3tCoZOOSB
	 fd9hWgKklWIMtdJ+kAqMjiXJBhdPtCTbtFZiyXvs9GiuoymxmPhJBODsWnYaKEJYsU
	 ZINGcw1RPLS391XNg8XnTP8m8xjAUtkKtdggWup0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/352] mISDN: Fix a use after free in hfcmulti_tx()
Date: Thu, 15 Aug 2024 15:24:29 +0200
Message-ID: <20240815131927.122243066@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 61ab751451f5ebd0b98e02276a44e23a10110402 ]

Don't dereference *sp after calling dev_kfree_skb(*sp).

Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/8be65f5a-c2dd-4ba0-8a10-bfe5980b8cfb@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4c5b6772562dc..a0697d64aab3c 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -1931,7 +1931,7 @@ hfcmulti_dtmf(struct hfc_multi *hc)
 static void
 hfcmulti_tx(struct hfc_multi *hc, int ch)
 {
-	int i, ii, temp, len = 0;
+	int i, ii, temp, tmp_len, len = 0;
 	int Zspace, z1, z2; /* must be int for calculation */
 	int Fspace, f1, f2;
 	u_char *d;
@@ -2152,14 +2152,15 @@ hfcmulti_tx(struct hfc_multi *hc, int ch)
 		HFC_wait_nodebug(hc);
 	}
 
+	tmp_len = (*sp)->len;
 	dev_kfree_skb(*sp);
 	/* check for next frame */
 	if (bch && get_next_bframe(bch)) {
-		len = (*sp)->len;
+		len = tmp_len;
 		goto next_frame;
 	}
 	if (dch && get_next_dframe(dch)) {
-		len = (*sp)->len;
+		len = tmp_len;
 		goto next_frame;
 	}
 
-- 
2.43.0



