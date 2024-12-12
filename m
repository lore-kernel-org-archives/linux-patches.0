Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51D753365;
	Thu, 12 Dec 2024 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020848; cv=none; b=tCmigeEaiLpBvz24d9o1Zkovi6CMePKhLebbaShvRNtZ5EBFLtg2b4tqWv5Hyd5o/ueQlM7S9qHfSWaXLqOD5O7HxdYsHk/Di0uVAVYKA+f2osd9OJFmFFb0Yp/tjHi9BXVq8aU3GOzRbF3pLl/rqfYD5xDEpZFY6Vqhqid7vvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020848; c=relaxed/simple;
	bh=Xl+0qdJB1AQubq9apt+sKxGtGbKmctKakH0344faBj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sUQkkts+Efg23vEnyhwJAAWAzXuPcp518KkG+lgzOF3PBkG79fn/GdjWVWte5VfibXDyxVx0HXn5JlA3p4HzQjj1sM5LPcWktN9omw1a/SgIaqueCv9L7rNYJEFi+lgR9Mci8LVMiVBDdS6Ni5kJMGpRfPCs17kwCKYGrAORzoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ma8PeqPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ma8PeqPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C578CC4CECE;
	Thu, 12 Dec 2024 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020846;
	bh=Xl+0qdJB1AQubq9apt+sKxGtGbKmctKakH0344faBj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ma8PeqPxEhFGEwcy8RxxkgMe/ILf2M09RW74ZZPSj9KPEzPBuR8Vi3Rv4Bv3TSQgd
	 pDCagM/sEmK54v5DJQrf/P6/bt7j7pL5aY+MkZ1nVrHDRflnlQo3OQZsrhcTwi3WSu
	 +k57cUWONUyPmeT8sEEi12t2tGbl5hLk+UiiI+ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 575/772] i3c: master: Extend address status bit to 4 and add I3C_ADDR_SLOT_EXT_DESIRED
Date: Thu, 12 Dec 2024 15:58:40 +0100
Message-ID: <20241212144413.712203436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 2f552fa280590e61bd3dbe66a7b54b99caa642a4 ]

Extend the address status bit to 4 and introduce the
I3C_ADDR_SLOT_EXT_DESIRED macro to indicate that a device prefers a
specific address. This is generally set by the 'assigned-address' in the
device tree source (dts) file.

 ┌────┬─────────────┬───┬─────────┬───┐
 │S/Sr│ 7'h7E RnW=0 │ACK│ ENTDAA  │ T ├────┐
 └────┴─────────────┴───┴─────────┴───┘    │
 ┌─────────────────────────────────────────┘
 │  ┌──┬─────────────┬───┬─────────────────┬────────────────┬───┬─────────┐
 └─►│Sr│7'h7E RnW=1  │ACK│48bit UID BCR DCR│Assign 7bit Addr│PAR│ ACK/NACK│
    └──┴─────────────┴───┴─────────────────┴────────────────┴───┴─────────┘

Some master controllers (such as HCI) need to prepare the entire above
transaction before sending it out to the I3C bus. This means that a 7-bit
dynamic address needs to be allocated before knowing the target device's
UID information.

However, some I3C targets may request specific addresses (called as
"init_dyn_addr"), which is typically specified by the DT-'s
assigned-address property. Lower addresses having higher IBI priority. If
it is available, i3c_bus_get_free_addr() preferably return a free address
that is not in the list of desired addresses (called as "init_dyn_addr").
This allows the device with the "init_dyn_addr" to switch to its
"init_dyn_addr" when it hot-joins the I3C bus. Otherwise, if the
"init_dyn_addr" is already in use by another I3C device, the target device
will not be able to switch to its desired address.

If the previous step fails, fallback returning one of the remaining
unassigned address, regardless of its state in the desired list.

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241021-i3c_dts_assign-v8-2-4098b8bde01e@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 851bd21cdb55 ("i3c: master: Fix dynamic address leak when 'assigned-address' is present")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 65 +++++++++++++++++++++++++++++++-------
 include/linux/i3c/master.h |  7 ++--
 2 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 621881b6bf81c..a24264f275135 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -341,7 +341,7 @@ struct bus_type i3c_bus_type = {
 };
 
 static enum i3c_addr_slot_status
-i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
+i3c_bus_get_addr_slot_status_mask(struct i3c_bus *bus, u16 addr, u32 mask)
 {
 	unsigned long status;
 	int bitpos = addr * I3C_ADDR_SLOT_STATUS_BITS;
@@ -352,11 +352,17 @@ i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 	status = bus->addrslots[bitpos / BITS_PER_LONG];
 	status >>= bitpos % BITS_PER_LONG;
 
-	return status & I3C_ADDR_SLOT_STATUS_MASK;
+	return status & mask;
 }
 
