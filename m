Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D621ABDB;
	Tue, 29 Apr 2025 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947224; cv=none; b=Xu2JcLExEyAnw6IUPusKymd+A0+wZkxzga2bVaB1aSg7+ejuxRNFauKlPuwJ9Ktdwvi0c5KGU9GdcJt7LLJB/mi/lNFzeSPce271JQFkipjrbT75uC2smXRwuJiTYljSsLB5yfNUQnn9DHO0aLdSYM0n7tyD3R3PsiCe16w+UQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947224; c=relaxed/simple;
	bh=xRFzAemfhT31C46nOcecGl5+QhtqGmKQ27yl5wz5mOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIOpuVwsWIFzfTWA+oZgk/oytoLL/LNCm9z+U6X1ead/KiWdjuXg5tDcxFUsIRLL6/lmXYyyK5WeAsW4da0PB0u41nUvJPQx9tslUpbYpECAs3AJuRKsl5sGDJxk462C4d9U5M9h/+lhQI1989+VXACdE4Y6lh8SytwqT44WOqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6KJ3Fqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6KJ3Fqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35046C4CEE3;
	Tue, 29 Apr 2025 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947223;
	bh=xRFzAemfhT31C46nOcecGl5+QhtqGmKQ27yl5wz5mOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6KJ3Fqt2I/SocFc3gph3oFLL9lTdDm9D72Lu1oW8YdIGRFGtamK440xwIcZN0KkN
	 G4T2L7JcwK50FJe6S1D3V9MqpIJ88QejSXAdn+cuiErVAsjLRfiKW1YLgvTgGPgZHG
	 paMV+YcQMZmtAc8VzqDwq9T4pN/ayqm7XfEAoRcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/286] soc: samsung: exynos-chipid: initialize later - with arch_initcall
Date: Tue, 29 Apr 2025 18:41:56 +0200
Message-ID: <20250429161116.671366305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 3b4c362e5ef102ca2d70d33f4e8cf0780053a7db ]

The Exynos ChipID driver on Exynos SoCs has only informational
purpose - to expose the SoC device in sysfs.  No other drivers
depend on it so there is really no benefit of initializing it early.

Instead, initialize everything with arch_initcall which:
1. Allows to use dev_info() as the SoC bus is present (since
   core_initcall),
2. Could speed things up because of execution in a SMP environment
   (after bringing up secondary CPUs, unlike early_initcall),
3. Reduces the amount of work to be done early, when the kernel has to
   bring up critical devices.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201202195955.128633-2-krzk@kernel.org
Stable-dep-of: c8222ef6cf29 ("soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-chipid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
index 8d4d050869068..0f2de1b016a59 100644
--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -98,9 +98,9 @@ static int __init exynos_chipid_early_init(void)
 		goto err;
 	}
 
-	/* it is too early to use dev_info() here (soc_dev is NULL) */
-	pr_info("soc soc0: Exynos: CPU[%s] PRO_ID[0x%x] REV[0x%x] Detected\n",
-		soc_dev_attr->soc_id, product_id, revision);
+	dev_info(soc_device_to_device(soc_dev),
+		 "Exynos: CPU[%s] PRO_ID[0x%x] REV[0x%x] Detected\n",
+		 soc_dev_attr->soc_id, product_id, revision);
 
 	return 0;
 
@@ -110,4 +110,4 @@ static int __init exynos_chipid_early_init(void)
 	return ret;
 }
 
-early_initcall(exynos_chipid_early_init);
+arch_initcall(exynos_chipid_early_init);
-- 
2.39.5



