Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BBD370E4
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85C2C433EF;
	Wed,  7 Jun 2023 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169906;
	bh=p2mr7ctiCs+Gtldc4f7kErsOgxIGbwiqY6XVuX/eN/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJZw4/ya80hHcwQ+yVdbicP/z4vjMC+DXpczmY9j4n4s/9fK2iXmb1+N6IIMDjNP4
	 hxdBROBx3obGEpvqsLsX9ysywW3K494KyUlhwaeMWvvtpZA5/wwIoy8jTkzgR8PBZ1
	 QTn34xAb01+4FCf21Mff/0+7ejeUKlYAkbX1kAl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.3 229/286] phy: qcom-qmp-combo: fix init-count imbalance
Date: Wed,  7 Jun 2023 22:15:28 +0200
Message-ID: <20230607200930.774930865@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 9bf03a0cbd80a256bc1e1c4bcc80bc2b06b8b2b9 upstream.

The init counter is not decremented on initialisation errors, which
prevents retrying initialisation and can lead to the runtime suspend
callback attempting to disable resources that have never been enabled.

Add the missing decrement on initialisation errors so that the counter
reflects the state of the device.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Cc: stable@vger.kernel.org	# 4.12
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230502103810.12061-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2487,7 +2487,7 @@ static int qmp_combo_com_init(struct qmp
 	ret = regulator_bulk_enable(cfg->num_vregs, qmp->vregs);
 	if (ret) {
 		dev_err(qmp->dev, "failed to enable regulators, err=%d\n", ret);
-		goto err_unlock;
+		goto err_decrement_count;
 	}
 
 	ret = reset_control_bulk_assert(cfg->num_resets, qmp->resets);
@@ -2537,7 +2537,8 @@ err_assert_reset:
 	reset_control_bulk_assert(cfg->num_resets, qmp->resets);
 err_disable_regulators:
 	regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
-err_unlock:
+err_decrement_count:
+	qmp->init_count--;
 	mutex_unlock(&qmp->phy_mutex);
 
 	return ret;


