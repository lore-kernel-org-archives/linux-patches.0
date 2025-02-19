Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A26D1BEF77;
	Wed, 19 Feb 2025 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956893; cv=none; b=kdgGF3ZpNks81lvqyy0wU9FDxFSIjngA2GpnJ09+ga5pTgIstUt0AqEmBg6KkQeY11jGOWrsagmb5Nd+AMeFTN1zpbWG2sq/TR3lsNkiXVuPmYFAnY8+n8FB8XRA7zLUGQobpvREu0uqkqDdKO+1MmS30khdkeoq5CK/Djh9M7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956893; c=relaxed/simple;
	bh=Shmi/EPLHcDI+WgT8LwekwnsCYieSLj4U+p2MswUTiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtvQOkK6ZEkSpHaKWHxlVa6CMD4VIVrrHE4nSNSH3ueG0ADYCsN7uaFqKqCl11r4MVZDa7tfE8XW+5WnTiZH8RAFIbPuF9uvD7+yjvYGRamKWBLSpGuiYgU7sYbZlcLOKMp4M3+vktsIYNkv86rIJDVanHInrwVAdX7e6JYuyCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSw/fs/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSw/fs/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45A0C4CED1;
	Wed, 19 Feb 2025 09:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956893;
	bh=Shmi/EPLHcDI+WgT8LwekwnsCYieSLj4U+p2MswUTiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSw/fs/OEsXJ3zNsKTaOL/jehlzUa92vsAMXxvh3g2L2fmtLYOGklJWpW1PE8AVJK
	 AofkpqORBC6PcV30ERAKdnxbEpR1f0csBWjOmtcf1OV2l7gbuYvVjx+YnkGbRDvJUw
	 A1N1COMmow5J16Qxr5a985HDmaFOP+2K1LnX69ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 336/578] leds: lp8860: Write full EEPROM, not only half of it
Date: Wed, 19 Feb 2025 09:25:40 +0100
Message-ID: <20250219082706.236724126@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -267,7 +267,7 @@ static int lp8860_init(struct lp8860_led
 		goto out;
 	}
 
-	reg_count = ARRAY_SIZE(lp8860_eeprom_disp_regs) / sizeof(lp8860_eeprom_disp_regs[0]);
+	reg_count = ARRAY_SIZE(lp8860_eeprom_disp_regs);
 	for (i = 0; i < reg_count; i++) {
 		ret = regmap_write(led->eeprom_regmap,
 				lp8860_eeprom_disp_regs[i].reg,


