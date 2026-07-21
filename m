Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A402472F8C;
	Tue, 21 Jul 2026 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656189; cv=none; b=uCk2kqEb/ypf8lBAPhCDicKdr8yWx6YRW41xw1EM7UlbAYbx5ByF0jphWAszQSjZX6UHO2tY/BzYCwOKKX7YQnniBdivTq1HuqVyHra3olc44tTJ/zd5RNo7X9BdDxS8FtjQ9RhpRwZQ3aJae0llK+0I6IJdUgAQnM5E9thkGGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656189; c=relaxed/simple;
	bh=kmvGv40fIl4t7A2n5f5A8ggAISMfL2deCqW09pd0Ip8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acBMPB9wTMiEKGeYq6iSxkpIXCTovoVE2oWTyHF+/Y0+Azu2hjbtm/xisBuclQ41UhIkQ0eDh5cn4tKJvL6A1KS7bMbly7xIcoOuzv2YLCI/vPBJrz0fFXNIHvPb8TTLqcRp63iFEw0P5FUAA+kDwPgNp5NMaY++yd6cAHrSJMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpAzMmE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpAzMmE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D107F1F000E9;
	Tue, 21 Jul 2026 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656186;
	bh=XgmX8206kn93mXyPOoa5ueD3rLHU1YGqyiBPGLDgsv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpAzMmE2xVWRYf5UN1uh4xVlbSSPhE8odSUtBWPYqmGjwtop8ap9mUMeSfTy7Tgad
	 aSHs3W8lrNh2pO8U/pIkLcU+WS7F6QHlezEy8WHA7VrVjNJh6Jr1VKkS9Y4M5og/BN
	 bdm7JhBKOXGrhTwU6L92VROjDKo8vyNg95cfFkBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0293/1611] ARM: imx3: Fix CCM node reference leak
Date: Tue, 21 Jul 2026 17:06:49 +0200
Message-ID: <20260721152521.658246426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



