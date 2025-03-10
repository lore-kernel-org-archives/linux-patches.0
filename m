Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCC422154C;
	Mon, 10 Mar 2025 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627332; cv=none; b=GfXPswlx3uylf4Omt3qVdDV23gjdVHSQhVrxfGbb3SIW7CvcsGAB8g9RHvfa/QFTirGL60cB1bVey+Ts5/bHR7Ff7ttBHGINgtpCeRkKcymlAahyeFpzk9FhFPKphRQ2suq5wj9EOx+KK0Iad/M801FLbH1WsoOCakuHzPwIjbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627332; c=relaxed/simple;
	bh=gSbG8uCcllxKbVIa+rRvv4NBWSYZa4oPOK1DxVySQAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2mmBP5i/qIv1LaOC8R26itEjsrVBxAj53IzjXJz8aidVdTk+L0keldU9yXMjJZs/vlBGAm+1+7KR1ZpHM79tJST9+hDtqMBARmKvtdOw6Ldd+4khlXkustAdbiR40LpPX+Pvgkj5HfEL6ATtZDep871fk8EgoMe/VodUN9GDrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSZHnoPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSZHnoPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1BDC4CEE5;
	Mon, 10 Mar 2025 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627332;
	bh=gSbG8uCcllxKbVIa+rRvv4NBWSYZa4oPOK1DxVySQAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSZHnoPS9Yaid37CwU4mHPvwdWpi8sSKBOq3qamG4R5ZfLiHLjzRH1R0mWSA66e4v
	 dWJbJ2KhgIrRPzh41isT8oCBfrpinQE7F56BtuUbvw+2+pFhpMJGpithVSD1EiD3yT
	 JWVC9C4ZuSXIBTWNP+crcxiKxOK9oDCz5XgglbBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 094/269] hwmon: (peci/dimmtemp) Do not provide fake thresholds data
Date: Mon, 10 Mar 2025 18:04:07 +0100
Message-ID: <20250310170501.457779521@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Fertser <fercerpav@gmail.com>

commit 5797c04400ee117bfe459ff1e468d0ea38054ab4 upstream.

When an Icelake or Sapphire Rapids CPU isn't providing the maximum and
critical thresholds for particular DIMM the driver should return an
error to the userspace instead of giving it stale (best case) or wrong
(the structure contains all zeros after kzalloc() call) data.

The issue can be reproduced by binding the peci driver while the host is
fully booted and idle, this makes PECI interaction unreliable enough.

Fixes: 73bc1b885dae ("hwmon: peci: Add dimmtemp driver")
Fixes: 621995b6d795 ("hwmon: (peci/dimmtemp) Add Sapphire Rapids support")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20250123122003.6010-1-fercerpav@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/peci/dimmtemp.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/peci/dimmtemp.c
+++ b/drivers/hwmon/peci/dimmtemp.c
@@ -127,8 +127,6 @@ static int update_thresholds(struct peci
 		return 0;
 
 	ret = priv->gen_info->read_thresholds(priv, dimm_order, chan_rank, &data);
-	if (ret == -ENODATA) /* Use default or previous value */
-		return 0;
 	if (ret)
 		return ret;
 
@@ -509,11 +507,11 @@ read_thresholds_icx(struct peci_dimmtemp
 
 	ret = peci_ep_pci_local_read(priv->peci_dev, 0, 13, 0, 2, 0xd4, &reg_val);
 	if (ret || !(reg_val & BIT(31)))
-		return -ENODATA; /* Use default or previous value */
+		return -ENODATA;
 
 	ret = peci_ep_pci_local_read(priv->peci_dev, 0, 13, 0, 2, 0xd0, &reg_val);
 	if (ret)
-		return -ENODATA; /* Use default or previous value */
+		return -ENODATA;
 
 	/*
 	 * Device 26, Offset 224e0: IMC 0 channel 0 -> rank 0
@@ -546,11 +544,11 @@ read_thresholds_spr(struct peci_dimmtemp
 
 	ret = peci_ep_pci_local_read(priv->peci_dev, 0, 30, 0, 2, 0xd4, &reg_val);
 	if (ret || !(reg_val & BIT(31)))
-		return -ENODATA; /* Use default or previous value */
+		return -ENODATA;
 
 	ret = peci_ep_pci_local_read(priv->peci_dev, 0, 30, 0, 2, 0xd0, &reg_val);
 	if (ret)
-		return -ENODATA; /* Use default or previous value */
+		return -ENODATA;
 
 	/*
 	 * Device 26, Offset 219a8: IMC 0 channel 0 -> rank 0


