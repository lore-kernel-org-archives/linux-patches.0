Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017831;
	b=oOdeeD1pBgY+/0iS7yTMZLzdEHherCwH57fVbE07VjXSjuA+opazSiaCOByeZR6H6h3H
	 OvT8OH4qHBri57JY4lHbqiFjNWdn9A19QqfrvHc5gyUk9HfA5lkD2HzM8dB2oZ4SFcM7X
	 Lnil0hle23S9OzVhQc7kkmJuzeQ1MfxeGNxGPmLCKGgibkATHRZrHqAQMbY5wqu2XJz2K
	 yoPtzN3N/KC9zNsFh7kawA7bunvDk0l3JfOmK8b7aRWW/mSXkhSdCS3XfjOOpeydj943V
	 Ya2RCdkuen9RdTnt+sZKDmAXz9KXUUDRqibsxRWYL85Mb6QntwQRJ9KkrO1KrJdiNFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVgn6GGy3Ry6VJYO47MlrjcdiUrNTtTK9D/x/BKKqGs=;
	b=pgcWCYqZjQthdirNqRubm9ZySdLATwCGfavxF8tz4wQW0ZToLAI0SVWOf5D1m2GKUEoc
	 yHiG3nP/sBMWM3BAhfDsNL0WRydR0UI2LUsfU7uA2z6129Y1AeFAXy9dld3WBEGB3U5qr
	 aj+nOQpP3B6r6P7xPsR/Kf3KX6BnLqZNTTphpNOn/QPfV35SVNvtS8+fDffXAumhVMMTM
	 YMHm5bA1ZNb9hfA2OSngevrBAm2gHvApo1yE73329EN4Ocizud/OEqj1niBCkHkKjtZWf
	 iNJnGFosUsjkGzP2E18gR0W+X1lm8rtRrhV3qfKNs8C9tCe1g4emG8wmJKfsVc2Bl0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzEdYRvH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07588606A320;
	Wed, 18 Nov 2026 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzEdYRvH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592151F000C4;
	Wed, 18 Nov 2026 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017830;
	bh=zVgn6GGy3Ry6VJYO47MlrjcdiUrNTtTK9D/x/BKKqGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzEdYRvH1blx6hmKueiZlHrj34El0q3xIiz8gTiCtSQLEV86srEPOyVOYAS5L1MnP
	 G36YRCLR+Ag4x3ww2GD6RZObKjJVQ9rjsx5I5Wv92r2afF1Lz26oA+hoZbz3SJF7LY
	 KEhynV1a7O5CoCqoQcPyERxvAX8RYEaGWzV7GbXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1024/2651] media: iris: reference count video instances
Date: Wed, 18 Nov 2026 15:37:44 +0100
Message-ID: <20261118150324.812620647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit af5f7df6c8b33bed714ec0aea15a0a2f48900c0a ]

iris_get_instance() looks up an instance on core->instances and returns
it after dropping core->lock, without taking any reference. The threaded
interrupt handler uses this to find the instance a firmware response
belongs to and then takes inst->lock. Meanwhile userspace may close the
same file descriptor: iris_close() removes the instance from the list,
destroys inst->lock and frees the instance. The interrupt handler then
operates on freed memory and a destroyed mutex, a use-after-free.

Add a kref to struct iris_inst. iris_get_instance() takes a reference
under core->lock, so an instance it returns cannot be freed until the
caller drops that reference with iris_inst_put(). The instance is
released (mutexes destroyed, memory freed) only when the last reference
goes away, whether that is held by the closing thread or the interrupt
handler.

Fixes: 38fc8beaba55 ("media: iris: implement reqbuf ioctl with vb2_queue_setup")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/iris/iris_hfi_gen1_response.c        |  2 ++
 .../qcom/iris/iris_hfi_gen2_response.c        |  1 +
 .../media/platform/qcom/iris/iris_instance.h  |  4 ++++
 drivers/media/platform/qcom/iris/iris_utils.c |  6 +++++
 drivers/media/platform/qcom/iris/iris_utils.h |  1 +
 drivers/media/platform/qcom/iris/iris_vidc.c  | 23 +++++++++++++++----
 6 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
index bfd7495bf44f0..e2b95c22f4d13 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
@@ -632,6 +632,7 @@ static void iris_hfi_gen1_handle_response(struct iris_core *core, void *response
 			mutex_lock(&inst->lock);
 			iris_hfi_gen1_session_event_notify(inst, hdr);
 			mutex_unlock(&inst->lock);
+			iris_inst_put(inst);
 		} else {
 			iris_hfi_gen1_sys_event_notify(core, hdr);
 		}
@@ -667,6 +668,7 @@ static void iris_hfi_gen1_handle_response(struct iris_core *core, void *response
 			}
 		}
 		mutex_unlock(&inst->lock);
+		iris_inst_put(inst);
 
 		break;
 	}
diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
index 8c2644c7f6e85..f0782c4b1e6e8 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
@@ -969,6 +969,7 @@ static int iris_hfi_gen2_handle_session_response(struct iris_core *core,
 		iris_hfi_gen2_handle_dequeue_buffers(inst);
 
 	mutex_unlock(&inst->lock);
+	iris_inst_put(inst);
 
 	return ret;
 }
diff --git a/drivers/media/platform/qcom/iris/iris_instance.h b/drivers/media/platform/qcom/iris/iris_instance.h
index a770331d16757..dde5d0b8a83bf 100644
--- a/drivers/media/platform/qcom/iris/iris_instance.h
+++ b/drivers/media/platform/qcom/iris/iris_instance.h
@@ -6,6 +6,8 @@
 #ifndef __IRIS_INSTANCE_H__
 #define __IRIS_INSTANCE_H__
 
+#include <linux/kref.h>
+
 #include <media/v4l2-ctrls.h>
 
 #include "iris_buffer.h"
@@ -35,6 +37,7 @@ enum iris_fmt_type_cap {
  * struct iris_inst - holds per video instance parameters
  *
  * @list: used for attach an instance to the core
+ * @kref: reference count, keeps the instance alive while the IRQ thread uses it
  * @core: pointer to core structure
  * @session_id: id of current video session
  * @hfi_session_ops: iris HFI session ops
@@ -82,6 +85,7 @@ enum iris_fmt_type_cap {
 
 struct iris_inst {
 	struct list_head		list;
+	struct kref			kref;
 	struct iris_core		*core;
 	u32				session_id;
 	const struct iris_hfi_session_ops	*hfi_session_ops;
diff --git a/drivers/media/platform/qcom/iris/iris_utils.c b/drivers/media/platform/qcom/iris/iris_utils.c
index ba5c8dc1280c2..1096cc4b01c36 100644
--- a/drivers/media/platform/qcom/iris/iris_utils.c
+++ b/drivers/media/platform/qcom/iris/iris_utils.c
@@ -92,6 +92,12 @@ struct iris_inst *iris_get_instance(struct iris_core *core, u32 session_id)
 	mutex_lock(&core->lock);
 	list_for_each_entry(inst, &core->instances, list) {
 		if (inst->session_id == session_id) {
+			/*
+			 * Take a reference under core->lock, paired with
+			 * iris_inst_put() once the caller is done, so the
+			 * instance cannot be freed by a concurrent close().
+			 */
+			kref_get(&inst->kref);
 			mutex_unlock(&core->lock);
 			return inst;
 		}
diff --git a/drivers/media/platform/qcom/iris/iris_utils.h b/drivers/media/platform/qcom/iris/iris_utils.h
index 228a5f963812b..be23acc0e8484 100644
--- a/drivers/media/platform/qcom/iris/iris_utils.h
+++ b/drivers/media/platform/qcom/iris/iris_utils.h
@@ -48,6 +48,7 @@ bool iris_split_mode_enabled(struct iris_inst *inst);
 bool iris_fmt_is_8bit(u32 pixelformat);
 bool iris_fmt_is_10bit(u32 pixelformat);
 struct iris_inst *iris_get_instance(struct iris_core *core, u32 session_id);
+void iris_inst_put(struct iris_inst *inst);
 void iris_helper_buffers_done(struct iris_inst *inst, unsigned int type,
 			      enum vb2_buffer_state state);
 int iris_wait_for_session_response(struct iris_inst *inst, bool is_flush);
diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index afec4a1ff163f..63c1611af6f6a 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -39,6 +39,22 @@ static void iris_v4l2_fh_deinit(struct iris_inst *inst, struct file *filp)
 	v4l2_fh_exit(&inst->fh);
 }
 
+static void iris_inst_release(struct kref *kref)
+{
+	struct iris_inst *inst = container_of(kref, struct iris_inst, kref);
+
+	mutex_destroy(&inst->ctx_q_lock);
+	mutex_destroy(&inst->lock);
+	kfree(inst->fmt_src);
+	kfree(inst->fmt_dst);
+	kfree(inst);
+}
+
+void iris_inst_put(struct iris_inst *inst)
+{
+	kref_put(&inst->kref, iris_inst_release);
+}
+
 static int iris_add_session(struct iris_inst *inst)
 {
 	struct iris_core *core = inst->core;
@@ -166,6 +182,7 @@ int iris_open(struct file *filp)
 	inst->domain = session_type;
 	inst->session_id = hash32_ptr(inst);
 	inst->state = IRIS_INST_DEINIT;
+	kref_init(&inst->kref);
 
 	mutex_init(&inst->lock);
 	mutex_init(&inst->ctx_q_lock);
@@ -305,11 +322,7 @@ int iris_close(struct file *filp)
 	iris_check_num_queued_internal_buffers(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	iris_remove_session(inst);
 	mutex_unlock(&inst->lock);
-	mutex_destroy(&inst->ctx_q_lock);
-	mutex_destroy(&inst->lock);
-	kfree(inst->fmt_src);
-	kfree(inst->fmt_dst);
-	kfree(inst);
+	iris_inst_put(inst);
 
 	return 0;
 }
-- 
2.53.0



