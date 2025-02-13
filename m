Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EB116B3A1;
	Thu, 13 Feb 2025 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460335; cv=none; b=fNVUrWF0EJQ1riDzcOPeZggFVh9i+ZSvaUHqs+lpmCYUgJnzzKnl+ZkOW1uRFshw1ZeufzWNqnKfdKZ2mpYDp1cdSkB6XmjA68h5zGb3SatD2Pc7zxPiBlmt0kypgGA6vSDhuGYBo7wYLOIvj83NzwX4JsQYj8VP65SsfDzmstw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460335; c=relaxed/simple;
	bh=QpGrt/tKq2QwHcq982sxfspEid7knGvgbKQ6VWTqYgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGGEi8J1v+n2/xPqlCyrgHtVcjEt1FyTls9WKE1C4wo9JXcPxKTkSeStZBDTmygvcs0GLcLo1iJwo3XSBu6XU2CL2jgNahsF6UueyDQRp8rbs//87fG6P77c58c/w3XiXihPQRdcHIdrEp4pITpFmk1vrFWznvwi2noS4nNTByY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8R8Bngk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8R8Bngk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07AFC4CED1;
	Thu, 13 Feb 2025 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460335;
	bh=QpGrt/tKq2QwHcq982sxfspEid7knGvgbKQ6VWTqYgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8R8BngkkiewpyjMGgXUOS7OGB8ToyzkGnvMgrhBxln08ACCeHt4NOIH1E3WGbSM1
	 uUqlxWGqruab/mGhnxeQJJeHBx3h5qPqVvkeCxvRPtQVS6CAYMX7kcFRrNKfIfrdeJ
	 NajrGFxUt7OO+3bHh8ZnvnE1BS8mieoESrBj/alg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 082/273] leds: lp8860: Write full EEPROM, not only half of it
Date: Thu, 13 Feb 2025 15:27:34 +0100
Message-ID: <20250213142410.586428799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 0d2e820a86793595e2a776855d04701109e46663 upstream.

I struggle to explain dividing an ARRAY_SIZE() by the size of an element
once again. As the latter equals to 2, only the half of EEPROM was ever
written. Drop the unexplainable division and write full ARRAY_SIZE().

Cc: stable@vger.kernel.org
Fixes: 7a8685accb95 ("leds: lp8860: Introduce TI lp8860 4 channel LED driver")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20241114101402.2562878-1-alexander.sverdlin@siemens.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp8860.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/leds/leds-lp8860.c
+++ b/drivers/leds/leds-lp8860.c
@@ -265,7 +265,7 @@ static int lp8860_init(struct lp8860_led
 		goto out;
 	}
 
-	reg_count = ARRAY_SIZE(lp8860_eeprom_disp_regs) / sizeof(lp8860_eeprom_disp_regs[0]);
+	reg_count = ARRAY_SIZE(lp8860_eeprom_disp_regs);
 	for (i = 0; i < reg_count; i++) {
 		ret = regmap_write(led->eeprom_regmap,
 				lp8860_eeprom_disp_regs[i].reg,


