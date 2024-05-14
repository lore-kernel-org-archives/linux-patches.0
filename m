Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D88D13B287;
	Tue, 14 May 2024 11:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684966; cv=none; b=rw9pjZC0dy6OtRAGdeEoJMrOdmnt0JhUW++jnnOd7UxpcCMst0HjYvu/p4Oiq5bRCXq0RNzsyqVc2oXCvLmaPV+ihZuyPnlppNKg5/wasoPKrxRgPwLP8Xp03W1vJhO4zTkCQFIC2s9bp2WmpWlcE5EIWefl4W5krp4uDy8VBpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684966; c=relaxed/simple;
	bh=N0SFvdPQI8ShWS3TgeoJMGOJTcLe/FovMFDAcDtN4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6wUThEaJlYGDDM2I3Qz8CDLwYvpKFNs8yIZ/qL3+Yc2B+Tg3DecW+lLpACeSz67wej1+t0cWnSN0QyKOWwExCdp2i8pKyU9Z11gG5WHKJ1W905WC49UNj93WWZ3dRC6sC4mTobpNMI8wi80cCoumyjLhqncMLknMrLr+WizwMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQA+leYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQA+leYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B422EC2BD10;
	Tue, 14 May 2024 11:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684966;
	bh=N0SFvdPQI8ShWS3TgeoJMGOJTcLe/FovMFDAcDtN4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQA+leYnW/Dg3iio7k42IQqJv/OUIkwnbTQgVEqxU2Tj6lAKvWb9JN62jk8Oz+f7w
	 ynwvsMqSRgBEAVgk/l4UchfY2g5S7kN7yUWfpV5HUZFJT+ZlO3YMIBT5sZdM9PTR4J
	 O+/fxBQRzLZugI1y+w3+rkF+7sgzV2BorOvMB1OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/301] drm/amdkfd: range check cp bad op exception interrupts
Date: Tue, 14 May 2024 12:16:25 +0200
Message-ID: <20240514101036.554614483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Jonathan Kim <Jonathan.Kim@amd.com>

[ Upstream commit 0cac183b98d8a8c692c98e8dba37df15a9e9210d ]

Due to a CP interrupt bug, bad packet garbage exception codes are raised.
Do a range check so that the debugger and runtime do not receive garbage
codes.
Update the user api to guard exception code type checking as well.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Tested-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdkfd/kfd_int_process_v10.c    |  3 ++-
 .../gpu/drm/amd/amdkfd/kfd_int_process_v11.c    |  3 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c |  3 ++-
 include/uapi/linux/kfd_ioctl.h                  | 17 ++++++++++++++---
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c
index a7697ec8188e0..f85ca6cb90f56 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c
@@ -336,7 +336,8 @@ static void event_interrupt_wq_v10(struct kfd_node *dev,
 				break;
 			}
 			kfd_signal_event_interrupt(pasid, context_id0 & 0x7fffff, 23);
