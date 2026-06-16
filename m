Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BF02F28EA;
	Tue, 16 Jun 2026 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622241; cv=none; b=aYN2VvAkTQyTiwSGj/RfZv/8F6CnTebne19R2oS9H4CLIFZuF4iqRlEsyGlaZExbEto0zNs+WtIK0lGG3EplmIZkSA9MVEGQ/DAlH0t9QwE5y4Im0aTbCrsCz8qnGlNeCZitl+c/bLernt5E01daA4UgmhzNcckc5QmM5Ue6IHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622241; c=relaxed/simple;
	bh=e1bPeqHw8z48/0DJz93C5gXweVeHdJn4HdUUT1mc+sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bzb5nzpmoS6/CGC1A0izHSbBZTr/THLKPJiJnqkC6VLiaNn8AqFBZ0n1wWBZT1XpspStQ96yGkfUoAAJ1zhAvz5f1lQsi7SjuXlk8DWHjrZXrO/iK8eU5NvPKtZ41BQ54etkxpplc8re//wH2Jo3CFjw4G9bp2rFtfV/jDPlsfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05ecHBuU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05ecHBuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79171F000E9;
	Tue, 16 Jun 2026 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622239;
	bh=f93yBY8WI5r/XheTsl0F2sR6q/e9ADWJcV6gNUr3Izw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05ecHBuU4EHLLWnZo3iqukxXSTqETS2o2Cu/fQvGPbUo1R9ChBw3f2JSkgMajerWu
	 GW70f3wofEX8nI+GHHfBr1sQmLgxPmgAAIna1niQ4idgYIx7CRTK6XhmzI59kxTZQB
	 iWnzWHruUYkfn3rUATthgubYOl8nOJnVEddBjpok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 001/411] Input: usbtouchscreen - clamp NEXIO data_len/x_len to URB buffer size
Date: Tue, 16 Jun 2026 20:23:59 +0530
Message-ID: <20260616145100.450973086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 2905281cbda52ec9df540113b35b835feb5fafd3 upstream.

nexio_read_data() pulls data_len and x_len from a packed __be16 header
in the device's interrupt packet and then walks packet->data[0..x_len)
and packet->data[x_len..data_len) comparing each byte against a
threshold.

Both fields are 16-bit on the wire (max 65535).  The existing
adjustments shave at most 0x100 / 0x80 off, so the loop bound can still
reach roughly 0xfeff.  The URB transfer buffer for NEXIO is rept_size
(1024) bytes from usb_alloc_coherent(), with the first 7 occupied by the
packed header — so packet->data[] has 1017 valid bytes.  read_data()
callbacks are not given urb->actual_length, and nothing else bounds the
walk.

A device that lies about its length can get a ~64 KiB out-of-bounds read
past the coherent DMA allocation.  The first index whose byte exceeds
NEXIO_THRESHOLD lands in begin_x / begin_y and from there into the
reported touch coordinates, so adjacent kernel memory contents leak to
userspace as ABS_X / ABS_Y events.  Far enough out, the read can also
hit an unmapped page and fault.

Fix this all by clamping data_len to the buffer's data[] capacity and
x_len to data_len.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Fixes: 5197424cdccc ("Input: usbtouchscreen - add NEXIO (or iNexio) support")
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026042026-chlorine-epidermis-fd6d@gregkh
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/usbtouchscreen.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -1061,6 +1061,11 @@ static int nexio_read_data(struct usbtou
 	if (x_len > 0xff)
 		x_len -= 0x80;
 
+	if (data_len > usbtouch->data_size - sizeof(*packet))
+		data_len = usbtouch->data_size - sizeof(*packet);
+	if (x_len > data_len)
+		x_len = data_len;
+
 	/* send ACK */
 	ret = usb_submit_urb(priv->ack, GFP_ATOMIC);
 	if (ret)


