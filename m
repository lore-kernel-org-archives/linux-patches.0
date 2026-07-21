Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EECA1474CC;
	Tue, 21 Jul 2026 18:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659352; cv=none; b=P5zIidhODF7MMcmW2Hnipb+AsfE6qNk85zYSgIIGJFuUj0Uow13dXLmjeF/mGAgLxOxqWrXt8qbk/87loHajCJWp5MIoKTFyPIEQT+9HMXX942OlRJrazBnh32AWNbuKc/biPld/B7ZGu0OfqeGIoxopkfPDmkEIOQT4dydmyTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659352; c=relaxed/simple;
	bh=aP4VONylsbh4IXA+bo6AT+Fq+PXYKWQNO/JIawswNh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itrE2VKwL/dzC9Tx6rCGdPzoLbLwgNuGt0AmRSN3nXCpRKdupb6QXT+aTKDFzR6K6XdkqbCSs9DGTBnT5XvMiUQSwrFhnYckeZ3w5WOrZXpr81ppUxF+6FcWYoBkcgmgaupmcUXKDfgbfxTwD4m47SsGYo46zB3uhRXEe7+XLoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaJNYY+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaJNYY+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD4A1F000E9;
	Tue, 21 Jul 2026 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659351;
	bh=Mh6hdZwxXa68kv+Bv2KUkCnsAAM2dCOS5K7AMCR9NMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaJNYY+b9lq9XsccM1d/d614vRajl99g01a4ioGS8SvFbZprMazZlIyUJ4H49EmCp
	 8rsYNM0bRXPBnwnHkHJdKOJxjjcduLmnRjSjWl6T4uQCk7WS99wgpIK4Tga82yHa3t
	 bdBAwnsz+6UMA8RDAbI4bYFLkQVKtT8k3PMiz4gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1445/1611] net: wwan: iosm: bound device offsets in the MUX downlink decoder
Date: Tue, 21 Jul 2026 17:26:01 +0200
Message-ID: <20260721152547.952650622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 526b8ef54668780c8f69e0211c342763d5dcbad1 upstream.

mux_dl_adb_decode() walks a chain of aggregated datagram tables using
offsets and lengths taken from the modem. first_table_index,
next_table_index, table_length, datagram_index and datagram_length are
all device supplied le values. Only first_table_index was checked, and
only for being non zero. The decoder then formed adth = block +
adth_index and read the table header and the datagram entries with no
bound against the received skb. A modem that reports an index or a
length past the downlink buffer makes the decoder read out of bounds.

The buffer is IPC_MEM_MAX_DL_MUX_LITE_BUF_SIZE and skb->len is at most
that, so skb->len is the real limit, but none of these in band offsets
were checked against it.

The table chain is also followed with no forward progress check. The loop
takes the next table from adth->next_table_index and stops only when that
reaches zero. A modem can stage two tables that point at each other, so
the loop never ends. It runs in softirq and clones the skb on every pass.

Validate every device offset and length against skb->len before use.
The block header must fit. Each table header, on entry and after every
next_table_index, must lie inside the skb. The datagram table must fit.
Each datagram index and length must stay inside the skb. The header
padding must not exceed the datagram length so the receive length does
not wrap. Require each next_table_index to move forward so the chain
cannot cycle.

This was reproduced under KASAN as a slab out of bounds read on a normal
downlink receive once the iosm net device is up.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Suggested-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/178236824878.3259367.5389624724479864947@maoyixie.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c |   40 +++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 10 deletions(-)

--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -553,19 +553,21 @@ static int mux_dl_process_dg(struct iosm
 	u32 packet_offset, i, rc, dg_len;
 
 	for (i = 0; i < nr_of_dg; i++, dg++) {
-		if (le32_to_cpu(dg->datagram_index)
-				< sizeof(struct mux_adbh))
+		u32 dg_index = le32_to_cpu(dg->datagram_index);
+
+		dg_len = le16_to_cpu(dg->datagram_length);
+
+		if (dg_index < sizeof(struct mux_adbh))
 			goto dg_error;
 
-		/* Is the packet inside of the ADB */
-		if (le32_to_cpu(dg->datagram_index) >=
-					le32_to_cpu(adbh->block_length)) {
+		/* Is the packet inside of the ADB and the received skb ? */
+		if (dg_index >= le32_to_cpu(adbh->block_length) ||
+		    dg_index >= skb->len ||
+		    dg_len > skb->len - dg_index ||
+		    dl_head_pad_len >= dg_len) {
 			goto dg_error;
 		} else {
-			packet_offset =
-				le32_to_cpu(dg->datagram_index) +
-				dl_head_pad_len;
-			dg_len = le16_to_cpu(dg->datagram_length);
+			packet_offset = dg_index + dl_head_pad_len;
 			/* Pass the packet to the netif layer. */
 			rc = ipc_mux_net_receive(ipc_mux, if_id, ipc_mux->wwan,
 						 packet_offset,
@@ -589,12 +591,16 @@ static void mux_dl_adb_decode(struct ios
 	struct mux_adbh *adbh;
 	struct mux_adth *adth;
 	int nr_of_dg, if_id;
-	u32 adth_index;
+	u32 adth_index, prev_index = 0;
 	u8 *block;
 
 	block = skb->data;
 	adbh = (struct mux_adbh *)block;
 
+	/* The block header itself must fit in the received skb. */
+	if (skb->len < sizeof(struct mux_adbh))
+		goto adb_decode_err;
+
 	/* Process the aggregated datagram tables. */
 	adth_index = le32_to_cpu(adbh->first_table_index);
 
@@ -606,6 +612,16 @@ static void mux_dl_adb_decode(struct ios
 
 	/* Loop through mixed session tables. */
 	while (adth_index) {
+		/* The table header must lie within the received skb, and the
+		 * chain must move forward so a modem cannot make the loop
+		 * cycle between two tables.
+		 */
+		if (adth_index <= prev_index ||
+		    adth_index < sizeof(struct mux_adbh) ||
+		    adth_index > skb->len - sizeof(struct mux_adth))
+			goto adb_decode_err;
+		prev_index = adth_index;
+
 		/* Get the reference to the table header. */
 		adth = (struct mux_adth *)(block + adth_index);
 
@@ -629,6 +645,10 @@ static void mux_dl_adb_decode(struct ios
 		if (le16_to_cpu(adth->table_length) < sizeof(struct mux_adth))
 			goto adb_decode_err;
 
+		/* The whole datagram table must fit in the received skb. */
+		if (le16_to_cpu(adth->table_length) > skb->len - adth_index)
+			goto adb_decode_err;
+
 		/* Calculate the number of datagrams. */
 		nr_of_dg = (le16_to_cpu(adth->table_length) -
 					sizeof(struct mux_adth)) /


