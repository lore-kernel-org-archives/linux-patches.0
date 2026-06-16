Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8E6332EC1;
	Tue, 16 Jun 2026 17:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631163; cv=none; b=DTBtpypc6c5IFT3zf5xO8fPufEwIwumLj4+L1YEJhth7GsXTGKyGAwdguMXr6lFaT+3g7xmPq9yWKF32ouDyUbnJi7NT65ymH5R6Z973MlDxGWON9qlfcz1WNweVaGES0Ktb37uaAPKX5nl/wSW+GcOYZYfg3rrH51TRSMuuI0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631163; c=relaxed/simple;
	bh=5IKNAmwc3TiGPSSxYgslRarq9fEWWcp8w5rQYy4BGJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuG/9HXZIGc0YFVOUob6qdf+F+481mdqCGvnIolRuFAPku9D5jmx4u/rIx5SA8CCrkcgrbnpULjLm9qNcEShXrdKdrlbC1sbcqkFfNvtF0c5KbuciZwPnRKlHLYw0Ww7kPAi7++hKnJNYpHodhG8pbC4aBESpd7dkvxUVqwZLLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Phsmi0gE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Phsmi0gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EB31F000E9;
	Tue, 16 Jun 2026 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631162;
	bh=U9fN4xvjH4ftrTMjS9inqQfS7w9Q9SAwpeTOJPErkNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Phsmi0gERg21u4JqE5vbLG3TTiot0AgZo0zZ8Xd6G1eZu8vawVjG/yodhDFGWlOVS
	 Q1b4drXIIWXCI3qUeQBdlxjvtViT0D/EhGdoKwBOqw8WJFg06O5ju7HLTxo9ei4MlS
	 sF7RVWD7gVOga+8bQTnlNKXMxfGJD+q7FYuHf+1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Berkant Koc <me@berkoc.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH 6.1 167/522] drm/hyperv: validate VMBus packet size in receive callback
Date: Tue, 16 Jun 2026 20:25:14 +0530
Message-ID: <20260616145133.972615148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Berkant Koc <me@berkoc.com>

commit 7f87763f47a3c22fb50265a00619ef10f2394b18 upstream.

hyperv_receive_sub() reads msg->vid_hdr.type and dispatches into one
of four message-type branches without knowing how many bytes the host
wrote into hv->recv_buf. The completion path then runs
memcpy(hv->init_buf, msg, VMBUS_MAX_PACKET_SIZE), so the consumer that
wakes on wait_for_completion_timeout() can read up to 16 KiB of
residue from a prior message as if it were the response payload.

Pass bytes_recvd into hyperv_receive_sub() and reject any packet that
does not cover the pipe + synthvid header. A single switch on
msg->vid_hdr.type then computes the type-specific payload size: the
three completion-driving types (SYNTHVID_VERSION_RESPONSE,
SYNTHVID_RESOLUTION_RESPONSE, SYNTHVID_VRAM_LOCATION_ACK) fall through
to a shared exit that requires that size before memcpy/complete, while
SYNTHVID_FEATURE_CHANGE validates its own payload and returns before
reading is_dirt_needed. Unknown types are dropped.

SYNTHVID_RESOLUTION_RESPONSE is variable length: the host fills
resolution_count entries, not the full SYNTHVID_MAX_RESOLUTION_COUNT
array. Validate the fixed prefix first so resolution_count can be
read, bound it against the array, then require only the count-sized
array, so the shorter responses the host actually sends are accepted.

Only run the sub-handler when vmbus_recvpacket() returned success. The
memcpy length is bytes_recvd, which is bounded by VMBUS_MAX_PACKET_SIZE
only on a successful receive; on -ENOBUFS vmbus_recvpacket() instead
reports the required length, which can exceed hv->recv_buf, so copying
bytes_recvd would read and write past the 16 KiB buffers. Gating on the
success return keeps the copy bounded. The nonzero-return path is itself
a malformed-message case and is now logged rather than silently skipped;
channel recovery is not attempted.

Rejected packets are reported via drm_err_ratelimited() rather than
silently dropped, matching the CoCo-hardened pattern in
hv_kvp_onchannelcallback().

Fixes: 76c56a5affeb ("drm/hyperv: Add DRM driver for hyperv synthetic video device")
Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Berkant Koc <me@berkoc.com>
Assisted-by: Claude:claude-opus-4-7 berkoc-pipeline
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Link: https://patch.msgid.link/8200dbc199c7a9b75ac7e8af6c748d2189b5ebd5.1779542874.git.me@berkoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_proto.c |  100 ++++++++++++++++++++++++++----
 1 file changed, 87 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/hyperv/hyperv_drm_proto.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_proto.c
@@ -425,30 +425,92 @@ static int hyperv_get_supported_resoluti
 	return 0;
 }
 
