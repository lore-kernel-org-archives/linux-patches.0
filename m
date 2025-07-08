Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FADA2DC34C;
	Tue,  8 Jul 2025 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993446; cv=none; b=Z7R4lFGBwKBf04UkZ3zY8jiuUE3CTKVHkweQY60/ZcRXKFnUfNiZqMaOXNMtLKutjIxut1dhV+Hrx/97+64gOXqEF/qwBngqyEjbjvqeW2tc5nyK0WSrhmoF+qAM8iZJFbiLt9nbkg/y0idWeEYbsYO2aE6R+dJunFJIP9qjEhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993446; c=relaxed/simple;
	bh=9PjNrjpE33n14o7fnd4XvUw9aTWIQtOS2p4Rz+s4MfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OMoPVxY+Go+HI05j5oOGMfoQ71RWsIM+pJyeJzHV/T+CxwE5uJLSV63Tx+t1lXuBFc9rboGqMDaVwbzoIt3edYMjygKzqSPmJ0KohQ1h+XC+MQyXPAQqLLC2mJ0+wFVxZrQ1D27ulYmX6BiyvpSwjK4J1mqHxl6xlsyT2xIfEU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDC+hlmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDC+hlmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897D2C4CEF6;
	Tue,  8 Jul 2025 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993445;
	bh=9PjNrjpE33n14o7fnd4XvUw9aTWIQtOS2p4Rz+s4MfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDC+hlmc0OXCphiohw4BFipPZR/YkcK3ShRyU5asH/aXLJHOkcRzj8Y633YtXBXwd
	 Lbjqz1cM3UIcj8b46RR/oU26fRxrQUWd9Dj6lFWgoTFvayF3wdZRAvGm2W5jeajAyn
	 xZ94+cMkYxkjoTfVdQzfIw6/NTAbOjynpuzQo2qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 037/178] firmware: exynos-acpm: fix timeouts on xfers handling
Date: Tue,  8 Jul 2025 18:21:14 +0200
Message-ID: <20250708162237.651624669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 8d2c2fa2209e83d0eb10f7330d8a0bbdc1df32ff ]

The mailbox framework has a single inflight request at a time. If
a request is sent while another is still active, it will be queued
to the mailbox core ring buffer.

ACPM protocol did not serialize the calls to the mailbox subsystem so we
could start the timeout ticks in parallel for multiple requests, while
just one was being inflight.

Consider a hypothetical case where the xfer timeout is 100ms and an ACPM
transaction takes 90ms:
      | 0ms: Message #0 is queued in mailbox layer and sent out, then sits
      |      at acpm_dequeue_by_polling() with a timeout of 100ms
      | 1ms: Message #1 is queued in mailbox layer but not sent out yet.
      |      Since send_message() doesn't block, it also sits at
      |      acpm_dequeue_by_polling() with a timeout of 100ms
      |  ...
      | 90ms: Message #0 is completed, txdone is called and message #1 is sent
      | 101ms: Message #1 times out since the count started at 1ms. Even though
      |       it has only been inflight for 11ms.

Fix the problem by moving mbox_send_message() and mbox_client_txdone()
immediately after the message has been written to the TX queue and while
still keeping the ACPM TX queue lock. We thus tie together the TX write
with the doorbell ring and mark the TX as done after the doorbell has
been rung. This guarantees that the doorbell has been rang before
starting the timeout ticks. We should also see some performance
improvement as we no longer wait to receive a response before ringing
the doorbell for the next request, so the ACPM firmware shall be able to
drain faster the TX queue. Another benefit is that requests are no
longer able to ring the doorbell one for the other, so it eases
debugging. Finally, the mailbox software queue will always contain a
single doorbell request due to the serialization done at the ACPM TX
queue level. Protocols like ACPM, that handle their own hardware queues
need a passthrough mailbox API, where they are able to just ring the
doorbell or flip a bit directly into the mailbox controller. The mailbox
software queue mechanism, the locking done into the mailbox core is not
really needed, so hopefully this lays the foundation for a passthrough
mailbox API.

Reported-by: André Draszik <andre.draszik@linaro.org>
Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20250606-acpm-timeout-v2-1-306b1aa07a6c@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/samsung/exynos-acpm.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/samsung/exynos-acpm.c b/drivers/firmware/samsung/exynos-acpm.c
index e80cb7a8da8f2..520a9fd3b0fd3 100644
--- a/drivers/firmware/samsung/exynos-acpm.c
+++ b/drivers/firmware/samsung/exynos-acpm.c
@@ -430,6 +430,9 @@ int acpm_do_xfer(const struct acpm_handle *handle, const struct acpm_xfer *xfer)
 		return -EOPNOTSUPP;
 	}
 
+	msg.chan_id = xfer->acpm_chan_id;
+	msg.chan_type = EXYNOS_MBOX_CHAN_TYPE_DOORBELL;
+
 	scoped_guard(mutex, &achan->tx_lock) {
 		tx_front = readl(achan->tx.front);
 		idx = (tx_front + 1) % achan->qlen;
@@ -446,25 +449,15 @@ int acpm_do_xfer(const struct acpm_handle *handle, const struct acpm_xfer *xfer)
 
 		/* Advance TX front. */
 		writel(idx, achan->tx.front);
-	}
 
-	msg.chan_id = xfer->acpm_chan_id;
-	msg.chan_type = EXYNOS_MBOX_CHAN_TYPE_DOORBELL;
-	ret = mbox_send_message(achan->chan, (void *)&msg);
-	if (ret < 0)
-		return ret;
-
-	ret = acpm_wait_for_message_response(achan, xfer);
+		ret = mbox_send_message(achan->chan, (void *)&msg);
+		if (ret < 0)
+			return ret;
 
-	/*
-	 * NOTE: we might prefer not to need the mailbox ticker to manage the
-	 * transfer queueing since the protocol layer queues things by itself.
-	 * Unfortunately, we have to kick the mailbox framework after we have
-	 * received our message.
-	 */
-	mbox_client_txdone(achan->chan, ret);
+		mbox_client_txdone(achan->chan, 0);
+	}
 
-	return ret;
+	return acpm_wait_for_message_response(achan, xfer);
 }
 
 /**
-- 
2.39.5



