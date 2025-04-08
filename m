Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B344926A0EC;
	Tue,  8 Apr 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115343; cv=none; b=VNtiyT85B5MvBzENjweua1bh+EFG9csdDNPRgF6kqDtSNT1+rLgiR6pahhY9GqG3pzo8RRoOT8nz8EGJh34kZxGQzyJ4baQg7YWc8wufM54cIsOBRQWHBkkkWkgc5XJ4/rSitIn2lA8UTnpD8HVWi43tzdyFGX9nTIVlSjt1jNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115343; c=relaxed/simple;
	bh=Ol7Om3V9k5yFEZuXj1Rmw87xNrZ122+kkihDsKDnvqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhf3XRMvgpXmtu7yoMMlAErNXrDxZ1YbbnxbVe86F8mSkttvjyUz/hvmK53h3LWW0Tq3snUx0cU+9q7FzJvewKG6BfvHPY70WgansaR8rspMmP/5iAxWoPPdbDRNtehbAROJ7JPvWuBmfl5xqb7ooVpUFnP3gloinAWYLjGi+Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcvgaNuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcvgaNuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405CDC4CEE5;
	Tue,  8 Apr 2025 12:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115343;
	bh=Ol7Om3V9k5yFEZuXj1Rmw87xNrZ122+kkihDsKDnvqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcvgaNuTT3I+Ho8ixsb7EG+vzyY6i5B/fy42oJ7YqRCPBLOT6U6NvRkHJ5D/BMoVv
	 RaXPBPy1IYqhIj1LgUJVV+kf0uH3mCV+dGr7+oBWX7s16QY1wGM9kxbmxu0RcXYkCj
	 xtMIwU8lD6M2bd6kRfMz08mQCKFUU6L0Nl+rzqg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 422/499] staging: gpib: Fix Oops after disconnect in ni_usb
Date: Tue,  8 Apr 2025 12:50:34 +0200
Message-ID: <20250408104901.752249053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit a239c6e91b665f1837cf57b97fe638ef1baf2e78 ]

If the usb dongle is disconnected subsequent calls to the
driver cause a NULL dereference Oops as the bus_interface
is set to NULL on disconnect.

This problem was introduced by setting usb_dev from the bus_interface
for dev_xxx messages.

Previously bus_interface was checked for NULL only in the the functions
directly calling usb_fill_bulk_urb or usb_control_msg.

Check for valid bus_interface on all interface entry points
and return -ENODEV if it is NULL.

