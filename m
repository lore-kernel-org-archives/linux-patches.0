Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063457;
	b=HZripxue9EC4lqaRo2PSTBtlJDR00lIj8e4FTo2r0qut7QjjpH6bMPhhDW+81J6diu/3
	 1cTqf2MqlnaLlWtWmciMpZa6ZwDTwxHtrZ480C2niNX9w/A2BSGnoVy5AAfD7n1uDc6dj
	 B907RWnq0FhZRywVX5CHoIqcNtl5dkX5AHUsAfR/ud5QuW785t0ObSQhz1b3GRigzEYEi
	 dou3d14VlsO74cIchoveLOvVsj/bpLhcrMqbcCq7LAfHiGiod9j17nck0Ga8tMLEf0hRT
	 GvaHwgjRa+JAu3RXOsTeUF6ismoiMQoluMvaleyVrOm+XhYxeEZ3BzBm4JqLYEN8a9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pIWKvEJy2vRDtS9H+SPRBCkR+3dlTk+LlD2OW8VxPgI=;
	b=3dK9rjgFLNFGkcP0U0rcjvx/6hG7ESse68wistPyk+MU+2oRr8Q/kn7DbcBtYwmTW6O3
	 ZubHY/w+PTv5bT8OG/iiOoWuF1Nu4YFgTXf5Vorhbwzg8bIvXlV9AQwFMAGlUN77QK7Vc
	 x2w6dKypIJZCFNtgb033FqLNkXnlBzHxCUAvewmcE0tflNIx2usf39YTf8UkWg6whTVf3
	 gWuvaRAXwGbPedLdnNCgcvwjSrMlhL7jBwsyabyGKt1d+7V5k5YWPVHrqY9YOD/EaRxrb
	 TuiEscMbKzMRsFZ+b9O61ewugRC3tS5qVXUcItnjuXeWGnEbr8gJM2ATKPSBYvas+7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z18X4fjg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964B4606EE81;
	Sat,  7 Nov 2026 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z18X4fjg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452091F0089F;
	Sat,  7 Nov 2026 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063457;
	bh=pIWKvEJy2vRDtS9H+SPRBCkR+3dlTk+LlD2OW8VxPgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z18X4fjg11OPFplqIsKGj9pet97gt3iMPghEA66Bomep6SMbJPyyIxzLhy1ur+dVU
	 wnHrseJIWENiO1GNlvjJ7NligtB0F5/SPnaJ40nc5dyksbHOizFVv/5GQuzxgMSZCH
	 Boxw1i3cakQgOv0PUIURlUFE83kmrIPcXtdD+rUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sonotri <sono7ri@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 614/869] ublk: pin module while release work is pending
Date: Sat,  7 Nov 2026 08:54:56 -0500
Message-ID: <20261107134913.879289726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: sonotri <sono7ri@gmail.com>

[ Upstream commit afc9cde716b29ce814798d649a95f9128ba42b43 ]

ublk_ch_release() takes a device reference and queues exit_work.  The VFS
module reference held through the file operations is dropped after
->release() returns.  A queued work item does not acquire its own module
reference for the callback.

Consequently, normal module removal can start while exit_work is pending or
executing.  In addition to the worker callback itself, the final device put
can invoke ublk_cdev_rel(), which is also module code.

Take a module reference while ->release() is still covered by the file
operations reference and drop it only after the worker has completed its
final device put.  A rearming worker retains the same reference.

Merely canceling exit_work during module exit is insufficient.  The worker
is the terminal path for the device reference taken by ublk_ch_release(),
so its cancellation would strand that reference and skip the associated
cleanup.

Fixes: c5c5eb24ed61 ("ublk: avoid ublk_io_release() called after ublk char dev is closed")
Cc: stable@vger.kernel.org
Signed-off-by: sonotri <sono7ri@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261015120654.241354-1-sono7ri@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c9109731d29ba..8c33a5f86c3d6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1839,6 +1839,7 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 
 	/* put the reference grabbed in ublk_ch_release() */
 	ublk_put_device(ub);
+	module_put(THIS_MODULE);
 }
 
 static int ublk_ch_release(struct inode *inode, struct file *filp)
@@ -1851,6 +1852,8 @@ static int ublk_ch_release(struct inode *inode, struct file *filp)
 	 */
 	ublk_get_device(ub);
 
+	/* Keep the worker's callback and final device release code resident. */
+	__module_get(THIS_MODULE);
 	INIT_DELAYED_WORK(&ub->exit_work, ublk_ch_release_work_fn);
 	schedule_delayed_work(&ub->exit_work, 0);
 	return 0;
-- 
2.53.0



