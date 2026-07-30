Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB52743801B;
	Thu, 30 Jul 2026 14:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421600; cv=none; b=k6JJjJJ9FIsX6IlkXFzafTkw11gC9as3TZ4/25TZqBfLOQ6xhGlgZ0iA+9c56uW3XeaYJm0ussJUpIM7tZw8ETw/WPWBWfdPQfK4SCcMKw4f/Ndu4PnQlBvvA4Hubr7QKfz1QLvorpQHuviJQgl6N3SA2IMyXzzlqC13iJmGSPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421600; c=relaxed/simple;
	bh=XNCPZu8UNwBBiPbhyOxU5hUIJMv2xo0Nwqtv6LHQ1Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC/pSKoNp2CAobpH8xljpNn2kz9LT6m8vs0I+s00hUFyPehQg3uobLd4xhQ/Q0sS5nXSn4ecHnFl67i+HYNXcLmQB2Ggo8oTaxslqMBcgH1yLMu3H69U5PdhAKXenDM+yLmJXZ+tyNNqCKgP8c/sGHYcN3tTMqy9fh9QpSksvs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/v9ZYuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/v9ZYuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BDA1F00A3A;
	Thu, 30 Jul 2026 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421598;
	bh=VKYDxrxXaceytJqxoWbJo8QhyL+Tc03TUddBDkk0Hdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/v9ZYuOEo9HaOwCY157saI289FFfGJDeizuJ4aeW/tb1jGTiaGPU8tsK0MzuhCu8
	 UbJeqimQuv2BBRDwScaqSvDArgeqb7FbvMIM23nb6NEzxAiAA5GgcZigEW3w4dpGns
	 c6ndcmvvWY+e5ZTDJEhdjUITuC2S9qkUjbXKRdeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.1 157/744] usb: typec: ucsi: Detect and skip duplicate altmodes from buggy firmware
Date: Thu, 30 Jul 2026 16:07:10 +0200
Message-ID: <20260730141447.629217830@linuxfoundation.org>
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
@@ -498,6 +498,129 @@ err:
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
@@ -622,6 +745,15 @@ static int ucsi_register_altmodes(struct
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


