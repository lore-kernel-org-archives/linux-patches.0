Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035188;
	b=SjOOvISc4zOq2fQRqJBdmhxniSMfT3TD6R7Lcbig8L1ZtE4F6Wr93hyocgCAwRI3V1Cu
	 5goTTI1Y1NAevHTmviKwTDsaL1ntAHazY9CJAkNVIVx0n0WIbaHCriB5TUjnu2JJ4XoWM
	 9Yb6HDMFCq6wMwUE6agfsAse0/lhqHsHgpe1iNK1RPi/byTdexfGJYXUop+fq0jVG2sSz
	 DwEcCDaErl/TchXJfBMHnq9pW6qhU6k7HEoy3zeO5PbZMJnYt6gJNoQ5Ng7oYAh+xmA9K
	 IO4bMzQMRZ9h5eR78m8oZNieBptRDAS+Lea9q6VPoKl4r+yYRSQ+2ibhw4HiSkROGSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3TTsBzH4GxFtKLtpmBItAp62GHkYGWMa66twu0nXhY=;
	b=lOCH7tITIgHtCVNYhlltV0lg3A8VLnh40UYOg2l1nt6VTE315nzQi1kowZOtWPq9MHii
	 Bxspr8SnTBFB31RYhaVK2yqPbrZvzDuYpUicgDdBOjKCgn1fTBTHHCzMz/ysROBDlJhac
	 hWJ48JarzeGFbQdoLG/jdrrLmkUfwiF4a89TJ2pcs6qElM2nMMJesGWcgpYuaF4+J+jGL
	 LUDCdTuo4XmEeIwQHuK9H/C5ZbbU73k3HuHkqU96jr+RlVg7JagSoICXYme/eIT57el2M
	 cNkutqa2PtsKHjN1HUCtX15WcsUhN3PPgWi++LtJ57WAi6qcYYb97GZ2xw0FK0WDzhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+WDDkvW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6F060A260B;
	Wed, 18 Nov 2026 20:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+WDDkvW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6FC1F000C9;
	Wed, 18 Nov 2026 20:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035188;
	bh=b3TTsBzH4GxFtKLtpmBItAp62GHkYGWMa66twu0nXhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+WDDkvWfHY/utclKj97/gcbUM5+4jVKukzUXphx61X2Hhp/9/1+1ejuW7tKsAb2e
	 aWnNVOZKAWg1lQ6pmh2LgZs+b7bf65fbZFe1wrcSydYArJw4DWsmS9cncqf/eSnrNw
	 7KlZDwSwqIffi1lYdLIM4W5F+ho6YVscv+Qocz1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0635/3318] media: rc: Use after free in ir_raw_event_handle()
Date: Wed, 18 Nov 2026 15:20:57 +0100
Message-ID: <20261118150336.963575356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


