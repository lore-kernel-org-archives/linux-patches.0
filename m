Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158D34ABBBC;
	Thu, 17 Sep 2026 16:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660949; cv=none; b=RiTmGxPwWpr4QCQF+JjlT6y/kyKJlQUDUZ7QbpaXX3lSUF3IxkMc4GlujtWzJUFl+46gv3+bQGYCgRZONGaxpRrza0hP+92ANflnd2edLZ/GlMMHyUJJprsd1uhcgWRU6Cs+3/Jj1SYiztt97MvApC79lpPL8j0fY6MfCSMTSVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660949; c=relaxed/simple;
	bh=iwSTF+aGQBIyVfrJS1+UeN4PXuxxLmvfT5cHYLMo9os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2YJz3QgpWlAvVL2TcmI1x0f2uTQVutWbQqQ865DVXJ0nTdbB3G2yWS229/xXH4WZvXlO+riIQdo6rMR6gefZkZ92lgVgTEcrt4onHC3cMrIEKJnhXIadOyReNC7T8w0AztW5Hg3BDuuCq1fpuEQBIY2YOxb76AcaahkWI+GwOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgCyOWmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgCyOWmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA461F000FF;
	Thu, 17 Sep 2026 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660947;
	bh=iMcz5fpPYLzB9QFsGsGZFegZc3GWMueUWg+vVuGof8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgCyOWmh6gkzBpFeChwzidZWjsozhgaZNfi+jefvzzIn7vN5iswx0lXZK2giR82rf
	 Uth0Y05ZX1YjyWobLGJjOieQA0CMRdeZqMMWvChm2RgFkzAzwplRAMVeHa4ZE5xtSR
	 WpPwBm0k6DTmxiLcfHan6wBeNObjIT/glXLIwqbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0006/1250] drm/xe/guc: Add support for NO_RESPONSE_BUSY in CTB
Date: Thu, 17 Sep 2026 15:56:41 +0100
Message-ID: <20260917151552.091551339@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 4d33314decfeac8b82d771a1bd083a59f4ac6fae ]

We only have support for G2H NO_RESPONSE_BUSY messages over MMIO,
but it turned out that GuC also uses that type of messages in CTB.

The following error was recently observed on BMG after adding VGT
policy updates to the GT restart sequence:

 [] xe 0000:03:00.0: [drm] *ERROR* Tile0: GT1: G2H channel broken on read, type=3, reset required
 [] xe 0000:03:00.0: [drm] *ERROR* Tile0: GT1: CT dequeue failed: -95
 ...
 [] xe 0000:03:00.0: [drm] *ERROR* Tile0: GT1: Timed out wait for G2H, fence 21965, action 5502, done no
 [] xe 0000:03:00.0: [drm] PF: Tile0: GT1: Failed to push 1 policy KLV (-ETIME)
 [] xe 0000:03:00.0: [drm] Tile0: GT1: { key 0x8004 : no value } # engine_group_config

where type=3 was this unrecognized NO_RESPONSE_BUSY message.

Note that GuC might send the real RESPONSE message right after
the BUSY message, so we must be prepared to update our g2h_fence
data twice before sender actually wakes up and clears the flags.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260410110457.573-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 38 ++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 4158e8af13908..b9d265ad06a0e 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -82,13 +82,16 @@ static void ct_dead_capture(struct xe_guc_ct *ct, struct guc_ctb *ctb, u32 reaso
 struct g2h_fence {
 	u32 *response_buffer;
 	u32 seqno;
+	/* fields below this point are setup based on the response */
 	u32 response_data;
 	u16 response_len;
 	u16 error;
 	u16 hint;
 	u16 reason;
+	u32 counter;
 	bool cancel;
 	bool retry;
+	bool wait;
 	bool fail;
 	bool done;
 };
@@ -102,6 +105,11 @@ static void g2h_fence_init(struct g2h_fence *g2h_fence, u32 *response_buffer)
 	g2h_fence->seqno = ~0x0;
 }
 
