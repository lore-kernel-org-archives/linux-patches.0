Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAD21E7C27;
	Thu, 30 Jan 2025 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247055; cv=none; b=u0t4DSWmfN+A8pBWfpjup9ieDVEZz1erlMbwR3SSES2GK3rYytS/RrdOVfwWxwTW95eG+MZsSkEdk9S6F/LIaQ5rT9go15smru3nwnLd3O1T0CfeuVEmo29zM+dH/4G2Zgrv9/FoZH2EtVknkm6QKAhKnH6/PtEuy7d0+yP18n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247055; c=relaxed/simple;
	bh=UHs4XaAuTEXkM2kVeoO+svMYGTNUw6xjHPmipYQkcuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3sXRiTXnlgOn5FBGpY24XevjVrm0Z8YT8J4DtWwWkjWO4cYG5JMapsSwoRZg9jagCJIko1OYbT5dBy8p9EGTjiYGZh9qM36fxW7sznr2cYWtbtBv1I0fP27ZKCyvR1uRIIPiKOGdn+hczaRKaXVjCDsLZ70kTB2pNjJRrndTZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJtA7f2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJtA7f2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74514C4CED2;
	Thu, 30 Jan 2025 14:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247054;
	bh=UHs4XaAuTEXkM2kVeoO+svMYGTNUw6xjHPmipYQkcuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJtA7f2auncJ0VNP5FMb+C39ey9x7D/4hM2o1BohC1kx3p8y3YVThE69HnGXhQ3cn
	 w3U/TuLLnmcsm1nQB/I07FAjkY3CKcQzNiqrAveC9F7B2L59HMnipXbSx3NnI7wTPs
	 wsTMIlwiBMeyxb2e83OfNlKlYONDvobB3gwc9t8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 036/133] usb: dwc3: gadget: fix writing NYET threshold
Date: Thu, 30 Jan 2025 15:00:25 +0100
Message-ID: <20250130140143.960132479@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 01ea6bf5cb58b20cc1bd159f0cf74a76cf04bb69 upstream.

Before writing a new value to the register, the old value needs to be
masked out for the new value to be programmed as intended, because at
least in some cases the reset value of that field is 0xf (max value).

At the moment, the dwc3 core initialises the threshold to the maximum
value (0xf), with the option to override it via a DT. No upstream DTs
seem to override it, therefore this commit doesn't change behaviour for
any upstream platform. Nevertheless, the code should be fixed to have
the desired outcome.

Do so.

Fixes: 80caf7d21adc ("usb: dwc3: add lpm erratum support")
Cc: stable@vger.kernel.org # 5.10+ (needs adjustment for 5.4)
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20241209-dwc3-nyet-fix-v2-1-02755683345b@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h   |    1 +
 drivers/usb/dwc3/gadget.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -422,6 +422,7 @@
 #define DWC3_DCTL_TRGTULST_SS_INACT	(DWC3_DCTL_TRGTULST(6))
 
 /* These apply for core versions 1.94a and later */
+#define DWC3_DCTL_NYET_THRES_MASK	(0xf << 20)
 #define DWC3_DCTL_NYET_THRES(n)		(((n) & 0xf) << 20)
 
 #define DWC3_DCTL_KEEP_CONNECT		BIT(19)
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3519,8 +3519,10 @@ static void dwc3_gadget_conndone_interru
 		WARN_ONCE(DWC3_VER_IS_PRIOR(DWC3, 240A) && dwc->has_lpm_erratum,
 				"LPM Erratum not available on dwc3 revisions < 2.40a\n");
 
-		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A))
+		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A)) {
+			reg &= ~DWC3_DCTL_NYET_THRES_MASK;
 			reg |= DWC3_DCTL_NYET_THRES(dwc->lpm_nyet_threshold);
+		}
 
 		dwc3_gadget_dctl_write_safe(dwc, reg);
 	} else {