-		} else if (source_id == SOC15_INTSRC_CP_BAD_OPCODE) {
+		} else if (source_id == SOC15_INTSRC_CP_BAD_OPCODE &&
+			   KFD_DBG_EC_TYPE_IS_PACKET(KFD_DEBUG_CP_BAD_OP_ECODE(context_id0))) {
 			kfd_set_dbg_ev_from_interrupt(dev, pasid,
 				KFD_DEBUG_DOORBELL_ID(context_id0),
 				KFD_EC_MASK(KFD_DEBUG_CP_BAD_OP_ECODE(context_id0)),
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c
index 2a65792fd1162..3ca9c160da7c2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c
@@ -325,7 +325,8 @@ static void event_interrupt_wq_v11(struct kfd_node *dev,
 		/* CP */
 		if (source_id == SOC15_INTSRC_CP_END_OF_PIPE)
 			kfd_signal_event_interrupt(pasid, context_id0, 32);
-		else if (source_id == SOC15_INTSRC_CP_BAD_OPCODE)
+		else if (source_id == SOC15_INTSRC_CP_BAD_OPCODE &&
+			 KFD_DBG_EC_TYPE_IS_PACKET(KFD_CTXID0_CP_BAD_OP_ECODE(context_id0)))
 			kfd_set_dbg_ev_from_interrupt(dev, pasid,
 				KFD_CTXID0_DOORBELL_ID(context_id0),
 				KFD_EC_MASK(KFD_CTXID0_CP_BAD_OP_ECODE(context_id0)),
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
index 27cdaea405017..8a6729939ae55 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
@@ -385,7 +385,8 @@ static void event_interrupt_wq_v9(struct kfd_node *dev,
 				break;
 			}
 			kfd_signal_event_interrupt(pasid, sq_int_data, 24);
-		} else if (source_id == SOC15_INTSRC_CP_BAD_OPCODE) {
+		} else if (source_id == SOC15_INTSRC_CP_BAD_OPCODE &&
+			   KFD_DBG_EC_TYPE_IS_PACKET(KFD_DEBUG_CP_BAD_OP_ECODE(context_id0))) {
 			kfd_set_dbg_ev_from_interrupt(dev, pasid,
 				KFD_DEBUG_DOORBELL_ID(context_id0),
 				KFD_EC_MASK(KFD_DEBUG_CP_BAD_OP_ECODE(context_id0)),
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index eeb2fdcbdcb70..cd924c959d732 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -909,14 +909,25 @@ enum kfd_dbg_trap_exception_code {
 				 KFD_EC_MASK(EC_DEVICE_NEW))
 #define KFD_EC_MASK_PROCESS	(KFD_EC_MASK(EC_PROCESS_RUNTIME) |	\
 				 KFD_EC_MASK(EC_PROCESS_DEVICE_REMOVE))
+#define KFD_EC_MASK_PACKET	(KFD_EC_MASK(EC_QUEUE_PACKET_DISPATCH_DIM_INVALID) |	\
+				 KFD_EC_MASK(EC_QUEUE_PACKET_DISPATCH_GROUP_SEGMENT_SIZE_INVALID) |	\
+				 KFD_EC_MASK(EC_QUEUE_PACKET_DISPATCH_CODE_INVALID) |	\
+				 KFD_EC_MASK(EC_QUEUE_PACKET_RESERVED) |	\
+				 KFD_EC_MASK(EC_QUEUE_PACKET_UNSUPPORTED) |	\
+				 KFD_EC_MASK(EC_QUEUE_PACKET_DISPATCH_WORK_GROUP_SIZE_INVALID) |	\
+				 KFD_EC_MASK(EC_QUEUE_PACKET_DISPATCH_REGISTER_INVALID) |	\
+				 KFD_EC_MASK(EC_QUEUE_PACKET_VENDOR_UNSUPPORTED))
 
 /* Checks for exception code types for KFD search */
+#define KFD_DBG_EC_IS_VALID(ecode) (ecode > EC_NONE && ecode < EC_MAX)
 #define KFD_DBG_EC_TYPE_IS_QUEUE(ecode)					\
-			(!!(KFD_EC_MASK(ecode) & KFD_EC_MASK_QUEUE))
+			(KFD_DBG_EC_IS_VALID(ecode) && !!(KFD_EC_MASK(ecode) & KFD_EC_MASK_QUEUE))
 #define KFD_DBG_EC_TYPE_IS_DEVICE(ecode)				\
-			(!!(KFD_EC_MASK(ecode) & KFD_EC_MASK_DEVICE))
+			(KFD_DBG_EC_IS_VALID(ecode) && !!(KFD_EC_MASK(ecode) & KFD_EC_MASK_DEVICE))
 #define KFD_DBG_EC_TYPE_IS_PROCESS(ecode)				\
-			(!!(KFD_EC_MASK(ecode) & KFD_EC_MASK_PROCESS))
+			(KFD_DBG_EC_IS_VALID(ecode) && !!(KFD_EC_MASK(ecode) & KFD_EC_MASK_PROCESS))
+#define KFD_DBG_EC_TYPE_IS_PACKET(ecode)				\
+			(KFD_DBG_EC_IS_VALID(ecode) && !!(KFD_EC_MASK(ecode) & KFD_EC_MASK_PACKET))
 
 
 /* Runtime enable states */
-- 
2.43.0



