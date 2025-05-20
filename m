Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD58C1A3A80;
	Tue, 20 May 2025 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750871; cv=none; b=szH4DwghCfH9WHGel6qFix8cRtr3XEMky5yzx96i6vD00Cx85+zUawtLk7D+e37tIVXu6rY5l8ZndjcNvtOpDAvpKaXUqmbiS+gw5+xzOPRvQ3fjfqA5jBbOzZkwQZfqqz+2r1hRr7qw64w6YkrjTVj1IHeNCFQr5hfdJrHbx78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750871; c=relaxed/simple;
	bh=+43pptpJu+1dMVHPOtiP1EsP3t/7458m8/qYgvYShIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd+YnLDm07PAYsDQ2De9k6xIc7V+cWaD7SaThmjniTRzU3zefsRPIVL3b6CcHGFdn/Um8UEFqFj+EutvYo1wWEomlx/g/c136lyKmTo0BKHh/r4Q2dJVx08flzIa0yInKwWD44rsaVjAj/w0qF9LBp3Wthpe8B4SEOTEVpPq+fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odk3/3gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odk3/3gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577B8C4CEE9;
	Tue, 20 May 2025 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750871;
	bh=+43pptpJu+1dMVHPOtiP1EsP3t/7458m8/qYgvYShIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odk3/3gNkwv/CM+yuE4JS1LB0d0b0gAj4s/k5ZnMA/zGXu8boGX44zNoXTbNGzBI0
	 pwvZeVLxYzbqahB9IjmGcKDHYgrVnfHGNZUTqE36dJclTXawWnhvuj5W/6YvDPZzln
	 UqxePeDDE/uU+RowK6aN+Wu96oXpdIxGveo1sf6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.14 141/145] accel/ivpu: Flush pending jobs of devices workqueues
Date: Tue, 20 May 2025 15:51:51 +0200
Message-ID: <20250520125816.065304088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Falkowski <maciej.falkowski@linux.intel.com>

commit 683e9fa1c885a0cffbc10b459a7eee9df92af1c1 upstream.

Use flush_work() instead of cancel_work_sync() for driver IRQ
workqueues to guarantee that remaining pending work
will be handled.

This resolves two issues that were encountered where a driver was left
in an incorrect state as the bottom-half was canceled:

1. Cancelling context-abort of a job that is still executing and
   is causing translation faults which is going to cause additional TDRs

2. Cancelling bottom-half of a DCT (duty-cycle throttling) request
   which will cause a device to not be adjusted to an external frequency
   request.

Fixes: bc3e5f48b7ee ("accel/ivpu: Use workqueue for IRQ handling")
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250401155755.4049156-1-maciej.falkowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -420,9 +420,9 @@ void ivpu_prepare_for_reset(struct ivpu_
 {
 	ivpu_hw_irq_disable(vdev);
 	disable_irq(vdev->irq);
-	cancel_work_sync(&vdev->irq_ipc_work);
-	cancel_work_sync(&vdev->irq_dct_work);
-	cancel_work_sync(&vdev->context_abort_work);
+	flush_work(&vdev->irq_ipc_work);
+	flush_work(&vdev->irq_dct_work);
+	flush_work(&vdev->context_abort_work);
 	ivpu_ipc_disable(vdev);
 	ivpu_mmu_disable(vdev);
 }


