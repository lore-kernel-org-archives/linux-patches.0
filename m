Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD913B6352;
	Thu, 30 Jul 2026 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424690; cv=none; b=V2JmpnlnhgEviUQmtudUoMqiT5L7HeOBvrcEdMmAtETqWKB2Udm9xQPQ+Ht8jP5P8O9WSRxUjEl4pULQd+nQ+Ry0sW5mZEhp3Uud71akidy4sJyz2PUuoWRAYw4wpvl+oXl2AjcXX2fi4dYm97iPShvn9FuWuQx6Ve0lhI3H+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424690; c=relaxed/simple;
	bh=RmC2uZWr5L1kd3hpbFgTCtYGPyAo7VTky/Y7f31dVH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDBpEKZqTjdHwWO66b20JHRseCjMGQPHhMsdrrLst2oyHOhAJYJOuTNzuw7nP6ZwgKr0pgL4vdGETlJ8nKit711TqZVuH2przf2xnjMZi4e8VvIEoD7xlS9Bw0d3BqGuEYyWLuv0MVqWREhCqmXYuBPrBE12JWf1rdF+g4EpIu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fv7X2gIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fv7X2gIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C181F000E9;
	Thu, 30 Jul 2026 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424689;
	bh=KfUoa5+XWUsrbH421KspGaAuPToX7N4ZqdENQ0GZ7+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fv7X2gIlqqfIG7vXOLYB/0TSbGpQ+GSZkZajn2gkIwUR90WcgGronpKQ2uYF9vjbe
	 YwRQ/YGZ5WFea6EtNKLL3ihopsxwcL68xXi3YI6fieWXtMOyBPOXgM0+E2zmKcp9Kj
	 1FhdOpJk3203hTQ0MKni2+MvwXfVMbzJ0piBTJuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 482/675] uio_hv_generic: Bind to FCopy device by default
Date: Thu, 30 Jul 2026 16:13:32 +0200
Message-ID: <20260730141455.369660406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -395,9 +395,15 @@ hv_uio_remove(struct hv_device *dev)
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


