Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506EF32C94B;
	Fri, 17 Oct 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713517; cv=none; b=T2FxpY8kIC/3vS5tgCurs+V3Zn1WswCyTgO4urKeTbKuW4uOsK1gBw2pjCe5kLvEMWXzqjTxwJRz0n2Cqs4/YiC95NfcKRh0Sxy64IBILlHEUtRVNpgF1w9Um+OotpeaogF5sFCPFL4dIkcJ6YEefmqJTH9amSV3Y3zOIPaAQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713517; c=relaxed/simple;
	bh=Pf0uggoZUKRhYnTJmchDdDc3AdHKRn8IK99nyw7oYss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjkZdvraWklUxD1mcnzb9ZxBpPXHVuLLGLuAX0TUHO70Sw9BPpPp6FqWRr5Be+km/fjdG8u09Tvl4K+wHc0lqqVUCjZFUONXLoreR/SXCSh1jeXoMxusnOpqKYQB01+EyH7N9zovjgipCiCAWDn8zVXe5NVcB5GJphrjsEXut5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ8RGwyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ8RGwyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C9DC4CEE7;
	Fri, 17 Oct 2025 15:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713517;
	bh=Pf0uggoZUKRhYnTJmchDdDc3AdHKRn8IK99nyw7oYss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ8RGwydpTdR4/g1eAWg62sUFcIMuEARjejkRmVfBflxX6aDw1An5Iw9zAYWn2Uen
	 j/h9GMf46zdxf0GeAB1ThdTOlBkAV0mkmKNye1HmkAVvN/rRfBuivaJtjnrsrxjM/S
	 0gDnZf9zzbUcS7JbtgxYdxPU88QA513oTqcLiRPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/201] clk: tegra: do not overallocate memory for bpmp clocks
Date: Fri, 17 Oct 2025 16:51:26 +0200
Message-ID: <20251017145135.668793126@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 49ef6491106209c595476fc122c3922dfd03253f ]

struct tegra_bpmp::clocks is a pointer to a dynamically allocated array
of pointers to 'struct tegra_bpmp_clk'.

But the size of the allocated area is calculated like it is an array
containing actual 'struct tegra_bpmp_clk' objects - it's not true, there
are just pointers.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: 2db12b15c6f3 ("clk: tegra: Register clocks from root to leaf")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-bpmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-bpmp.c b/drivers/clk/tegra/clk-bpmp.c
index 7bfba0afd7783..4ec408c3a26aa 100644
--- a/drivers/clk/tegra/clk-bpmp.c
+++ b/drivers/clk/tegra/clk-bpmp.c
@@ -635,7 +635,7 @@ static int tegra_bpmp_register_clocks(struct tegra_bpmp *bpmp,
 
 	bpmp->num_clocks = count;
 
-	bpmp->clocks = devm_kcalloc(bpmp->dev, count, sizeof(struct tegra_bpmp_clk), GFP_KERNEL);
+	bpmp->clocks = devm_kcalloc(bpmp->dev, count, sizeof(*bpmp->clocks), GFP_KERNEL);
 	if (!bpmp->clocks)
 		return -ENOMEM;
 
-- 
2.51.0



