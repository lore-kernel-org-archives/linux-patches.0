Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3024054B1C6;
	Wed,  9 Sep 2026 13:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961839; cv=none; b=pHaAXWjLIWN7gBr7OUKkPmeu9TleuBNMYNsqDJy4ypToi0TjCxfB3l9YT77ubY6nZnnzWP/EDxFpPQtLZgdz7W2gNkNnglY12YxHBRBgWy8siq2B95Z+DMMz19s6QuimxnjJgcLbUs2JeeRBv8k87JepeAJIW81+CURUaSR1UXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961839; c=relaxed/simple;
	bh=5ZYvrGSdj5wU5yR8jCZFMWVqmAkbLfK/45Ugw/2r1XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3sL7VSonf/psPU4NaZv/RLc9LkBmrom59WejzNOpesaRcCBctWE8Fh0KmS9aXALzcyr/PkXhg45s6BRdneyMkpapPrPqLLL0CqveGJPuzXDbeb3o3f0FAK/G90RXHSfjg+l/wURsQiwI6k/OKXuVXydldkJh0Oe89UmLiMd7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNioM3tj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNioM3tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0651F00A3A;
	Wed,  9 Sep 2026 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961838;
	bh=j+k2XSfCW8VN4tgjCYM+WIbHzxF0kmggMPyY/Ra1Vuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNioM3tjC00N5I3dCEKMxRpaAht+hJt3tJU5kfgeTANYgxSSPMXo+uW1avZivVaHm
	 wc2fQSWBd0fg8XudUYPR+JHiqWnGgVDZbD51V56krFrMXzM4kf6UQR7KJwmsA3HNiM
	 9DZOkLrYW5laUM5wMZ4mHpMfykwEtHXj/l0ZqtJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sven Peter <sven@kernel.org>,
	Rafay <ahmedrafay888@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 042/556] usb: typec: tipd: Fix Thunderbolt altmode VDOs for cd321x
Date: Wed,  9 Sep 2026 15:35:22 +0200
Message-ID: <20260909134231.971571162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

commit e24e3370356bddb65d667985a332b5f8aeeb5f97 upstream.

The Intel VID status register is actually 9 bytes long and doesn't
contain the raw VDOs but only the upper 16bits for device mode and enter
mode. Shift those two fields into place and reconstruct the cable
discover mode VDO from the data status register instead since it's not
directly accessible. With this fixed now the correct VDOs are forwarded
to the PHY and the to-be-submitted Thunderbolt/USB4 native host interface
so that the right mode can be negotiated and the link actually comes up.

Link: https://www.ti.com/lit/ug/slvubh2b/slvubh2b.pdf
Fixes: 0b31c978935f ("usb: typec: tipd: Read USB4, Thunderbolt and DisplayPort status for cd321x")
Fixes: 82432bbfb9e8 ("usb: typec: tipd: Handle mode transitions for CD321x")
Cc: stable <stable@kernel.org>
Signed-off-by: Sven Peter <sven@kernel.org>
Tested-by: Rafay <ahmedrafay888@gmail.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260813-b4-tipd-vdo-fix-v1-1-70317f2cd554@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c     |   17 +++++++++++++----
 drivers/usb/typec/tipd/tps6598x.h |    4 ++--
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -114,7 +114,6 @@ struct tps6598x_intel_vid_status_reg {
 	__le32 attention_vdo;
 	__le16 enter_vdo;
 	__le16 device_mode;
-	__le16 cable_mode;
 } __packed;
 
 /* Standard Task return codes */
@@ -700,9 +699,19 @@ static void cd321x_typec_update_mode(str
 		   cd321x->state.mode == TYPEC_TBT_MODE)
 			return;
 
-		tbt_data.cable_mode = le16_to_cpu(st->intel_vid_status.cable_mode);
-		tbt_data.device_mode = le16_to_cpu(st->intel_vid_status.device_mode);
-		tbt_data.enter_vdo = le16_to_cpu(st->intel_vid_status.enter_vdo);
+		tbt_data.cable_mode = TBT_MODE |
+			TBT_SET_CABLE_SPEED(TPS_DATA_STATUS_TBT_CABLE_SPEED(st->data_status)) |
+			TBT_SET_CABLE_ROUNDED(TPS_DATA_STATUS_TBT_CABLE_GEN(st->data_status));
+		if (st->data_status & TPS_DATA_STATUS_OPTICAL_CABLE)
+			tbt_data.cable_mode |= TBT_CABLE_OPTICAL;
+		if (st->data_status & TPS_DATA_STATUS_ACTIVE_LINK_TRAIN)
+			tbt_data.cable_mode |= TBT_CABLE_LINK_TRAINING;
+		if (st->data_status & TPS_DATA_STATUS_ACTIVE_CABLE)
+			tbt_data.cable_mode |= TBT_CABLE_ACTIVE_PASSIVE;
+		tbt_data.device_mode = TBT_MODE |
+			(u32)le16_to_cpu(st->intel_vid_status.device_mode) << 16;
+		tbt_data.enter_vdo =
+			(u32)le16_to_cpu(st->intel_vid_status.enter_vdo) << 16;
 		cd321x->state.alt = cd321x->port_altmode_tbt;
 		cd321x->state.mode = TYPEC_TBT_MODE;
 		cd321x->state.data = &tbt_data;
--- a/drivers/usb/typec/tipd/tps6598x.h
+++ b/drivers/usb/typec/tipd/tps6598x.h
@@ -206,10 +206,10 @@
 #define TPS_DATA_STATUS_DP_PIN_ASSIGNMENT(x) \
 	TPS_FIELD_GET(TPS_DATA_STATUS_DP_PIN_ASSIGNMENT_MASK, (x))
 #define TPS_DATA_STATUS_TBT_CABLE_SPEED_MASK   GENMASK(27, 25)
-#define TPS_DATA_STATUS_TBT_CABLE_SPEED \
+#define TPS_DATA_STATUS_TBT_CABLE_SPEED(x) \
 	TPS_FIELD_GET(TPS_DATA_STATUS_TBT_CABLE_SPEED_MASK, (x))
 #define TPS_DATA_STATUS_TBT_CABLE_GEN_MASK     GENMASK(29, 28)
-#define TPS_DATA_STATUS_TBT_CABLE_GEN \
+#define TPS_DATA_STATUS_TBT_CABLE_GEN(x) \
 	TPS_FIELD_GET(TPS_DATA_STATUS_TBT_CABLE_GEN_MASK, (x))
 
 /* Map data status to DP spec assignments */


