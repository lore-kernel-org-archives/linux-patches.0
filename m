Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87293281349;
	Thu, 13 Feb 2025 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457614; cv=none; b=Gkqvu6d5kNFq6M2Y5Ga/vdfEzB7y7zIibV3YKNFRUMuGM9emOmJP8bVS+Sgp0bfmgHXvOu4isY7EU10aIy9d1HoKhiG/p7Ei0dNvBe9emryWGCRaEz4sAqyy7tVhQhcLs591dHgHSr8ZwnZPSu3i3dxjJ2C0xjXtzfVnIhJWV5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457614; c=relaxed/simple;
	bh=b7UfQI6+FIOT92qgxHABajcrvofAc7S4nhyF1GqE8ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYaTWVTnq7Ks5aM32mSlbOwwuuctCxCb5tK558GBGBBK1hDt6CEZ4vubWVGT5MacqnifGmzQ4ZECpSq/19QdkdMhG6QctuW7zE28zAzz717/n5/rAyNZIFjp+kFZqm2TtcDXoL6JcCV+ifiVzsAHQuSGiUQmNDH2haD3k3gp9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uksfspkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uksfspkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9894C4CED1;
	Thu, 13 Feb 2025 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457614;
	bh=b7UfQI6+FIOT92qgxHABajcrvofAc7S4nhyF1GqE8ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uksfspkdgNuE7J3NhbnaTUzBp8ROahdi+6Bm+IdqwRF7vXVvlmR+8kOV3Lnrc+Ex8
	 Gr6Fn7jsSyh9LH92HiWBI6ylS3hCLysogP3J1oLdpKDbf6mkDRsASnEBC4+2yFRTF9
	 8kfg4YwzG4lLAAiA1R3lSIVScPaSpg5D2nrrVyfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 130/422] leds: lp8860: Write full EEPROM, not only half of it
Date: Thu, 13 Feb 2025 15:24:39 +0100
Message-ID: <20250213142441.565759994@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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


