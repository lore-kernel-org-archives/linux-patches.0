Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F23750CF;
	Thu, 30 Jul 2026 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423768; cv=none; b=bdIRcBneCAn5Z5juif0okBhJMeYPIwiNHhnosMmRvl5J4vJo2hOkGkAPYG+2e+C85PHzwGh0aG7MxrQHn96797rt4361Qgd1sTh0B1j3Y/eLPKVeBgwjDf6kIoiV7GZNQn0l79jgqlDR0ftxtwg/Ruwab2SPrwZMbdwGW+cC4x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423768; c=relaxed/simple;
	bh=+c/25Kv3wUAk023vqUnnzGZkHC/3a7klxWygUbyy7KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaNRjWRcev5roVV9Yf71i7/yoPXuAULqG6ijGyo1N98bWgbviVvcgMOuaB44qtXEJGt705YvdinG/CdC4vFVhP0zTAbBpxIzh0DtIP23Sx95swRs6/xOCvA4SUmDXX7sUKnYtvKswSRACAAzs9Dpik4PH1rxHVzXCf4wkEad98c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiCoKtGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiCoKtGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90A21F000E9;
	Thu, 30 Jul 2026 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423767;
	bh=IMCFWybvKvlHP5iRjCNdiL7HcQfcRz7FdNoVuZc+YOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiCoKtGOAGXDp824af2PHAnLf2L1YRBvjGTz35Uw77HnPP8gdXorbwTbq83J/LQEf
	 jhSYT6VqcNgJSeJzQNqIWnHtrxHefOK38m1d5vIvADDgbedKpezRDbB5UgFW6EKAKz
	 GLJJnQqujc/CJcqV3rb8dqHbSgzCL0OzUkm26CMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 158/675] usb: typec: ucsi: Detect and skip duplicate altmodes from buggy firmware
Date: Thu, 30 Jul 2026 16:08:08 +0200
Message-ID: <20260730141448.493539080@linuxfoundation.org>
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

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

commit 67c92c6419ea6dbc5b1f3e9691aecea956e3e81c upstream.

Some firmware implementations incorrectly return the same altmode
multiple times at different offsets when queried via
UCSI_GET_ALTERNATE_MODES.  This causes sysfs duplicate filename errors
and kernel call traces when the driver attempts to register the same
altmode twice:

  sysfs: cannot create duplicate filename '/devices/.../typec/port0/port0.0/partner'
  typec-thunderbolt port0-partner.1: failed to create symlinks
  typec-thunderbolt port0-partner.1: probe with driver typec-thunderbolt failed with error -17

The matching rules differ by recipient:

  - UCSI_RECIPIENT_CON (port) and UCSI_RECIPIENT_SOP_P (plug):
    Two altmodes with identical SVID and VDO are byte-for-byte
    duplicates and the second has no observable function, so drop it.

  - UCSI_RECIPIENT_SOP (partner):
    The typec class binds each partner altmode to a port altmode of
    the same SVID via altmode_match()/device_find_child(), which
    returns the first port altmode with a matching SVID.  If the
    partner advertises more altmodes for SVID X than the port
    advertises, the surplus partner altmode(s) collapse onto an
    already-paired port altmode and trigger the
    "duplicate filename .../partner" sysfs error during
    typec_altmode_create_links().  Use the port-side altmode count for
    SVID X as the authoritative cap and reject any partner altmode
    that would exceed it.  This preserves legitimate multi-Mode
    partner altmodes (vendor SVIDs that the port really does
    advertise more than once) while filtering the firmware-generated
    duplicates that have no port counterpart, and is therefore
    stricter than a plain SVID+VDO comparison (which still admits the
    Thunderbolt case where firmware reports the same SVID twice with
    different VDOs) without being over-broad like a plain SVID match
    (which would falsely drop legitimate vendor multi-Mode entries).

If a duplicate is detected, skip it and emit a clean warning instead
of generating a kernel call trace:

  ucsi_acpi USBC000:00: con2: Firmware bug: duplicate partner altmode SVID 0x8087 at offset 1, ignoring.
  ucsi_acpi USBC000:00: con2: VDO mismatch: 0x8087a043 vs 0x00000001

The duplicate detection logic lives in a reusable helper
ucsi_altmode_is_duplicate() and is invoked from
ucsi_register_altmodes().  It applies to all three recipient types:
partner (SOP), port (CON), and plug (SOP_P) altmodes.

Fixes: a79f16efcd00 ("usb: typec: ucsi: Add support for the partner USB Modes")
Cc: stable <stable@kernel.org>
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
unchanged: still SVID+VDO exact-dup match.
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260713084323.287516-1-acelan.kao@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |  132 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -487,6 +487,129 @@ err:
 	return ret;
 }
 
