Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB4FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB9DC433D2;
	Mon, 15 May 2023 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171950;
	bh=OOSk6E47L5v3k5q8JitSU3+y696+rg94U0EanL7ixHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwComZpCrLUsAlUBjXPLUTlVC0BX10xxxqTGnPlEMaYiRYgRDxA67EPeLzfcWWAsc
	 CGM8/TYrcjWRGs1xt6xqbmcgQOJ+jo3HB7s/I2Gcu0wm8WjlsJQjKREuYPN6QA7Ok5
	 imjtzsJ0NntME0ZzXK8Cl49jumz//3XfMJzBvXYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.15 130/134] drm/msm/adreno: adreno_gpu: Use suspend() instead of idle() on load error
Date: Mon, 15 May 2023 18:30:07 +0200
Message-Id: <20230515161707.492696259@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit 3eeca5e5f3100435b06a5b5d86daa3d135a8a4bd upstream.

The adreno_load_gpu() path is guarded by an error check on
adreno_load_fw(). This function is responsible for loading
Qualcomm-only-signed binaries (e.g. SQE and GMU FW for A6XX), but it
does not take the vendor-signed ZAP blob into account.

By embedding the SQE (and GMU, if necessary) firmware into the
initrd/kernel, we can trigger and unfortunate path that would not bail
out early and proceed with gpu->hw_init(). That will fail, as the ZAP
loader path will not find the firmware and return back to
adreno_load_gpu().

This error path involves pm_runtime_put_sync() which then calls idle()
instead of suspend(). This is suboptimal, as it means that we're not
going through the clean shutdown sequence. With at least A619_holi, this
makes the GPU not wake up until it goes through at least one more
start-fail-stop cycle. The pm_runtime_put_sync that appears in the error
path actually does not guarantee that because of the earlier enabling of
runtime autosuspend.

Fix that by using pm_runtime_put_sync_suspend to force a clean shutdown.

Test cases:
1. All firmware baked into kernel
2. error loading ZAP fw in initrd -> load from rootfs at DE start

Both succeed on A619_holi (SM6375) and A630 (SDM845).

Fixes: 0d997f95b70f ("drm/msm/adreno: fix runtime PM imbalance at gpu load")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/530001/
Link: https://lore.kernel.org/r/20230330231517.2747024-1-konrad.dybcio@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -431,7 +431,7 @@ struct msm_gpu *adreno_load_gpu(struct d
 	return gpu;
 
 err_put_rpm:
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_sync_suspend(&pdev->dev);
 err_disable_rpm:
 	pm_runtime_disable(&pdev->dev);
 


