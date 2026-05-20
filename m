Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D013D3CE5;
	Wed, 20 May 2026 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296251; cv=none; b=tBY1UD8x46S1v/xcGlgUrsqUvBqL2HdR7hh2R7JZrU7ogO2S+JlHGbcFcmyttClwkz1FW89zicIbvhos0WdqbXA9vzblZcwGJmvmrfi6+k6KsgWoLJrv1OAxaKwHstgfgXRW0AQ1eCb2y1yf94UiVIaOCy7n5crONpFaBibV970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296251; c=relaxed/simple;
	bh=ucmd6Ay8JfAZC7LXS2dxNZ4kbKr+ET0W4rvMKAhezzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUoHHvust4uuoV7/6CK0dxuajXegc6afY0PyM+9/J7x+1PMvklBBshq5x+MckG4/UQ4NZc02f/pjkXowg4oS/PQI/4TOjyZyAEm23TbhRiQiyCHY2QmXUiAlISf8MQ6Z3wi5HmqrJ35N3X9ETwnJbp94L8k0CVpLex0AMEFiXPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLbCSYG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLbCSYG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD6D1F000E9;
	Wed, 20 May 2026 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296250;
	bh=qIi/SDW0FNVSweFEFtimNc4dV/0x1eljZcY1FqLG48o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLbCSYG2U7g264jq+nRqwOZVeSVfHpF55tZQJyCItgXvOaaR6Kl7D3XRJit0cVNEG
	 G25iG+hCcxa5MJKNQ0LHhqB7gfALcwuThokg+sdk5diLj3DLb3yHfWDvFLFa3ou8iD
	 CoT2LmPFMfz3qkRZR+b+emxizZzUOuKz+W78ulQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuwei Wu <shuwei.wu@mailbox.org>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0727/1146] clk: spacemit: ccu_mix: fix inverted condition in ccu_mix_trigger_fc()
Date: Wed, 20 May 2026 18:16:17 +0200
Message-ID: <20260520162204.658092448@linuxfoundation.org>
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

From: Shuwei Wu <shuwei.wu@mailbox.org>

[ Upstream commit 54e97360b44bed6b4399dd3be3d65f392df940fa ]

Fix inverted condition that skips frequency change trigger,
causing kernel panics during cpufreq scaling.

Fixes: 1b72c59db0ad ("clk: spacemit: Add clock support for SpacemiT K1 SoC")
Signed-off-by: Shuwei Wu <shuwei.wu@mailbox.org>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://lore.kernel.org/r/20260305-k1-clk-fix-v1-1-abca85d6e266@mailbox.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu_mix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spacemit/ccu_mix.c b/drivers/clk/spacemit/ccu_mix.c
index 9578366e97466..a8b407049bf4d 100644
--- a/drivers/clk/spacemit/ccu_mix.c
+++ b/drivers/clk/spacemit/ccu_mix.c
@@ -73,7 +73,7 @@ static int ccu_mix_trigger_fc(struct clk_hw *hw)
 	struct ccu_common *common = hw_to_ccu_common(hw);
 	unsigned int val;
 
-	if (common->reg_fc)
+	if (!common->reg_fc)
 		return 0;
 
 	ccu_update(common, fc, common->mask_fc, common->mask_fc);
-- 
2.53.0



