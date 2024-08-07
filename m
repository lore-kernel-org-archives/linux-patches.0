Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053F082499;
	Wed,  7 Aug 2024 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043621; cv=none; b=NPaSLAndTr/me1iQlmX+LX/l680OsCYD9hZHn50pJZCqk4nEHKhRUikL3eiaOg6iIpigESFRYKCinFn4fo6a/a+mhpWTCl36l+8VCd0bdn1dsyj1Jdz75Wy1N5T/bN5RC0DJVSwiI96QOf4GoIFLA0cmtOs6HjvixTSQq6qZt18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043621; c=relaxed/simple;
	bh=Svfokq+rrJghC83j1sVymGbbi73pkeg5bQhwdUbPEQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JV2obnVaPNLw2McN4JMUg4kG+Ofh6BnLf2/HfqGmhideO+ETzApaIq8RcG44ti+2IUk9RH2cUR7fCQckfCLmr1OeQ9XQKwVDzYwEXhnwstunzyXzEipqG6WqwbylCZ53lwmiqy15MQilchgmCwjfYrECPuNejGuqyjhX7YfLAD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iynGaEqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iynGaEqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD7CC32781;
	Wed,  7 Aug 2024 15:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043620;
	bh=Svfokq+rrJghC83j1sVymGbbi73pkeg5bQhwdUbPEQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iynGaEqCvYSFEkRSf4baEd85v/y0UuddjnZX7EqDEaylskODmVxTl7GL94G5f37zj
	 1JEpu99qNMCxDBsKtlIZvd/8iqXFzfA6zhcy+x33Dli5rZVusmtMSiV+aZwyqrT23l
	 KdkVixB2JOAe/w0ox2V5ITsTVS5OkdCNm9WolH/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/86] HID: amd_sfh: Remove duplicate cleanup
Date: Wed,  7 Aug 2024 17:00:17 +0200
Message-ID: <20240807150040.490068613@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit e295709054d59e35be44794dd125efee528ccceb ]

A number of duplicate cleanups are performed that are not necessary. As a
result, remove duplicate cleanups and use common cleanup.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 8031b001da70 ("HID: amd_sfh: Move sensor discovery before HID device initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 27 ++++--------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index c751d12f5df89..34eb419b225ed 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -291,18 +291,8 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 			cl_data->is_any_sensor_enabled = true;
 			cl_data->sensor_sts[i] = SENSOR_ENABLED;
 			rc = amdtp_hid_probe(cl_data->cur_hid_dev, cl_data);
-			if (rc) {
-				mp2_ops->stop(privdata, cl_data->sensor_idx[i]);
-				status = amd_sfh_wait_for_response
-					(privdata, cl_data->sensor_idx[i], SENSOR_DISABLED);
-				if (status != SENSOR_ENABLED)
-					cl_data->sensor_sts[i] = SENSOR_DISABLED;
-				dev_dbg(dev, "sid 0x%x (%s) status 0x%x\n",
-					cl_data->sensor_idx[i],
-					get_sensor_name(cl_data->sensor_idx[i]),
-					cl_data->sensor_sts[i]);
+			if (rc)
 				goto cleanup;
-			}
 		} else {
 			cl_data->sensor_sts[i] = SENSOR_DISABLED;
 			dev_dbg(dev, "sid 0x%x (%s) status 0x%x\n",
@@ -316,25 +306,16 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 	}
 	if (!cl_data->is_any_sensor_enabled ||
 	   (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0)) {
-		amd_sfh_hid_client_deinit(privdata);
-		for (i = 0; i < cl_data->num_hid_devices; i++) {
-			devm_kfree(dev, cl_data->feature_report[i]);
-			devm_kfree(dev, in_data->input_report[i]);
-			devm_kfree(dev, cl_data->report_descr[i]);
-		}
 		dev_warn(dev, "Failed to discover, sensors not enabled is %d\n", cl_data->is_any_sensor_enabled);
-		return -EOPNOTSUPP;
+		rc = -EOPNOTSUPP;
+		goto cleanup;
 	}
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
 	return 0;
 
 cleanup:
+	amd_sfh_hid_client_deinit(privdata);
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
-		if (in_data->sensor_virt_addr[i]) {
-			dma_free_coherent(&privdata->pdev->dev, 8 * sizeof(int),
-					  in_data->sensor_virt_addr[i],
-					  cl_data->sensor_dma_addr[i]);
-		}
 		devm_kfree(dev, cl_data->feature_report[i]);
 		devm_kfree(dev, in_data->input_report[i]);
 		devm_kfree(dev, cl_data->report_descr[i]);
-- 
2.43.0



