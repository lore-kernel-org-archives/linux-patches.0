Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EBB18BC28;
	Tue, 10 Sep 2024 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961169; cv=none; b=USmsse/BlLvlhwi+d0wJ486jg63e9uVVdnPk9RkRXOKU+dFuJTnMQuvjuMAFoTt93Vdxgo3ooBD5VYwg2jKtoITAySvH0rF+aehGgOV44MIZRcRgrHN5okZf8loTH0G7IrwEqe4egREzrhg4UuBDpQU3R5RfJmkc78s3H/xfyJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961169; c=relaxed/simple;
	bh=rR+bq/6fmiqu8mKUxz4ifANDVf00GH1QJXYYfxZwAaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnlrgpEXmqbHOg322aVn6khoO0pBQ7bornfd4dAkYNe6zQ29e8Nq7QmXb7san218BkcmxM0EkE3EIfIT2ZgMBzZAHhL9M2WicPe5nWy+Izonr8o6T6DOzJ7COMA9mzyqTY70EggUuQSTL9DzSMCTm7npQQYUeVyODy3IaM8CUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chMtv6On; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chMtv6On"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB37C4CEC3;
	Tue, 10 Sep 2024 09:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961169;
	bh=rR+bq/6fmiqu8mKUxz4ifANDVf00GH1QJXYYfxZwAaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chMtv6OnggYoDvaN58EL5M/s72JieYvkxEiorEZpgRTP/Xn6mwuWbqIiGi4FRPIBi
	 uvII7t4KsH2k28xc1ONjNlfNIYKE9LQ0QgfIxERq0wuGAz4LtLgKqLQbhYpV4VHwlM
	 Q1dL1p7ypRrhBbLrZbTfStzSv6vNNq62hP8uml8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 4.19 77/96] Drivers: hv: vmbus: Fix rescind handling in uio_hv_generic
Date: Tue, 10 Sep 2024 11:32:19 +0200
Message-ID: <20240910092544.928631249@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1973,6 +1973,7 @@ acpi_walk_err:
 		vmbus_acpi_remove(device);
 	return ret_val;
 }
+EXPORT_SYMBOL_GPL(vmbus_device_unregister);
 
 static const struct acpi_device_id vmbus_acpi_device_ids[] = {
 	{"VMBUS", 0},
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


