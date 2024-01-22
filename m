Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7774512BF3D;
	Tue, 23 Jan 2024 00:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968951; cv=none; b=bgk2n1dAKybpyPUUkDjLPUzTsJNZMCgmxytLpqJ0wJENTM5PWps+OWDYO8F+0t7mL4/Sin9ceFGZZDtoD2NSD9abXs9udMgI6wzh8wJnx1lFePJVlfMcwstJP62Q1cQ5yuw0aKQHOpONuoEiSJaIxZp0cymO2h6V+Ir0IThDlmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968951; c=relaxed/simple;
	bh=Ar9OAi59UwpAFbE97/N3UmW542QaaZTB3LEtxoEgank=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtD9m75AJKxJsIo5UGR7BbDjljRX1Gmcetf0m4lvUWAyg0UzDGr/UedrMjFn0mm/CJlh68ELfImnUOL5D8u/20t/h5ux0F953PDmOd442ZD9LFQi8OAZ0pUqt0M2AlUefNXCYhj8438nMjOY/n43LWcVu2z0WPc/cn5CYOLVOtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pE6Ib2TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE6Ib2TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1A5C433F1;
	Tue, 23 Jan 2024 00:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968951;
	bh=Ar9OAi59UwpAFbE97/N3UmW542QaaZTB3LEtxoEgank=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE6Ib2TJm6uN7z/d4laLyXVxZUdbQzPP2mPKlOoQPC2S1PHYLJ6KU9IqOZPoAtVNp
	 LlRkunrIWaKqoXq2tUWud1zTHJfOOz5LGYfkpZ2fFQ92wbWh4ha7QH8uTyNF3AOMgU
	 xvjg3+bdey87i7+rtTixNxF9OC0xBIBKzpwp2zeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/194] drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks
Date: Mon, 22 Jan 2024 15:57:29 -0800
Message-ID: <20240122235724.335180031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 3d07a411b4faaf2b498760ccf12888f8de529de0 ]

This helper has been introduced to avoid programmer errors (missing
_put calls leading to dangling refcnt) when using pm_runtime_get, use it.

While at it, start checking the return value.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 5c8290284402 ("drm/msm/dsi: Split PHY drivers to separate files")
Patchwork: https://patchwork.freedesktop.org/patch/543350/
Link: https://lore.kernel.org/r/20230620-topic-dsiphy_rpm-v2-1-a11a751f34f0@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index 08a95c3a9444..1582386fe162 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -464,7 +464,9 @@ static int dsi_phy_enable_resource(struct msm_dsi_phy *phy)
 	struct device *dev = &phy->pdev->dev;
 	int ret;
 
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(phy->ahb_clk);
 	if (ret) {
-- 
2.43.0



