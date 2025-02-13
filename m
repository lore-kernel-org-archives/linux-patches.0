Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199C326B0AD;
	Thu, 13 Feb 2025 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459679; cv=none; b=Dy78MKpPnStPdZdHouhiFS1pQ5wputqQLVcEhEWAcW8UPPIL21DqqR/huVtkmDPZzN6TiePGAVRN687D1hMcgoGwr7OzgAaMYnGGaHfSgNnaRII6bCBW6V7sN6L8Jo1/iup95sGCAWdFf5XVYi5OuIdrCsbEeAr26kdiN94KgUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459679; c=relaxed/simple;
	bh=QCCWWD8WcyavN+w59rNJnG2860qQ7sgLJp38WdqPS64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPvZd6nbJ9dY57KkgtTEbdHVza+F2bTQjITk6xandPE18VQG+TgKcJYjINLYFGO3JoxxBncxm/deAHvTJmF559SdN+Zm/dcnPE7xtmHNwOdFroBL+e5pWN9d3f92Ocll65PGMzq1pc1z2yUA0CIHKL1hh1urECFKfmJoxXz5sVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIiD6WwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIiD6WwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9276EC4CEE4;
	Thu, 13 Feb 2025 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459679;
	bh=QCCWWD8WcyavN+w59rNJnG2860qQ7sgLJp38WdqPS64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIiD6WwJU6nog/+TSRM/hhGSN7pLuKMpQjykkQ2DmyC2SreU3qDnsVpzrtKXT/gUr
	 B9zBReVCgJa2hONE4sT2bO1Bi/8AtFmZxACyBS+9eHYYofAtOJWbKFK9LxX/A1NDmm
	 0qenlj40h/LOKlFSh4AwRsJoiM5OQ2fLqbYGIPdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.13 332/443] accel/ivpu: Fix error handling in ivpu_boot()
Date: Thu, 13 Feb 2025 15:28:17 +0100
Message-ID: <20250213142453.435160672@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit f3be8a9b1afffbcc70f8e41063b151b1038d7813 upstream.

Ensure IRQs and IPC are properly disabled if HW sched or DCT
initialization fails.

Fixes: cc3c72c7e610 ("accel/ivpu: Refactor failure diagnostics during boot")
Cc: stable@vger.kernel.org # v6.13+
Reviewed-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129124009.1039982-2-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_drv.c b/drivers/accel/ivpu/ivpu_drv.c
index ca2bf47ce248..0c4a82271c26 100644
--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -397,15 +397,19 @@ int ivpu_boot(struct ivpu_device *vdev)
 	if (ivpu_fw_is_cold_boot(vdev)) {
 		ret = ivpu_pm_dct_init(vdev);
 		if (ret)
-			goto err_diagnose_failure;
+			goto err_disable_ipc;
 
 		ret = ivpu_hw_sched_init(vdev);
 		if (ret)
-			goto err_diagnose_failure;
+			goto err_disable_ipc;
 	}
 
 	return 0;
 
+err_disable_ipc:
+	ivpu_ipc_disable(vdev);
+	ivpu_hw_irq_disable(vdev);
+	disable_irq(vdev->irq);
 err_diagnose_failure:
 	ivpu_hw_diagnose_failure(vdev);
 	ivpu_mmu_evtq_dump(vdev);
-- 
2.48.1



