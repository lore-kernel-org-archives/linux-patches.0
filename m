Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B3536A033;
	Tue, 16 Jun 2026 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622236; cv=none; b=T2eUWlvqEuNWLf18L9c6YbgCTpsDm8O4qxV6WS7dt10d5UjEkZVvhGCTFT7qEVga+ucajddTUOJJhtCvsbai4KqG4lHnYjvsHttpvFMpmffLktXlWH9sG1zilcBggirVMwxpVdVicgfORIP2xuVxks6CA8zcEgSyZizBuYBzQi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622236; c=relaxed/simple;
	bh=/68b4gFERWeIFxDIN4gkDMAQEB9RciOsuHPIIHVt9Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbUTFLxjiAcNRP0ZR7+pR7E28q+ts5wEQimU9N6Y1Tsu/bw72C91QEvKN1Nxlm3C+ZkZn4tDyOSuFCBKiBLPPbfY0iarRKmTLJ81E8a9Q3NoZbeiWq7TkgFHfmNPt2WKPx59OHPhdjN8HZoDJTuPnZWnDWH6L66y7xjwpnKAcGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8WSc/Sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8WSc/Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C2F1F000E9;
	Tue, 16 Jun 2026 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622235;
	bh=gqd2DmRpsjmOJfjLgeIF1Ax8HQ2/58Agildhfugx45A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8WSc/SzikkKYaO2hnQePWQPFN+PRV1Mf7ILyOQQTZiBqLadCQvjMRexKeuSQ4YEV
	 a48lMHoCxU55V0KXCuD5hBzE9LNZeVrX7XkE22+auKyTVr/YEG14owWvCo74wf1Ikm
	 NkDTafJyGJW2oXHXWaZbU8nDxE2I24/SyB8jXq7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 001/342] Input: usbtouchscreen - clamp NEXIO data_len/x_len to URB buffer size
Date: Tue, 16 Jun 2026 20:24:57 +0530
Message-ID: <20260616145048.419899724@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1060,6 +1060,11 @@ static int nexio_read_data(struct usbtou
 	if (x_len > 0xff)
 		x_len -= 0x80;
 
+	if (data_len > usbtouch->data_size - sizeof(*packet))
+		data_len = usbtouch->data_size - sizeof(*packet);
+	if (x_len > data_len)
+		x_len = data_len;
+
 	/* send ACK */
 	ret = usb_submit_urb(priv->ack, GFP_ATOMIC);
 


