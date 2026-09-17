Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF9547C0F1;
	Thu, 17 Sep 2026 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665048; cv=none; b=G7PPglKMV0Vdv84O7O4/nyK/+TbRLIsYodh9WESBUfWUTVDAZZMb7tB8cAO3y8LG8dObDUW9bQXXQ5mpL9pVeG+p7SsLxBzldzU774wglDssUWEuDL26MIiJomh2iNa/zWxLp13nnSEjneGCWOECD5eiAmz7pLgtjhmB6sPSFvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665048; c=relaxed/simple;
	bh=C2cBtBg9bcnqyukaSHr2q7c4tUIOk2WSrKBUAMfohEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBPXuIV5sDudXnkj8ExA/ayzUxNfJ5swmkQ+D94RPxmR1d1lwTiNv0BHLHuBycL5yUMNrRo72UDY646r/CNvee22C74Y+MOcMnQCVb0JlpBIKIPJvO57W+/LZt8eVbt5ltC+8qnJiDC8/uFO5qaj0MKJ11To4KNzCipt13S5Ar4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+7pzQjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+7pzQjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908F21F00893;
	Thu, 17 Sep 2026 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665044;
	bh=n7Wb+PuLnlgtnBkp6XsX6czHNZK8oSd8pNx9dRMtZig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+7pzQjSVNDbgahnVV5qjDvYdKjKaKuHVdF9Zg2/y7Cm/ORDiT2f5s7IiKJrgK1j6
	 8P61AR37GjTt2swFFihyr3f2nEyvmR2fXGS7RO3exTTTq3Tz8n00pYtTJUDNCtMQ4J
	 UaLcIUDONJngNsQJqnRamZ1JITxM62/xrQU7TNLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Garg <hargar@linux.microsoft.com>,
	Tianyu Lan <Tianyu.Lan@microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0557/1250] Drivers: hv: vmbus: add VTL2 redirect connection ID
Date: Thu, 17 Sep 2026 16:05:52 +0100
Message-ID: <20260917151607.027618728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardik Garg <hargar@linux.microsoft.com>

[ Upstream commit 92d0593128023cf93ae61b7728dcc3062f8d514f ]

VMBus sends CHANNELMSG_INITIATE_CONTACT through a Hyper-V message
connection ID. Older protocol versions use VMBUS_MESSAGE_CONNECTION_ID,
while protocol version 5.0 and newer normally use
VMBUS_MESSAGE_CONNECTION_ID_4.

For a VTL2 kernel using VMBus protocol 5.0 or newer, the host
may expect INITIATE_CONTACT on either the redirect connection ID or
VMBUS_MESSAGE_CONNECTION_ID_4. There is no capability indication that
identifies which ID is active, so the driver must determine it at runtime.

During VMBus negotiation, the redirect ID is tried first because it is
used by VTL2 configurations with VMBus redirection enabled. If the
redirect ID is unavailable, the host rejects it synchronously with
HV_STATUS_INVALID_CONNECTION_ID, allowing fallback to the standard ID.

Return a distinct error for an invalid Initiate Contact connection ID so
this fallback does not mask other post-message failures or
protocol-version rejections. Preserve the existing connection ID
selection for older protocol versions or when running below VTL2.

Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c   | 47 +++++++++++++++++++++++----------------
 drivers/hv/hyperv_vmbus.h |  2 ++
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 1fe3573ae52a4..9be2af772867d 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -71,7 +71,8 @@ module_param(max_version, uint, S_IRUGO);
 MODULE_PARM_DESC(max_version,
 		 "Maximal VMBus protocol version which can be negotiated");
 
