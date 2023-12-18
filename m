Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD5B37868;
	Mon, 18 Dec 2023 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGUcmRWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F54C433C8;
	Mon, 18 Dec 2023 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908174;
	bh=aRUDmhu58qsXbvDsdDRgzrAiNvqewPAx+eYtfIzQZMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGUcmRWPsqx1iprsst5jGZX61ieBiey1sBYI4NS1rnHqXOgMtJIJz08zV69pkhtxn
	 r4xmLIP9ryLUvwiKlubnQcKidQLGPlyByLeKWEdJXd1Oyx89hFp4e1VSDXgMwjqQd3
	 3mkJqSX3zCpy7uhEXRBVswOORCobCqqOslqHXRpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/166] accel/ivpu: Print information about used workarounds
Date: Mon, 18 Dec 2023 14:50:46 +0100
Message-ID: <20231218135108.615694722@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

[ Upstream commit eefa13a69053a09f20b2d1c00dda59be9c98cfe9 ]

Use ivpu_dbg(MISC) to print information about workarounds.

Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230901094957.168898-6-stanislaw.gruszka@linux.intel.com
Stable-dep-of: 35c49cfc8b70 ("accel/ivpu/37xx: Fix interrupt_clear_with_0 WA initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_drv.h     | 5 +++++
 drivers/accel/ivpu/ivpu_hw_37xx.c | 5 +++++
 drivers/accel/ivpu/ivpu_hw_40xx.c | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_drv.h b/drivers/accel/ivpu/ivpu_drv.h
index 2adc349126bb6..6853dfe1c7e58 100644
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -76,6 +76,11 @@
 
 #define IVPU_WA(wa_name) (vdev->wa.wa_name)
 
+#define IVPU_PRINT_WA(wa_name) do {					\
+	if (IVPU_WA(wa_name))						\
+		ivpu_dbg(vdev, MISC, "Using WA: " #wa_name "\n");	\
+} while (0)
+
 struct ivpu_wa_table {
 	bool punit_disabled;
 	bool clear_runtime_mem;
diff --git a/drivers/accel/ivpu/ivpu_hw_37xx.c b/drivers/accel/ivpu/ivpu_hw_37xx.c
index b8010c07eec17..2409ff0dda619 100644
--- a/drivers/accel/ivpu/ivpu_hw_37xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_37xx.c
@@ -104,6 +104,11 @@ static void ivpu_hw_wa_init(struct ivpu_device *vdev)
 
 	if (ivpu_device_id(vdev) == PCI_DEVICE_ID_MTL && ivpu_revision(vdev) < 4)
 		vdev->wa.interrupt_clear_with_0 = true;
+
+	IVPU_PRINT_WA(punit_disabled);
+	IVPU_PRINT_WA(clear_runtime_mem);
+	IVPU_PRINT_WA(d3hot_after_power_off);
+	IVPU_PRINT_WA(interrupt_clear_with_0);
 }
 
 static void ivpu_hw_timeouts_init(struct ivpu_device *vdev)
diff --git a/drivers/accel/ivpu/ivpu_hw_40xx.c b/drivers/accel/ivpu/ivpu_hw_40xx.c
index 7c3ff25232a2c..03600a7a5aca8 100644
--- a/drivers/accel/ivpu/ivpu_hw_40xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_40xx.c
@@ -125,6 +125,10 @@ static void ivpu_hw_wa_init(struct ivpu_device *vdev)
 
 	if (ivpu_hw_gen(vdev) == IVPU_HW_40XX)
 		vdev->wa.disable_clock_relinquish = true;
+
+	IVPU_PRINT_WA(punit_disabled);
+	IVPU_PRINT_WA(clear_runtime_mem);
+	IVPU_PRINT_WA(disable_clock_relinquish);
 }
 
 static void ivpu_hw_timeouts_init(struct ivpu_device *vdev)
-- 
2.43.0



