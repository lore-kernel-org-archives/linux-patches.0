Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A5337110;
	Fri, 17 Oct 2025 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713907; cv=none; b=T3skwZ3i/9GfmF7cKT3Et+ePpKfxO/xNHcXSHdr8pDtl43SgVGv6byMT6rRVVsnomb5UV9KSejm/wWmcS2W2GYC9rMODBdneKsbRjX6P5tsQzHPyFYkF775u9OLzP0z5FULDA3ZaPm+qYfWX6m19aJ1NE10Q77qMQh0NuRM0JYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713907; c=relaxed/simple;
	bh=38orlfzJ0vMXJ0wt2m14Zk3sul2FeA3mI6Cldi3oQqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0BuqQiGTGMFBC6er2WMQ85bnN8MoCKrny5v80c3Cq2x9FeFfi02qosC96b/LTbC4iDsXPtiuDOnq08bYgrw7QlLmFADBVJ7xV363Vo2jWXOvwQUIHx50AW6OghAQXTDkBSLSf3qNErpSFSu5IvDaT0XXWu1fXaBYhGfCarAXfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjnpIj0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjnpIj0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F485C4CEE7;
	Fri, 17 Oct 2025 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713907;
	bh=38orlfzJ0vMXJ0wt2m14Zk3sul2FeA3mI6Cldi3oQqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjnpIj0qWxZYjx9T3PXFB/x6i+1TT1rqURP17moXLfxo05FieuH2bSiyRApxQyRme
	 qpBe30iE4koQoE/YrlaI3aIgxA1gYoK7LDrCmBkG+cqs4jfvk3vI34V56+yNvlQr0I
	 m5qjL5OeV4xD5Pz26zPbVG6SQCxlAHhguVcmc/tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/201] mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag
Date: Fri, 17 Oct 2025 16:53:43 +0200
Message-ID: <20251017145140.684403454@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