-static void hyperv_receive_sub(struct hv_device *hdev)
+static void hyperv_receive_sub(struct hv_device *hdev, u32 bytes_recvd)
 {
 	struct hyperv_drm_device *hv = hv_get_drvdata(hdev);
 	struct synthvid_msg *msg;
+	size_t hdr_size;
+	size_t need;
 
 	if (!hv)
 		return;
 
-	msg = (struct synthvid_msg *)hv->recv_buf;
-
-	/* Complete the wait event */
-	if (msg->vid_hdr.type == SYNTHVID_VERSION_RESPONSE ||
-	    msg->vid_hdr.type == SYNTHVID_RESOLUTION_RESPONSE ||
-	    msg->vid_hdr.type == SYNTHVID_VRAM_LOCATION_ACK) {
-		memcpy(hv->init_buf, msg, VMBUS_MAX_PACKET_SIZE);
-		complete(&hv->wait);
+	hdr_size = sizeof(struct pipe_msg_hdr) +
+		   sizeof(struct synthvid_msg_hdr);
+	if (bytes_recvd < hdr_size) {
+		drm_err_ratelimited(&hv->dev,
+				    "synthvid packet too small for header: %u\n",
+				    bytes_recvd);
 		return;
 	}
 
-	if (msg->vid_hdr.type == SYNTHVID_FEATURE_CHANGE) {
+	msg = (struct synthvid_msg *)hv->recv_buf;
+	need = hdr_size;
+
+	switch (msg->vid_hdr.type) {
+	case SYNTHVID_VERSION_RESPONSE:
+		need += sizeof(struct synthvid_version_resp);
+		break;
+	case SYNTHVID_RESOLUTION_RESPONSE:
+		/*
+		 * The resolution response is variable length: the host
+		 * fills resolution_count entries, not the full
+		 * SYNTHVID_MAX_RESOLUTION_COUNT array. Require the fixed
+		 * prefix first so resolution_count can be read, then
+		 * demand exactly the count-sized array.
+		 */
+		need += offsetof(struct synthvid_supported_resolution_resp,
+				 supported_resolution);
+		if (bytes_recvd < need)
+			break;
+		if (msg->resolution_resp.resolution_count >
+		    SYNTHVID_MAX_RESOLUTION_COUNT) {
+			drm_err_ratelimited(&hv->dev,
+					    "synthvid resolution count too large: %u\n",
+					    msg->resolution_resp.resolution_count);
+			return;
+		}
+		need += msg->resolution_resp.resolution_count *
+			sizeof(struct hvd_screen_info);
+		break;
+	case SYNTHVID_VRAM_LOCATION_ACK:
+		need += sizeof(struct synthvid_vram_location_ack);
+		break;
+	case SYNTHVID_FEATURE_CHANGE:
+		/*
+		 * Not a completion-driving message: validate its own payload
+		 * and consume it here rather than falling through to the
+		 * memcpy/complete shared by the wait-event responses.
+		 */
+		if (bytes_recvd < need +
+		    sizeof(struct synthvid_feature_change)) {
+			drm_err_ratelimited(&hv->dev,
+					    "synthvid feature change packet too small: %u\n",
+					    bytes_recvd);
+			return;
+		}
 		hv->dirt_needed = msg->feature_chg.is_dirt_needed;
 		if (hv->dirt_needed)
 			hyperv_hide_hw_ptr(hv->hdev);
+		return;
+	default:
+		return;
+	}
+
+	/*
+	 * Shared completion path for the wait-event responses
+	 * (VERSION_RESPONSE, RESOLUTION_RESPONSE, VRAM_LOCATION_ACK):
+	 * require the type-specific payload before handing the buffer to
+	 * the waiter.
+	 */
+	if (bytes_recvd < need) {
+		drm_err_ratelimited(&hv->dev,
+				    "synthvid packet too small for type %u: %u < %zu\n",
+				    msg->vid_hdr.type, bytes_recvd, need);
+		return;
 	}
+	memcpy(hv->init_buf, msg, bytes_recvd);
+	complete(&hv->wait);
 }
 
 static void hyperv_receive(void *ctx)
@@ -469,9 +531,21 @@ static void hyperv_receive(void *ctx)
 		ret = vmbus_recvpacket(hdev->channel, recv_buf,
 				       VMBUS_MAX_PACKET_SIZE,
 				       &bytes_recvd, &req_id);
-		if (bytes_recvd > 0 &&
-		    recv_buf->pipe_hdr.type == PIPE_MSG_DATA)
-			hyperv_receive_sub(hdev);
+		if (ret) {
+			/*
+			 * A nonzero return (e.g. -ENOBUFS for an oversized
+			 * packet) is itself a malformed message: bytes_recvd
+			 * then reports the required length rather than a copied
+			 * payload, so it must not be forwarded to the
+			 * sub-handler. Channel recovery is not attempted.
+			 */
+			drm_err_ratelimited(&hv->dev,
+					    "vmbus_recvpacket failed: %d (need %u)\n",
+					    ret, bytes_recvd);
+		} else if (bytes_recvd > 0 &&
+			   recv_buf->pipe_hdr.type == PIPE_MSG_DATA) {
+			hyperv_receive_sub(hdev, bytes_recvd);
+		}
 	} while (bytes_recvd > 0 && ret == 0);
 }
 


