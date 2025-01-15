Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4012248BA1;
	Wed, 15 Jan 2025 10:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937798; cv=none; b=p/+Ww2mTrVuKqIyAHzsgPQ4UT7YnBO/0ttJAXpRiIsZykxd2RCYj5h6M/27GpJm6GpEV9GsjX84kq4yHhhroZTrYuIUP1ZcsOzWe3DXoSpmUDCHGZkOfP0p4O4Rx/z5iYCFHLHVKTQ4sSfToQbX3jKNibUoTlSCv8K5gQn4VNQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937798; c=relaxed/simple;
	bh=fFI6iVDEGFIUW3oSTkLkVgvUIRHsd07viSBQEsY0cTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXGhrHP71WKgBbZ9EZPe8tEEkbpDkPhfX2Gz2FK1ZClGPGsbXHm4zpgpYzKSmZc0+Jpwa8AOPMx86i8qKIjYnjdqqyt8GNuSyibIDKe5uFVeyB05UuOKPkXhZ9A76oCD+S1cc0jpqImnPAKKlTd44aGzqzU5tYtrqyGGTEA4mOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vitUL/Qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vitUL/Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD52C4CEE1;
	Wed, 15 Jan 2025 10:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937797;
	bh=fFI6iVDEGFIUW3oSTkLkVgvUIRHsd07viSBQEsY0cTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vitUL/Qum0doZfnaSqlcfuG/jgXgZDq9ns15MCzQh0nuYrHgXsYixIUD/cyp0LBSU
	 km6BmC5NOE2EH0cDPDzGH5g64+5tiUhoqYGg8iRjnab87JBM9iVtJw2Y/isHtUylgm
	 99YPGyHkoCwIi5du369QTzVCiwPWwdUy4XlGmwoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 58/92] usb: dwc3: gadget: fix writing NYET threshold
Date: Wed, 15 Jan 2025 11:37:16 +0100
Message-ID: <20250115103549.876433273@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -447,6 +447,7 @@
 #define DWC3_DCTL_TRGTULST_SS_INACT	(DWC3_DCTL_TRGTULST(6))
 
 /* These apply for core versions 1.94a and later */
+#define DWC3_DCTL_NYET_THRES_MASK	(0xf << 20)
 #define DWC3_DCTL_NYET_THRES(n)		(((n) & 0xf) << 20)
 
 #define DWC3_DCTL_KEEP_CONNECT		BIT(19)
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4056,8 +4056,10 @@ static void dwc3_gadget_conndone_interru
 		WARN_ONCE(DWC3_VER_IS_PRIOR(DWC3, 240A) && dwc->has_lpm_erratum,
 				"LPM Erratum not available on dwc3 revisions < 2.40a\n");
 
-		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A))
+		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A)) {
+			reg &= ~DWC3_DCTL_NYET_THRES_MASK;
 			reg |= DWC3_DCTL_NYET_THRES(dwc->lpm_nyet_threshold);
+		}
 
 		dwc3_gadget_dctl_write_safe(dwc, reg);
 	} else {


