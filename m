Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3F22F12B0;
	Fri, 17 Oct 2025 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713389; cv=none; b=OTzYnym1VCU/VphJQfJ1JAzUVfMIYM/y4HhQCIWdQ1GiC1QLzsq/NR+1aqVqaiP9V69lPYPxbOw3TCKG4rn/cNzWuDoQYjOzO3fbH7xvxu9Ri3SZ4g7DZFHDIaHSKUjsQZ/foAQzSk2CSIybgcld/SZBRWaFCFFBrkQfZnWY/oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713389; c=relaxed/simple;
	bh=ZOoa8WItby1L2TK+XDRfYVVg8yDONIuFoy9Gr/pE7mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIsProyPJ+cE1BH7m9kDILOL8TVYSsN1VwkJM6LHoBL6iBBpLgS9Ca8bJxihAHEo3hjX3N2K/rc4xmTZzH4osSeTMrq3ksHl2QLDETyrPtOuWvwIYp7Vnf+nFfF1qTf+YZHrLpXIZ1/yxTo8Brs9OCnZrQ6bUT/lad+KwSrGPMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLaz4G17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLaz4G17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB177C4CEE7;
	Fri, 17 Oct 2025 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713389;
	bh=ZOoa8WItby1L2TK+XDRfYVVg8yDONIuFoy9Gr/pE7mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLaz4G177q/bFcVTlXb5XTCx6JZUwfxu/2i9V/8Xd/ovuPS/tYZ3ygXOYMJs1KZin
	 roN3N+fcBr3E5YdmeicFcV2R5n6PexVNc0vxnjlsonqXNBRrvD2zxK6AF5jH2UxzcD
	 ytU5hmCsgJYrnd7KPVdF0sDm1ZZ32A2cgDq4JRPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/168] mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag
Date: Fri, 17 Oct 2025 16:53:47 +0200
Message-ID: <20251017145134.490143039@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 64e0d839c589f4f2ecd2e3e5bdb5cee6ba6bade9 ]

Testing has shown that reading multiple registers at once (for 10-bit
ADC values) does not work. Set the use_single_read regmap_config flag
to make regmap split these for us.

This should fix temperature opregion accesses done by
drivers/acpi/pmic/intel_pmic_chtdc_ti.c and is also necessary for
the upcoming drivers for the ADC and battery MFD cells.

Fixes: 6bac0606fdba ("mfd: Add support for Cherry Trail Dollar Cove TI PMIC")
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250804133240.312383-1-hansg@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/intel_soc_pmic_chtdc_ti.c
+++ b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
@@ -82,6 +82,8 @@ static const struct regmap_config chtdc_
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = 0xff,
+	/* The hardware does not support reading multiple registers at once */
+	.use_single_read = true,
 };
 
 static const struct regmap_irq chtdc_ti_irqs[] = {


