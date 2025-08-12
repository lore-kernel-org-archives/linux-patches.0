Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04FD2FE560;
	Tue, 12 Aug 2025 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020258; cv=none; b=de9pU0n+uP9e1VneCPkJGnoYm0bn++E16x4YZW/R2FEJN6GRr4r0k9cy4MMeCBTbiG/GsXTBY7dQpb5fh5ck5yKFuu5rN4QpRchKN+pD1yaruKUvIF4CNWNFhSLTHnAhYIIPlsfAdSwkuHgSR7XgY/E3EqA7b5Dd6IoWEa4X7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020258; c=relaxed/simple;
	bh=kvVuIoknzEldHKvpHJTBRs7JCdPfezWQxaT1rDlKCA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttrsdRIen2JbzzBewnl6sdEfC287dHXds5T68AbPdkA9gtjSxxcKTHpqvcbddKPQ27+7S3lwx0kbb8cDjTaDTEe17XTrQqWaPOFlxkOTyb/xubrSAISGVfOvkQLv7fSOSa6mW7JiadSbd0YzEv1/1RdN7WgQbQSlgwyOD9nX6UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhPbtXKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhPbtXKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F6DC4CEF0;
	Tue, 12 Aug 2025 17:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020257;
	bh=kvVuIoknzEldHKvpHJTBRs7JCdPfezWQxaT1rDlKCA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhPbtXKhG1734fI0IuIwNa1FMT7whS29DEDDWXzD4tK1UIodUYW0gZMrONkuPWxEP
	 r3VIEtSD6KAi6gG/qf+2j2j+vxVKn8zdFHJH2sppY/RJRUZsbsL/yljzuSk2QIDi0R
	 HldJ+ZvIpYj1wHsAyLH/VNhmz5dSxWfCH/EpOlOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/253] staging: vc04_services: Drop VCHIQ_ERROR usage
Date: Tue, 12 Aug 2025 19:26:37 +0200
Message-ID: <20250812172949.092403189@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit ab73dc85328195c10a55b8f0fbc5b0e2749c628a ]

Drop the usage of VCHIQ_ERROR vchiq_status enum type. Replace it with
-EINVAL to report the error in most cases, -ENOMEM for out-of-memory
errors and -EHOSTDOWN for service shutdown.

This patch acts as intermediatory to address the TODO item:
    * Get rid of custom function return values
