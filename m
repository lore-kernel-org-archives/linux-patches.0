Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17F268684;
	Tue,  8 Apr 2025 12:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115419; cv=none; b=dwskK2ewEj33GeYsD897IBtvZoui/X8c7Z+vZE+DShx9KrqF1idxTZp33oxiDbNIe8F5J68OEJqJTW5AiIG/EzBPTo+ao64ovPKbkbqLs4eWAUw9A3NYagrwSm9cx1oflO4zEtWvYtQ3sBjB8AwM8dbcxTqVhJT4V9w3ZNyTZUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115419; c=relaxed/simple;
	bh=rjzrVne48kpwPOOisEipTgqFC2L/zRAumXwpMqtaAko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEcaMkWhdHckXwQssgyzzMMuY+I8p6QEFbDD52C7Sugj9cjtiVVzV4LB+6f5Wxi1duGSoDiNqOX9g0p1LeRIPwZnU3/iyC7ZZGEC7MIs04uL5zmBZTMeICXjBT24c4Aco6TuiIIBloTNThCRnpQr7EHvd5GpTAG9kUe0USSxwDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IP1AxGG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IP1AxGG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A50C4CEE5;
	Tue,  8 Apr 2025 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115418;
	bh=rjzrVne48kpwPOOisEipTgqFC2L/zRAumXwpMqtaAko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IP1AxGG/v783Yr/aPqWNMCsBstMhnCT+altUEtu0qU4XzqHJtLjYWeeDMLPSQyye4
	 WDazme+TiizJuYSiCPs0UxHD6U7X1NSayvfQ2BojV8r4lRIQtKD0+8cyNlI5F931uw
	 vT32lwVWguxGJe9c1pKkupFUZljgOt5EhSp9dFu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 428/499] staging: gpib: Fix Oops after disconnect in agilent usb
Date: Tue,  8 Apr 2025 12:50:40 +0200
Message-ID: <20250408104901.903667413@linuxfoundation.org>
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

[ Upstream commit 8491e73a5223acb0a4b4d78c3f8b96aa9c5e774d ]

If the agilent usb dongle is disconnected subsequent calls to the
driver cause a NULL dereference Oops as the bus_interface
is set to NULL on disconnect.

This problem was introduced by setting usb_dev from the bus_interface
for dev_xxx messages.

Previously bus_interface was checked for NULL only in the functions
directly calling usb_fill_bulk_urb or usb_control_msg.

Check for valid bus_interface on all interface entry points
and return -ENODEV if it is NULL.

Fixes: fbae7090f30c ("staging: gpib: Update messaging and usb_device refs in agilent_usb")
Cc: stable <stable@kernel.org>
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250222204515.5104-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpib/agilent_82357a/agilent_82357a.c      | 65 ++++++++++++++++---
 1 file changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