-static void i3c_bus_set_addr_slot_status(struct i3c_bus *bus, u16 addr,
-					 enum i3c_addr_slot_status status)
+static enum i3c_addr_slot_status
+i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
+{
+	return i3c_bus_get_addr_slot_status_mask(bus, addr, I3C_ADDR_SLOT_STATUS_MASK);
+}
+
+static void i3c_bus_set_addr_slot_status_mask(struct i3c_bus *bus, u16 addr,
+					      enum i3c_addr_slot_status status, u32 mask)
 {
 	int bitpos = addr * I3C_ADDR_SLOT_STATUS_BITS;
 	unsigned long *ptr;
@@ -365,9 +371,14 @@ static void i3c_bus_set_addr_slot_status(struct i3c_bus *bus, u16 addr,
 		return;
 
 	ptr = bus->addrslots + (bitpos / BITS_PER_LONG);
-	*ptr &= ~((unsigned long)I3C_ADDR_SLOT_STATUS_MASK <<
-						(bitpos % BITS_PER_LONG));
-	*ptr |= (unsigned long)status << (bitpos % BITS_PER_LONG);
+	*ptr &= ~((unsigned long)mask << (bitpos % BITS_PER_LONG));
+	*ptr |= ((unsigned long)status & mask) << (bitpos % BITS_PER_LONG);
+}
+
+static void i3c_bus_set_addr_slot_status(struct i3c_bus *bus, u16 addr,
+					 enum i3c_addr_slot_status status)
+{
+	i3c_bus_set_addr_slot_status_mask(bus, addr, status, I3C_ADDR_SLOT_STATUS_MASK);
 }
 
 static bool i3c_bus_dev_addr_is_avail(struct i3c_bus *bus, u8 addr)
@@ -379,13 +390,44 @@ static bool i3c_bus_dev_addr_is_avail(struct i3c_bus *bus, u8 addr)
 	return status == I3C_ADDR_SLOT_FREE;
 }
 
+/*
+ * ┌────┬─────────────┬───┬─────────┬───┐
+ * │S/Sr│ 7'h7E RnW=0 │ACK│ ENTDAA  │ T ├────┐
+ * └────┴─────────────┴───┴─────────┴───┘    │
+ * ┌─────────────────────────────────────────┘
+ * │  ┌──┬─────────────┬───┬─────────────────┬────────────────┬───┬─────────┐
+ * └─►│Sr│7'h7E RnW=1  │ACK│48bit UID BCR DCR│Assign 7bit Addr│PAR│ ACK/NACK│
+ *    └──┴─────────────┴───┴─────────────────┴────────────────┴───┴─────────┘
+ * Some master controllers (such as HCI) need to prepare the entire above transaction before
+ * sending it out to the I3C bus. This means that a 7-bit dynamic address needs to be allocated
+ * before knowing the target device's UID information.
+ *
+ * However, some I3C targets may request specific addresses (called as "init_dyn_addr"), which is
+ * typically specified by the DT-'s assigned-address property. Lower addresses having higher IBI
+ * priority. If it is available, i3c_bus_get_free_addr() preferably return a free address that is
+ * not in the list of desired addresses (called as "init_dyn_addr"). This allows the device with
+ * the "init_dyn_addr" to switch to its "init_dyn_addr" when it hot-joins the I3C bus. Otherwise,
+ * if the "init_dyn_addr" is already in use by another I3C device, the target device will not be
+ * able to switch to its desired address.
+ *
+ * If the previous step fails, fallback returning one of the remaining unassigned address,
+ * regardless of its state in the desired list.
+ */
 static int i3c_bus_get_free_addr(struct i3c_bus *bus, u8 start_addr)
 {
 	enum i3c_addr_slot_status status;
 	u8 addr;
 
 	for (addr = start_addr; addr < I3C_MAX_ADDR; addr++) {
-		status = i3c_bus_get_addr_slot_status(bus, addr);
+		status = i3c_bus_get_addr_slot_status_mask(bus, addr,
+							   I3C_ADDR_SLOT_EXT_STATUS_MASK);
+		if (status == I3C_ADDR_SLOT_FREE)
+			return addr;
+	}
+
+	for (addr = start_addr; addr < I3C_MAX_ADDR; addr++) {
+		status = i3c_bus_get_addr_slot_status_mask(bus, addr,
+							   I3C_ADDR_SLOT_STATUS_MASK);
 		if (status == I3C_ADDR_SLOT_FREE)
 			return addr;
 	}
@@ -1860,9 +1902,10 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 			goto err_rstdaa;
 		}
 
-		i3c_bus_set_addr_slot_status(&master->bus,
-					     i3cboardinfo->init_dyn_addr,
-					     I3C_ADDR_SLOT_I3C_DEV);
+		i3c_bus_set_addr_slot_status_mask(&master->bus,
+						  i3cboardinfo->init_dyn_addr,
+						  I3C_ADDR_SLOT_I3C_DEV | I3C_ADDR_SLOT_EXT_DESIRED,
+						  I3C_ADDR_SLOT_EXT_STATUS_MASK);
 
 		/*
 		 * Only try to create/attach devices that have a static
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 706a583c45efc..2f731c6c16ea8 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -289,7 +289,8 @@ enum i3c_open_drain_speed {
  * @I3C_ADDR_SLOT_I2C_DEV: address is assigned to an I2C device
  * @I3C_ADDR_SLOT_I3C_DEV: address is assigned to an I3C device
  * @I3C_ADDR_SLOT_STATUS_MASK: address slot mask
- *
+ * @I3C_ADDR_SLOT_EXT_DESIRED: the bitmask represents addresses that are preferred by some devices,
+ *			       such as the "assigned-address" property in a device tree source.
  * On an I3C bus, addresses are assigned dynamically, and we need to know which
  * addresses are free to use and which ones are already assigned.
  *
@@ -302,9 +303,11 @@ enum i3c_addr_slot_status {
 	I3C_ADDR_SLOT_I2C_DEV,
 	I3C_ADDR_SLOT_I3C_DEV,
 	I3C_ADDR_SLOT_STATUS_MASK = 3,
+	I3C_ADDR_SLOT_EXT_STATUS_MASK = 7,
+	I3C_ADDR_SLOT_EXT_DESIRED = BIT(2),
 };
 
-#define I3C_ADDR_SLOT_STATUS_BITS 2
+#define I3C_ADDR_SLOT_STATUS_BITS 4
 
 /**
  * struct i3c_bus - I3C bus object
-- 
2.43.0



