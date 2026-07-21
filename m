Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF2471268;
	Tue, 21 Jul 2026 20:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664855; cv=none; b=ck2eD0BZno3TalaT6IYmiAUJ36tYyhMSk3QeCxsjYNCqQothByIqA6eKo8c/phFDNz8XqihlkwUN5dI1C3d8kmr7wH+LiSAxRzefVMBbA7WU3nn0nKxmPqTcW0tLO5mwm2cvI66oQ81zBsfE6DjY3/dEzVAGd1OESSGyM27w/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664855; c=relaxed/simple;
	bh=WfIVDCt3XOQ4NRo1rrFa1r8w3clU1Qk1beJJJGHgQn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3yRF6XYdmjsH8LqQ2Ue9wxcpLUH6sNzREcdQOZIEQnD4vex9sKIHxwG50AAuV2s4MahP9s+ZcMgYePrilqq4L1a6EWjrrAKGLavHzt79gNqeF52MJmBGc929GwDVo13rTHVRUKMu0985zrhGhkDc9OVcKHBPfMwI/TTsRpDr2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOCk63vt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOCk63vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A82B1F000E9;
	Tue, 21 Jul 2026 20:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664854;
	bh=wNkHwbQ7V9+bW/avZRqBYdEH8/xFWhBwIb6KiA2T4Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOCk63vt5xMEMb1cUAknQ4hpZ7JRbwnTaGJfKZrMCAliYF6p7xwWyKnMBCqoA4vie
	 geMnivm5HAuWLRdfxd/uWaAkvSUCLcV6RS27pNsEXNXxagv2ec9is6H67joHv/Rs7r
	 YBWh7rFnRRBKNPujhCg6uyZeVB3bcXu9V20aYdQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.6 0082/1266] usb: gadget: function: rndis: add length check for header
Date: Tue, 21 Jul 2026 17:08:39 +0200
Message-ID: <20260721152443.634285245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


