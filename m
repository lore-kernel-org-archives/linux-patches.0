Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D50235C684;
	Tue, 21 Jul 2026 21:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668159; cv=none; b=Jy0UGPCB+ImL8SMryddNtbaHsbKdX21Aq5PJY6HNoRacYjwVabuZ0DHKd8TvtZL/nY9AG1DzKaNSHgOvnAsOQMf8cXeppHqz0+R7VXaCwXtewQrujlZS4HvvsksPLq2GBIWwc5hIa7RJZE0D8jE1Znhv4zkUmW0+MKq4/l2uqbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668159; c=relaxed/simple;
	bh=WJG5oGkT6NQTbIFnteepixZ56R8+8KEMip5wTtW5h30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNK/77RyWak1V9S8JJ+E+1EMudliLqs28MOc9NZVQIX9V2unQdh9VkKEiv3+XPqNflBuWegBHWqDk1qNPigmBPI9YUTOVSw3PHDuA6Fi4os20er9YH6Sjx1z9+Pf4cjoweZQX0ALZu23SY6MzldUD1lrLeWS8UaY98d4NyymOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Um8iZoBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Um8iZoBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1A81F000E9;
	Tue, 21 Jul 2026 21:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668158;
	bh=DjNLR9w0++syCxxffPfrqD6+nsolgvQ8i5kKL1VxI7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Um8iZoBPC5GtKoVgqbKkhQAAeHdZMldPzXQS2WPuZ2h7brBW/rWZFYfRIYva5qTFT
	 lM7Sbnk53MwLJ6PnxhEG8Ynj+pha1TeHzWR1jQoTpQt1nLazCJNnO+GaEBqcq3eMeA
	 iKC0nO6NbWq+uMYpvdW4pAu8YIkBL7sqIHkjhq3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.1 0053/1067] usb: gadget: function: rndis: add length check for header
Date: Tue, 21 Jul 2026 17:10:54 +0200
Message-ID: <20260721152425.751422217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


