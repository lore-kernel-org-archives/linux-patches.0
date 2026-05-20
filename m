Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BDC36405A;
	Wed, 20 May 2026 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298490; cv=none; b=qkvVpzsfEluzlTPWdrpdTrLjGujKgKuHaE07FWoKcRlBa9VJv+BbFtuayXdyQehspQ2ueTCjDc9lrJ4NClxHvcrs1lwlwsgFxKzlZcJZ0unw8XiCwwOqseEXKxVY3MykT/YtMLl/O7S7UjNX1ZXnrPCoqzIsitX/goxEsTELN5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298490; c=relaxed/simple;
	bh=p7ZRQDqGoqlaUrL74Rr78iDt0v7ou4cK6w8/UndsCVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj/1kZTUkjgOqgOtIE2Z0G/3MmvSjXIrWfX6QBt4JsPpbZm2l68r1R5kBXloN/ge4ddgKGvQZhlKuEReqEbv7/xfiXVXBGLQqpfQNC8YCnlxOHwDdxUxdwqPLcbZuXDgzr9TqerzrTk3q0bpdEP8EYSx5kHa6eqtC80Q+LK2U4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFlVZPin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFlVZPin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FB91F000E9;
	Wed, 20 May 2026 17:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298489;
	bh=0ReyQSHrGjPxBOZSZhNwYT1+0gYJDAjrN8Grp/dHTow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFlVZPinTO4EkOVABgzhcaOqid4N6RwT7HA1BR/DMV3/NL+6iK8aJQQdBfCY1ACd/
	 ckj4WkcSZRFxjEcbQcvb/lNTggGENzQ2Kjwfk1+ElH0/Jkrp0H5nxdSLf/Q+Z8uTSB
	 HD7Pi50Oia9fbkx5qtpU4suCN6vo6ziT7vJqupOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 429/957] soc/tegra: cbb: Fix cross-fabric target timeout lookup
Date: Wed, 20 May 2026 18:15:12 +0200
Message-ID: <20260520162143.825230195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



