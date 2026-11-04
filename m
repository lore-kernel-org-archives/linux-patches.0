Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831513;
	b=4Ahlkm5bOxUbeKEgqRl0hff3DsgR5586RVdUdpuxTpvmf1IxYfg2/dwkvXyzTfRhCerj
	 HcKpGY2Jnzp/H+8JF8zgdu7L1clmB2ybJKYjl6xZGtco8Mnqr7k2VOSgj+VpfBHg2oZH5
	 Tgs+Uxct5b87PoDBxRmnrtoz9ov+LvEeGk91YieMIT6s4a5xy6zFj7K6772R+QZLjmxM+
	 EEA/c1GruZ+4r7hW/J3C7LFfzAVSoLIsnhfP0pxplIS2aqlq8mXAQthKCIWsM3pwt5X+I
	 D6lQ85LPekfo86Ju2LTEJXCqJw+ST2aMKRn+d4P9GEOWVlGumz1948Jxv6Qsivv7syw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2yvT6C0VmfZYhru2+QYk44sZl1fvZIs6EHms7zVrG2o=;
	b=AJwxpIBP62HOCN+WaFkdHRVjqz9caPFt/bCsDgONUgjUQCYCpD1qjiq7TZ3XJotShvQm
	 v4FPseXJEvGdWsHg6l43BMSXIHaty+YOvAluQ5N43EMWEKfFQJkTh/iP44rt4mI9EfV3Y
	 PAGIRcAiCOxvO9Ph0cRO4ZEM1rDhc6y7yDIkq/KwVydU7rs50L/3aM5KvG2UiIAwpoUSx
	 Ynzp2EQeYpN3Pi8IgB2EMcJXjeOj5ApyV08Uq66+pSil3rfvEzMcoccJerJhnJeghrKpF
	 8UGK9Z8rCsXM/9sW61PqsIqkxadz+5e3CqG/QBDo/VlIPBTO9A4EJJ7hDTxeHS67xMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erPTqSvb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B948606D80B;
	Wed,  4 Nov 2026 22:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erPTqSvb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C680C1F0093A;
	Wed,  4 Nov 2026 22:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831513;
	bh=2yvT6C0VmfZYhru2+QYk44sZl1fvZIs6EHms7zVrG2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erPTqSvb3Ua2BI1KwZBbcFVAnYutD3//FXS+InKKfzLvDCaUQxy9qM2dXdgwajKGV
	 CBuMYZhUrymw3w34/X8OrTmMMO+DymtfuDABlz3PMX68eL0cxPvKcUtqpfXuT0BUTo
	 0B5RCu2rwSpfzqzStS9zVlzuMjx21KWr9AZbUhps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0748/1005] media: rc: Use after free in ir_raw_event_handle()
Date: Wed,  4 Nov 2026 16:08:01 -0500
Message-ID: <20261104211104.412807527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -648,8 +648,13 @@ int ir_raw_event_register(struct rc_dev
 
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
@@ -659,6 +664,13 @@ void ir_raw_event_unregister(struct rc_d
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
 


