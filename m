Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA11313B2B8;
	Tue, 27 Feb 2024 14:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042839; cv=none; b=dN7fCfjmD1E1/i2U3VxHueHc5NuA+UiqjvBJWfRY4afhwHTBcEaDr8sJc7MGG/2fLdNdlnsJCIgUve8tSsDqUt6khyXmC9UyAKuUKgMAgroK/BMEdro89yybB55W1VTrThwOgX8UwI424bK11iCBUnOUGzL83dVK5+TbiHq9luI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042839; c=relaxed/simple;
	bh=ITQ4NYlRzT6AZ9UX2JGzls9XAaNKjILoehDdBCCHihQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1yuskI9Y7rVOjuvcMYsnH5zrmPrFucOhVN9xKsMs3f6N/KP/xni7o3VGB5DUBIYu2+rlRXFy+GfWcN1hpTcVIFW1lj39qc2oN8F7UUiqE1tZBWSaX46/1wWOsLTahG7J7HY3NhLVFh/dRy/Ig6gfKsGwrvCNJ1eOYKLcocoPQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYoUzqBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYoUzqBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCDDC433C7;
	Tue, 27 Feb 2024 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042839;
	bh=ITQ4NYlRzT6AZ9UX2JGzls9XAaNKjILoehDdBCCHihQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYoUzqBkLgJK9nH4gCeD9pZwTfBsHg3YAnjdU/3jdLJu4LUt2+u3LxVL7MPDqcZ/L
	 7unDuZ4M06c/CPa05jnvXZKaKA5P/LA12nUp1iYrZiKBnYEqOp+O7LqplUW2++pUNV
	 8Uu9yUlpojDWPfTdObl43rMnGyUoZ3MnBEOsROPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/245] clk: Honor CLK_OPS_PARENT_ENABLE in clk_core_is_enabled()
Date: Tue, 27 Feb 2024 14:25:10 +0100
Message-ID: <20240227131619.197441161@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 79200d5851c8e7179f68a4a6f162d8f1bde4986f ]

In the previous commits that added CLK_OPS_PARENT_ENABLE, support for
this flag was only added to rate change operations (rate setting and
reparent) and disabling unused subtree. It was not added to the
clock gate related operations. Any hardware driver that needs it for
these operations will either see bogus results, or worse, hang.

This has been seen on MT8192 and MT8195, where the imp_ii2_* clk
drivers set this, but dumping debugfs clk_summary would cause it
to hang.

Prepare parent on prepare and enable parent on enable dependencies are
already handled automatically by the core as part of its sequencing.
Whether the case for "enable parent on prepare" should be supported by
this flag or not is not clear, and thus ignored for now.

This change solely fixes the handling of clk_core_is_enabled, i.e.
enabling the parent clock when reading the hardware state. Unfortunately
clk_core_is_enabled is called in a variety of places, sometimes with
the enable clock already held. To avoid deadlocking, the core will
ignore readouts and just return false if CLK_OPS_PARENT_ENABLE is set
but the parent isn't currently enabled.

Fixes: fc8726a2c021 ("clk: core: support clocks which requires parents enable (part 2)")
Fixes: a4b3518d146f ("clk: core: support clocks which requires parents enable (part 1)")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20230103092330.494102-1-wenst@chromium.org
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b37af6b27e9c6..bf9057a8fbf06 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -251,6 +251,17 @@ static bool clk_core_is_enabled(struct clk_core *core)
 		}
 	}
 
+	/*
+	 * This could be called with the enable lock held, or from atomic
+	 * context. If the parent isn't enabled already, we can't do
+	 * anything here. We can also assume this clock isn't enabled.
+	 */
+	if ((core->flags & CLK_OPS_PARENT_ENABLE) && core->parent)
+		if (!clk_core_is_enabled(core->parent)) {
+			ret = false;
+			goto done;
+		}
+
 	ret = core->ops->is_enabled(core->hw);
 done:
 	if (core->rpm_enabled)
-- 
2.43.0



