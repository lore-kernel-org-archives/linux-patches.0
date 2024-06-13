Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D74144317;
	Thu, 13 Jun 2024 12:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282911; cv=none; b=VfcKMM7OSA+L59KvZwbMMudVv10jixaq5PWJUa/Y+KuPNIII1KQRmFrb2QXdYOZRijnPE2XaReji0opzyC7GW1J+D+89T/YiEv4Pndh2KKu6ItgQ6QKhd5ZSAORm3dO0wc9SYmbPUs+2p40GlGOlZoNTYbHlVE594a+otvgH63k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282911; c=relaxed/simple;
	bh=QQqS7Qzfl0nXxIaJPO71jp333d3YZjPQSqFD3LEGILo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQl23MWcqzffUaanyoIMWd/+IrpcGXtAIxLrOlzKqnMYLLlh7MCHnHX8SS4BdU9QTiJKddixMhq9Bm2nJ3IrT+HrKnF2PiIK6lnBxxsGd0DAKbTRPukNKthsZbppBcQM0m7qPp2Fq/Ck6LDD+SqGdpgzwD8Wu/ykt0LB0DnU6VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJtT0j5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJtT0j5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83655C2BBFC;
	Thu, 13 Jun 2024 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282910;
	bh=QQqS7Qzfl0nXxIaJPO71jp333d3YZjPQSqFD3LEGILo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJtT0j5GzCIjzRqzWwxw3kisD0rq97cqacjT1wNvziEAydNREpH38qZUDNVICKDhQ
	 09NP/sV6YWlDCsb/x3YvSQiu3dYKQDNgqaof/BaD6Qu8i6EJxs2HD5uIfdw3X0WENY
	 oUyO+fotZWyBul9r3fwCrgfIJ44hNHnKaPtmIbHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.1 35/85] media: mc: mark the media devnode as registered from the, start
Date: Thu, 13 Jun 2024 13:35:33 +0200
Message-ID: <20240613113215.502938904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 4bc60736154bc9e0e39d3b88918f5d3762ebe5e0 upstream.

First the media device node was created, and if successful it was
marked as 'registered'. This leaves a small race condition where
an application can open the device node and get an error back
because the 'registered' flag was not yet set.

Change the order: first set the 'registered' flag, then actually
register the media device node. If that fails, then clear the flag.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Fixes: cf4b9211b568 ("[media] media: Media device node support")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/mc/mc-devnode.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/media/mc/mc-devnode.c
+++ b/drivers/media/mc/mc-devnode.c
@@ -246,15 +246,14 @@ int __must_check media_devnode_register(
 	kobject_set_name(&devnode->cdev.kobj, "media%d", devnode->minor);
 
 	/* Part 3: Add the media and char device */
+	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
 	if (ret < 0) {
+		clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 		pr_err("%s: cdev_device_add failed\n", __func__);
 		goto cdev_add_error;
 	}
 
-	/* Part 4: Activate this minor. The char device can now be used. */
-	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
-
 	return 0;
 
 cdev_add_error:


