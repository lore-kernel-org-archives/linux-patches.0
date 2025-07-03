Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193CC2EF67A;
	Thu,  3 Jul 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554363; cv=none; b=IgW75lkqZx1HMQO1Yb3a3D9Zp5SFmuxIWr2PkFOgCqtqxCKdHqxkP1vF+akGEX0YnG/tFsDcgZhgRYYioUcfOL+GvOg0IyFWqX2+s8xYdkKsJK5IF3OCLPDsBjHVZSgty9PLMrKLE9UxEyJwKKxLzmuk9/7bW2mqvzhe2AdmaYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554363; c=relaxed/simple;
	bh=HNx6pjcCBV2Fkse48B2LBKaVYmfp3/hgxuLLC0qX7ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkJvMotoDkxgpbGsDbk9A2o+YTHy1GLAwS1wF4Qk9+FLtfriCXksymDKiqp+XdsfEuqROlwhca8rxSs6vSMi3YbmqAi4/PmZ1kDQbi5DrmZA4F3Vtt1oNX+XQnw8U12KkaTM7LDGNU2I46RYwdYEreqKx9LSkNyQuqbgbvG7ZVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjNV6h2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjNV6h2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389D4C4CEF2;
	Thu,  3 Jul 2025 14:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554361;
	bh=HNx6pjcCBV2Fkse48B2LBKaVYmfp3/hgxuLLC0qX7ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjNV6h2sDhUPZdow/Z8b0sQ9HwRUV5KXBk4Z1hOSEtbklnxZRNuELnNBo7mOVqVlZ
	 XJAk4cfdd5/lWO1qiADDBYgrIO5f4whVN82HXQEAXUzWb0w732zdimhkU1oaeD3gM/
	 Y2P028N41nnm+Q9WJNsdzCSQJMPyR4jlrl3ISfWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aidan Stewart <astewart@tektelic.com>
Subject: [PATCH 6.12 131/218] serial: core: restore of_node information in sysfs
Date: Thu,  3 Jul 2025 16:41:19 +0200
Message-ID: <20250703144001.353244648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


