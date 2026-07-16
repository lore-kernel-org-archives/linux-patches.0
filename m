Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35332F2619;
	Thu, 16 Jul 2026 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210535; cv=none; b=MqR1sjes/5QHqZlr462Bps4Yi2HiCncxII+7hiYxYFFbAS28mW/LrMX9owDdqlQ6YbQzaF/I/iL655cANedWLGG2htX/3EMLkC1zLFYugHFQ+VyWDVfbH83Hu5jHQGAVAL3qQuXwDJvygtcPZmo/3DPteeuK1dteS2ns6GWGNG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210535; c=relaxed/simple;
	bh=rIRVSgEUNf8nfDNf8fiKEdnXv0v3WQE09vPPSrmPUbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ceun1drKgVX/0VxVUnizIB+PcPw9CaNKFk8EOLNzcTCrxG4EVRuCRr78BfJ1I/5hKcBxxrI42j5unWGrR5bW6x5M1HsSnVYzALhhG4whdtYmAyGFbJ4lBZxW41wkP2W9QMNfmKeVoWV++xi3S5n+AW5J7OWEzsgzx4IosxYnJIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVaq6p8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVaq6p8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D761F000E9;
	Thu, 16 Jul 2026 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210534;
	bh=2DyAZ4lJVL8VXl9H9D6GwA9UWG/oFjCyRsXUgOPRsoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVaq6p8iw1pQlG7SaS2B5fc3qs3y5AZa7JExNeGSXN487ezH/NvLO3RyCGIJlE3Lr
	 UiHD/xT7YapbF8OdYuXAA43qsXK+f07rgSx7LoKlFl0CJo/oMRo+vogQGOigOdg8K9
	 9FIeDnXUvS4dDgQi7eSKK3Bva4OYUpg7FNua3uzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.18 047/480] usb: gadget: function: rndis: add length check for header
Date: Thu, 16 Jul 2026 15:26:34 +0200
Message-ID: <20260716133045.726153079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


