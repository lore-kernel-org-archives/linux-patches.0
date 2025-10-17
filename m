Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3A0330B1D;
	Fri, 17 Oct 2025 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715756; cv=none; b=alQPZ5+K16KzhC7lM4GfOG+EHFV3Qeqbi2USphZLCQk/BJR23K0HPUmqbGkUB0jHCjqwfNts1Cbg9mwed22N7lN9Aj07eON/OFl9t9lj5nIAmS3HZdzKDWTatlIkOqjvdD7hut3S61jbcADqo+grblRPB5RFn2Rf/LhY8mQuUJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715756; c=relaxed/simple;
	bh=9rRvqXIorU9r5l7Yo2rWEEaW3ES64D1CKcmKEwWR6S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRDljCiJDAo3C0DVgCWSYrKoXPk1MnxVIDRVlLWJRK3qy3NulHlBndUp/hUIH3jSoRpzqu2oxY+l07Ao6a0WQmIUvO0EyrIIrYJs7JmXvgVwXYQ8iimwDXgScMbtPyYFmJr37z3ojHeBF1haMcFRK9DBDKvebGCV4MJaijIv6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t916Edo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t916Edo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3285EC4CEE7;
	Fri, 17 Oct 2025 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715756;
	bh=9rRvqXIorU9r5l7Yo2rWEEaW3ES64D1CKcmKEwWR6S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0t916EdoqreF1URd9+zfNnWPsuef4cmTnTTcm4RkGJVWn+Cyd+bG7yf3wBNdjLDL2
	 tJsD60rpVKj5Pt95LPy3k57KXwDl9nfMPtuHUvNGydqh24dySslkCOK5lGdJ35Bav7
	 3QzDDUTehOWMRBmfof0CgszIUZhyPORo5be6hJac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 326/371] media: iris: fix module removal if firmware download failed
Date: Fri, 17 Oct 2025 16:55:01 +0200
Message-ID: <20251017145213.871152658@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

commit fde38008fc4f43db8c17869491870df24b501543 upstream.

Fix remove if firmware failed to load:
qcom-iris aa00000.video-codec: Direct firmware load for qcom/vpu/vpu33_p4.mbn failed with error -2
qcom-iris aa00000.video-codec: firmware download failed
qcom-iris aa00000.video-codec: core init failed

then:
$ echo aa00000.video-codec > /sys/bus/platform/drivers/qcom-iris/unbind

Triggers:
genpd genpd:1:aa00000.video-codec: Runtime PM usage count underflow!
------------[ cut here ]------------
video_cc_mvs0_clk already disabled
WARNING: drivers/clk/clk.c:1206 at clk_core_disable+0xa4/0xac, CPU#1: sh/542
<snip>
pc : clk_core_disable+0xa4/0xac
lr : clk_core_disable+0xa4/0xac
<snip>
Call trace:
 clk_core_disable+0xa4/0xac (P)
 clk_disable+0x30/0x4c
 iris_disable_unprepare_clock+0x20/0x48 [qcom_iris]
 iris_vpu_power_off_hw+0x48/0x58 [qcom_iris]
 iris_vpu33_power_off_hardware+0x44/0x230 [qcom_iris]
 iris_vpu_power_off+0x34/0x84 [qcom_iris]
 iris_core_deinit+0x44/0xc8 [qcom_iris]
 iris_remove+0x20/0x48 [qcom_iris]
 platform_remove+0x20/0x30
 device_remove+0x4c/0x80