Fixes: 4934b98bb243 ("staging: gpib: Update messaging and usb_device refs in ni_usb")
Cc: stable <stable@kernel.org>
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250222165817.12856-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 93 ++++++++++++++++++-----
 1 file changed, 73 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index b6c28a28ee25d..7faae29b66e61 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -592,7 +592,7 @@ static int ni_usb_read(gpib_board_t *board, uint8_t *buffer, size_t length,
 {
 	int retval, parse_retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	static const int out_data_length = 0x20;
 	int in_data_length;
@@ -605,8 +605,11 @@ static int ni_usb_read(gpib_board_t *board, uint8_t *buffer, size_t length,
 	struct ni_usb_register reg;
 
 	*bytes_read = 0;
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
 	if (length > max_read_length)
 		return -EINVAL;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
 		return -ENOMEM;
@@ -719,7 +722,7 @@ static int ni_usb_write(gpib_board_t *board, uint8_t *buffer, size_t length,
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	int out_data_length;
 	static const int in_data_length = 0x10;
@@ -729,9 +732,11 @@ static int ni_usb_write(gpib_board_t *board, uint8_t *buffer, size_t length,
 	struct ni_usb_status_block status;
 	static const int max_write_length = 0xffff;
 
-	*bytes_written = 0;
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
 	if (length > max_write_length)
 		return -EINVAL;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_data_length = length + 0x10;
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
@@ -818,7 +823,7 @@ static int ni_usb_command_chunk(gpib_board_t *board, uint8_t *buffer, size_t len
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	int out_data_length;
 	static const int in_data_length = 0x10;
@@ -830,8 +835,11 @@ static int ni_usb_command_chunk(gpib_board_t *board, uint8_t *buffer, size_t len
 	static const int max_command_length = 0x10;
 
 	*command_bytes_written = 0;
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
 	if (length > max_command_length)
 		length = max_command_length;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_data_length = length + 0x10;
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
@@ -924,7 +932,7 @@ static int ni_usb_take_control(gpib_board_t *board, int synchronous)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	static const int out_data_length = 0x10;
 	static const int  in_data_length = 0x10;
@@ -932,6 +940,9 @@ static int ni_usb_take_control(gpib_board_t *board, int synchronous)
 	int i = 0;
 	struct ni_usb_status_block status;
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
 		return -ENOMEM;
@@ -982,7 +993,7 @@ static int ni_usb_go_to_standby(gpib_board_t *board)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	static const int out_data_length = 0x10;
 	static const int  in_data_length = 0x20;
@@ -990,6 +1001,9 @@ static int ni_usb_go_to_standby(gpib_board_t *board)
 	int i = 0;
 	struct ni_usb_status_block status;
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
 		return -ENOMEM;
@@ -1038,11 +1052,14 @@ static void ni_usb_request_system_control(gpib_board_t *board, int request_contr
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	int i = 0;
 	struct ni_usb_register writes[4];
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return; // -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	if (request_control) {
 		writes[i].device = NIUSB_SUBDEV_TNT4882;
 		writes[i].address = CMDR;
@@ -1086,7 +1103,7 @@ static void ni_usb_interface_clear(gpib_board_t *board, int assert)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	static const int out_data_length = 0x10;
 	static const int  in_data_length = 0x10;
@@ -1094,7 +1111,10 @@ static void ni_usb_interface_clear(gpib_board_t *board, int assert)
 	int i = 0;
 	struct ni_usb_status_block status;
 
-	// FIXME: we are going to pulse when assert is true, and ignore otherwise
+	if (!ni_priv->bus_interface)
+		return; // -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+// FIXME: we are going to pulse when assert is true, and ignore otherwise
 	if (assert == 0)
 		return;
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
@@ -1132,10 +1152,13 @@ static void ni_usb_remote_enable(gpib_board_t *board, int enable)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct ni_usb_register reg;
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return; // -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	reg.device = NIUSB_SUBDEV_TNT4882;
 	reg.address = nec7210_to_tnt4882_offset(AUXMR);
 	if (enable)
@@ -1179,11 +1202,14 @@ static unsigned int ni_usb_update_status(gpib_board_t *board, unsigned int clear
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	static const int buffer_length = 8;
 	u8 *buffer;
 	struct ni_usb_status_block status;
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	buffer = kmalloc(buffer_length, GFP_KERNEL);
 	if (!buffer)
 		return board->status;
@@ -1231,11 +1257,14 @@ static int ni_usb_primary_address(gpib_board_t *board, unsigned int address)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	int i = 0;
 	struct ni_usb_register writes[2];
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	writes[i].device = NIUSB_SUBDEV_TNT4882;
 	writes[i].address = nec7210_to_tnt4882_offset(ADR);
 	writes[i].value = address;
@@ -1286,11 +1315,14 @@ static int ni_usb_secondary_address(gpib_board_t *board, unsigned int address, i
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	int i = 0;
 	struct ni_usb_register writes[3];
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	i += ni_usb_write_sad(writes, address, enable);
 	retval = ni_usb_write_registers(ni_priv, writes, i, &ibsta);
 	if (retval < 0) {
@@ -1305,7 +1337,7 @@ static int ni_usb_parallel_poll(gpib_board_t *board, uint8_t *result)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	static const int out_data_length = 0x10;
 	static const int  in_data_length = 0x20;
@@ -1314,6 +1346,9 @@ static int ni_usb_parallel_poll(gpib_board_t *board, uint8_t *result)
 	int j = 0;
 	struct ni_usb_status_block status;
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
 		return -ENOMEM;
@@ -1357,11 +1392,14 @@ static void ni_usb_parallel_poll_configure(gpib_board_t *board, uint8_t config)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	int i = 0;
 	struct ni_usb_register writes[1];
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return; // -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	writes[i].device = NIUSB_SUBDEV_TNT4882;
 	writes[i].address = nec7210_to_tnt4882_offset(AUXMR);
 	writes[i].value = PPR | config;
@@ -1379,11 +1417,14 @@ static void ni_usb_parallel_poll_response(gpib_board_t *board, int ist)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	int i = 0;
 	struct ni_usb_register writes[1];
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return; // -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	writes[i].device = NIUSB_SUBDEV_TNT4882;
 	writes[i].address = nec7210_to_tnt4882_offset(AUXMR);
 	if (ist)
@@ -1404,11 +1445,14 @@ static void ni_usb_serial_poll_response(gpib_board_t *board, u8 status)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	int i = 0;
 	struct ni_usb_register writes[1];
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return; // -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	writes[i].device = NIUSB_SUBDEV_TNT4882;
 	writes[i].address = nec7210_to_tnt4882_offset(SPMR);
 	writes[i].value = status;
@@ -1431,11 +1475,14 @@ static void ni_usb_return_to_local(gpib_board_t *board)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	int i = 0;
 	struct ni_usb_register writes[1];
 	unsigned int ibsta;
 
+	if (!ni_priv->bus_interface)
+		return; // -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	writes[i].device = NIUSB_SUBDEV_TNT4882;
 	writes[i].address = nec7210_to_tnt4882_offset(AUXMR);
 	writes[i].value = AUX_RTL;
@@ -1453,7 +1500,7 @@ static int ni_usb_line_status(const gpib_board_t *board)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	static const int out_data_length = 0x20;
 	static const int  in_data_length = 0x20;
@@ -1463,6 +1510,9 @@ static int ni_usb_line_status(const gpib_board_t *board)
 	int line_status = ValidALL;
 	// NI windows driver reads 0xd(HSSEL), 0xc (ARD0), 0x1f (BSR)
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
 		return -ENOMEM;
@@ -1569,12 +1619,15 @@ static unsigned int ni_usb_t1_delay(gpib_board_t *board, unsigned int nano_sec)
 {
 	int retval;
 	struct ni_usb_priv *ni_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(ni_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct ni_usb_register writes[3];
 	unsigned int ibsta;
 	unsigned int actual_ns;
 	int i;
 
+	if (!ni_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	i = ni_usb_setup_t1_delay(writes, nano_sec, &actual_ns);
 	retval = ni_usb_write_registers(ni_priv, writes, i, &ibsta);
 	if (retval < 0) {
-- 
2.39.5



