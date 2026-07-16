Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0DA2DF137;
	Thu, 16 Jul 2026 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209151; cv=none; b=BTokkHUDSTlalhZKTnAIfaXgTtQXNbG5GP79FfSyiOXOYSUId+5KWTojrQok1w5GjVBPxkRtZsdG/GI2s44kD8ozXGRl4Tm32PgnjS6pCi7G9+jpMSlIQ5Ktol3eN2I7cvWIuLrKyolcOgxAN0gQzHUDp4C4ZnQkKnKTmxn5XH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209151; c=relaxed/simple;
	bh=5hWHgX3vgMdHLEeeXgRDSl4f6N0OiOUpiIy3pKTA+QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfLcPJYXa9sMRnm2HxkP7tlsPCIcJ938SbbZWV+buvNL1DY9xf2E0sTwoAyNfd/8mAOR5IP84zP3RcmPEkL+qsK7J5G3clSWRjyx+HHHiApRA/tLdLk0J4sIi/t+otzuEl6Yj6tc2IF4f3/T85loLUW+icnmlr9AwwCZl/PdqgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rts783gH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rts783gH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C041F000E9;
	Thu, 16 Jul 2026 13:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209150;
	bh=F5zmrjWBJx/rzSd7v/mnQhtlWNMRNotPSWnh3h8ozEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rts783gHhTF2Rb2RQ1ijcD16dRmX/g3tem9a434kqaKO/qN5CtTRAvoM4jeVSTP11
	 RnTh8XTqs0LpbubcuNgMXFjZrgfE5uFGvI9IWr6HB7fmD2Wph6/xaJlgQmW+SK8wjz
	 FypIUnp9czL3rMKtgwORx+CmM2gnJd9AVRDNH7s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.1 032/518] usb: gadget: function: rndis: add length check for header
Date: Thu, 16 Jul 2026 15:25:00 +0200
Message-ID: <20260716133048.480918056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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


