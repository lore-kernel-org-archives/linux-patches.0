Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E389400982;
	Thu, 16 Jul 2026 14:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211696; cv=none; b=M7MKypQnEh0rgHkbCuwE8wMPf9yG0einjdl1KOb73EG9RS2c77f7toANh4TjaA7nsNiGr3RiEvPLsph+u6M5fomxQtwdC398Vh/0xhCOb66/0ptFH/f6wUkC4kZpoebMcrFrrP8OlrvLqHayYO2276XA1rKgZBo1a1HTwiADL3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211696; c=relaxed/simple;
	bh=oa7UQwqv/5atAQaygE/jntUuW+8IanIiqnEZUPz9MBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6CmDdOF+yVc4NsYDm40meQKJoUzPkQNGAF0vc/qPs7wS5C6xgHrWTg8yq3vNR/0XdG+QI+86o8tqwzXg3lQ6i9lXOlBBUHvdGxXIfHJ8OPiAIg/CK4eRZjWwo/Z+RAQylyGcwyJxsVhTFvvjMx91ZCb97k1izw4UXOh7Enw5tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GswmRIYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GswmRIYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6B21F000E9;
	Thu, 16 Jul 2026 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211695;
	bh=Wlnglj/zfRAnA624mCILjzSwdtsT4qcLMP6JaJ0xIe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GswmRIYd9NdwxnOFqrjLFE3oL0zpUNUPJmyBvnVUTSADB79S417dQNTAwH8SaT2tS
	 33p+u59IbeOmlhPJxy0tKQG2AKt4G++4WPQ9s6vdaddVAAOzRDpoKqOp5t51gVlZM1
	 nCdn9H8a9o6ulLRTPMFplaWZWy1jDbHdNqtkiqJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.12 043/349] usb: gadget: function: rndis: add length check for header
Date: Thu, 16 Jul 2026 15:29:37 +0200
Message-ID: <20260716133034.288853001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


