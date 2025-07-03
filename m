Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07602EA149;
	Thu,  3 Jul 2025 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555096; cv=none; b=rQM3u1lkmU/H3wWVhSqUx9f1BLaUuRp+XRX4zVsCerxZSAbrkR8Sl5FW1IBYqlLmMbOBa3nKVqZb8bTSwF5vqTbz+a4vRFdWFCU4UKtsLBI0zOpcMkgOQyjezc0GWthvbwi43I8Nl2Rq95Y2KvYLBo4OigglEp4v/77C8GrWejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555096; c=relaxed/simple;
	bh=7sm6wYlrVYK9rRnz0pyC0lKeCqwc19xFwmFde8GN8G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAcBR++kqhOkd+/Ly2uEGUdBDXHFCmXi5JUQYljD3IThmKcWXLzDvkJ17siLFkyLrJpy/PWAHiQkyc7QXoyKe+3fgr+H+ddvmKAWJe/jaGnqZuKsFoor7Zy4+3Hsz51k0KMUQTiMoZiLV8Z3kG0gANyfv4low3fPGuJCY8TAJaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4RQ0E/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4RQ0E/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC78C4CEE3;
	Thu,  3 Jul 2025 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555096;
	bh=7sm6wYlrVYK9rRnz0pyC0lKeCqwc19xFwmFde8GN8G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4RQ0E/+CEyHL6v8fUk5l2HWR3L1sdwPnXoa+Mqb0ta9yWRTGWsctpxAcPVH6wu/N
	 jTreeX+KVXAG22SqpXRfZaJ5HOYCHQCiiBmnW6r83OqWxVGcjRS648va9Kn5T1MAFE
	 209WK2mznL9vSUUS0hWWUKYiDeD3SGWQ6CPObxiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aidan Stewart <astewart@tektelic.com>
Subject: [PATCH 6.15 175/263] serial: core: restore of_node information in sysfs
Date: Thu,  3 Jul 2025 16:41:35 +0200
Message-ID: <20250703144011.364566973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aidan Stewart <astewart@tektelic.com>

commit d36f0e9a0002f04f4d6dd9be908d58fe5bd3a279 upstream.

Since in v6.8-rc1, the of_node symlink under tty devices is
missing. This breaks any udev rules relying on this information.

Link the of_node information in the serial controller device with the
parent defined in the device tree. This will also apply to the serial
device which takes the serial controller as a parent device.

Fixes: b286f4e87e32 ("serial: core: Move tty and serdev to be children of serial core port device")
Cc: stable@vger.kernel.org
Signed-off-by: Aidan Stewart <astewart@tektelic.com>
Link: https://lore.kernel.org/r/20250617164819.13912-1-astewart@tektelic.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_base_bus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/serial_base_bus.c
+++ b/drivers/tty/serial/serial_base_bus.c
@@ -72,6 +72,7 @@ static int serial_base_device_init(struc
 	dev->parent = parent_dev;
 	dev->bus = &serial_base_bus_type;
 	dev->release = release;
+	device_set_of_node_from_dev(dev, parent_dev);
 
 	if (!serial_base_initialized) {
 		dev_dbg(port->dev, "uart_add_one_port() called before arch_initcall()?\n");


