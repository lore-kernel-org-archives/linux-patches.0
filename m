Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA9F187325;
	Tue, 10 Sep 2024 10:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965184; cv=none; b=SmdleCUV1wYtvYDPoIQpNQKi0mp+svHVLUgt60bFBmzEp4STqcz/4ms8Ne+SbJzVhNiD4+Ns7pA4M1y8JGFoWRD+JhQJ3dQzo+NptVcRbRyYaBtV4dxtOf4MXdp1bOtzBZNxOzFIOA1kEIvivHXBR5o53ieogB76PLBlfDIb6G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965184; c=relaxed/simple;
	bh=XkKI9x9yVcNiOC1aWsoX3Vw+B0SpG3HrDU7MJC3EiFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbazJEv4zcJcwREokbagjD8fGI1ubbrcmbvdBtrXCZIetQSBmBuXBoDoA3/r47M/jE+R/h/SrWX1iJ8m/E8Cy4VSj0duU+vuoA+5fCadssnHkzD5yZ3+qyje6WfHl1PxXa8ZPkVy//rFW5wrUpL9L1RdF/Hn+LnfHVE1sTGqQDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjONnYRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjONnYRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7B1C4CEC3;
	Tue, 10 Sep 2024 10:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965184;
	bh=XkKI9x9yVcNiOC1aWsoX3Vw+B0SpG3HrDU7MJC3EiFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjONnYRym7G4mLzaxl/YoPcmJwkFx9o3jefbCu8RoGkLooIlfAmITuBgN84X1+Slh
	 +XOKYc5rB7bKUR3mFklSBxxxKwbNcstfK/AsLBODbWMwgurDTeynasgiiANL2rM3am
	 w4K1364pXnMAHKiDzyRyadybvGXCq4FDf0QOH/DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 5.10 166/186] Drivers: hv: vmbus: Fix rescind handling in uio_hv_generic
Date: Tue, 10 Sep 2024 11:34:21 +0200
Message-ID: <20240910092601.450357098@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1965,6 +1965,7 @@ int vmbus_add_channel_kobj(struct hv_dev
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vmbus_device_unregister);
 
 /*
  * vmbus_remove_channel_attr_group - remove the channel's attribute group
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


