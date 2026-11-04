Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828892;
	b=uURGNSSefRGATCWPIDTIAxy9ISsSeBjW8nL5FxtiNpkSy37WDyn9mxgihpbVWjYBKTMo
	 vrO2jgoBUh1+GJT9mJicV7HGJC5rK7glo3ZCfB4HV/ejYGKYnBeNG2hQaKUtZlZAsXoEF
	 w+7xNArj+UfR2w7OnPgvxqx4hxAqc4eXFUffbH/0CMATrCZg/dc6FbW7Ug9IfnUbOWMxU
	 wYmAJ1/ZRj6wIV2q/c28bdmtMSIienIDkZRe+bkYwU9OBVZHL26NBss9CQMmz/iAZly3K
	 AxToBObpqiP87uBBIWmRBiZ7DieHHspPNukfEQsw3kU3zsn7j7d+v9RqZ/JujZzb9xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WfPJGqSFlE8YtrCLsRRIcv9/f6dt1AbV1s5eULYdlI=;
	b=nYosuc+1lLX8AT49tGWbpxURikaRZahcJQ+iR5plJmPNz6SKPlsdW1sGjZCbJqvPlvjU
	 owq/FYfuFivHAEg9mcHlBhjK6JW42Vo+dPtvv6lzQYLGkYzFEnb4b0PtclvMfdmGz4zPR
	 BD9wb3yhFl8BhKvMBv3IJLlgjDI0L/2zUudQW9q1quN9llCI2TMuK//vrJmukliKyL/x6
	 sC8Nz6xUxkV93P/nWdfBDjnOS4HiKbD1j1q88OIX8BorT3jIRLS261ST6iG6nDlb+af9H
	 DY9zNuOmOZV522jsdjAeP8kLZ6RrOcl7RpzaVspuIsoBREotn5NDYUuw2W58pt1uaYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1O+R8Wf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D9606A33A;
	Wed,  4 Nov 2026 21:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1O+R8Wf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6491F000C1;
	Wed,  4 Nov 2026 21:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828891;
	bh=/WfPJGqSFlE8YtrCLsRRIcv9/f6dt1AbV1s5eULYdlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1O+R8WfjdiFM6g4rIKMjPHcRO53P4r0eHly+/1cO/f8LfHuwJmfIVWETsepq/Qfa
	 QQXNZtg30k32TcOiXNNRfdvNUGU3ziH30LTfId7B6S0x1yjZFYmfj0lhWVA7jUY/bi
	 mRVlevGz0nlyzMfb9FphXa14ax9QKwD6SbukdY14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 268/547] media: rc: Use after free in ir_raw_event_handle()
Date: Wed,  4 Nov 2026 16:07:32 -0500
Message-ID: <20261104211045.803707949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

commit 3ae19773168104fa57d2a2ec57731e89df54175f upstream.

If rc_unregister_device() is called while IR is being processed, then
ir_raw_event_handle() could call wake_up_process(dev->raw->thread)
after kthread_stop(dev->raw->thread). Avoid use after free by using
get_task_struct().

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-ir-raw.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -630,8 +630,13 @@ int ir_raw_event_register(struct rc_dev
 
 void ir_raw_event_free(struct rc_dev *dev)
 {
-	kfree(dev->raw);
-	dev->raw = NULL;
+	if (dev->raw) {
+		timer_delete_sync(&dev->raw->edge_handle);
+		if (dev->raw->thread)
+			put_task_struct(dev->raw->thread);
+		kfree(dev->raw);
+		dev->raw = NULL;
+	}
 }
 
 void ir_raw_event_unregister(struct rc_dev *dev)
@@ -641,6 +646,13 @@ void ir_raw_event_unregister(struct rc_d
 	if (!dev || !dev->raw)
 		return;
 
+	/*
+	 * After ir_raw_event_unregister() is called, an sync
+	 * call to ir_raw_event_handle() can still arrive. This function
+	 * may call wake_up_process(dev->raw->thread). Ensure this memory
+	 * is not freed by kthread_stop().
+	 */
+	get_task_struct(dev->raw->thread);
 	kthread_stop(dev->raw->thread);
 	timer_delete_sync(&dev->raw->edge_handle);
 


