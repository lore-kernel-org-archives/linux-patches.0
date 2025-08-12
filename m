Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36F72FDC30;
	Tue, 12 Aug 2025 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026101; cv=none; b=BgCShWjCznjRobRm2f0scnksfEn1uTnSx88WaRGV2rIx/yY9Xllo0kB6zwCCnbMrI/gjdKi0qX+NB6/Dxj+DhIIIDTY3xqSkorG7F4O5xI1ClznIOpvd0MvD+5ACjnR09ASL+53dMmIhSuKoRl6skEckAT36/hnZfwkvgwp0UFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026101; c=relaxed/simple;
	bh=SW6DhHdJfC93t4L82tqpOxP9+s+AWjzXWeusaI2hnO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXPKjRVsXykoce7IMp9B+bmzxFYbAECRIy7+VBJJLNPZwMTpnnhC6YWfb5erjfH/GZVRHj0FAeY10aU+A80or1vwmS22LbydmMWSzzKNzRBFcYTXofTW8Veoio6ImDuucYJnGDjRwqHvrnnvU1pywtCXT6mpEvgg56T8CKwSPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woAqDkSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woAqDkSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BE6C4CEF0;
	Tue, 12 Aug 2025 19:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026100;
	bh=SW6DhHdJfC93t4L82tqpOxP9+s+AWjzXWeusaI2hnO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woAqDkSEUg5iX0+Zp7rq4NDTVUklyJjcFWBnb7mRd3FRinsAXyH72nWmEGv2VjsfD
	 tzvKkmDWjvDqQGD2CRD0YO4xjkcKSui8wDA4lmPtxqj2ENvrtIiExtWO7fREbZa2XC
	 rVt5JBgPx6glS6huXRE32Bi5vJQK+P21QDzbzw3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 237/480] power: supply: cpcap-charger: Fix null check for power_supply_get_by_name
Date: Tue, 12 Aug 2025 19:47:25 +0200
Message-ID: <20250812174407.226021833@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit d9fa3aae08f99493e67fb79413c0e95d30fca5e9 ]

In the cpcap_usb_detect() function, the power_supply_get_by_name()
function may return `NULL` instead of an error pointer.
To prevent potential null pointer dereferences, Added a null check.

Fixes: eab4e6d953c1 ("power: supply: cpcap-charger: get the battery inserted infomation from cpcap-battery")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20250519024741.5846-1-hanchunchao@inspur.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index 13300dc60baf..d0c3008db534 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -689,9 +689,8 @@ static void cpcap_usb_detect(struct work_struct *work)
 		struct power_supply *battery;
 
 		battery = power_supply_get_by_name("battery");
-		if (IS_ERR_OR_NULL(battery)) {
-			dev_err(ddata->dev, "battery power_supply not available %li\n",
-					PTR_ERR(battery));
+		if (!battery) {
+			dev_err(ddata->dev, "battery power_supply not available\n");
 			return;
 		}
 
-- 
2.39.5



