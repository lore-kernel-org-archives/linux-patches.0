Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C96171671;
	Tue, 10 Sep 2024 09:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962125; cv=none; b=MzFKZdXmal7O2vwe2V2UxeoBQACFjV0Zmaa18mumH2fFy/ONF+1DpIlfHaPGzWkchpaaNzbyy7FbgxB6tGTckSf8Db+/TEAjJ4LB4wna4c/n2Jy210WbYLsStbmTyCAApdSaZRAAdyoWA0Z2KRmt2jerJQLqYqRnl4AdyN+qzCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962125; c=relaxed/simple;
	bh=Co3+Clvhs9mUIcsLp+mmJmW5+JA+brMZhzUx2AAhhJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i22z5N2Lid+DbKpQxa8p9eSlO+70KI1TroiY7Aubp+j4yW5BbtmonP/qff9k4hbBQOh4P1VxEP1zHJ5HTihIkfvUo4P0Zapzs3Llxd+bm4QK3XKHN7J88BWgH5oRG6okQTBpaouAGgoHmBuulBo4ZmohkAkQ+fS/vj4LeA8sHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMg9AN9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMg9AN9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11ACAC4CEC3;
	Tue, 10 Sep 2024 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962125;
	bh=Co3+Clvhs9mUIcsLp+mmJmW5+JA+brMZhzUx2AAhhJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMg9AN9ttNSTdMFilCiRHJlab2eCJzSuNfVDiPEW0vKgn3mTPqHJfqj9+QQab4QCS
	 GPS8uc0DReDZDfgdu+T5wGdK9HydE7TG3kEexPWLNbAjoPzVfwDziNY+O1oMGzlLBU
	 pn0H1v0zYj2OU2zAzjt/Rt9/AaZ/3+t5BuG2nap0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 6.10 303/375] Drivers: hv: vmbus: Fix rescind handling in uio_hv_generic
Date: Tue, 10 Sep 2024 11:31:40 +0200
Message-ID: <20240910092632.741395512@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1952,6 +1952,7 @@ void vmbus_device_unregister(struct hv_d
 	 */
 	device_unregister(&device_obj->device);
 }
+EXPORT_SYMBOL_GPL(vmbus_device_unregister);
 
 #ifdef CONFIG_ACPI
 /*
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -121,6 +121,14 @@ static void hv_uio_rescind(struct vmbus_
 
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


