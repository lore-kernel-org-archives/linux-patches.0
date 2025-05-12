Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4E2989A9;
	Mon, 12 May 2025 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073286; cv=none; b=eqpxbLbw529cl0qALrJLOrmbghLQlaFV72XKtQ6kHD0WifXQBPL81axviWmt3AHgu9KJQ+ogDeqPbAg9OBBUx+NJ6lihYdkqbgqQ8frBV/Xnbo8mhrJ1AVW0zk47/t+i0vrsghxdFhbHAH4GZ4HVq/nhCI6mHHDc4faIFP23XOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073286; c=relaxed/simple;
	bh=u6lGgCsx1G6FYZ2eIsyQL4uQo+uHj94WICm5VMZitH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2wzQV/YLpxCbukloiYa0uoWJY6W024ENDFHq07zXlznrguKZeBEbWLZePOBXTBBETcF8NuIKseL1d62aOX3RYikawSV27sQDCxPovVMvnDMjj295YG9Z7ehRD7FHvx4x1Q9ywJe/9GS2MfFA2t3RFwxaSytsl4HSrFTxLp+qUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A76DLptX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A76DLptX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648C1C4CEE7;
	Mon, 12 May 2025 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073285;
	bh=u6lGgCsx1G6FYZ2eIsyQL4uQo+uHj94WICm5VMZitH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A76DLptXNxXRFcLmQD3NnC3fr7PZ5JfV89n89X10gWDr5FhZxmzQXJXOK0sIMvxlh
	 lFxO7j7dt8zInd8M/Ufw7C+XrlPrEQ6TiKa6PtbcS2l7eHLg8is8VetQ8Jca4WchqX
	 PqCfLlP/VYMX7X7TjuDJvDuVri46FcyYduq+E5Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Bisson <bisson.gary@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 028/113] Input: mtk-pmic-keys - fix possible null pointer dereference
Date: Mon, 12 May 2025 19:45:17 +0200
Message-ID: <20250512172028.826499196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

From: Gary Bisson <bisson.gary@gmail.com>

commit 11cdb506d0fbf5ac05bf55f5afcb3a215c316490 upstream.

In mtk_pmic_keys_probe, the regs parameter is only set if the button is
parsed in the device tree. However, on hardware where the button is left
floating, that node will most likely be removed not to enable that
input. In that case the code will try to dereference a null pointer.

Let's use the regs struct instead as it is defined for all supported
platforms. Note that it is ok setting the key reg even if that latter is
disabled as the interrupt won't be enabled anyway.

Fixes: b581acb49aec ("Input: mtk-pmic-keys - transfer per-key bit in mtk_pmic_keys_regs")
Signed-off-by: Gary Bisson <bisson.gary@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/mtk-pmic-keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/mtk-pmic-keys.c
+++ b/drivers/input/keyboard/mtk-pmic-keys.c
@@ -147,8 +147,8 @@ static void mtk_pmic_keys_lp_reset_setup
 	u32 value, mask;
 	int error;
 
-	kregs_home = keys->keys[MTK_PMIC_HOMEKEY_INDEX].regs;
-	kregs_pwr = keys->keys[MTK_PMIC_PWRKEY_INDEX].regs;
+	kregs_home = &regs->keys_regs[MTK_PMIC_HOMEKEY_INDEX];
+	kregs_pwr = &regs->keys_regs[MTK_PMIC_PWRKEY_INDEX];
 
 	error = of_property_read_u32(keys->dev->of_node, "power-off-time-sec",
 				     &long_press_debounce);


