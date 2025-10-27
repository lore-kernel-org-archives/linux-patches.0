Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68FE31D37A;
	Mon, 27 Oct 2025 18:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591387; cv=none; b=kHrVU2OB4f0mGoOrWUc7FoH6s9mTKjesCKIGJZmRLZhHCVWVT/MeW2bV6PGFVqaIt/kMOWoi5zyuzc5UiAo2R7q3WxgJp09zgTFZEffrI12gTJ7KrLJXE0IGJniunxMLBkAM0A8Zhnb0DysuuMVSwLNFoCsrQb+ux7u4bAUjG5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591387; c=relaxed/simple;
	bh=DTOJh9+Au/RfRgETdTDiXYwnIgw97mbplF+JI4Cq908=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB8ltSNgraikl3QXzH/g+dLx9VQ2tJQutvsbq7+mbxzT5DtnORELdpQMMInKR7Sm+wPk3V9YoShJnLs1Jx2X8KGPSWX+RMq5WpjdoOtC9JUecjSViZqdqy8KIVxxMzPy0aYfQd9vJOlduwReNHuhfP6+G4M0u+np9ovzLmJ1prA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPnFPhLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPnFPhLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F2BC4CEF1;
	Mon, 27 Oct 2025 18:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591387;
	bh=DTOJh9+Au/RfRgETdTDiXYwnIgw97mbplF+JI4Cq908=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPnFPhLWm4rzkzqtMffUobUkRlRVlg93kv1cn3jGxKQY+wqUZOIO+jBSZoIvnnal5
	 P7qj6qsPl22ao1xoAo4PwwSYbDejmwmxsnvdhjpLNxj4/ZDbgWpNkNJ4wqgc5NwDNo
	 NiVgf53rLLIn3bgcT/glchGm3NxDM1vZjfkbe2I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/332] mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag
Date: Mon, 27 Oct 2025 19:33:50 +0100
Message-ID: <20251027183529.321642622@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


