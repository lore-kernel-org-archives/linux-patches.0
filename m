Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061642;
	b=v2B2yBAbyKNSa81Dom2pBJb5Ag/iaF3tylOyiVW75qDgJ4DQelCMRCZ4e1wkBFNTdyhX
	 GY0YQudmNvgfYh+w64I5nZNtr5QAkfNohABfaK4FXpSAzeg0j4K8eqbPblKnMnk4GKgGb
	 wAUpurUWHi2ARgdrElViG12Cu2alfcFtxUvwGGYC8XbFfNs44RrmmmlLXpTzO142VizqD
	 8OYZhDqxTbLYkBW1Et5TyOyZh2MH+vqCgPx6W5cf4NkN1XI5pm7UGS5KeY+zT8Sn49S/E
	 6g37ruCA6Y/e14r9FAcOtoKKZ0byydPC11kbTYDpYrRI/4edr4n86d0Um3tgw4UUrBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BsqUoH+i7YklJN1FsHGbJy1QDbgfwi8478526VWXm1s=;
	b=XlihyYW5vgI+UcWK9Pg74R9WLvERLAGxz4+kgMEkBXQUmEDCOKZB3ZXqF+JrYo9z29Fe
	 nP7xJ47rCCnwWG6MvknRZ2YHnFzVJnT8esmbRtMrOspgLD7x8urVff3ciPQ6xyduzhND8
	 jRFaQpqmtDu8TEofOSEiewqIrM1+VKYMymKFGiN4OwMLcJyCwzsgp3ieQTlrdk6aIP6fG
	 lRfjhnP9ZOUd35v8qWMhrVxBevgZND2W27KuoeG+XWNaQGU0DO6vJG8gAlbYl5qdhW7o5
	 /zzF+uJE7VCT93dlZSV3X5NzDDxW4xo6uAXf2fLJpZExA58C/qYmgNEnM5g1jwwLuug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmlkBug7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EA3606A334;
	Sat,  7 Nov 2026 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmlkBug7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FDC1F0089F;
	Sat,  7 Nov 2026 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061641;
	bh=BsqUoH+i7YklJN1FsHGbJy1QDbgfwi8478526VWXm1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmlkBug7r/3XI9cssFKssqzhU1uDvoBkwpw7peJVxVdQqJanUX8BlL+BXPCEFgTwb
	 EGx7LPE+KDQ7kLDtogi36AO59nW8YWxc6Norr2cE8glob4M3GMstwO3r5ENIxwvRnd
	 WZVBCAmhhf/tLsxEOhAkQw81YkPbGnsqg7txkZcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0665/1536] media: rc: Use after free in ir_raw_event_handle()
Date: Sat,  7 Nov 2026 08:44:41 -0500
Message-ID: <20261107135016.178228630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -647,8 +647,13 @@ int ir_raw_event_register(struct rc_dev
 
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
@@ -658,6 +663,13 @@ void ir_raw_event_unregister(struct rc_d
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
 	del_timer_sync(&dev->raw->edge_handle);
 


