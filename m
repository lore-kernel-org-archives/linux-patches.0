Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B411220CCFB;
	Tue, 17 Jun 2025 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178788; cv=none; b=fuvTX25Konpp1utLJHOgvpl0siJ7c6bx/wHwHEQe8/5y6WbouDXEovuVBMWfwpo3gEg2nhKVhnDrbztMMmh680pp2w4dpuvrTeWM9IIfUlJ8BWvAmvXscp0BHu8nah/nZItRXowTNzQxHVvQmVt4YGE+vlhkIhnu1kkEn5/yJTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178788; c=relaxed/simple;
	bh=jKl51tomfM+kmCs+ltMoiXaz8knePlChOUSj9QQK82U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzP++y3plRyjDJH1Xv3N8xX/z3dNJLc0xXKsEo3kQnRTgb8Pyk8CvwH5MMMOWYXVBW78O/bPbMAZn7ZXmErPdEhG0mg4m0tMjTQ/46bUSJO4a7qd47lsFpr6gRT3DCZBfPQnLZGspeBi0qZiTTTt2upjOYrNYzs3yWOU9kpWL/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjPvXZsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjPvXZsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39514C4CEE3;
	Tue, 17 Jun 2025 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178788;
	bh=jKl51tomfM+kmCs+ltMoiXaz8knePlChOUSj9QQK82U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjPvXZsu8MQ/6aCnjAfKusugbzymoHzoXMAnh84QC9njUDuaBu6gkhc0wf21xKXCV
	 C3ZYzEukmdnPIr1h0AmKHJi4yqo3Gs5TXPTmscTuwEH+amwYwqOOfqT2IDla2r7+qH
	 m0AGF4dWr6PXHVR+5Y+WkVjXw4CLGf2hxMEF9obg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 555/780] drm/bridge: analogix_dp: Fix clk-disable removal
Date: Tue, 17 Jun 2025 17:24:23 +0200
Message-ID: <20250617152514.101970131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit fd03f82a026cc03cb8051a8c6487c99f96c9029f ]

Commit 6579a03e68ff ("drm/bridge: analogix_dp: Remove the unnecessary
calls to clk_disable_unprepare() during probing") removed the mismatched
clock_disable calls from analogix_dp_probe.

But that patch was created and sent before
commit e5e9fa9f7aad ("drm/bridge: analogix_dp: Add support to get panel
from the DP AUX bus") was merged, so couldn't know about this change.

So in the original patch the last change is
    if (ret) {
	dev_err(&pdev->dev, "failed to request irq\n");
-		goto err_disable_clk;
+		return ERR_PTR(ret);
    }
    disable_irq(dp->irq);

    return dp;
-
-err_disable_clk:
-	clk_disable_unprepare(dp->clock);
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(analogix_dp_probe);

the analogix_dp_core.c actually now has the runtime-pm handling between
disable_irq() and return do introducing another goto err_clk_disable there.

So remove that one too and return an error pointer, to not create build
breakage.

Fixes: 6579a03e68ff ("drm/bridge: analogix_dp: Remove the unnecessary calls to clk_disable_unprepare() during probing")
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250527225120.3361663-1-heiko@sntech.de
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 28a5326e11b35..5222b1e9f533d 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1652,7 +1652,7 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 	pm_runtime_set_autosuspend_delay(dp->dev, 100);
 	ret = devm_pm_runtime_enable(dp->dev);
 	if (ret)
-		goto err_disable_clk;
+		return ERR_PTR(ret);
 
 	return dp;
 }
-- 
2.39.5



