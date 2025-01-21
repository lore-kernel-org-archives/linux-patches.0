Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D761F543D;
	Tue, 21 Jan 2025 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482892; cv=none; b=C3GPe+g63U3g3i62pZgwL9jhgR+UwS+AAWZa4XAW32AW17H1G9B8AFZpalJf9VpOci6Q3KZx5SnTj1GyYUFycdNISJQOny1Y7OeCZR/JEvpzMLjwckJ2TJrxRhlQEBgvEbs2U9/ThoCDjRb5vzXVlYGhCF9kUEhPAuIWC+EgkKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482892; c=relaxed/simple;
	bh=IC9TMpPX4pO+H0gTsV9yGEjoQvHiXffJ+581PPFUR0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sStkpSJ/T29QEhxisjV7siM0YTsAZhEI8/aOlQa7pVcvo90RetpndvPs3pYffOABwhKJIWW/CpTUw4jTbLqwVufxsv3i114x73N76tWFa85szDSXoYmTeMKHcLlaOyESOnJzQ/rfV6Kx8hd4mERmwEf/jg+NfV74/8CzMACgxek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiQKdcd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiQKdcd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B6AC4CEDF;
	Tue, 21 Jan 2025 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482892;
	bh=IC9TMpPX4pO+H0gTsV9yGEjoQvHiXffJ+581PPFUR0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiQKdcd4ZRr75EqAn4AT5e+KusmHC3O/UGkJ40cFHtT8HjzismsEGYQR3hIGaFGPc
	 qcm80SfoDEvGUM/UhSNMwmGDDbHTyuU1/supKA7Fzwwy7DunYbxisahCA80AwZ+mbV
	 4BD4LedAhfLH6QC4yprEklQkEdodF2Fw5Ti1+Z5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 045/127] usb: dwc3: gadget: fix writing NYET threshold
Date: Tue, 21 Jan 2025 18:51:57 +0100
Message-ID: <20250121174531.411617229@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -430,6 +430,7 @@
 #define DWC3_DCTL_TRGTULST_SS_INACT	(DWC3_DCTL_TRGTULST(6))
 
 /* These apply for core versions 1.94a and later */
+#define DWC3_DCTL_NYET_THRES_MASK	(0xf << 20)
 #define DWC3_DCTL_NYET_THRES(n)		(((n) & 0xf) << 20)
 
 #define DWC3_DCTL_KEEP_CONNECT		BIT(19)
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4004,8 +4004,10 @@ static void dwc3_gadget_conndone_interru
 		WARN_ONCE(DWC3_VER_IS_PRIOR(DWC3, 240A) && dwc->has_lpm_erratum,
 				"LPM Erratum not available on dwc3 revisions < 2.40a\n");
 
-		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A))
+		if (dwc->has_lpm_erratum && !DWC3_VER_IS_PRIOR(DWC3, 240A)) {
+			reg &= ~DWC3_DCTL_NYET_THRES_MASK;
 			reg |= DWC3_DCTL_NYET_THRES(dwc->lpm_nyet_threshold);
+		}
 
 		dwc3_gadget_dctl_write_safe(dwc, reg);
 	} else {


