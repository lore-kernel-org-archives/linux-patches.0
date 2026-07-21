Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C1C367B92;
	Tue, 21 Jul 2026 21:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670909; cv=none; b=qMZZ0RwrcSija4tIfpcCUYgG+Ug011dFg6Kwnh01HMw4ZxAgr4nwhvwW2ekUdCCwwIpkZssDthhKSV9+gw3GVdETJpGAKC+9siHqbsFY7dgki9KmekstDMWMuS9GINxulomVDuaRvI+azkrw1LiGto4aP67wJGRAKfQkFcSBPfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670909; c=relaxed/simple;
	bh=hOBqQrgqoNtlktGtMnJrjhidzopNk+iFuhJ2JQ+cAIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIc9z4wyqWwK+FvpaIATQcdrUod3uOEWXn5voUomtqHPGuGcrBTvV/aZIGfCeRmHMI6JbjyR26RnSufIIzOW+IKDbElAwIZpM5nmX5deOe9wW1UJklWOYh8xwQ9LmeJsbmKWHC4lHXvHPjZCagIJF81A/w9ln3aLNANdgMdFpik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrTrCEQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrTrCEQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48201F000E9;
	Tue, 21 Jul 2026 21:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670908;
	bh=bBGeTJt0FtPiJVWdd0S2QprU/+T6zOHOQFRPSNxQp6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrTrCEQU3FxaK+xIsKnvSk9OTQPRV3VzHmqgGj6O0uFrdoO719aFfYithbWTVHETU
	 iG/YpCGEx/ecZCrsq8zO9YG4dABWf3mPSeesUvvj8djJICrqpVE52BjNFiwziQitfR
	 5O63k+I1lhivebnL4grSHLW00PM/q/eX21Ck5Jao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.15 047/843] usb: gadget: function: rndis: add length check for header
Date: Tue, 21 Jul 2026 17:14:42 +0200
Message-ID: <20260721152407.040360882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


