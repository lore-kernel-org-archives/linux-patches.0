Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E292443AAD;
	Tue, 21 Jul 2026 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673118; cv=none; b=p1AgsfD8DtQOFTBMRPuaZbaxSIl4ueWqc4FAbUKj0MaqaLDnvUyLx30SEXugiZwpauja0swLdeX6T/ty2qKT4qkoD8e/uu6jXALHaTGOt089fri88I9h68y2SDy691uIFy/OLbsyJHkWAZE0fyP0s3/R8fj4/qd/dg+XJhHADTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673118; c=relaxed/simple;
	bh=WObQFS4iAwvuBC3E8CjhhS8ygKnRmN+1/0YI+fHv8aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlZGYbpxCLvEuxFm7fOIXyuMEqg37FUe/ca5JabsB0fPgZQn/biP8W4QxKyhXNOLAtBXTJxQ1z1QZmHt38PpiKohhormkqXj+5Lmtz4bExSpciZM/0eepEtb4fWnjXQ5gw5qCOJlJN4cxpBNQE9P2WqQop2yL7WshLsYGmvcln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrEPC+My; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrEPC+My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EF11F000E9;
	Tue, 21 Jul 2026 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673116;
	bh=HEWXu3PJg29OSGMMB2W5Kdt560iqdFXUbmB7Ds1sy3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrEPC+Myi/lx0YNhMQjMWsPl/zweXDlMKn/w1EI6mC8TEyrTtzaui2qwNSvcBbHE3
	 gXAF/aGYwYW8kJWs/ixC0xlVyakrMfUoe6C9lO418tufSpI81R1fwoJSNpSgIZAKOk
	 iT7PA5DbttbPdcvKLx7BDRgQcfoeEGgWpABYQ+Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.10 034/699] usb: gadget: function: rndis: add length check for header
Date: Tue, 21 Jul 2026 17:16:33 +0200
Message-ID: <20260721152356.477857086@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 21b5bf155435008e0fb0736795289788e63d426f upstream.

Add a length check for the rndis header in rndis_rm_hdr, to ensure that
MessageType, MessageLength, DataOffset, and DataLength fields are
present before they are accessed.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260708-usb-gadget-rndis-v1-2-e77e026dcc6a@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/rndis.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -1080,6 +1080,12 @@ int rndis_rm_hdr(struct gether *port,
 	/* tmp points to a struct rndis_packet_msg_type */
 	__le32 *tmp = (void *)skb->data;
 
+	/* Need at least MessageType, MessageLength, DataOffset, DataLength */
+	if (skb->len < 16) {
+		dev_kfree_skb_any(skb);
+		return -EINVAL;
+	}
+
 	/* MessageType, MessageLength */
 	if (cpu_to_le32(RNDIS_MSG_PACKET)
 			!= get_unaligned(tmp++)) {


