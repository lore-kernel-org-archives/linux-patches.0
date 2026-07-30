Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0727416CF3;
	Thu, 30 Jul 2026 14:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422865; cv=none; b=FXn+IpWg7MDScDhtqRObawM9arpwtsKS+RLGo21/YTmgD5nUYG/QwkA9G9YsksHYdum9uHMTtBC28EhwCreoip3jNUlBc/HSPX4NMLjc0R6ZlFPQHxwY6NHVGsYExe/wwMP8lh4V8qST0Bubjo5ar2u8cJAeZMwhglOVuSwUtN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422865; c=relaxed/simple;
	bh=vZL6FTpNSdpokOJ79Dfc3HPNA2X9qXbmM/vJo4yNTQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ1+4leHxiVl+q+nN4zLyHFddvButc+l/8Z0CjqhU81lKSLoz6XaBZovDOvvEJuuCRMd+NZ0qLtJFyCLNBtezRB8yr1UN6yiJ9DJ0/+LzrYOP2njvIjP2XuCc1W7r1P2JojOwsGqCucBYyEInIjDnL0sqHmFw70tv1H2y/+GxYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGi4j92m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGi4j92m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F901F000E9;
	Thu, 30 Jul 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422864;
	bh=UD6Cggh/UdXmjiaTVPObEhnPjxPY+8WfKm2ZOhTTh28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGi4j92m2Wusu5Sns82ekQ0kdTpu5T/upcMOp7A7vdMM+92ZZ7UfTeRXLV0VWTCKG
	 W/+P3yZz0O62AX2AE6QFewg4D1Jp5/RV9PnVcg+vY8JFlS+MGlcANKTnwRJx4acwxK
	 /EmCA53F1P3nWAS+NSuTNvexyLgUDz1lybcKqbFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	stable <stable@kernel.org>
Subject: [PATCH 7.1 582/744] uio_hv_generic: Bind to FCopy device by default
Date: Thu, 30 Jul 2026 16:14:15 +0200
Message-ID: <20260730141456.655247063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

commit 87d3621ccc63b3999d756bb59f0cedd738c28eb3 upstream.

The Hyper-V kernel-mode fcopy driver was removed in 6.10 and the new
fcopy daemon requires this uio driver to function.  However, by
default the driver does not bind to any devices, and must be
configured through the sysfs "new_id" file.

Since the FCopy device is now only usable through this driver, add its
ID to the driver's ID table so that the daemon will work "out of the
box".

Signed-off-by: Ben Hutchings <benh@debian.org>
Fixes: ec314f61e4fc ("Drivers: hv: Remove fcopy driver")
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/ahQ6xuhSReidmN-3@decadent.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -396,9 +396,15 @@ hv_uio_remove(struct hv_device *dev)
 	vmbus_free_ring(dev->channel);
 }
 
+static const struct hv_vmbus_device_id hv_uio_id_table[] = {
+	{ HV_FCOPY_GUID },
+	{}
+};
+MODULE_DEVICE_TABLE(vmbus, hv_uio_id_table);
+
 static struct hv_driver hv_uio_drv = {
 	.name = "uio_hv_generic",
-	.id_table = NULL, /* only dynamic id's */
+	.id_table = hv_uio_id_table,
 	.probe = hv_uio_probe,
 	.remove = hv_uio_remove,
 };