<snip>
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
video_cc_mvs0_clk already unprepared
WARNING: drivers/clk/clk.c:1065 at clk_core_unprepare+0xf0/0x110, CPU#2: sh/542
<snip>
pc : clk_core_unprepare+0xf0/0x110
lr : clk_core_unprepare+0xf0/0x110
<snip>
Call trace:
 clk_core_unprepare+0xf0/0x110 (P)
 clk_unprepare+0x2c/0x44
 iris_disable_unprepare_clock+0x28/0x48 [qcom_iris]
 iris_vpu_power_off_hw+0x48/0x58 [qcom_iris]
 iris_vpu33_power_off_hardware+0x44/0x230 [qcom_iris]
 iris_vpu_power_off+0x34/0x84 [qcom_iris]
 iris_core_deinit+0x44/0xc8 [qcom_iris]
 iris_remove+0x20/0x48 [qcom_iris]
 platform_remove+0x20/0x30
 device_remove+0x4c/0x80
<snip>
---[ end trace 0000000000000000 ]---
genpd genpd:0:aa00000.video-codec: Runtime PM usage count underflow!
------------[ cut here ]------------
gcc_video_axi0_clk already disabled
WARNING: drivers/clk/clk.c:1206 at clk_core_disable+0xa4/0xac, CPU#4: sh/542
<snip>
pc : clk_core_disable+0xa4/0xac
lr : clk_core_disable+0xa4/0xac
<snip>
Call trace:
 clk_core_disable+0xa4/0xac (P)
 clk_disable+0x30/0x4c
 iris_disable_unprepare_clock+0x20/0x48 [qcom_iris]
 iris_vpu33_power_off_controller+0x17c/0x428 [qcom_iris]
 iris_vpu_power_off+0x48/0x84 [qcom_iris]
 iris_core_deinit+0x44/0xc8 [qcom_iris]
 iris_remove+0x20/0x48 [qcom_iris]
 platform_remove+0x20/0x30
 device_remove+0x4c/0x80
<snip>
------------[ cut here ]------------
gcc_video_axi0_clk already unprepared
WARNING: drivers/clk/clk.c:1065 at clk_core_unprepare+0xf0/0x110, CPU#4: sh/542
<snip>
pc : clk_core_unprepare+0xf0/0x110
lr : clk_core_unprepare+0xf0/0x110
<snip>
Call trace:
 clk_core_unprepare+0xf0/0x110 (P)
 clk_unprepare+0x2c/0x44
 iris_disable_unprepare_clock+0x28/0x48 [qcom_iris]
 iris_vpu33_power_off_controller+0x17c/0x428 [qcom_iris]
 iris_vpu_power_off+0x48/0x84 [qcom_iris]
 iris_core_deinit+0x44/0xc8 [qcom_iris]
 iris_remove+0x20/0x48 [qcom_iris]
 platform_remove+0x20/0x30
 device_remove+0x4c/0x80
<snip>
---[ end trace 0000000000000000 ]---

Skip deinit if initialization never succeeded.

Fixes: d7378f84e94e ("media: iris: introduce iris core state management with shared queues")
Fixes: d19b163356b8 ("media: iris: implement video firmware load/unload")
Fixes: bb8a95aa038e ("media: iris: implement power management")
Cc: stable@vger.kernel.org
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_core.c b/drivers/media/platform/qcom/iris/iris_core.c
index 0fa0a3b549a2..8406c48d635b 100644
--- a/drivers/media/platform/qcom/iris/iris_core.c
+++ b/drivers/media/platform/qcom/iris/iris_core.c
@@ -15,10 +15,12 @@ void iris_core_deinit(struct iris_core *core)
 	pm_runtime_resume_and_get(core->dev);
 
 	mutex_lock(&core->lock);
-	iris_fw_unload(core);
-	iris_vpu_power_off(core);
-	iris_hfi_queues_deinit(core);
-	core->state = IRIS_CORE_DEINIT;
+	if (core->state != IRIS_CORE_DEINIT) {
+		iris_fw_unload(core);
+		iris_vpu_power_off(core);
+		iris_hfi_queues_deinit(core);
+		core->state = IRIS_CORE_DEINIT;
+	}
 	mutex_unlock(&core->lock);
 
 	pm_runtime_put_sync(core->dev);
-- 
2.51.0