for vc04_services/interface.

Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20221223122404.170585-4-umang.jain@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f2b8ebfb8670 ("staging: vchiq_arm: Make vchiq_shutdown never fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../include/linux/raspberrypi/vchiq.h         |  1 -
 .../interface/vchiq_arm/vchiq_arm.c           | 24 +++++-----
 .../interface/vchiq_arm/vchiq_core.c          | 44 +++++++++----------
 .../interface/vchiq_arm/vchiq_dev.c           |  6 +--
 4 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
index ce73930d71d1a..842bec937bd90 100644
--- a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
+++ b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
@@ -18,7 +18,6 @@ enum vchiq_reason {
 };
 
 enum vchiq_status {
-	VCHIQ_ERROR   = -1,
 	VCHIQ_RETRY   = 1
 };
 
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index f27f5a1a23e2f..d0b08ed078670 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -496,7 +496,7 @@ static int vchiq_platform_init(struct platform_device *pdev, struct vchiq_state
 
 	vchiq_slot_zero = vchiq_init_slots(slot_mem, slot_mem_size);
 	if (!vchiq_slot_zero)
-		return -EINVAL;
+		return -ENOMEM;
 
 	vchiq_slot_zero->platform_data[VCHIQ_PLATFORM_FRAGMENTS_OFFSET_IDX] =
 		(int)slot_phys + slot_mem_size;
@@ -782,7 +782,7 @@ vchiq_add_service(struct vchiq_instance *instance,
 		*phandle = service->handle;
 		status = 0;
 	} else {
-		status = VCHIQ_ERROR;
+		status = -EINVAL;
 	}
 
 	vchiq_log_trace(vchiq_core_log_level, "%s(%p): returning %d", __func__, instance, status);
@@ -795,7 +795,7 @@ vchiq_open_service(struct vchiq_instance *instance,
 		   const struct vchiq_service_params_kernel *params,
 		   unsigned int *phandle)
 {
-	enum vchiq_status   status = VCHIQ_ERROR;
+	int status = -EINVAL;
 	struct vchiq_state   *state = instance->state;
 	struct vchiq_service *service = NULL;
 
@@ -842,7 +842,7 @@ vchiq_bulk_transmit(struct vchiq_instance *instance, unsigned int handle, const
 							      VCHIQ_BULK_TRANSMIT);
 			break;
 		default:
-			return VCHIQ_ERROR;
+			return -EINVAL;
 		}
 
 		/*
@@ -879,7 +879,7 @@ enum vchiq_status vchiq_bulk_receive(struct vchiq_instance *instance, unsigned i
 							      VCHIQ_BULK_RECEIVE);
 			break;
 		default:
-			return VCHIQ_ERROR;
+			return -EINVAL;
 		}
 
 		/*
@@ -907,7 +907,7 @@ vchiq_blocking_bulk_transfer(struct vchiq_instance *instance, unsigned int handl
 
 	service = find_service_by_handle(instance, handle);
 	if (!service)
-		return VCHIQ_ERROR;
+		return -EINVAL;
 
 	vchiq_service_put(service);
 
@@ -941,7 +941,7 @@ vchiq_blocking_bulk_transfer(struct vchiq_instance *instance, unsigned int handl
 		waiter = kzalloc(sizeof(*waiter), GFP_KERNEL);
 		if (!waiter) {
 			vchiq_log_error(vchiq_core_log_level, "%s - out of memory", __func__);
-			return VCHIQ_ERROR;
+			return -ENOMEM;
 		}
 	}
 
@@ -1114,7 +1114,7 @@ service_callback(struct vchiq_instance *instance, enum vchiq_reason reason,
 				vchiq_log_info(vchiq_arm_log_level, "%s closing", __func__);
 				DEBUG_TRACE(SERVICE_CALLBACK_LINE);
 				vchiq_service_put(service);
-				return VCHIQ_ERROR;
+				return -EINVAL;
 			}
 			DEBUG_TRACE(SERVICE_CALLBACK_LINE);
 			spin_lock(&msg_queue_spinlock);
@@ -1577,7 +1577,7 @@ vchiq_instance_set_trace(struct vchiq_instance *instance, int trace)
 enum vchiq_status
 vchiq_use_service(struct vchiq_instance *instance, unsigned int handle)
 {
-	enum vchiq_status ret = VCHIQ_ERROR;
+	int ret = -EINVAL;
 	struct vchiq_service *service = find_service_by_handle(instance, handle);
 
 	if (service) {
@@ -1591,7 +1591,7 @@ EXPORT_SYMBOL(vchiq_use_service);
 enum vchiq_status
 vchiq_release_service(struct vchiq_instance *instance, unsigned int handle)
 {
-	enum vchiq_status ret = VCHIQ_ERROR;
+	int ret = -EINVAL;
 	struct vchiq_service *service = find_service_by_handle(instance, handle);
 
 	if (service) {
@@ -1686,7 +1686,7 @@ enum vchiq_status
 vchiq_check_service(struct vchiq_service *service)
 {
 	struct vchiq_arm_state *arm_state;
-	enum vchiq_status ret = VCHIQ_ERROR;
+	int ret = -EINVAL;
 
 	if (!service || !service->state)
 		goto out;
@@ -1698,7 +1698,7 @@ vchiq_check_service(struct vchiq_service *service)
 		ret = 0;
 	read_unlock_bh(&arm_state->susp_res_lock);
 
-	if (ret == VCHIQ_ERROR) {
+	if (ret) {
 		vchiq_log_error(vchiq_susp_log_level,
 				"%s ERROR - %c%c%c%c:%d service count %d, state count %d", __func__,
 				VCHIQ_FOURCC_AS_4CHARS(service->base.fourcc), service->client_id,
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index 9c4523d04bdbb..e60f294fdb682 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -467,14 +467,14 @@ static inline enum vchiq_status
 make_service_callback(struct vchiq_service *service, enum vchiq_reason reason,
 		      struct vchiq_header *header, void *bulk_userdata)
 {
-	enum vchiq_status status;
+	int status;
 
 	vchiq_log_trace(vchiq_core_log_level, "%d: callback:%d (%s, %pK, %pK)",
 			service->state->id, service->localport, reason_names[reason],
 			header, bulk_userdata);
 	status = service->base.callback(service->instance, reason, header, service->handle,
 					bulk_userdata);
-	if (status == VCHIQ_ERROR) {
+	if (status && (status != VCHIQ_RETRY)) {
 		vchiq_log_warning(vchiq_core_log_level,
 				  "%d: ignoring ERROR from callback to service %x",
 				  service->state->id, service->handle);
@@ -930,7 +930,7 @@ queue_message(struct vchiq_state *state, struct vchiq_service *service,
 		if (!service) {
 			WARN(1, "%s: service is NULL\n", __func__);
 			mutex_unlock(&state->slot_mutex);
-			return VCHIQ_ERROR;
+			return -EINVAL;
 		}
 
 		WARN_ON(flags & (QMFLAGS_NO_MUTEX_LOCK |
@@ -939,7 +939,7 @@ queue_message(struct vchiq_state *state, struct vchiq_service *service,
 		if (service->closing) {
 			/* The service has been closed */
 			mutex_unlock(&state->slot_mutex);
-			return VCHIQ_ERROR;
+			return -EHOSTDOWN;
 		}
 
 		quota = &state->service_quotas[service->localport];
@@ -989,13 +989,13 @@ queue_message(struct vchiq_state *state, struct vchiq_service *service,
 			if (wait_for_completion_interruptible(&quota->quota_event))
 				return VCHIQ_RETRY;
 			if (service->closing)
-				return VCHIQ_ERROR;
+				return -EHOSTDOWN;
 			if (mutex_lock_killable(&state->slot_mutex))
 				return VCHIQ_RETRY;
 			if (service->srvstate != VCHIQ_SRVSTATE_OPEN) {
 				/* The service has been closed */
 				mutex_unlock(&state->slot_mutex);
-				return VCHIQ_ERROR;
+				return -EHOSTDOWN;
 			}
 			spin_lock(&quota_spinlock);
 			tx_end_index = SLOT_QUEUE_INDEX_FROM_POS(state->local_tx_pos + stride - 1);
@@ -1037,7 +1037,7 @@ queue_message(struct vchiq_state *state, struct vchiq_service *service,
 		if (callback_result < 0) {
 			mutex_unlock(&state->slot_mutex);
 			VCHIQ_SERVICE_STATS_INC(service, error_count);
-			return VCHIQ_ERROR;
+			return -EINVAL;
 		}
 
 		if (SRVTRACE_ENABLED(service,
@@ -1185,7 +1185,7 @@ queue_message_sync(struct vchiq_state *state, struct vchiq_service *service,
 	if (callback_result < 0) {
 		mutex_unlock(&state->slot_mutex);
 		VCHIQ_SERVICE_STATS_INC(service, error_count);
-		return VCHIQ_ERROR;
+		return -EINVAL;
 	}
 
 	if (service) {
@@ -2520,7 +2520,7 @@ vchiq_open_service_internal(struct vchiq_service *service, int client_id)
 					service->state->id,
 					srvstate_names[service->srvstate],
 					kref_read(&service->ref_count));
-		status = VCHIQ_ERROR;
+		status = -EINVAL;
 		VCHIQ_SERVICE_STATS_INC(service, error_count);
 		vchiq_release_service_internal(service);
 	}
@@ -2638,7 +2638,7 @@ close_service_complete(struct vchiq_service *service, int failstate)
 		vchiq_log_error(vchiq_core_log_level, "%s(%x) called in state %s", __func__,
 				service->handle, srvstate_names[service->srvstate]);
 		WARN(1, "%s in unexpected state\n", __func__);
-		return VCHIQ_ERROR;
+		return -EINVAL;
 	}
 
 	status = make_service_callback(service, VCHIQ_SERVICE_CLOSED, NULL, NULL);
@@ -2695,7 +2695,7 @@ vchiq_close_service_internal(struct vchiq_service *service, int close_recvd)
 					__func__, srvstate_names[service->srvstate]);
 		} else if (is_server) {
 			if (service->srvstate == VCHIQ_SRVSTATE_LISTENING) {
-				status = VCHIQ_ERROR;
+				status = -EINVAL;
 			} else {
 				service->client_id = 0;
 				service->remoteport = VCHIQ_PORT_FREE;
@@ -2886,7 +2886,7 @@ vchiq_close_service(struct vchiq_instance *instance, unsigned int handle)
 	int status = 0;
 
 	if (!service)
-		return VCHIQ_ERROR;
+		return -EINVAL;
 
 	vchiq_log_info(vchiq_core_log_level, "%d: close_service:%d",
 		       service->state->id, service->localport);
@@ -2895,7 +2895,7 @@ vchiq_close_service(struct vchiq_instance *instance, unsigned int handle)
 	    (service->srvstate == VCHIQ_SRVSTATE_LISTENING) ||
 	    (service->srvstate == VCHIQ_SRVSTATE_HIDDEN)) {
 		vchiq_service_put(service);
-		return VCHIQ_ERROR;
+		return -EINVAL;
 	}
 
 	mark_service_closing(service);
@@ -2928,7 +2928,7 @@ vchiq_close_service(struct vchiq_instance *instance, unsigned int handle)
 	if (!status &&
 	    (service->srvstate != VCHIQ_SRVSTATE_FREE) &&
 	    (service->srvstate != VCHIQ_SRVSTATE_LISTENING))
-		status = VCHIQ_ERROR;
+		status = -EINVAL;
 
 	vchiq_service_put(service);
 
@@ -2944,14 +2944,14 @@ vchiq_remove_service(struct vchiq_instance *instance, unsigned int handle)
 	int status = 0;
 
 	if (!service)
-		return VCHIQ_ERROR;
+		return -EINVAL;
 
 	vchiq_log_info(vchiq_core_log_level, "%d: remove_service:%d",
 		       service->state->id, service->localport);
 
 	if (service->srvstate == VCHIQ_SRVSTATE_FREE) {
 		vchiq_service_put(service);
-		return VCHIQ_ERROR;
+		return -EINVAL;
 	}
 
 	mark_service_closing(service);
@@ -2987,7 +2987,7 @@ vchiq_remove_service(struct vchiq_instance *instance, unsigned int handle)
 	}
 
 	if (!status && (service->srvstate != VCHIQ_SRVSTATE_FREE))
-		status = VCHIQ_ERROR;
+		status = -EINVAL;
 
 	vchiq_service_put(service);
 
@@ -3014,7 +3014,7 @@ enum vchiq_status vchiq_bulk_transfer(struct vchiq_instance *instance, unsigned
 	const char dir_char = (dir == VCHIQ_BULK_TRANSMIT) ? 't' : 'r';
 	const int dir_msgtype = (dir == VCHIQ_BULK_TRANSMIT) ?
 		VCHIQ_MSG_BULK_TX : VCHIQ_MSG_BULK_RX;
-	enum vchiq_status status = VCHIQ_ERROR;
+	int status = -EINVAL;
 	int payload[2];
 
 	if (!service)
@@ -3141,7 +3141,7 @@ enum vchiq_status vchiq_bulk_transfer(struct vchiq_instance *instance, unsigned
 		if (wait_for_completion_interruptible(&bulk_waiter->event))
 			status = VCHIQ_RETRY;
 		else if (bulk_waiter->actual == VCHIQ_BULK_ACTUAL_ABORTED)
-			status = VCHIQ_ERROR;
+			status = -EINVAL;
 	}
 
 	return status;
@@ -3167,7 +3167,7 @@ vchiq_queue_message(struct vchiq_instance *instance, unsigned int handle,
 		    size_t size)
 {
 	struct vchiq_service *service = find_service_by_handle(instance, handle);
-	enum vchiq_status status = VCHIQ_ERROR;
+	int status = -EINVAL;
 	int data_id;
 
 	if (!service)
@@ -3198,7 +3198,7 @@ vchiq_queue_message(struct vchiq_instance *instance, unsigned int handle,
 					    copy_callback, context, size, 1);
 		break;
 	default:
-		status = VCHIQ_ERROR;
+		status = -EINVAL;
 		break;
 	}
 
@@ -3278,7 +3278,7 @@ release_message_sync(struct vchiq_state *state, struct vchiq_header *header)
 enum vchiq_status
 vchiq_get_peer_version(struct vchiq_instance *instance, unsigned int handle, short *peer_version)
 {
-	enum vchiq_status status = VCHIQ_ERROR;
+	int status = -EINVAL;
 	struct vchiq_service *service = find_service_by_handle(instance, handle);
 
 	if (!service)
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_dev.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_dev.c
index d9c4d550412e4..df274192937e5 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_dev.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_dev.c
@@ -130,7 +130,7 @@ vchiq_ioc_queue_message(struct vchiq_instance *instance, unsigned int handle,
 	status = vchiq_queue_message(instance, handle, vchiq_ioc_copy_element_data,
 				     &context, total_size);
 
-	if (status == VCHIQ_ERROR)
+	if (status == -EINVAL)
 		return -EIO;
 	else if (status == VCHIQ_RETRY)
 		return -EINTR;
@@ -364,7 +364,7 @@ static int vchiq_irq_queue_bulk_tx_rx(struct vchiq_instance *instance,
 	vchiq_service_put(service);
 	if (ret)
 		return ret;
-	else if (status == VCHIQ_ERROR)
+	else if (status == -EINVAL)
 		return -EIO;
 	else if (status == VCHIQ_RETRY)
 		return -EINTR;
@@ -862,7 +862,7 @@ vchiq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		vchiq_service_put(service);
 
 	if (ret == 0) {
-		if (status == VCHIQ_ERROR)
+		if (status == -EINVAL)
 			ret = -EIO;
 		else if (status == VCHIQ_RETRY)
 			ret = -EINTR;
-- 
2.39.5



