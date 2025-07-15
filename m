Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78962E5413;
	Tue, 15 Jul 2025 13:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586876; cv=none; b=nvUUaSSKksoAlFMj6PzbQrSliQT8ym4Hl7Cq2f5eTzneNrsNvAJbrj9r75IMtOR9A6an2YT4dYec03pjY02Saf0dzXV5VNlBbM2k1QvFQDmQS2juGlE8MYD6KoAuxX1YILSCH3B51Kc4V4IRZTILBZfAYvByYLXUYFED7fSP62c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586876; c=relaxed/simple;
	bh=eFhymE0mb0Sx7KkVe3Hs0tAXYJvaIlEsSA6f+IXEY6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClOLqcE5ZiEYbwOqhu0z8LoZ4PoR2l0fAjindWrb/mzkqAlxVlYAK42/cORfofOaYC9MGzcqIHSKRxlPJES/5tzgVD6zyCQ9mtJuTevvTHfYROeqauurzhCgPFA0oET7v9tIYMnS1J1cdVtvp/xD25KScc9fa+b5OPWMOoMlym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOXh9nzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOXh9nzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDCBC4CEE3;
	Tue, 15 Jul 2025 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586875;
	bh=eFhymE0mb0Sx7KkVe3Hs0tAXYJvaIlEsSA6f+IXEY6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOXh9nzXyxvixwn2e2SoY2FXby5gTFmFwcSY/EtfXkHTFLavX599CJp6bce3CVQm7
	 CI3uiMLC6FMvkm6BlLbFu/f7UmrGm0ZXDbyBi0PCw0z6lLZWpD7dWtK0iFRiiyS1F3
	 mp/vukUu6lCLuagUXeCYkdTo4Frbc1sxPQnvHPMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.15 081/192] drm/imagination: Fix kernel crash when hard resetting the GPU
Date: Tue, 15 Jul 2025 15:12:56 +0200
Message-ID: <20250715130818.172892934@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Alessio Belle <alessio.belle@imgtec.com>

commit d38376b3ee48d073c64e75e150510d7e6b4b04f7 upstream.

The GPU hard reset sequence calls pm_runtime_force_suspend() and
pm_runtime_force_resume(), which according to their documentation should
only be used during system-wide PM transitions to sleep states.

The main issue though is that depending on some internal runtime PM
state as seen by pm_runtime_force_suspend() (whether the usage count is
<= 1), pm_runtime_force_resume() might not resume the device unless
needed. If that happens, the runtime PM resume callback
pvr_power_device_resume() is not called, the GPU clocks are not
re-enabled, and the kernel crashes on the next attempt to access GPU
registers as part of the power-on sequence.

Replace calls to pm_runtime_force_suspend() and
pm_runtime_force_resume() with direct calls to the driver's runtime PM
callbacks, pvr_power_device_suspend() and pvr_power_device_resume(),
to ensure clocks are re-enabled and avoid the kernel crash.

Fixes: cc1aeedb98ad ("drm/imagination: Implement firmware infrastructure and META FW support")
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://lore.kernel.org/r/20250624-fix-kernel-crash-gpu-hard-reset-v1-1-6d24810d72a6@imgtec.com
Cc: stable@vger.kernel.org
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_power.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_power.c
+++ b/drivers/gpu/drm/imagination/pvr_power.c
@@ -363,13 +363,13 @@ pvr_power_reset(struct pvr_device *pvr_d
 		if (!err) {
 			if (hard_reset) {
 				pvr_dev->fw_dev.booted = false;
-				WARN_ON(pm_runtime_force_suspend(from_pvr_device(pvr_dev)->dev));
+				WARN_ON(pvr_power_device_suspend(from_pvr_device(pvr_dev)->dev));
 
 				err = pvr_fw_hard_reset(pvr_dev);
 				if (err)
 					goto err_device_lost;
 
-				err = pm_runtime_force_resume(from_pvr_device(pvr_dev)->dev);
+				err = pvr_power_device_resume(from_pvr_device(pvr_dev)->dev);
 				pvr_dev->fw_dev.booted = true;
 				if (err)
 					goto err_device_lost;


