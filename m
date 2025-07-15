Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F842D9EFF;
	Tue, 15 Jul 2025 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585524; cv=none; b=Cctl2PutzhC0fNQho1Oxh0lGgyU2rqsIN4J6cxa386QZJVPW6ExLsPsBna74o61rDWlTl4ZE0Tt4Lz/DJzlI1Ha1SVeIJmYCX2udmLU5/Pkg51hQlRq003qnPnUzMgCZax26K351BJh4IKaFcOHhQcLPQEyTloY95D6Lxuw8U3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585524; c=relaxed/simple;
	bh=8MnSN0BKKEw/sutcZZGIsP1HwVeno5Bv3fy8qeZq6FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKH450bTUk/6T4wcaGpx6RN6/0CWoPFE0DbDqPg1hmOYZxSOZ/en+5RUuvMXejyMI3TRGiKlUiViTyWmvFckEQZFDLGctdO4GLv0FF9NEJTDAOP6HbJCfZlmBiEB516kMTd7ra4Boc7Qzlhgh2wpLuCgVo2/BVTiSaEGAsIgopg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YudKiSdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YudKiSdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC156C4CEE3;
	Tue, 15 Jul 2025 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585524;
	bh=8MnSN0BKKEw/sutcZZGIsP1HwVeno5Bv3fy8qeZq6FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YudKiSdnDQAJ3umh4iIVPEgXl7PY2UlN1mtMhltLKLcsZNnEvcUMh3jkweCXfou5x
	 /gRdtuHpVV4VLqVXO5yWZnRQhqwgXMPOI+XWhcpRLgxFyLfLIVvRSL9upY/cw9s2df
	 PlHO6P8B/pebIcb5UlByIUGk9JoLR3Bk9na6zAqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.12 072/163] drm/imagination: Fix kernel crash when hard resetting the GPU
Date: Tue, 15 Jul 2025 15:12:20 +0200
Message-ID: <20250715130811.628113044@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


