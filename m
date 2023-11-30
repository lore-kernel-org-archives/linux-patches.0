Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D89524C2;
	Thu, 30 Nov 2023 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UP2bhqJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C68C433C9;
	Thu, 30 Nov 2023 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361520;
	bh=+mqRmpZoPOJ+etfTeBnZnm8BxtOUnmJlYNrI56dmL9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UP2bhqJdjhC2O80ROTWs+dhW9oKPqGbkyyD/W/tLG8Rx/6yyeD9PDb6m7Qlp7vaqW
	 7TgNdfQPQxyCepD9A32yiyW58zZOC13eLL59H3wkC7NFiiJRBELnv0qsB6yS02n1Js
	 7cV0B6QQgddwKjiuA4J+VrftiVEKBDVN5+3n5Vqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/112] accel/ivpu: Do not initialize parameters on power up
Date: Thu, 30 Nov 2023 16:21:18 +0000
Message-ID: <20231130162141.304683769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

[ Upstream commit f956bf2080862cfc97412e1eaa08689bc9838d20 ]

Initialize HW specific parameters only once. We do not have to do this
on every power_up (performed during initialization and on resume). Move
corresponding code to ->info_init()

Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231020104501.697763-6-stanislaw.gruszka@linux.intel.com
Stable-dep-of: 3f7c0634926d ("accel/ivpu/37xx: Fix hangs related to MMIO reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_hw_37xx.c | 8 ++++----
 drivers/accel/ivpu/ivpu_hw_40xx.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_37xx.c b/drivers/accel/ivpu/ivpu_hw_37xx.c
index 18be8b98e9a8b..cb9f0196e3ddf 100644
--- a/drivers/accel/ivpu/ivpu_hw_37xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_37xx.c
@@ -625,6 +625,10 @@ static int ivpu_hw_37xx_info_init(struct ivpu_device *vdev)
 	ivpu_hw_init_range(&hw->ranges.shave, 0x180000000, SZ_2G);
 	ivpu_hw_init_range(&hw->ranges.dma,   0x200000000, SZ_8G);
 
+	ivpu_hw_read_platform(vdev);
+	ivpu_hw_wa_init(vdev);
+	ivpu_hw_timeouts_init(vdev);
+
 	return 0;
 }
 
@@ -681,10 +685,6 @@ static int ivpu_hw_37xx_power_up(struct ivpu_device *vdev)
 {
 	int ret;
 
-	ivpu_hw_read_platform(vdev);
-	ivpu_hw_wa_init(vdev);
-	ivpu_hw_timeouts_init(vdev);
-
 	ret = ivpu_hw_37xx_reset(vdev);
 	if (ret)
 		ivpu_warn(vdev, "Failed to reset HW: %d\n", ret);
diff --git a/drivers/accel/ivpu/ivpu_hw_40xx.c b/drivers/accel/ivpu/ivpu_hw_40xx.c
index 85171a408363f..7c3ff25232a2c 100644
--- a/drivers/accel/ivpu/ivpu_hw_40xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_40xx.c
@@ -728,6 +728,10 @@ static int ivpu_hw_40xx_info_init(struct ivpu_device *vdev)
 	ivpu_hw_init_range(&vdev->hw->ranges.shave,  0x80000000 + SZ_256M, SZ_2G - SZ_256M);
 	ivpu_hw_init_range(&vdev->hw->ranges.dma,   0x200000000, SZ_8G);
 
+	ivpu_hw_read_platform(vdev);
+	ivpu_hw_wa_init(vdev);
+	ivpu_hw_timeouts_init(vdev);
+
 	return 0;
 }
 
@@ -819,10 +823,6 @@ static int ivpu_hw_40xx_power_up(struct ivpu_device *vdev)
 		return ret;
 	}
 
-	ivpu_hw_read_platform(vdev);
-	ivpu_hw_wa_init(vdev);
-	ivpu_hw_timeouts_init(vdev);
-
 	ret = ivpu_hw_40xx_d0i3_disable(vdev);
 	if (ret)
 		ivpu_warn(vdev, "Failed to disable D0I3: %d\n", ret);
-- 
2.42.0



