Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1D1C89F8;
	Thu,  6 Jun 2024 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683712; cv=none; b=DWPL9hGQQO9Ds1W4Rbkfy1zKGROkpuVGrCSCeNgjX6GT/5sswQAR0G65bBhLO9cuFxhhcs5j6U6EEbZSGxR813u6zcBaNvJRqJ00O6HUMGBie0avqGq5oaDUylKQ92bHRoVVcr9HK7jbjHix+fKprRMUm3vIOGOV9roy1qTHrnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683712; c=relaxed/simple;
	bh=xJyCJfPQzw0xOLlVhcyaNd/peel69QArTffiTIivlMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t27MBA531qRT+hVJiyzfJ9YvDvViGvRDej5N+i8FawcRuDJozhn+yLUe1wp4GQrRT0WA97IBRFU2bh3flahf99p5jZGDKYCKVIzEHIrrqpTQj732/28FbcPR4Yqhi9iemlV1XRUI/Zf7Wq1cJqpM/fDldSFQKCqINmtTpAt4r6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDZdLRrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDZdLRrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683A1C2BD10;
	Thu,  6 Jun 2024 14:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683712;
	bh=xJyCJfPQzw0xOLlVhcyaNd/peel69QArTffiTIivlMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDZdLRrNkmbGiB+HSBhrNsg+cFjKPO3hWlGdxYKq2nJlVMZOVt1DlvZI8ibXNwftn
	 mfzp5Hx2Dfiv5cUND725jPArK8Ho0N9LiTpzM8eRkmj83e38u62HYTw6Zla7b3uApR
	 2aJdYqx/YGmbvptnoKGfkCJEy+iKQxxoMHcwGAI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 644/744] regulator: tps6287x: Force writing VSEL bit
Date: Thu,  6 Jun 2024 16:05:16 +0200
Message-ID: <20240606131753.125995685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 1ace99d7c7c4c801c0660246f741ff846a9b8e3c ]

The data-sheet for TPS6287x-Q1
https://www.ti.com/lit/ds/symlink/tps62873-q1.pdf
states at chapter 9.3.6.1 Output Voltage Range:

"Note that every change to the VRANGE[1:0] bits must be followed by a
write to the VSET register, even if the value of the VSET[7:0] bits does
not change."

The current implementation of the driver uses the
regulator_set_voltage_sel_pickable_regmap() helper which further uses
regmap_update_bits() to write the VSET-register. The
regmap_update_bits() will not access the hardware if the new register
value is same as old. It is worth noting that this is true also when the
register is marked volatile, which I can't say is wrong because
'read-mnodify-write'-cycle with a volatile register is in any case
something user should carefully consider.

The 'range_applied_by_vsel'-flag in regulator desc was added to force
the vsel register upodates by using regmap_write_bits(). This variant
will always unconditionally write the bits to the hardware.

It is worth noting that the vsel is now forced to be written to the
hardware, whether the range was changed or not. This may cause a
performance drop if users are wrtiting same voltage value repeteadly.

It would be possible to read the range register to determine if it was
changed, but this would be a performance issue for users who don't use
reg cache for vsel.

Always write the VSET register to the hardware regardless the cache.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 7b0518fbf2be ("regulator: Add support for TI TPS6287x regulators")
Link: https://msgid.link/r/ZktD50C5twF1EuKu@fedora
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6287x-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps6287x-regulator.c b/drivers/regulator/tps6287x-regulator.c
index 9b7c3d77789e3..3c9d79e003e4b 100644
--- a/drivers/regulator/tps6287x-regulator.c
+++ b/drivers/regulator/tps6287x-regulator.c
@@ -115,6 +115,7 @@ static struct regulator_desc tps6287x_reg = {
 	.vsel_mask = 0xFF,
 	.vsel_range_reg = TPS6287X_CTRL2,
 	.vsel_range_mask = TPS6287X_CTRL2_VRANGE,
+	.range_applied_by_vsel = true,
 	.ramp_reg = TPS6287X_CTRL1,
 	.ramp_mask = TPS6287X_CTRL1_VRAMP,
 	.ramp_delay_table = tps6287x_ramp_table,
-- 
2.43.0