-int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
+static int vmbus_try_connection_id(struct vmbus_channel_msginfo *msginfo,
+				   u32 version, u32 connection_id)
 {
 	int ret = 0;
 	struct vmbus_channel_initiate_contact *msg;
@@ -86,20 +87,20 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 	msg->vmbus_version_requested = version;
 
 	/*
-	 * VMBus protocol 5.0 (VERSION_WIN10_V5) and higher require that we must
-	 * use VMBUS_MESSAGE_CONNECTION_ID_4 for the Initiate Contact Message,
-	 * and for subsequent messages, we must use the Message Connection ID
-	 * field in the host-returned Version Response Message. And, with
-	 * VERSION_WIN10_V5 and higher, we don't use msg->interrupt_page, but we
-	 * tell the host explicitly that we still use VMBUS_MESSAGE_SINT(2) for
-	 * compatibility.
+	 * For VMBus protocol 5.0 (VERSION_WIN10_V5) and higher, use the
+	 * caller-supplied connection_id for the Initiate Contact message so
+	 * the caller can implement the required retry scheme. For subsequent
+	 * messages, use the Message Connection ID field in the host-returned
+	 * Version Response message. With VERSION_WIN10_V5 and higher, we don't
+	 * use msg->interrupt_page, but tell the host explicitly that we still
+	 * use VMBUS_MESSAGE_SINT(2) for compatibility.
 	 *
 	 * On old hosts, we should always use VMBUS_MESSAGE_CONNECTION_ID (1).
 	 */
 	if (version >= VERSION_WIN10_V5) {
 		msg->msg_sint = VMBUS_MESSAGE_SINT;
 		msg->msg_vtl = ms_hyperv.vtl;
-		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID_4;
+		vmbus_connection.msg_conn_id = connection_id;
 	} else {
 		msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
 		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID;
@@ -161,6 +162,22 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 	return ret;
 }
 
+int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
+{
+	int ret;
+
+	/* Try the redirect ID first for VTL2 with VMBus protocol 5.0+. */
+	if (version >= VERSION_WIN10_V5 && ms_hyperv.vtl == 2) {
+		ret = vmbus_try_connection_id(msginfo, version,
+					      VMBUS_MESSAGE_CONNECTION_ID_REDIRECT);
+		if (ret != -ENXIO)
+			return ret;
+	}
+
+	return vmbus_try_connection_id(msginfo, version,
+				       VMBUS_MESSAGE_CONNECTION_ID_4);
+}
+
 /*
  * vmbus_connect - Sends a connect request on the partition service connection
  */
@@ -454,18 +471,10 @@ int vmbus_post_msg(void *buffer, size_t buflen, bool can_sleep)
 
 		switch (ret) {
 		case HV_STATUS_INVALID_CONNECTION_ID:
-			/*
-			 * See vmbus_negotiate_version(): VMBus protocol 5.0
-			 * and higher require that we must use
-			 * VMBUS_MESSAGE_CONNECTION_ID_4 for the Initiate
-			 * Contact message, but on old hosts that only
-			 * support VMBus protocol 4.0 or lower, here we get
-			 * HV_STATUS_INVALID_CONNECTION_ID and we should
-			 * return an error immediately without retrying.
-			 */
+			/* Allow INITIATE_CONTACT to try another connection ID. */
 			hdr = buffer;
 			if (hdr->msgtype == CHANNELMSG_INITIATE_CONTACT)
-				return -EINVAL;
+				return -ENXIO;
 			/*
 			 * We could get this if we send messages too
 			 * frequently.
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 39cdded062e8b..f16395ba5d823 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -108,6 +108,8 @@ struct hv_input_post_message {
 enum {
 	VMBUS_MESSAGE_CONNECTION_ID	= 1,
 	VMBUS_MESSAGE_CONNECTION_ID_4	= 4,
+	/* VTL2 redirect connection ID for INITIATE_CONTACT. */
+	VMBUS_MESSAGE_CONNECTION_ID_REDIRECT = 0x800074,
 	VMBUS_MESSAGE_PORT_ID		= 1,
 	VMBUS_EVENT_CONNECTION_ID	= 2,
 	VMBUS_EVENT_PORT_ID		= 2,
-- 
2.53.0