+static void g2h_fence_reinit(struct g2h_fence *g2h_fence)
+{
+	memset_after(g2h_fence, 0, seqno);
+}
+
 static void g2h_fence_cancel(struct g2h_fence *g2h_fence)
 {
 	g2h_fence->cancel = true;
@@ -1134,6 +1142,7 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 	/* READ_ONCEs pairs with WRITE_ONCEs in parse_g2h_response
 	 * and g2h_fence_cancel.
 	 */
+wait_again:
 	ret = wait_event_timeout(ct->g2h_fence_wq, READ_ONCE(g2h_fence.done), HZ);
 	if (!ret) {
 		LNL_FLUSH_WORK(&ct->g2h_worker);
@@ -1159,6 +1168,14 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 		return -ETIME;
 	}
 
+	if (g2h_fence.wait) {
+		xe_gt_dbg(gt, "H2G action %#x busy: counter %u\n",
+			  action[0], g2h_fence.counter);
+		/* we can't leave any response data if we want to wait again */
+		g2h_fence_reinit(&g2h_fence);
+		mutex_unlock(&ct->lock);
+		goto wait_again;
+	}
 	if (g2h_fence.retry) {
 		xe_gt_dbg(gt, "H2G action %#x retrying: reason %#x\n",
 			  action[0], g2h_fence.reason);
@@ -1354,7 +1371,12 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 		return -EPROTO;
 	}
 
-	g2h_fence = xa_erase(&ct->fence_lookup, fence);
+	/* don't erase as we still expect a final response with the same fence */
+	if (type == GUC_HXG_TYPE_NO_RESPONSE_BUSY)
+		g2h_fence = xa_load(&ct->fence_lookup, fence);
+	else
+		g2h_fence = xa_erase(&ct->fence_lookup, fence);
+
 	if (unlikely(!g2h_fence)) {
 		/* Don't tear down channel, as send could've timed out */
 		/* CT_DEAD(ct, NULL, PARSE_G2H_UNKNOWN); */
@@ -1365,6 +1387,12 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 
 	xe_gt_assert(gt, fence == g2h_fence->seqno);
 
+	/*
+	 * reinit as we might have already process this g2h_fence before
+	 * if we received a NO_RESPONSE_BUSY reply
+	 */
+	g2h_fence_reinit(g2h_fence);
+
 	if (type == GUC_HXG_TYPE_RESPONSE_FAILURE) {
 		g2h_fence->fail = true;
 		g2h_fence->error = FIELD_GET(GUC_HXG_FAILURE_MSG_0_ERROR, hxg[0]);
@@ -1372,6 +1400,9 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 	} else if (type == GUC_HXG_TYPE_NO_RESPONSE_RETRY) {
 		g2h_fence->retry = true;
 		g2h_fence->reason = FIELD_GET(GUC_HXG_RETRY_MSG_0_REASON, hxg[0]);
+	} else if (type == GUC_HXG_TYPE_NO_RESPONSE_BUSY) {
+		g2h_fence->wait = true;
+		g2h_fence->counter = FIELD_GET(GUC_HXG_BUSY_MSG_0_COUNTER, hxg[0]);
 	} else if (g2h_fence->response_buffer) {
 		g2h_fence->response_len = hxg_len;
 		memcpy(g2h_fence->response_buffer, hxg, hxg_len * sizeof(u32));
@@ -1379,7 +1410,9 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 		g2h_fence->response_data = FIELD_GET(GUC_HXG_RESPONSE_MSG_0_DATA0, hxg[0]);
 	}
 
-	g2h_release_space(ct, GUC_CTB_HXG_MSG_MAX_LEN);
+	/* don't release any space if it was an intermediate message */
+	if (!g2h_fence->wait)
+		g2h_release_space(ct, GUC_CTB_HXG_MSG_MAX_LEN);
 
 	/* WRITE_ONCE pairs with READ_ONCEs in guc_ct_send_recv. */
 	WRITE_ONCE(g2h_fence->done, true);
@@ -1416,6 +1449,7 @@ static int parse_g2h_msg(struct xe_guc_ct *ct, u32 *msg, u32 len)
 	case GUC_HXG_TYPE_RESPONSE_SUCCESS:
 	case GUC_HXG_TYPE_RESPONSE_FAILURE:
 	case GUC_HXG_TYPE_NO_RESPONSE_RETRY:
+	case GUC_HXG_TYPE_NO_RESPONSE_BUSY:
 		ret = parse_g2h_response(ct, msg, len);
 		break;
 	default:
-- 
2.53.0



