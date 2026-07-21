Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8548E3B2FE4;
	Tue, 21 Jul 2026 20:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665878; cv=none; b=CSfnevLE3qVuCjlR7skbSsvDmMJwpRoPHZCBHQub4zHl4s0UaWJ2RvzhpD64Zg0xt/U9eszFMUA1d2lwwFLQ2ATJkwSRU4QiAzXFc4dGtIELls6litSUatToRqseZ6kV6mD1jNQqsISQ3x71DJ7KG1i8qRoxJw9/KJ5W+S8GtEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665878; c=relaxed/simple;
	bh=I4c3EUoZF8rDxO+cLiKV9E+c6L3e6CE+ZHn4pn1KF+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BewMeuNKWhdXF1ELxH1NWdKwqxkJeHa7McHid+miLgZV+SnzsFCT8qdxdZrZWgtKZaXb1TlnS1JvVmtKdfPXXunP1VDOVlEh88IIn2Fqzlp08vHDWKRAA2NYxPRxwJdc6GvF9hq+0zX5lalXO1hbbWJBlsfM54nTyH9IQc60sgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADQiHcUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADQiHcUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18D41F000E9;
	Tue, 21 Jul 2026 20:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665877;
	bh=vI8Cc7ujf2VcUyG94K8Unyoptv5y4obMvhR49qRBGRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADQiHcUA8QZGKmubmHQ+HhqMWxxQFne44GDGX6xQtH2kYBdFwiJ8ZOs25cHl4F5Sy
	 Bg3DG8jIfWiZUgMKavpeprVM6FLCMUDqgSZvye4mRGr/LwclTYh0PUVio/874f3btq
	 XcjqM8byu1zY4RT0mYkLzGLYtbDCT/RDDUES0t2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0471/1266] ARM: imx3: Fix CCM node reference leak
Date: Tue, 21 Jul 2026 17:15:08 +0200
Message-ID: <20260721152452.373180114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



