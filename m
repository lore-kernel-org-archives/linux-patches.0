Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1D2422E10;
	Thu, 16 Jul 2026 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211136; cv=none; b=BoPv+h57p+/tvG5XOAbi30TbZC+xgVhskOockyhUnULwzHS/4sQtf7WfS3+WlX/c1VKLaxwn8yusEHCoEe8fsbewifn3K5r8mcKu6bFXQJ4G0bNBdL9I+oDQZ+8atHL5OV0UQpgEnBPqyyiMnUfd0PmfcWVivr+qAKPrnW19tAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211136; c=relaxed/simple;
	bh=GRGadDwF0erduoSzQJ2HmHpje0hlkUbWF0lDq7Lvy5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrbIXefObX+YMR/ILqQ3/0Dmt2pzPzvbN4+NvBYJQ/3bk1F2hPVlh5l7hr9Dz4ntLFvmm/L8z1bUp9sJmzEsgkf7yOly0gFsJ/kzgF11Y9rQlFq8HtFO1GcqlEh/75+GcCnDLBiAC6aXRxePkHht1z9s3bxIssTkK3JRWEyntQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUY0StKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUY0StKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFBC1F000E9;
	Thu, 16 Jul 2026 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211135;
	bh=37Fh8I/vRyE/L+l+VGNq/Sq+vC20UE8FuJRHqf8ccr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUY0StKe2yI/tYUJYdfHtdFTNJ6YswiL6nsx4RjQNJpSWs3QhswnrKbPFnCB7ZANz
	 AYuzdsb1BymcGtyA2x0v6zNHNAly+ux6QndDt2EisMT7Lo2rQipzAL1MKNUAYzTRv1
	 sYmLUC6KlnM0+Ua59a+XM1+lLd0gu2J55bxliOzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.18 312/480] usb: typec: class: drop PD lookup reference
Date: Thu, 16 Jul 2026 15:30:59 +0200
Message-ID: <20260716133051.570291979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 43ae2f90b70cda374c487c1639a01d0f14e5d583 upstream.

usb_power_delivery_find() wraps class_find_device_by_name(). That helper
returns a device reference that must be released by the caller.

select_usb_power_delivery_store() only needs this reference while calling
the pd_set callback. Drop it once the callback returns. Otherwise the sysfs
write can pin the selected USB Power Delivery object and prevent it from
being released on unregister.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable <stable@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260702191329.2648043-1-shuangpeng.kernel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1525,6 +1525,7 @@ static ssize_t select_usb_power_delivery
 		return -EINVAL;
 
 	ret = port->ops->pd_set(port, pd);
+	put_device(&pd->dev);
 	if (ret)
 		return ret;
 


