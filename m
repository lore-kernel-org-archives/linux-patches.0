Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6098F3D8100;
	Wed, 20 May 2026 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295791; cv=none; b=ebeMZSaeXGYFRGUgYzEJ3eL4UcFxWddIgYT7yoTk00Ipob10YLZusqxfINJV3E0sWw8HUoYAaon3SIjsMQOsEgvzIzg94lgDs7C3cDnuOSaVa4tDB6vJCP90QIflfIVsj5+uJ2fWelD9bmLke8fkVH7Ni44wwzXEK6rF4RbylTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295791; c=relaxed/simple;
	bh=bqsnaQiKtR5Jm1hAXsXW0alvdvYmfMLmDzHZfoj3Bao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiOPkd/dYYvE5WymjASTFyNEQaJKGLGsxMKA9WECSXZ/WudkXRZ0FZKgUFw/zxdmRLBbSyjk9x6/yQA+xxhSutiDG4w+O4drjr8CEPndCkqhrFzNmTa27ch9K59QxSZUuL3ke/cExBjbwrsXe1v6yEfoM1rOF8UXK5j+a3RDf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNyFNyGj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNyFNyGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DE91F000E9;
	Wed, 20 May 2026 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295787;
	bh=fdYvc0iU91yjyMPQRt/n/tLtrCpSyXi0XzA6Y17bUeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNyFNyGjtnvLL1BFxY8PB+TcYeMasOP5R6kCDQ5m3HxFnmG920f9SYATn/molfjZK
	 4AvEcBjhUwq0ansZmA9zb1pijMVBrG8OA/Xp/p9qaXoSs0sdwBGY5esysmkKqswso2
	 6D90p4fjf5iBEkxHTVLH4vndTUlkDRBXm3Oet/iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0551/1146] soc/tegra: cbb: Fix cross-fabric target timeout lookup
Date: Wed, 20 May 2026 18:13:21 +0200
Message-ID: <20260520162200.648534286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit a5f51b04cbb3ae0f9cb2c4488952b775ebb0ccbf ]

When a fabric receives an error interrupt, the error may have
occurred on a different fabric. The target timeout lookup was using
the wrong base address (cbb->regs) with offsets from a different
fabric's target map, causing a kernel page fault.

  Unable to handle kernel paging request at virtual address ffff80000954cc00
  pc : tegra234_cbb_get_tmo_slv+0xc/0x28
  Call trace:
   tegra234_cbb_get_tmo_slv+0xc/0x28
   print_err_notifier+0x6c0/0x7d0
   tegra234_cbb_isr+0xe4/0x1b4

Add tegra234_cbb_get_fabric() to look up the correct fabric device
using fab_id, and use its base address for accessing target timeout
registers.

Fixes: 25de5c8fe0801 ("soc/tegra: cbb: Improve handling for per SoC fabric data")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/cbb/tegra234-cbb.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/cbb/tegra234-cbb.c b/drivers/soc/tegra/cbb/tegra234-cbb.c
index 626e0e820329b..7e387fc54c6b1 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -313,12 +313,37 @@ static void tegra234_cbb_lookup_apbslv(struct seq_file *file, const char *target
 	}
 }
 
+static struct tegra234_cbb *tegra234_cbb_get_fabric(u8 fab_id)
+{
+	struct tegra_cbb *entry;
+
+	list_for_each_entry(entry, &cbb_list, node) {
+		struct tegra234_cbb *priv = to_tegra234_cbb(entry);
+
+		if (priv->fabric->fab_id == fab_id)
+			return priv;
+	}
+
+	return NULL;
+}
+
 static void tegra234_sw_lookup_target_timeout(struct seq_file *file, struct tegra234_cbb *cbb,
 					      u8 target_id, u8 fab_id)
 {
 	const struct tegra234_target_lookup *map = cbb->fabric->fab_list[fab_id].target_map;
+	struct tegra234_cbb *target_cbb = NULL;
 	void __iomem *addr;
 
+	if (fab_id == cbb->fabric->fab_id)
+		target_cbb = cbb;
+	else
+		target_cbb = tegra234_cbb_get_fabric(fab_id);
+
+	if (!target_cbb) {
+		dev_err(cbb->base.dev, "could not find fabric for fab_id:%d\n", fab_id);
+		return;
+	}
+
 	if (target_id >= cbb->fabric->fab_list[fab_id].max_targets) {
 		tegra_cbb_print_err(file, "\t  Invalid target_id:%d\n", target_id);
 		return;
@@ -341,7 +366,7 @@ static void tegra234_sw_lookup_target_timeout(struct seq_file *file, struct tegr
 	 *	e) Goto step-a till all bits are set.
 	 */
 
-	addr = cbb->regs + map[target_id].offset;
+	addr = target_cbb->regs + map[target_id].offset;
 
 	if (strstr(map[target_id].name, "AXI2APB")) {
 		addr += APB_BLOCK_TMO_STATUS_0;
-- 
2.53.0



