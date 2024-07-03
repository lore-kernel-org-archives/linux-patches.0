Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A0D136E2A;
	Wed,  3 Jul 2024 10:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003562; cv=none; b=aDbdHvf5mBZq7cKbQv+ydwT1qYKnNMc5CLFXjlqXG7trrbMmiHQ+nlwfGmjwAr/+xVCt1gkOT063/L96IERwk47mfjOY4JLp0GQPORSjiE+/gqnu0ZzbdZKSeJX4UvsLINo9dDmTsY2td+k4GxW12SM5FB/cVZqQl14gqGIw7W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003562; c=relaxed/simple;
	bh=aUvMGDGXGvaPm2OsIkcznIleHeWQ7/rLeBK1ZWt8TC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu0KQs3tJ6+EKivEhR8jyDGcOUMrqDYG4t9U2RhYwGQA/8q6/EbQc3VH77TG8DkAYn37tMkzcZKECXB9/0tPZLNAfuU21oRiwep37WocSu24pHzumcBX35G9rVjUjnVP83yG6SORLDevBE1WaKSRyq3+UkRKrV678zs2fkhR9Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fcfb2umJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fcfb2umJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0489DC2BD10;
	Wed,  3 Jul 2024 10:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003562;
	bh=aUvMGDGXGvaPm2OsIkcznIleHeWQ7/rLeBK1ZWt8TC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fcfb2umJUPX1Fkts0j4fZtOCfE9vupLp3IB9vQCxcONBOXjD2dsaiV+7VGpZlpDN+
	 P/BfeTy/zO7V1cLhH8BMJOBs55W+ybJSq3DhjntN+BQYaGv8GV/+mS1P0qSfeCv9V3
	 W/dQOEKUeu2XtG3CI4oYgBSIuvXw6ez03s8imEQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Pillai <viremana@linux.microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 4.19 058/139] hv_utils: drain the timesync packets on onchannelcallback
Date: Wed,  3 Jul 2024 12:39:15 +0200
Message-ID: <20240703102832.629887036@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Pillai <viremana@linux.microsoft.com>

commit b46b4a8a57c377b72a98c7930a9f6969d2d4784e upstream.

There could be instances where a system stall prevents the timesync
packets to be consumed. And this might lead to more than one packet
pending in the ring buffer. Current code empties one packet per callback
and it might be a stale one. So drain all the packets from ring buffer
on each callback.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20200821152849.99517-1-viremana@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
[ The upstream commit uses HV_HYP_PAGE_SIZE, which is not defined in 4.19.y.
  Fixed this manually for 4.19.y by using PAGE_SIZE instead.

  If there are multiple messages in the host-to-guest ringbuffer of the TimeSync
  device, 4.19.y only handles 1 message, and later the host puts new messages
  into the ringbuffer without signaling the guest because the ringbuffer is not
  empty, causing a "hung" ringbuffer. Backported the mainline fix for this issue. ]
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hv_util.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -294,10 +294,23 @@ static void timesync_onchannelcallback(v
 	struct ictimesync_ref_data *refdata;
 	u8 *time_txf_buf = util_timesynch.recv_buffer;
 
-	vmbus_recvpacket(channel, time_txf_buf,
-			 PAGE_SIZE, &recvlen, &requestid);
+	/*
+	 * Drain the ring buffer and use the last packet to update
+	 * host_ts
+	 */
+	while (1) {
+		int ret = vmbus_recvpacket(channel, time_txf_buf,
+					   PAGE_SIZE, &recvlen,
+					   &requestid);
+		if (ret) {
+			pr_warn_once("TimeSync IC pkt recv failed (Err: %d)\n",
+				     ret);
+			break;
+		}
+
+		if (!recvlen)
+			break;
 
-	if (recvlen > 0) {
 		icmsghdrp = (struct icmsg_hdr *)&time_txf_buf[
 				sizeof(struct vmbuspipe_hdr)];
 


