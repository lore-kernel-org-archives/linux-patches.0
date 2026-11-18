Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028053;
	b=m32WXYmxYsZT6022KyVOGLv6kFe5ZQZkAcMjBRPUdP3qOBI5/VL4ko/okB/i9J5GpoSp
	 vEhpxKBWJ1PjlnAeaW6iD7wLYb6SdCcoa76OFDhx+daKMFJU+N05BDAbiq3CZdBzdzqma
	 vAYPgtqjRkHs0dHhw67f5lBX5SIhweXf61cGszcAYSHyQyNd5SplL+lJprQnIQq3oIJcb
	 Hn+oMsqY+TXKzTJQXOK2F2iPc6ualTJ5SzyLnulKcu0eRRx+gt8stq1LvjA9APhIz4Poh
	 9iTy6SX4rfLoMzUlgVtfr1UJd8dceJDcmimsBBYSmMJsRJshzv7lvhBhTjT7rB+jlQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/K7z9gb5TMEhbywS5XEQzwYhVe8yM6kuAZOSBz7oRw4=;
	b=qjWKn2ZyjyJmddF0u/O+X/D5Ui/iuwx6B01PqRkEUEedixktYGuZ7tFDw0NURTpuAPWb
	 i4WUr5SOW5/uiIStJdvsCv8jEOhuxRxJwb6Q74Y2cYbU2o3yl+t0eecj7eBQcyvKInogi
	 RWk4xwlazURXN/BeBzdC+TXB5xAibv71Ny6lielrOSZAxLRCo+Cd6vlua+opG2YFrFkmk
	 cWiDmE2UCTamzQOGZJabfUzTQo0FrFecrYPxjRO0f/eyY03m0Qym3ERHsjoiwCGHYLbZV
	 AKiXL/8PIm8laQBbTq2ecdIiGFDvPLzaHptxRzP1pOVuDN+7elvApW8FeRxHDNlKZRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wziwimu0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD8C606A31C;
	Wed, 18 Nov 2026 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wziwimu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FDE1F000C5;
	Wed, 18 Nov 2026 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028053;
	bh=/K7z9gb5TMEhbywS5XEQzwYhVe8yM6kuAZOSBz7oRw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wziwimu0wtK1pXIzL1lsNHzOvAtMmlejl08nP32lNuzTZ8Yoh3uISQOSE9IQVz6ov
	 uE+Z7wF6rYF+JZKc8ClrM8ul7TIfz6AJYOTInt32vCGVW0mkB/azA4uq5r2Sr6SUj3
	 MoWBi1vlTIyR835zFXEAykPL5FFMeN+mPgvUngWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2009/2151] net: microchip: fdma: fix DCB corruption under sustained load
Date: Wed, 18 Nov 2026 16:02:24 +0100
Message-ID: <20261118150234.907458539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 573a6d4c7a21e34d7a2174b8d3c7ca67a5e850b6 ]

__fdma_dcb_add() prepares a DCB and links it into a channel's chain by
writing its address to the NEXT_PTR of the current last DCB. The FDMA
may be processing the chain while this happens.

Before this patch, the link is written before the new DCB's own nextptr
and info fields, so the FDMA can follow it to a DCB that hasn't been fully
prepared yet. Under sustained load this stalls the FDMA.

Prepare the new DCB fully before linking it, and update the previous
DCB's NEXT_PTR using the two-step sequence from the datasheet (poison
the LSB and flush, then clear it) so the FDMA never observes a
partially-updated pointer.

Reported by a customer running iperf3 --bidir against a lan969x board.

Reproduced on lan969x with iperf3, throughput collapsing to zero:

  [  5]   1.00-2.00   sec  73.9 MBytes   620 Mbits/sec    0    305 KBytes
  [  5]   2.00-3.00   sec  73.9 MBytes   620 Mbits/sec    0    305 KBytes
  [  5]   3.00-4.00   sec  13.9 MBytes   116 Mbits/sec    2   1.41 KBytes
  [  5]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
  [  5]   5.00-6.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
  [  5]   6.00-7.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes

The race is timing-dependent: across three reproductions the stall
appeared anywhere from ~400s to ~3000s into the run.

Fixes: 30e48a75df9c ("net: microchip: add FDMA library")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261026-microchip-fdma-dcb-corruption-v1-1-36dab6caca07@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/fdma/fdma_api.c    | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/fdma/fdma_api.c b/drivers/net/ethernet/microchip/fdma/fdma_api.c
index 6dfe36f58d67a..a85dcb492829d 100644
--- a/drivers/net/ethernet/microchip/fdma/fdma_api.c
+++ b/drivers/net/ethernet/microchip/fdma/fdma_api.c
@@ -43,9 +43,19 @@ int __fdma_dcb_add(struct fdma *fdma, int dcb_idx, u64 info, u64 status,
 				u64 *dataptr))
 {
 	struct fdma_dcb *dcb = fdma_dcb_get(fdma, dcb_idx);
+	struct fdma_dcb *prev = fdma->last_dcb;
 	u64 nextptr;
 	int i, err;
 
+	/* Per the FDMA datasheet, adding a DCB to an active channel takes
+	 * three steps:
+	 * 1) Write NEXT_PTR of the current last DCB with the LSB forced to
+	 *    FDMA_DCB_INVALID_DATA, and flush that write.
+	 * 2) Clear the LSB to complete the link.
+	 * 3) Reload the channel (FDMA_CH_RELOAD); this is done by the caller
+	 *    once the chain has been extended.
+	 */
+
 	for (i = 0; i < fdma->n_dbs; i++) {
 		err = __fdma_db_add(fdma, dcb_idx, i, status, db_cb);
 		if (unlikely(err))
@@ -56,13 +66,25 @@ int __fdma_dcb_add(struct fdma *fdma, int dcb_idx, u64 info, u64 status,
 	if (unlikely(err))
 		return err;
 
-	fdma->last_dcb->nextptr = cpu_to_le64(nextptr);
-
-	fdma->last_dcb = dcb;
-
 	dcb->nextptr = cpu_to_le64(FDMA_DCB_INVALID_DATA);
 	dcb->info = cpu_to_le64(info);
 
+	/* On the first DCB of fdma_dcbs_init() prev is the DCB itself;
+	 * don't link it to itself.
+	 */
+	if (prev != dcb) {
+		/* Write NEXT_PTR of the current last DCB with the LSB forced
+		 * to FDMA_DCB_INVALID_DATA, and flush that write.
+		 */
+		prev->nextptr = cpu_to_le64(nextptr | FDMA_DCB_INVALID_DATA);
+		dma_wmb();
+
+		/* Clear the LSB to complete the link. */
+		prev->nextptr = cpu_to_le64(nextptr);
+	}
+
+	fdma->last_dcb = dcb;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__fdma_dcb_add);
-- 
2.53.0



