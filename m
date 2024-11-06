Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6131D2784;
	Wed,  6 Nov 2024 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896170; cv=none; b=uRTemFddLLyz1gWmVactxs2hMMZQsP0N+K4TOViSRxHehbvPU8uTJaB2olIxjKVpCThpyUkoWmDOvOC6FA8iVJpDwFAmXm7Sjrm7Hh4FhpvYW8veKHMpi/arWMIUx0xiyuNtjsWAJ868TJoIcdgcQY3tuDa/puhToeFoXlyOSTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896170; c=relaxed/simple;
	bh=PaITI447tIyYetv6DvppzTLajgLM0uV/ulReXhrs+CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ggb9WvxAWQmjLnRBVYSw89J2VZVFI7ebCgwe7ouH6ZjMgWIo502yFiUZLRnfCbbaV+rlhEoPcZEqUS6RxBjy5W9QYbG6UGkjHOFN1Nh1QTZsgZEjtlH9dAi6c8Mcm1rmWUZQX+VAasmlWPJJ9SJV+vyWedLFZfzLeD9hw2Ein1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aeyg5a9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aeyg5a9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A86C4CECD;
	Wed,  6 Nov 2024 12:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896170;
	bh=PaITI447tIyYetv6DvppzTLajgLM0uV/ulReXhrs+CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aeyg5a9Pz/PhymbXugz+nKxHe83w++FRTyBZXeHgXgvxlkCU52ws3x+d2ciQtr02H
	 rTiJkxYUugEo2eSZU4KfERRtXAtV3VVvYUijpbQkd5T/L2C/lhK9tFoTSZVHvB5pp6
	 WUoR6NxjzwnTyHgNmLTgIbY2f28SylXwaRZ9CY1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.11 112/245] usb: typec: qcom-pmic-typec: fix missing fwnode removal in error path
Date: Wed,  6 Nov 2024 13:02:45 +0100
Message-ID: <20241106120321.976300264@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit b8423a2f5814dbf055ed7c41f25bfe91c2066cbe upstream.

If drm_dp_hpd_bridge_register() fails, the probe function returns
without removing the fwnode via fwnode_handle_put(), leaking the
resource.

Jump to fwnode_remove if drm_dp_hpd_bridge_register() fails to remove
the fwnode acquired with device_get_named_child_node().

Cc: stable@vger.kernel.org
Fixes: 7d9f1b72b296 ("usb: typec: qcom-pmic-typec: switch to DRM_AUX_HPD_BRIDGE")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20241020-qcom_pmic_typec-fwnode_remove-v2-2-7054f3d2e215@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c
index 7d9d37c16fad..b80eb2d78d88 100644
--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c
@@ -93,8 +93,10 @@ static int qcom_pmic_typec_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	bridge_dev = devm_drm_dp_hpd_bridge_alloc(tcpm->dev, to_of_node(tcpm->tcpc.fwnode));
-	if (IS_ERR(bridge_dev))
-		return PTR_ERR(bridge_dev);
+	if (IS_ERR(bridge_dev)) {
+		ret = PTR_ERR(bridge_dev);
+		goto fwnode_remove;
+	}
 
 	tcpm->tcpm_port = tcpm_register_port(tcpm->dev, &tcpm->tcpc);
 	if (IS_ERR(tcpm->tcpm_port)) {
-- 
2.47.0



