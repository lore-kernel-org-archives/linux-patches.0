Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211115;
	b=sJz2pTw0jRByYDL2DZrYVns6XdQhjsheG1bQ4GPVV+9S/2fWaZXj8YwfuCn0nI93c+qq
	 7T42D0yD/B16ZRi8ohT6MNP9rzIxMEZ0BJOUSnnVM6DNkx326PC4zMXGMGjhkXu0FqcVM
	 YrHSmH3i3VidV5aneV3Lcih2ncijxZG71jEbU01nmncIDnijPT34tPJUK9hA+zLgJLBmj
	 sZOkRKiM9PoL+hSWa/zHFIJTKkUtiNtkrJAwFVB4K+Akkbzzk+kMtOtenfrmJJe5W76Vd
	 858ROm6FgSsPyIKXj2eseBYlVBENGgpf+yZJoK9Ynw6rETuqXceYC2fs9+H5eAEtyQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=faGAEr+hqgde3TXar7wJakadRpUYMn/OvakZxG/n7L4=;
	b=V/FXi04RDWMD7Uc8OZsvHXjQaKyS9ziUj661TMSSp/dj0tUmplDdGmLeMMNKme17qtlT
	 simPG/n5OMXYF0B1K8tT2cjoPOb4pgfyWd7v9DBkoTJ1mFrbS5Qc3FPIsXws5+NOCWtDV
	 u+1fUQ8kC29bpyUjL1MmnkZ1GCb0k9v2USQy77O/0KgzZUrlGLrhpxNh08uO1loN66CiE
	 HaggrHk1soiD7zlKwLdKpnzShoP/HF2B83URlPEoxWYFvArz1a7sT9kRSsxPhxTJjnfRL
	 BcULpPkmqAGBJK1mxHLYJlGVHElV+h+5HQneYSHT01i2J+6AnQs/KcpLgoNCDmpsz6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hsGT/hmk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7F560A5BE9;
	Wed, 28 Oct 2026 18:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hsGT/hmk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191F71F031E0;
	Wed, 28 Oct 2026 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211114;
	bh=faGAEr+hqgde3TXar7wJakadRpUYMn/OvakZxG/n7L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsGT/hmkN+zvfhNIwPkh+lL3miOlOvckHqdJFW5kpJJQWqIwvILKau5flaTUH3vVZ
	 psK2+abOnihwj9o/ISAbVCmZutbEr9vzT+rW00ra4UmbYsyK6Vh6eSytm9HLOlVXoH
	 /l6YuURXMkwIVt5vxPmMs0jtP2/f3NX92WHjtkXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 262/571] iio: trigger: cancel reenable_work before freeing trigger
Date: Wed, 28 Oct 2026 17:56:49 +0100
Message-ID: <20261028170014.221492104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 2a57b9246cecd5dd797a42eb310d6c8816f26d9e upstream.

iio_trigger_notify_done_atomic() defers ->reenable() into
trig->reenable_work on the system workqueue, and the worker dereferences
the owning trigger through container_of().  Nothing cancels this work
before iio_trig_release() frees the trigger, so a worker armed by the
last in-flight IRQ can outlive the free and touch freed memory.

Cancel it at the top of iio_trig_release(), which every free path
reaches through the device core's final put_device().

Found by an in-house static analysis tool.

Fixes: 9020ef659885 ("iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -513,6 +513,8 @@ static void iio_trig_release(struct devi
 	struct iio_trigger *trig = to_iio_trigger(device);
 	int i;
 
+	cancel_work_sync(&trig->reenable_work);
+
 	if (trig->subirq_base) {
 		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
 			irq_modify_status(trig->subirq_base + i,


