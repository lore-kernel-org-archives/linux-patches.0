Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54003335BA;
	Thu, 13 Feb 2025 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459016; cv=none; b=UgEAzm6NgaQ2V+qpOAKk8tdbxyAQjkBzrGlQGCTw817eRUXdpoXvXUUVGlKUNxNLVuyEHfKqDBstWWgUIHPqjJaQJkyeRflvSAPMND/ULu/1hBlZTF0hOL/CEXZEvuQp/aiIGwtZFM/BVmNwweeWhzNzFqf8DbV5qfmAB3vsJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459016; c=relaxed/simple;
	bh=yuITxHOxq2Eey7hCbqUunKP+jMcfiymWpmd7tX1gW8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQv8w2zhG38NPS4U+n6u5jSzft6v9O9UHKXlmTk7zdVobil35vAZlEeLHDQMiU1PUn4PccBTvY3TduzjZojGfEAhIqymOOjXZ0tyaqLdXiYsHAhd7eCtXbwQxXaik349s27K+Lfqd3g37Eg4GU0CzNglVcr7ae9rcDrgWIqNAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIcqiCt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIcqiCt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2333C4CED1;
	Thu, 13 Feb 2025 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459016;
	bh=yuITxHOxq2Eey7hCbqUunKP+jMcfiymWpmd7tX1gW8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIcqiCt8rQadoS8b/EZZWe5m+bF5kXnEMkvl6DFrsjuLnzPZ8JTJTIBBxXzQDW5m+
	 waet8dzuOcDL4cd5DYuDUTCkNEQKgDv50oMXyjkM4UC0J2643F0iwgwPjp191mwc2q
	 BNIEtXYk2IuCaDzM6Z4W2coD+NiAYLuCJ+qZIqPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.13 144/443] leds: lp8860: Write full EEPROM, not only half of it
Date: Thu, 13 Feb 2025 15:25:09 +0100
Message-ID: <20250213142446.157114364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


