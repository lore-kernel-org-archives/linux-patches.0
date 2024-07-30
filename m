Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585AF1A76A5;
	Tue, 30 Jul 2024 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360675; cv=none; b=ccEXA3T9QcBt78XuDY1K9r5Lawp7Z7lfxCm4t8QYdotPJF0ovB5dIUBSpn/qpK0Zihod4Xe2OJU5yr6NoOQckWZvjp/EI2EyIOACqVBFsMlxAdz4DIElGqMSkwlyIqcHwVtYR/DMJW6PUisj4iqyfsp8/28sff2Yb2RcOcafr+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360675; c=relaxed/simple;
	bh=Nf02E0T8RQVFKXu3DizHUgC/I0cxIPKIQQpIW0aItxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxQJ/if0chm0Ok0+ouQBtfknUOYarPA8FA49xVzFdcxM7iMEvI+2u+m/AShfaktrgCCqzz6JrOUpBs2tG9C6ubDO74stJ9YT0YGWz5vHW9Phv91iH1Mtga3pVuStF+2t8wEJKpitLj1oJ6kYtGbbnITNDz+wdIEVTBYAa8OANRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daAB/wVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daAB/wVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6EEC32782;
	Tue, 30 Jul 2024 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360675;
	bh=Nf02E0T8RQVFKXu3DizHUgC/I0cxIPKIQQpIW0aItxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daAB/wVupauPxVbVHCXcrucPTu6SstnRZ8kN4bzHLg6a65X5TqasZQKQhysNF9nfz
	 Xg4jPQGDmLw/wTDIGO20GIeFVsgJUa2WZD1s1EitNFFB1UgGsBV2ZZ4ROY01IcDosn
	 Y0IVz9zrrsfupeGyQwFLIfZDRplChWRZasdvejzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 773/809] mISDN: Fix a use after free in hfcmulti_tx()
Date: Tue, 30 Jul 2024 17:50:49 +0200
Message-ID: <20240730151755.500832827@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2e5cb9dde3ec5..44383cec1f47a 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -1900,7 +1900,7 @@ hfcmulti_dtmf(struct hfc_multi *hc)
 static void
 hfcmulti_tx(struct hfc_multi *hc, int ch)
 {
-	int i, ii, temp, len = 0;
+	int i, ii, temp, tmp_len, len = 0;
 	int Zspace, z1, z2; /* must be int for calculation */
 	int Fspace, f1, f2;
 	u_char *d;
@@ -2121,14 +2121,15 @@ hfcmulti_tx(struct hfc_multi *hc, int ch)
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



