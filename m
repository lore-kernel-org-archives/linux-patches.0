Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69F417E8EE;
	Wed,  3 Jul 2024 10:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003977; cv=none; b=M8R41umqmDDrv+uQrhTytLwJ7SViwxBy4l9YjuBzbUK+rYA5PUD2TC6F8Qpe37tXOP8PTvUvPB4lRGP58QeGzlwL7k+Qvn5fr2mNtpLaowWV31YygVdti78czUB2KJuNvxu4UmBJthV8vhMoVo5WeDXtEBX/d/MhegMXHUmPrtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003977; c=relaxed/simple;
	bh=DZpTmII+pwoD4cRGBakfBs4t7K5alkVemm6BxQUvM00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGd/8evejSGg4vdCvrPWTZq1YppViz4oAnqjHWtj6NgmSQg+yRMj+BGNL6WfEJBYY72xJf8VpLz/OFtF2IuqyYTj2LYU7Z2Aq05GgrB7WCnqAPqu8q/T3J1y+sxsvc+0mVpcaaBFEhgak059z+1WWisULYLg3qS7q95009QSvWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuRBR/Th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuRBR/Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5959AC2BD10;
	Wed,  3 Jul 2024 10:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003977;
	bh=DZpTmII+pwoD4cRGBakfBs4t7K5alkVemm6BxQUvM00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuRBR/Th/jt6lUP1fk6a7M8hGinvTNs2H8tztkT1lq2d33ztidqk5w8ZwQApQ/CyE
	 fdGc3TShLTGGdBi6Z3EoauztOruSxHZDLqkG+8x4/AR5NydRRJSmuom92NthOBhaOr
	 7JfEKm1Xrnm3qW/WU7bVzzylVNs/R1snYIj+l+x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Pillai <viremana@linux.microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 5.4 083/189] hv_utils: drain the timesync packets on onchannelcallback
Date: Wed,  3 Jul 2024 12:39:04 +0200
Message-ID: <20240703102844.634836546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[ The old code in the upstream commit uses HV_HYP_PAGE_SIZE, but
  the old code in 5.4.y sitll uses PAGE_SIZE. Fixed this manually for 5.4.y.
  Note: 5.4.y already has the define HV_HYP_PAGE_SIZE, so the new code in
  in the upstream commit works for 5.4.y.
  If there are multiple messages in the host-to-guest ringbuffer of the TimeSync
  device, 5.4.y only handles 1 message, and later the host puts new messages
  into the ringbuffer without signaling the guest because the ringbuffer is not
  empty, causing a "hung" ringbuffer. Backported the mainline fix for this issue.]
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hv_util.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -283,10 +283,23 @@ static void timesync_onchannelcallback(v
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
+					   HV_HYP_PAGE_SIZE, &recvlen,
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
 


