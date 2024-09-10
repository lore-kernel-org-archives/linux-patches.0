Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F4418FC7E;
	Tue, 10 Sep 2024 10:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962639; cv=none; b=gywvStG05tlnGmk2+WaJM8ixsJWQWPOFMEzngN0pLM1QVOyROd+QfYALRaZXgIBVuuvLJwgaaS4/phk5x6FI5qnkbdU/DCeVco29RIp3guH0PooINHCfP6ZDaEgEc/M+TIHM/TEy6cM389W0Gf6Jdyb5aXyCYHI7d0+ZLJqwU3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962639; c=relaxed/simple;
	bh=Rk9anvR38O3DWGETWYri+MsUG171rIS/dBtKP9dCiVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djtf4m9ZnIe2AsVIDfIrLgB4xtclvYrKrne/GT2W0iFVh9jryzCGsTkMluDXU47Ogwp5ZbvGzO0rWgBggGgqI48aUD2WsKSlipJuhd1/nk7Fk4tIA22r2qfSbY1ayZdQvP32Rs29RkjJlk944vYXZZlArlnp/32pBSyUEecUnPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCUCLK/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCUCLK/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B76C4CEC6;
	Tue, 10 Sep 2024 10:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962639;
	bh=Rk9anvR38O3DWGETWYri+MsUG171rIS/dBtKP9dCiVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCUCLK/jNacBB84ZOUv9EwJYnorfVFlPWcTxFQigHtyvilUJixMYRiq1PJ80rsZCQ
	 Usd1lPbN6vvykKdRhUx+gQh0j99ffJKAC3ySdeGb21ubBATJyYPjzl/5IhmnFhA3RN
	 1CE4KmK+uQPp0Hrt9VGQsBnG3uj+vz/zr21xfdAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 5.4 102/121] Drivers: hv: vmbus: Fix rescind handling in uio_hv_generic
Date: Tue, 10 Sep 2024 11:32:57 +0200
Message-ID: <20240910092550.679374727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit 6fd28941447bf2c8ca0f26fda612a1cabc41663f upstream.

Rescind offer handling relies on rescind callbacks for some of the
resources cleanup, if they are registered. It does not unregister
vmbus device for the primary channel closure, when callback is
registered. Without it, next onoffer does not come, rescind flag
remains set and device goes to unusable state.

Add logic to unregister vmbus for the primary channel in rescind callback
to ensure channel removal and relid release, and to ensure that next
onoffer can be received and handled properly.

Cc: stable@vger.kernel.org
Fixes: ca3cda6fcf1e ("uio_hv_generic: add rescind support")
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240829071312.1595-3-namjain@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/vmbus_drv.c       |    1 +
 drivers/uio/uio_hv_generic.c |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1908,6 +1908,7 @@ void vmbus_device_unregister(struct hv_d
 	 */
 	device_unregister(&device_obj->device);
 }
+EXPORT_SYMBOL_GPL(vmbus_device_unregister);
 
 
 /*
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -119,6 +119,14 @@ static void hv_uio_rescind(struct vmbus_
 
 	/* Wake up reader */
 	uio_event_notify(&pdata->info);
+
+	/*
+	 * With rescind callback registered, rescind path will not unregister the device
+	 * from vmbus when the primary channel is rescinded.
+	 * Without it, rescind handling is incomplete and next onoffer msg does not come.
+	 * Unregister the device from vmbus here.
+	 */
+	vmbus_device_unregister(channel->device_obj);
 }
 
 /* Sysfs API to allow mmap of the ring buffers


