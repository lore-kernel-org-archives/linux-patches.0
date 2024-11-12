Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0647214404;
	Tue, 12 Nov 2024 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408330; cv=none; b=Zn8DLPOcnqPBizwuBHkScmdp6X4CZll3pCA5F4oW2UeeuS2KV/YUrkuRuD0IpFrfabv0g9Df31fwnjbw+7kiiBYPl1j6K1lFlRx2hSqQUv3zS+kSJUV5R1s9ybE0IZvw08LjnFGzD2AnAARPe/jwGX7hJYK7D+LK12LK+XKZBW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408330; c=relaxed/simple;
	bh=qhAxGBOpkCSpOnf/Yy32tXBLgkP4ojrKvOOWClQHRg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+cBKrqVGK0rGCyE7B+EhJwA934282CamkLSQYuM+VTjZOIjXnp2UMl5EF8q7Q7x73t8g+KoaNeZ0RB5yOrGoJ3oIhIqb/w8GyrqRYo0rh/+i2oxVKFTTVt02zXtctadD12o916paRwGRNw3kH0pp9ph4M8NSYDH8WY+DJjr/tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMp2/pAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMp2/pAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C66FC4CECD;
	Tue, 12 Nov 2024 10:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408330;
	bh=qhAxGBOpkCSpOnf/Yy32tXBLgkP4ojrKvOOWClQHRg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMp2/pAAQjtim/mXarGtBei83Kq/SDnT/yY+Qt/ncziuzN8LIDQTcF3/JIi2+Hc6a
	 aZrr1kza3Ye9KiebaHt7CxMoolfjSQwEhCwpwfNFKoI2nFFw2J2rM2ipEC26YDrU61
	 780x+IWn7bECFXPQFc8rDzYSJpKqJLr8PETEiPgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 098/184] rpmsg: glink: Handle rejected intent request better
Date: Tue, 12 Nov 2024 11:20:56 +0100
Message-ID: <20241112101904.625370588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit a387e73fedd6307c0e194deaa53c42b153ff0bd6 upstream.

GLINK operates using pre-allocated buffers, aka intents, where incoming
messages are aggregated before being passed up the stack. In the case
that no suitable intents have been announced by the receiver, the sender
can request an intent to be allocated.

The initial implementation of the response to such request dealt
with two outcomes; granted allocations, and all other cases being
considered -ECANCELLED (likely from "cancelling the operation as the
remote is going down").

But on some channels intent allocation is not supported, instead the
remote will pre-allocate and announce a fixed number of intents for the
sender to use. If for such channels an rpmsg_send() is being invoked
before any channels have been announced, an intent request will be
issued and as this comes back rejected the call fails with -ECANCELED.

Given that this is reported in the same way as the remote being shut
down, there's no way for the client to differentiate the two cases.

In line with the original GLINK design, change the return value to
-EAGAIN for the case where the remote rejects an intent allocation
request.

It's tempting to handle this case in the GLINK core, as we expect
intents to show up in this case. But there's no way to distinguish
between this case and a rejection for a too big allocation, nor is it
possible to predict if a currently used (and seemingly suitable) intent
will be returned for reuse or not. As such, returning the error to the
client and allow it to react seems to be the only sensible solution.

In addition to this, commit 'c05dfce0b89e ("rpmsg: glink: Wait for
intent, not just request ack")' changed the logic such that the code
always wait for an intent request response and an intent. This works out
in most cases, but in the event that an intent request is rejected and no
further intent arrives (e.g. client asks for a too big intent), the code
will stall for 10 seconds and then return -ETIMEDOUT; instead of a more
suitable error.

This change also resulted in intent requests racing with the shutdown of
the remote would be exposed to this same problem, unless some intent
happens to arrive. A patch for this was developed and posted by Sarannya
S [1], and has been incorporated here.

To summarize, the intent request can end in 4 ways:
- Timeout, no response arrived => return -ETIMEDOUT
- Abort TX, the edge is going away => return -ECANCELLED
- Intent request was rejected => return -EAGAIN
- Intent request was accepted, and an intent arrived => return 0

This patch was developed with input from Sarannya S, Deepak Kumar Singh,
and Chris Lew.

[1] https://lore.kernel.org/all/20240925072328.1163183-1-quic_deesin@quicinc.com/

Fixes: c05dfce0b89e ("rpmsg: glink: Wait for intent, not just request ack")
Cc: stable@vger.kernel.org
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Link: https://lore.kernel.org/r/20241023-pmic-glink-ecancelled-v2-1-ebc268129407@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/qcom_glink_native.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1354,14 +1354,18 @@ static int qcom_glink_request_intent(str
 		goto unlock;
 
 	ret = wait_event_timeout(channel->intent_req_wq,
-				 READ_ONCE(channel->intent_req_result) >= 0 &&
-				 READ_ONCE(channel->intent_received),
+				 READ_ONCE(channel->intent_req_result) == 0 ||
+				 (READ_ONCE(channel->intent_req_result) > 0 &&
+				  READ_ONCE(channel->intent_received)) ||
+				 glink->abort_tx,
 				 10 * HZ);
 	if (!ret) {
 		dev_err(glink->dev, "intent request timed out\n");
 		ret = -ETIMEDOUT;
+	} else if (glink->abort_tx) {
+		ret = -ECANCELED;
 	} else {
-		ret = READ_ONCE(channel->intent_req_result) ? 0 : -ECANCELED;
+		ret = READ_ONCE(channel->intent_req_result) ? 0 : -EAGAIN;
 	}
 
 unlock:


