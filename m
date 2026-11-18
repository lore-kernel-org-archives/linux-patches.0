Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035177;
	b=oN3VRY9DyJGQdEz6ztuijoS4sLpkxMrtkDZCzMSNOj2kxPVWAn4TbR2Unwis2JUWiyVY
	 CzBX1QV7cazjQPRD6xtIhdfe6AHhLlMjoiab3qqcNWC75DEJOQOJwDcqNEkEDyxRXJdlj
	 Me18rDgqScFIxkaB3zH3aLg7kINtCGuQCP7cyWBtXYIqqMmRbD0JuKtuSF5WMCKNB43l2
	 Nn53z64gZeTyfWNQqjYNLTSRMl7lmgVMf+6kUfr1+N+o2k+T7QGE4D7GnvCuFIm1GnMnW
	 Ch1e41/7E0tVHSFG9ZhF6yFzluZKu+6lYQnIO65JBRLZttm1KyzxwxMF5IKrZm1YJ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JgJXsCEn7m13QRPoBy3gxxmr2UnF2VLxieVIGPa0PmA=;
	b=GtSAw7V+m+c40N+q5xEVyGEKXv+zdYquhdM82ZhMN5b3AihRtxeXU73V2kSoiChULzSj
	 pdvU/ypRqPpZPg6ovKerDcwdtbHxiXuY2CQFZoQ2YrFW6gjkq7oNs9DRaaRwLg1F9AmCh
	 fbThIi7wY2QfWccAenwfZpUI3jes/m/gDx1Wca8aS3XQoiapu1PPiPlPh4P65LrgXgXhD
	 cvkZG4zIqlu2umf/L2lqYepbUx6+M6n3YJ8xy8jYpN//AbFSginYXmt3GVdL2PvbXT92R
	 POA+ucWwLjJEBrgJi9KS38jOP/gO1x4x8Mt2Cjld+FScojMRqv7brk/4tBFn7lffOwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXuCEdYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C8060A260B;
	Wed, 18 Nov 2026 20:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXuCEdYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8091F000C5;
	Wed, 18 Nov 2026 20:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035177;
	bh=JgJXsCEn7m13QRPoBy3gxxmr2UnF2VLxieVIGPa0PmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXuCEdYg5o4V77YpUoXEtWx+6fak9CZoHqoKAn+MSeqrTvk7/84EP/lE6h78bIyuZ
	 D+hP/4ZOKAciGapXnvfAdcJEXvq2J4qHjSTZz4WznzwU9J1968C97FsXyH2wyDzXTH
	 cYl2aqp8h0RIUZO4rL4fEXuW9gVIsSLXZAxa1JRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0631/3318] media: rc: Ensure that rc_unregister_device() does not free input device
Date: Wed, 18 Nov 2026 15:20:53 +0100
Message-ID: <20261118150336.812178469@linuxfoundation.org>
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

commit 61c7ca95d2483c77dfdde1b007cbe846f145dec4 upstream.

During or after rc_unregister_device(), IR may still be reported which
results in a input event being reported. This could result in a null
pointer deref in rc_keydown() or a use-after-free of the input device if
the pointer was read before it is set to NULL.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1742,7 +1742,7 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
-	input_free_device(dev->input_dev);
+	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);
 
@@ -1854,6 +1854,8 @@ static int rc_setup_rx_device(struct rc_
 	if (rc)
 		return rc;
 
+	input_get_device(dev->input_dev);
+
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
 	 * since the timeout is currently set to 250ms. Increase it to 500ms,
@@ -1880,10 +1882,8 @@ static void rc_free_rx_device(struct rc_
 	if (!dev)
 		return;
 
-	if (dev->input_dev) {
+	if (dev->input_dev)
 		input_unregister_device(dev->input_dev);
-		dev->input_dev = NULL;
-	}
 
 	ir_free_table(&dev->rc_map);
 }


