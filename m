Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8667CD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A4EC433EF;
	Mon, 12 Jun 2023 10:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566974;
	bh=bqUEYH8Qf7N77afHcl2OBGW1+16P+8bXBi1v0vkTLkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6wgvPzARyeUpaeUl6SdXiaT8LzPMMFyFIRq7WwciCCSxrA4jAjnWzZn7s1CIK5fm
	 uhP1d6TFoFyg5uT+YZS4m8xcULMkSnSpjRdH2XfWL/nOZSdFxWIfkhSy2bhog9MTc7
	 80vHutkFSKCeo5k/p5W/O6lBDs5xkCNMqX3kD4lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.3 102/160] accel/ivpu: Do not trigger extra VPU reset if the VPU is idle
Date: Mon, 12 Jun 2023 12:27:14 +0200
Message-ID: <20230612101719.693367776@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>

commit 9f7e3611f6c828fcb6001c39d8e7a523a4f31525 upstream.

Turning off the PLL and entering D0i3 will reset the VPU so
an explicit IP reset is redundant.
But if the VPU is active, it may interfere with PLL disabling
and to avoid that, we have to issue an additional IP reset
to silence the VPU before turning off the PLL.

Fixes: a8fed6d1e0b9 ("accel/ivpu: Fix power down sequence")
Cc: stable@vger.kernel.org # 6.3.x
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230525103818.877590-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_hw_mtl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_mtl.c b/drivers/accel/ivpu/ivpu_hw_mtl.c
index 382ec127be8e..156dae676967 100644
--- a/drivers/accel/ivpu/ivpu_hw_mtl.c
+++ b/drivers/accel/ivpu/ivpu_hw_mtl.c
@@ -754,9 +754,8 @@ static int ivpu_hw_mtl_power_down(struct ivpu_device *vdev)
 {
 	int ret = 0;
 
-	if (ivpu_hw_mtl_reset(vdev)) {
+	if (!ivpu_hw_mtl_is_idle(vdev) && ivpu_hw_mtl_reset(vdev)) {
 		ivpu_err(vdev, "Failed to reset the VPU\n");
-		ret = -EIO;
 	}
 
 	if (ivpu_pll_disable(vdev)) {
@@ -764,8 +763,10 @@ static int ivpu_hw_mtl_power_down(struct ivpu_device *vdev)
 		ret = -EIO;
 	}
 
-	if (ivpu_hw_mtl_d0i3_enable(vdev))
-		ivpu_warn(vdev, "Failed to enable D0I3\n");
+	if (ivpu_hw_mtl_d0i3_enable(vdev)) {
+		ivpu_err(vdev, "Failed to enter D0I3\n");
+		ret = -EIO;
+	}
 
 	return ret;
 }
-- 
2.41.0



