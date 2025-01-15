Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9A11F9F41;
	Wed, 15 Jan 2025 10:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938747; cv=none; b=e+GIW60ApamXXWAlIS746hsiQMcvdLkCczbwKI7NwquQSbcqcrcFbVTzxfnZ5Otk/e7iZuG2yPrPmA5SDoICrmyE/GILlE/Ky4R5CYR86pHFYO7AxGgBa9BE1IeDR1M2BJRlDjuo/uLpgcGG8FL6Ghr0+bobQaQd61lx+oiIQUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938747; c=relaxed/simple;
	bh=9+Ob+Bz4Aime04RSB8msp7eJwNZJXPMarnoD4ju+Q10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkyvWFImQDEtvjpUJ/yH7d0Qucid2zrXKNHLN2Dc6CTAVo/802/qCGaKkLjg6Hfy289Tmhw+PypgCxfYxlWnSjDnrLZBu8om0C7lzu3NLyPo8TnOm4B9dyam8PeBKpBAnPuHjN1Du46N11S2zSYBh1FMErjpo22ToO61ZXxXA7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKdjOIZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKdjOIZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD89C4CEDF;
	Wed, 15 Jan 2025 10:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938746;
	bh=9+Ob+Bz4Aime04RSB8msp7eJwNZJXPMarnoD4ju+Q10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKdjOIZAnVHfDxfoStSFWD33gtggoQKdABODdr6vcqXU0OHkMORYa1hMaid3mEmXJ
	 2VO+FfOYVv9kzbJNRNuzu8z5wr8xBxKnI1FK7SjU/HfhCdfDzrLh68UfZlSvo5qs/i
	 bGSz7ohT8mzUO4EaF8ZfqSab099eAbWfdv5PD0ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 085/129] usb: dwc3: gadget: fix writing NYET threshold
Date: Wed, 15 Jan 2025 11:37:40 +0100
Message-ID: <20250115103557.749618526@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -451,6 +451,7 @@
 #define DWC3_DCTL_TRGTULST_SS_INACT	(DWC3_DCTL_TRGTULST(6))
 
 /* These apply for core versions 1.94a and later */
+#define DWC3_DCTL_NYET_THRES_MASK	(0xf << 20)
 #define DWC3_DCTL_NYET_THRES(n)		(((n) & 0xf) << 20)
 
 #define DWC3_DCTL_KEEP_CONNECT		BIT(19)
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4208,8 +4208,10 @@ static void dwc3_gadget_conndone_interru
 		WARN_ONCE(DWC3_VER_IS_PRIOR(DWC3, 240A) && dwc->has_lpm_erratum,
 				"LPM Erratum not available on dwc3 revisions < 2.40a\n");
 
-		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A))
+		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A)) {
+			reg &= ~DWC3_DCTL_NYET_THRES_MASK;
 			reg |= DWC3_DCTL_NYET_THRES(dwc->lpm_nyet_threshold);
+		}
 
 		dwc3_gadget_dctl_write_safe(dwc, reg);
 	} else {