+static void ucsi_dump_duplicate_altmode(struct ucsi_connector *con,
+					u8 recipient, u16 svid,
+					u32 existing_vdo, u32 new_vdo,
+					int offset)
+{
+	static const char * const recipient_names[] = {
+		[UCSI_RECIPIENT_CON]    = "port",
+		[UCSI_RECIPIENT_SOP]    = "partner",
+		[UCSI_RECIPIENT_SOP_P]  = "plug",
+		[UCSI_RECIPIENT_SOP_PP] = "cable plug prime",
+	};
+
+	dev_warn(con->ucsi->dev,
+		 "con%d: Firmware bug: duplicate %s altmode SVID 0x%04x at offset %d, ignoring but please contact the BIOS vendor to fix this issue.\n",
+		 con->num, recipient_names[recipient], svid, offset);
+
+	if (existing_vdo != new_vdo)
+		dev_warn(con->ucsi->dev,
+			 "con%d: VDO mismatch: 0x%08x vs 0x%08x\n",
+			 con->num, existing_vdo, new_vdo);
+}
+
+/* Count altmodes in @altmodes that advertise @svid. */
+static int ucsi_altmode_count_svid(struct typec_altmode **altmodes, u16 svid)
+{
+	int count = 0;
+	int k;
+
+	for (k = 0; k < UCSI_MAX_ALTMODES; k++) {
+		if (!altmodes[k])
+			break;
+		if (altmodes[k]->svid == svid)
+			count++;
+	}
+
+	return count;
+}
+
+/*
+ * Check if an altmode is a duplicate. Some firmware implementations
+ * incorrectly return the same altmode multiple times, causing sysfs errors.
+ * Returns true if the altmode should be skipped.
+ *
+ * The matching rules differ by recipient:
+ *
+ *   - UCSI_RECIPIENT_CON (port) and UCSI_RECIPIENT_SOP_P (plug):
+ *     Two altmodes with identical SVID and VDO are byte-for-byte duplicates
+ *     and the second has no observable function. Drop them.
+ *
+ *   - UCSI_RECIPIENT_SOP (partner):
+ *     The typec class binds each partner altmode to a port altmode of the
+ *     same SVID via altmode_match()/device_find_child(), which returns the
+ *     first port altmode with a matching SVID. If the partner advertises
+ *     more altmodes for SVID X than the port advertises, the surplus
+ *     partner altmode(s) collapse onto an already-paired port altmode and
+ *     trigger a "duplicate filename .../partner" sysfs error during
+ *     typec_altmode_create_links(). Use the port-side altmode count for
+ *     SVID X as the authoritative cap and reject any partner altmode that
+ *     would exceed it. This preserves legitimate multi-Mode partner
+ *     altmodes (e.g. vendor SVIDs that the port really does advertise
+ *     twice) while filtering the firmware-generated duplicates that have
+ *     no port counterpart.
+ */
+static bool ucsi_altmode_is_duplicate(struct ucsi_connector *con, u8 recipient,
+				      const struct ucsi_altmode *alt_batch, int batch_idx,
+				      u16 svid, u32 vdo, int offset)
+{
+	struct typec_altmode **altmodes;
+	int port_count, partner_count;
+	int k;
+
+	/* Check for duplicates within the current batch first */
+	for (k = 0; k < batch_idx; k++) {
+		if (alt_batch[k].svid == svid && alt_batch[k].mid == vdo) {
+			ucsi_dump_duplicate_altmode(con, recipient, svid,
+						    vdo, vdo, offset);
+			return true;
+		}
+	}
+
+	switch (recipient) {
+	case UCSI_RECIPIENT_SOP:
+		/*
+		 * Cap partner altmodes per SVID by the port-side count:
+		 * any further partner altmode for that SVID would alias an
+		 * already-paired port altmode and break typec sysfs.
+		 */
+		port_count = ucsi_altmode_count_svid(con->port_altmode, svid);
+		partner_count = ucsi_altmode_count_svid(con->partner_altmode,
+							svid);
+		if (port_count && partner_count >= port_count) {
+			ucsi_dump_duplicate_altmode(con, recipient, svid,
+						    con->partner_altmode[partner_count - 1]->vdo,
+						    vdo, offset);
+			return true;
+		}
+		return false;
+	case UCSI_RECIPIENT_CON:
+		altmodes = con->port_altmode;
+		break;
+	case UCSI_RECIPIENT_SOP_P:
+		altmodes = con->plug_altmode;
+		break;
+	default:
+		return false;
+	}
+
+	/* CON and SOP_P: drop only exact SVID+VDO duplicates. */
+	for (k = 0; k < UCSI_MAX_ALTMODES; k++) {
+		if (!altmodes[k])
+			break;
+
+		if (altmodes[k]->svid != svid || altmodes[k]->vdo != vdo)
+			continue;
+
+		ucsi_dump_duplicate_altmode(con, recipient, svid,
+					    altmodes[k]->vdo, vdo, offset);
+		return true;
+	}
+
+	return false;
+}
+
 static int
 ucsi_register_altmodes_nvidia(struct ucsi_connector *con, u8 recipient)
 {
@@ -611,6 +734,15 @@ static int ucsi_register_altmodes(struct
 			if (!alt[j].svid)
 				return 0;
 
+			/*
+			 * Check for duplicates in current batch and already
+			 * registered altmodes. Skip if duplicate found.
+			 */
+			if (ucsi_altmode_is_duplicate(con, recipient, alt, j,
+						      alt[j].svid, alt[j].mid,
+						      i - num + j))
+				continue;
+
 			memset(&desc, 0, sizeof(desc));
 			desc.vdo = alt[j].mid;
 			desc.svid = alt[j].svid;


