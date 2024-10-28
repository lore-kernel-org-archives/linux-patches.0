Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7C61DFFD;
	Mon, 28 Oct 2024 06:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098070; cv=none; b=qscvekm5NvnuFp8MkSiY4BbMCrlRoJs1XX6AOKqFQ/8SB4qQtIfA+NKPdYHc0Ht7IVW1WR2Oxy1Ey++jDNh9gN9lyChYei2R1/xdfhsIbBHsllGED8HUvLfdxXMwnLZqqeiE3lPGSFyDE6C6xcA8+MblxdTRYYvw9pkT7teQoiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098070; c=relaxed/simple;
	bh=fwkkrNV3Ygw2uaCO0hNj3BXp8K/t6LDXL7Mr69HHV8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAyzBAvgqvQcM/DF71XPjeV64Vt96Q4wdJata+WJ+/g1OxdyqcqetNYK+HhcoRf5iOgLP30DT6QXIWNnATOOdrQMkDWhVOlO4SN0x0wOfM5Tx5eror2fofBGI7hjLZr3YGj3GOjlGYiARye0jas6DzFMjbkA6rtZOBzIlrNFo60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP5O6Nun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP5O6Nun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B16C4CEC3;
	Mon, 28 Oct 2024 06:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098070;
	bh=fwkkrNV3Ygw2uaCO0hNj3BXp8K/t6LDXL7Mr69HHV8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tP5O6NunsRMAszeOsEPJbnER2ZORziy8CaUN5vBLFESvdxWT1ukGEZglvyzY3ewdA
	 HpwOO7E3XxYJgTce5NzHnApf9f8HKASOkxH4xGPG1ydJTmzuTf0moSQlUqCudK3K2W
	 nxO08z5OLHR3fFZUVh0G3Be2h4WlPzJRPJI6BSHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 017/261] clk: rockchip: fix finding of maximum clock ID
Date: Mon, 28 Oct 2024 07:22:39 +0100
Message-ID: <20241028062312.443996951@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit ad1081a0da2744141d12e94ff816ac91feb871ca ]

If an ID of a branch's child is greater than current maximum, we should
set new maximum to the child's ID, instead of its parent's.

Fixes: 2dc66a5ab2c6 ("clk: rockchip: rk3588: fix CLK_NR_CLKS usage")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Link: https://lore.kernel.org/r/20240912133204.29089-2-ziyao@disroot.org
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index 2fa7253c73b2c..88629a9abc9c9 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -439,7 +439,7 @@ unsigned long rockchip_clk_find_max_clk_id(struct rockchip_clk_branch *list,
 		if (list->id > max)
 			max = list->id;
 		if (list->child && list->child->id > max)
-			max = list->id;
+			max = list->child->id;
 	}
 
 	return max;
-- 
2.43.0



