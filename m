Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A365330B1D;
	Fri, 17 Oct 2025 15:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715753; cv=none; b=WtLUAP+k9zWZQsvJchyY9RNWKN2Jbrdma852Fux6JBAd5WIhEYsyOlyv7lSjbqv5zjkiiCvLVHPWV1QfcpoWsa16naq+5NCOyUDmIFHZnhKF81CbMX4Z9+9bMJmlwB3cPTC7j+9BM14JEz80vBFeDN5J84wNhhxsBUUzqu8yFx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715753; c=relaxed/simple;
	bh=XE2eW8hCI6OYe2t9I2OqBAAXstre8dlHIVpG1yelcl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8QMBOvVVMkpCuak3rRXGx8Jd8oqpVQW2ocLKSa1dxVQe47/Br+p9toG4Y9fDqGFVZBKrCoEG7YcsnSNez6/U/04H14mHvY239GZiynd3TWZjo15AUx1yNn3gGfwJ4/Ofu/GkP4HIhoT206k3/s7sCTMx/PvMA/rkhl/b76Tq0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzEMzYk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzEMzYk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA0EC4CEE7;
	Fri, 17 Oct 2025 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715753;
	bh=XE2eW8hCI6OYe2t9I2OqBAAXstre8dlHIVpG1yelcl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzEMzYk07qorHDHqQuoNMjk39qAqlYKNHsqOUbo04zrO6aVcWYRvCwDGY10uS1pTH
	 gTM+z7C3dVmt9hKUvZkvK3f9kUmE6e76LbCljavkVzmar0Bew2Br4ntnIUO2JNvCze
	 U7nALFlXScsMaT/oLaIjDyAk/n3mcI6TnFpBHwps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 325/371] media: iris: Fix firmware reference leak and unmap memory after load
Date: Fri, 17 Oct 2025 16:55:00 +0200
Message-ID: <20251017145213.835227195@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 57429b0fddfe3cea21a56326576451a4a4c2019b upstream.

When we succeed loading the firmware, we don't want to hold on to the
firmware pointer anymore, since it won't be freed anywhere else. The same
applies for the mapped memory. Unmapping the memory is particularly
important since the memory will be protected after the Iris firmware is
started, so we need to make sure there will be no accidental access to this
region (even if just a speculative one from the CPU).

Almost the same firmware loading code also exists in venus/firmware.c,
there it is implemented correctly.

Fix this by dropping the early "return ret" and move the call of
qcom_scm_pas_auth_and_reset() out of iris_load_fw_to_memory(). We should
unmap the memory before bringing the firmware out of reset.

Cc: stable@vger.kernel.org
Fixes: d19b163356b8 ("media: iris: implement video firmware load/unload")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_firmware.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_firmware.c b/drivers/media/platform/qcom/iris/iris_firmware.c
index f1b5cd56db32..9ab499fad946 100644
--- a/drivers/media/platform/qcom/iris/iris_firmware.c
+++ b/drivers/media/platform/qcom/iris/iris_firmware.c
@@ -60,16 +60,7 @@ static int iris_load_fw_to_memory(struct iris_core *core, const char *fw_name)
 
 	ret = qcom_mdt_load(dev, firmware, fw_name,
 			    pas_id, mem_virt, mem_phys, res_size, NULL);
-	if (ret)
-		goto err_mem_unmap;
 
-	ret = qcom_scm_pas_auth_and_reset(pas_id);
-	if (ret)
-		goto err_mem_unmap;
-
-	return ret;
-
-err_mem_unmap:
 	memunmap(mem_virt);
 err_release_fw:
 	release_firmware(firmware);
@@ -94,6 +85,12 @@ int iris_fw_load(struct iris_core *core)
 		return -ENOMEM;
 	}
 
+	ret = qcom_scm_pas_auth_and_reset(core->iris_platform_data->pas_id);
+	if (ret)  {
+		dev_err(core->dev, "auth and reset failed: %d\n", ret);
+		return ret;
+	}
+
 	ret = qcom_scm_mem_protect_video_var(cp_config->cp_start,
 					     cp_config->cp_size,
 					     cp_config->cp_nonpixel_start,
-- 
2.51.0



