Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A8523A994;
	Mon, 27 Oct 2025 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590724; cv=none; b=Ni75FlrCfv9UJw6hY64z7Ia97kyihrLzFtqfcTaxP23OtxCAUuEtqS476ixQMfwGNNY4wgCrZn53PBPrDemFlEpGjXWC4xPiorCTbsAOVXpvO2o5vEuhqosPI/xdmgGw+8kWYvkGVa3ik88cHJL0bYy9BdM1FjKT5XDItHqnpmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590724; c=relaxed/simple;
	bh=t/tNq4S0zPzdBZZtwW4u2GYG0kPSMADlsmJqACkFusA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMPZKEMwGlMLLkReu6Q0t01rVsnJRev3ghKzhyGp8PgFM+oYy4w9KyH2K380ylm8on7cvL9eywQMx5YeRd9jWQuXEcyW7vFlE9NROjEbxPOHhPynlmVkdBIefqal0Tl822g0NTRFH5/3HLcSaisOwlkKcJXdAswVyeFa5dbvkeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThpMi0K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThpMi0K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CA9C4CEFD;
	Mon, 27 Oct 2025 18:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590723;
	bh=t/tNq4S0zPzdBZZtwW4u2GYG0kPSMADlsmJqACkFusA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThpMi0K9diX9foc5nfkwvncwNKtH4rxKTb9C24czOVxhJtDS02ZTRU3AdLeGP8umJ
	 1Rl8zhjXyaF/d9BlTmccaZwMEnlfnxA3CVbghcOaonPBMxC1vqfzIzotfzG6h+C6mu
	 p1HCnZT4YFp62M1LFAPfEods6ackao9f4CG2Tf1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	keliu <liuke94@huawei.com>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/224] media: rc: Directly use ida_free()
Date: Mon, 27 Oct 2025 19:34:59 +0100
Message-ID: <20251027183513.048524514@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: keliu <liuke94@huawei.com>

[ Upstream commit cd54ff938091d890edf78e6555ec30c63dcd2eb5 ]

Use ida_alloc() and ida_free() instead of the deprecated
ida_simple_get() and ida_simple_remove().

Signed-off-by: keliu <liuke94@huawei.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 4f4098c57e13 ("media: lirc: Fix error handling in lirc_register()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    6 +++---
 drivers/media/rc/rc-main.c  |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -746,7 +746,7 @@ int ir_lirc_register(struct rc_dev *dev)
 	const char *rx_type, *tx_type;
 	int err, minor;
 
-	minor = ida_simple_get(&lirc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
+	minor = ida_alloc_max(&lirc_ida, RC_DEV_MAX - 1, GFP_KERNEL);
 	if (minor < 0)
 		return minor;
 
@@ -791,7 +791,7 @@ int ir_lirc_register(struct rc_dev *dev)
 	return 0;
 
 out_ida:
-	ida_simple_remove(&lirc_ida, minor);
+	ida_free(&lirc_ida, minor);
 	return err;
 }
 
@@ -809,7 +809,7 @@ void ir_lirc_unregister(struct rc_dev *d
 	spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
 
 	cdev_device_del(&dev->lirc_cdev, &dev->lirc_dev);
-	ida_simple_remove(&lirc_ida, MINOR(dev->lirc_dev.devt));
+	ida_free(&lirc_ida, MINOR(dev->lirc_dev.devt));
 }
 
 int __init lirc_dev_init(void)
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1861,7 +1861,7 @@ int rc_register_device(struct rc_dev *de
 	if (!dev)
 		return -EINVAL;
 
-	minor = ida_simple_get(&rc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
+	minor = ida_alloc_max(&rc_ida, RC_DEV_MAX - 1, GFP_KERNEL);
 	if (minor < 0)
 		return minor;
 
@@ -1944,7 +1944,7 @@ out_rx_free:
 out_raw:
 	ir_raw_event_free(dev);
 out_minor:
-	ida_simple_remove(&rc_ida, minor);
+	ida_free(&rc_ida, minor);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(rc_register_device);
@@ -2004,7 +2004,7 @@ void rc_unregister_device(struct rc_dev
 
 	device_del(&dev->dev);
 
-	ida_simple_remove(&rc_ida, dev->minor);
+	ida_free(&rc_ida, dev->minor);
 
 	if (!dev->managed_alloc)
 		rc_free_device(dev);


