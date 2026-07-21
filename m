Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A4243C05F;
	Tue, 21 Jul 2026 22:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673307; cv=none; b=SmacKG4KdWoF/DcjQNpI1Mwgnw47E2rhn4Xn8WhlG4G3kZb3+qI4c41Skh4Ux78F+ohb2qkBc//AZeNccbI7GKubw5XgwjX9mETZOb9gV8SqGzhp9AswlogNU+AJ+XMMFQYKNOJtETmYso9BRsrQmfLk9W2Qp0uzlLKoCBzmb+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673307; c=relaxed/simple;
	bh=ef/6f105VMD3p9YdVgDVpaZKQbEmLjDTmwzrwSUikiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxdTA8dtmAyZGlXceIrrgYUhqyG6kd2dK7HQmcL0cCf/kqv98JV6pLvhpam77cMz9NT7GP4FpiuP+JrBKDYxRSnKykQKxTPnvINqFcRMXyBZzOULsu06KG7u2kmPeyaR2F4787jcMNQX44Oo+MAYc5E6vxEVYPWgVU4oyfdHhWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDCMO/NH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDCMO/NH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252981F000E9;
	Tue, 21 Jul 2026 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673306;
	bh=MhGsjy+zrmStxMQdZPJtqgfVaghpidj+3AcDaXt1WA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDCMO/NHX1KRgExMS2B7wjrX97KlNvQsvLaz6Oc5LLpscGP33v2FPqSu1ej5KcZSo
	 2rJqTTOk31HdFyW5DipmRQTf8jjJSv3tTMagn1Eq2+VqdaDTh7K7/wZNu6nLBQHCFz
	 uaaQOG+s416pUA0sKHBKJhCwW+Kxy1fCd59n7WU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 112/699] USB: ulpi: fix memory leak on registration failure
Date: Tue, 21 Jul 2026 17:17:51 +0200
Message-ID: <20260721152358.229786385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8af6812795869a66e9b26044f455b13deecdb69c upstream.

The allocated device name is never freed on early ULPI device
registration failures.

Fix this by initialising the device structure earlier and releasing the
initial reference whenever registration fails.

Fixes: 289fcff4bcdb ("usb: add bus type for USB ULPI")
Cc: stable <stable@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260608145803.69360-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -241,28 +241,24 @@ static int ulpi_register(struct device *
 	ulpi->dev.parent = dev; /* needed early for ops */
 	ulpi->dev.bus = &ulpi_bus;
 	ulpi->dev.type = &ulpi_dev_type;
+
+	device_initialize(&ulpi->dev);
+
 	dev_set_name(&ulpi->dev, "%s.ulpi", dev_name(dev));
 
 	ACPI_COMPANION_SET(&ulpi->dev, ACPI_COMPANION(dev));
 
 	ret = ulpi_of_register(ulpi);
-	if (ret) {
-		kfree(ulpi);
+	if (ret)
 		return ret;
-	}
 
 	ret = ulpi_read_id(ulpi);
-	if (ret) {
-		of_node_put(ulpi->dev.of_node);
-		kfree(ulpi);
+	if (ret)
 		return ret;
-	}
 
-	ret = device_register(&ulpi->dev);
-	if (ret) {
-		put_device(&ulpi->dev);
+	ret = device_add(&ulpi->dev);
+	if (ret)
 		return ret;
-	}
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
 		ulpi->id.vendor, ulpi->id.product);
@@ -291,9 +287,10 @@ struct ulpi *ulpi_register_interface(str
 	ulpi->ops = ops;
 
 	ret = ulpi_register(dev, ulpi);
-	if (ret)
+	if (ret) {
+		put_device(&ulpi->dev);
 		return ERR_PTR(ret);
-
+	}
 
 	return ulpi;
 }


