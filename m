Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828895;
	b=DZiGO3dWqJWt81UhN7kiir8fsfyaUpYaEVc1m6FpjopA0VONl9zs9ty5bgXdHstPVCmZ
	 YThaQOCxk91Yp0pVjllvuEe746OSEP1bfh8lmX/Ki9o88WM6Uk8GLwTYR0Pvq1JSbIsiu
	 aR5dl2awiRDN1IJeMJaHjWtaKuk7wuO+MCjJWAek1+miBX/iUNNlQ6dQcfUCaUpyFSvg4
	 ijB++vHWnD3k+IehQ/ohQMGruvVPtdfX7eVVdz4Bx9C4ZhoGTGJ1IEglEt+qIHpDuEzwr
	 KadcYLryy3nUqT9WaXzh1mfsWC8kSJX30HUaAy3JUr0C6G/48GQbINTwB5BXjOELu6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bXex9aKqkfljhu0U0JZyPUO/W9ExH9xk/gjcn7+m87w=;
	b=ng+s5FP/PKqU2IxJfEi5EhoxWyqMa5LIUFE5Z2qceTQRrmSAm1Bj2WOSYMQunYJWhT2i
	 zjk4vnKw163kTfCymFA4NDt+5JS3fRFNTs2DTqSZ33hJlxKgB1T+Qoy1nUm8JzCuN6eiB
	 sfG+1ALKqw1sj3QEeihXU2pFrYO/pqEWsbdUQiPi/IhAFC8jOduJNu2vXXTNrI/61qlc0
	 pZhtdv08ilNtuQJxfMgrJfEbdAGYoyNVsikdjdlTuObEXIoVNizoLJwvdvVcryKa6lM2+
	 aU5Sb+wVNlfr0I/8A2/DYHDUQzu4gBrZdsOoVhimNfhXsYDhtQsEqExsQY4qTruO+qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRA1fmYk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A5F6071AE2;
	Wed,  4 Nov 2026 21:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRA1fmYk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536041F00919;
	Wed,  4 Nov 2026 21:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828894;
	bh=bXex9aKqkfljhu0U0JZyPUO/W9ExH9xk/gjcn7+m87w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRA1fmYksbcgacFc1F1UvicZrAT3vqfUOCTdKFZ3SiJVj7UCQf7YlMmCUiAFHsbow
	 BF/aXMJ9yc+ikZaSo+8AGo7dVDWtcwyRkRd0FG6fgoB4tKSIugLYIKSTP01quhW+lI
	 QqpnyHpHU8Oolm7K51xkbrlPbaHovI4l34x02B5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 270/547] media: rc: Fix use after free in bpf progs
Date: Wed,  4 Nov 2026 16:07:34 -0500
Message-ID: <20261104211045.858696482@linuxfoundation.org>
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

commit f95a9f8472f97c30106513fc7494b7abad243949 upstream.

Since commit dccc0c3ddf8f ("media: rc: fix race between unregister and
urb/irq callbacks"), rcdev->raw is no longer set to NULL after device
unregister. raw->progs could point to stale data.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/bpf-lirc.c  |   18 +++++++++++++-----
 drivers/media/rc/rc-ir-raw.c |   11 +++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -148,12 +148,13 @@ static int lirc_bpf_attach(struct rc_dev
 	if (ret)
 		return ret;
 
-	raw = rcdev->raw;
-	if (!raw) {
+	if (!rcdev->registered) {
 		ret = -ENODEV;
 		goto unlock;
 	}
 
+	raw = rcdev->raw;
+
 	old_array = lirc_rcu_dereference(raw->progs);
 	if (old_array && bpf_prog_array_length(old_array) >= BPF_MAX_PROGS) {
 		ret = -E2BIG;
@@ -186,12 +187,13 @@ static int lirc_bpf_detach(struct rc_dev
 	if (ret)
 		return ret;
 
-	raw = rcdev->raw;
-	if (!raw) {
+	if (!rcdev->registered) {
 		ret = -ENODEV;
 		goto unlock;
 	}
 
+	raw = rcdev->raw;
+
 	old_array = lirc_rcu_dereference(raw->progs);
 	ret = bpf_prog_array_copy(old_array, prog, NULL, 0, &new_array);
 	/*
@@ -235,7 +237,8 @@ void lirc_bpf_free(struct rc_dev *rcdev)
 	struct bpf_prog_array_item *item;
 	struct bpf_prog_array *array;
 
-	array = lirc_rcu_dereference(rcdev->raw->progs);
+	array = rcu_replace_pointer(rcdev->raw->progs, NULL,
+				    lockdep_is_held(&ir_raw_handler_lock));
 	if (!array)
 		return;
 
@@ -316,6 +319,11 @@ int lirc_prog_query(const union bpf_attr
 	if (ret)
 		goto put;
 
+	if (!rcdev->registered) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
 	progs = lirc_rcu_dereference(rcdev->raw->progs);
 	cnt = progs ? bpf_prog_array_length(progs) : 0;
 
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -632,8 +632,11 @@ void ir_raw_event_free(struct rc_dev *de
 {
 	if (dev->raw) {
 		timer_delete_sync(&dev->raw->edge_handle);
+		mutex_lock(&ir_raw_handler_lock);
 		if (dev->raw->thread)
 			put_task_struct(dev->raw->thread);
+		lirc_bpf_free(dev);
+		mutex_unlock(&ir_raw_handler_lock);
 		kfree(dev->raw);
 		dev->raw = NULL;
 	}
@@ -643,9 +646,6 @@ void ir_raw_event_unregister(struct rc_d
 {
 	struct ir_raw_handler *handler;
 
-	if (!dev || !dev->raw)
-		return;
-
 	/*
 	 * After ir_raw_event_unregister() is called, an sync
 	 * call to ir_raw_event_handle() can still arrive. This function
@@ -665,11 +665,6 @@ void ir_raw_event_unregister(struct rc_d
 
 	lirc_bpf_free(dev);
 
-	/*
-	 * A user can be calling bpf(BPF_PROG_{QUERY|ATTACH|DETACH}), so
-	 * ensure that the raw member is null on unlock; this is how
-	 * "device gone" is checked.
-	 */
 	mutex_unlock(&ir_raw_handler_lock);
 }
 


