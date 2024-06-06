Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDBB196DA2;
	Thu,  6 Jun 2024 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683023; cv=none; b=XQyUkPiEtwzTTARhQV/lv2zf+Nwa7aZdtfe82jZ2ZX6jY+CB4Fz/WQzLK2LZZePW4ujRnPyzVMgk5sRMeKr/miQYs9aPFL/1jaUcWBba6d8W1JiT4f8nuh+fq6uI6eDeh1VY81ZrvY28g+d9vcDOYbtKznla5e7gfOQPHEdnw5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683023; c=relaxed/simple;
	bh=w86GACuHByk3Q34jgY+XnXeNSZmINPklASYgFalcb+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgGi2RHml8WzbuzM2Uf2/Y1RSGqV8cU5D1aLT+iTik00ut5Ly557Elnk/TYvxgaH4AnmQ1+5V2DFPJsZ8BPvWYSYYXoUV4xDHkSbjWtaqd4Pawhshrem0jcHHIHg/4i/8qJR+C+E1UQIrYXn7SWG6bSAzyGuD612cbmOc29EEx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8HmPW8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8HmPW8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B852EC2BD10;
	Thu,  6 Jun 2024 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683022;
	bh=w86GACuHByk3Q34jgY+XnXeNSZmINPklASYgFalcb+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8HmPW8D51/1st6IAhdipLxZObt9e9hb9WcfWbp/0xbJr4my8e4z7X/MCf/5BHFSl
	 /RrjhDWeNJelhPIjqklcOhqib9O2o8uS+vZBOSWiNkbw0H3IO5tus+yZapOK71Z/Vz
	 tR5Im9efrYP0tA0yARIZzB/byBYOqDwxpTSYXQxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 244/374] regulator: tps6287x: Force writing VSEL bit
Date: Thu,  6 Jun 2024 16:03:43 +0200
Message-ID: <20240606131659.991269820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



