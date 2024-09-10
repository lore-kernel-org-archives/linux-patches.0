Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CA3188A38;
	Tue, 10 Sep 2024 10:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963130; cv=none; b=g/+DcfYp10N9Yp6u3sCKP3hS1BPk/Izqkn0j67gb20zXgwFHShulnd1j00woIPb26ChYF7joEY14msMKT3rBI8prArpTcACl6n3LjVENIZAheDcb8f3jxLid6TPKolOMFU25zfijQecyDntVPw7ISfyy/+WQoV4v3qVljjX9Ldo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963130; c=relaxed/simple;
	bh=Nj3/sxM3Bgyc66Bn3sf2vsYNpm9zFzs4byduH7vFsxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b//Oy9ORKXb2IhkHmSHn0wJmC7BTatr9RXGaifyV3Ita9GQzWv+siUQoNzJWZGvrYY8T/EHH/z7FKXqQAkgh9fz5lMW1Hd2R64MgmZqE8PxywUOUjp+mmNMrPlfNfI2Hoa3Xt+CC3xqN/X6m94aAOTCZh9oqv8UqM1cuMNMoHAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+W3tRCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+W3tRCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66B9C4CEC3;
	Tue, 10 Sep 2024 10:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963130;
	bh=Nj3/sxM3Bgyc66Bn3sf2vsYNpm9zFzs4byduH7vFsxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+W3tRCcr0WXJc3pOZ24nkgcbA0Pkoz9UuaHyZ9Ju2DOctWVJMDK9lMt3ZcQ3+Lh2
	 8Eft6uVUfRpr7lH1ydt0MTHoLlF/NIN5zrHOG2CgOXSmwKADgolQtFersnmGaqCEZw
	 F4ssu0j28xcfGI/H6MelM59ScGJ4icrf6cEgEsYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 6.1 146/192] Drivers: hv: vmbus: Fix rescind handling in uio_hv_generic
Date: Tue, 10 Sep 2024 11:32:50 +0200
Message-ID: <20240910092603.980857261@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
@@ -1977,6 +1977,7 @@ static umode_t vmbus_chan_attr_is_visibl
 
 	return attr->mode;
 }
+EXPORT_SYMBOL_GPL(vmbus_device_unregister);
 
 static struct attribute_group vmbus_chan_group = {
 	.attrs = vmbus_chan_attrs,
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


