Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A492E889D;
	Tue, 15 Jul 2025 13:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587503; cv=none; b=FtnVDmzwhpb9bc0/nZGU/XJpYh6O4Zzz0a5xqFj+1XAFW7QvcUPCSAApjzHZdVw4LFKMu1t0qqsoAcnVr2xoNKLW2B8eUr/0WsoGdpAdKy17R6wEUQbNrGwSVQVTTDOjQhn3NGjhuQOZyWDZ/+zYVcoeM0iKJyaB6cSdbdp8VW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587503; c=relaxed/simple;
	bh=jnwBtzXtuMW7ZthTkCTRhosgOJrpRww0KuSRp0F6LkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcUdmeAY1VPxP/BzmENdf/pIWXa73ZufArkb7OoynXkQz6Kys3eje/WMNhSL/VXwwYFvDzduq/HZU9rhbF7wyWSh0OAOPY485GvT+Y8LXXMyAbETakurfmW4EJbeI/l40qL6khtlLE1kGtQFDMsWa/VSH+HI23OREWXuVqrciQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxY64knd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxY64knd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C05BC4CEE3;
	Tue, 15 Jul 2025 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587503;
	bh=jnwBtzXtuMW7ZthTkCTRhosgOJrpRww0KuSRp0F6LkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxY64kndkhZ18UqEYraOVi0cgbY0SExBVP57w2nrD8DYUXiqiCvaD2Lv0/hXqwaJ1
	 bGIETHk//qEBgG2ZBkaeSmoNKIlSUghdbpu9Cz0SG2uk5FjLAO+xuZMqDl/REr6cvN
	 DsmWSafPo29K7hvpIyyvqg8djza7sMVUv5SN5xKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/208] uio: uio_hv_generic: use devm_kzalloc() for private data alloc
Date: Tue, 15 Jul 2025 15:12:26 +0200
Message-ID: <20250715130812.446588760@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 74e71964b1a9ffd34fa4b6ec8f2fa13e7cf0ac7a ]

This is a minor cleanup for the management of the private object of this
driver. The allocation can be tied to the life-time of the hv_device
object.
This cleans up a bit the exit & error paths, since the object doesn't need
to be explicitly free'd anymore.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201119154903.82099-4-alexandru.ardelean@analog.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_hv_generic.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 67cfe838a7874..f7f5106307627 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -256,14 +256,14 @@ hv_uio_probe(struct hv_device *dev,
 		return -ENOTSUPP;
 	}
 
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(&dev->device, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
 	ret = vmbus_alloc_ring(channel, HV_RING_SIZE * PAGE_SIZE,
 			       HV_RING_SIZE * PAGE_SIZE);
 	if (ret)
-		goto fail;
+		return ret;
 
 	set_channel_read_mode(channel, HV_CALL_ISR);
 
@@ -360,8 +360,6 @@ hv_uio_probe(struct hv_device *dev,
 
 fail_close:
 	hv_uio_cleanup(dev, pdata);
-fail:
-	kfree(pdata);
 
 	return ret;
 }
@@ -377,10 +375,8 @@ hv_uio_remove(struct hv_device *dev)
 	sysfs_remove_bin_file(&dev->channel->kobj, &ring_buffer_bin_attr);
 	uio_unregister_device(&pdata->info);
 	hv_uio_cleanup(dev, pdata);
-	hv_set_drvdata(dev, NULL);
 
 	vmbus_free_ring(dev->channel);
-	kfree(pdata);
 	return 0;
 }
 
-- 
2.39.5