index 7a39056ebc886..438ddc5a84ed3 100644
--- a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
+++ b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
@@ -427,7 +427,7 @@ static int agilent_82357a_read(gpib_board_t *board, uint8_t *buffer, size_t leng
 {
 	int retval;
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data, *in_data;
 	int out_data_length, in_data_length;
 	int bytes_written, bytes_read;
@@ -438,6 +438,10 @@ static int agilent_82357a_read(gpib_board_t *board, uint8_t *buffer, size_t leng
 
 	*nbytes = 0;
 	*end = 0;
+
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	out_data_length = 0x9;
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
@@ -534,7 +538,7 @@ static ssize_t agilent_82357a_generic_write(gpib_board_t *board, uint8_t *buffer
 {
 	int retval;
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	u8 *out_data = NULL;
 	u8 *status_data = NULL;
 	int out_data_length;
@@ -545,6 +549,10 @@ static ssize_t agilent_82357a_generic_write(gpib_board_t *board, uint8_t *buffer
 	struct agilent_82357a_register_pairlet read_reg;
 
 	*bytes_written = 0;
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	out_data_length = length + 0x8;
 	out_data = kmalloc(out_data_length, GFP_KERNEL);
 	if (!out_data)
@@ -697,9 +705,13 @@ int agilent_82357a_take_control_internal(gpib_board_t *board, int synchronous)
 
 static int agilent_82357a_take_control(gpib_board_t *board, int synchronous)
 {
+	struct agilent_82357a_priv *a_priv = board->private_data;
 	const int timeout = 10;
 	int i;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+
 /* It looks like the 9914 does not handle tcs properly.
  *  See comment above tms9914_take_control_workaround() in
  *  drivers/gpib/tms9914/tms9914_aux.c
@@ -723,10 +735,14 @@ static int agilent_82357a_take_control(gpib_board_t *board, int synchronous)
 static int agilent_82357a_go_to_standby(gpib_board_t *board)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet write;
 	int retval;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	write.address = AUXCR;
 	write.value = AUX_GTS;
 	retval = agilent_82357a_write_registers(a_priv, &write, 1);
@@ -739,11 +755,15 @@ static int agilent_82357a_go_to_standby(gpib_board_t *board)
 static void agilent_82357a_request_system_control(gpib_board_t *board, int request_control)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet writes[2];
 	int retval;
 	int i = 0;
 
+	if (!a_priv->bus_interface)
+		return; // -ENODEV;
+
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	/* 82357B needs bit to be set in 9914 AUXCR register */
 	writes[i].address = AUXCR;
 	if (request_control) {
@@ -767,10 +787,14 @@ static void agilent_82357a_request_system_control(gpib_board_t *board, int reque
 static void agilent_82357a_interface_clear(gpib_board_t *board, int assert)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet write;
 	int retval;
 
+	if (!a_priv->bus_interface)
+		return; // -ENODEV;
+
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	write.address = AUXCR;
 	write.value = AUX_SIC;
 	if (assert) {
@@ -785,10 +809,14 @@ static void agilent_82357a_interface_clear(gpib_board_t *board, int assert)
 static void agilent_82357a_remote_enable(gpib_board_t *board, int enable)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet write;
 	int retval;
 
+	if (!a_priv->bus_interface)
+		return; //-ENODEV;
+
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	write.address = AUXCR;
 	write.value = AUX_SRE;
 	if (enable)
@@ -804,6 +832,8 @@ static int agilent_82357a_enable_eos(gpib_board_t *board, uint8_t eos_byte, int
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
 	if (compare_8_bits == 0)
 		return -EOPNOTSUPP;
 
@@ -822,10 +852,13 @@ static void agilent_82357a_disable_eos(gpib_board_t *board)
 static unsigned int agilent_82357a_update_status(gpib_board_t *board, unsigned int clear_mask)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet address_status, bus_status;
 	int retval;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	board->status &= ~clear_mask;
 	if (a_priv->is_cic)
 		set_bit(CIC_NUM, &board->status);
@@ -885,6 +918,9 @@ static int agilent_82357a_primary_address(gpib_board_t *board, unsigned int addr
 	struct agilent_82357a_register_pairlet write;
 	int retval;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	// put primary address in address0
 	write.address = ADR;
 	write.value = address & ADDRESS_MASK;
@@ -906,11 +942,14 @@ static int agilent_82357a_secondary_address(gpib_board_t *board, unsigned int ad
 static int agilent_82357a_parallel_poll(gpib_board_t *board, uint8_t *result)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet writes[2];
 	struct agilent_82357a_register_pairlet read;
 	int retval;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	// execute parallel poll
 	writes[0].address = AUXCR;
 	writes[0].value = AUX_CS | AUX_RPP;
@@ -975,11 +1014,14 @@ static void agilent_82357a_return_to_local(gpib_board_t *board)
 static int agilent_82357a_line_status(const gpib_board_t *board)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet bus_status;
 	int retval;
 	int status = ValidALL;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	bus_status.address = BSR;
 	retval = agilent_82357a_read_registers(a_priv, &bus_status, 1, 0);
 	if (retval) {
@@ -1025,10 +1067,13 @@ static unsigned short nanosec_to_fast_talker_bits(unsigned int *nanosec)
 static unsigned int agilent_82357a_t1_delay(gpib_board_t *board, unsigned int nanosec)
 {
 	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
+	struct usb_device *usb_dev;
 	struct agilent_82357a_register_pairlet write;
 	int retval;
 
+	if (!a_priv->bus_interface)
+		return -ENODEV;
+	usb_dev = interface_to_usbdev(a_priv->bus_interface);
 	write.address = FAST_TALKER_T1;
 	write.value = nanosec_to_fast_talker_bits(&nanosec);
 	retval = agilent_82357a_write_registers(a_priv, &write, 1);
-- 
2.39.5



