Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A52233159;
	Mon, 10 Mar 2025 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627958; cv=none; b=Wj46WroSSMXqrUMPxDGOUkicmYiPogzFszwnm4VtZqAx7VxCf6Y06dpZZzhfqh08fVydGw+xICs1si14HOydJdzb4XcDkFmYbDeIRFUFC5ofRu5ZkM7JXaen5N68Vu2VIz2o2/G5q2e4YQ0TNxiv5YjfhBp1eUqSb/Op6h2cuxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627958; c=relaxed/simple;
	bh=XLJAH5nto5cRRu6zWihz3EZg0Kd8+F5njsmWg8z5Ltg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=but0CBjPSmFvau+iFOYzGQzDBaXJzhkZQKiAfeeqFNBRZCZiETYAExIUQe3LZX0/WgvyHbxrkfE0N4kS8wX29EsRnFiQiAK18PEBvp75TIm3MUwJxmovXKIndS5BR3LjKXT8H6EvIf6XodJvQsriozwDW/cDh0yhfnubUDZum44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr4CWvyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr4CWvyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DE3C4CEED;
	Mon, 10 Mar 2025 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627958;
	bh=XLJAH5nto5cRRu6zWihz3EZg0Kd8+F5njsmWg8z5Ltg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr4CWvyBQxp+jlrKj66+bfcXDImzf82ONmrloozb7fEIs3DKFQE7TeS3Zsa1xilvL
	 NAWDCPX3I38IiVVxb++45BAWzZUOnRj3aBAT6EZn59LPHwNIXHL3I25ABjr8P22TQp
	 UF7xOE/kzaYYQAakur0JRAqOYsrFd4T9q9BxRZBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 039/145] hwmon: (peci/dimmtemp) Do not provide fake thresholds data
Date: Mon, 10 Mar 2025 18:05:33 +0100
Message-ID: <20250310170436.312846426@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


