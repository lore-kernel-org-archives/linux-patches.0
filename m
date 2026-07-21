Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AEB408039;
	Tue, 21 Jul 2026 19:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661825; cv=none; b=a+VzqoAglW96WYNVbJ9gIjT8QSuE+58NsYFh9+LU+FHDehdb5g9lXOwOwt1yebn3d2zbWLtQeYJoS5qJCKBY8tZaRRhmcc6nacCLMNuGnbTHciJmWQawiS+yDkZNcofTH2MGH+vAbE9cwmOdvGYF6+ZnLFYlLiN65qd0q75AQx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661825; c=relaxed/simple;
	bh=v2+KcHjqT0xZzO/7Mnqq/XU/SjyNivnC3fiEQedLpSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8Q/3TwmnyjcDwR9URzYWhA5uXqw5mKQkUouCK5gnlZZwB1qvtMPiI3SOh5E3ohwiDfMfWkpL0p6SNyKjRfPvv72qEpyr/YtMeaRUiaDX6zxg4GxtuixxetO+8/O0AlMD1DCY1yfpXkhu8gmBqy7Q4/DkFiMGPaZBzjAc6ZFNhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvsuRI8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvsuRI8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E611F00A3A;
	Tue, 21 Jul 2026 19:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661823;
	bh=HluJnJAwL54/ASOjZC4RDYNzVU5vwtPLkKGL2lHzW08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvsuRI8ZW7N1CKDKhS+Y15Gc/DELc6cf0UBPsk4Bi/LEmVxyQHkbAktOGH7ca+Ofs
	 SvwmH71EcJwmOclndoFcZXgoesWIQlI6AolfagBOIBgUNS6Rv/+1zolx2FWSDWfr8H
	 Gem4KM3kZJaIfC6zMqkYSBidTwR4i1Th/KylZMhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0211/1276] ARM: imx3: Fix CCM node reference leak
Date: Tue, 21 Jul 2026 17:10:54 +0200
Message-ID: <20260721152450.807712463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 36d46348eb5fc4bc505cd2290ddd70c25fbe6bb3 ]

of_find_compatible_node() returns a referenced device node. The i.MX31
and i.MX35 early init paths use the node to map the CCM registers with
of_iomap(), but never drop the node reference.

Release the node after the mapping is created.

Fixes: 2cf98d12958c ("ARM: imx3: Retrieve the CCM base address from devicetree")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mm-imx3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
index 0788c5cc7f9e64..9b0b014d7fe276 100644
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@ -106,6 +106,7 @@ void __init imx31_init_early(void)
 	arm_pm_idle = imx31_idle;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 #endif /* ifdef CONFIG_SOC_IMX31 */
@@ -143,6 +144,7 @@ void __init imx35_init_early(void)
 	arch_ioremap_caller = imx3_ioremap_caller;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx35-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 #endif /* ifdef CONFIG_SOC_IMX35 */
-- 
2.53.0



