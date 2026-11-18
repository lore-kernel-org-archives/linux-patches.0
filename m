Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048517;
	b=AsnnvHp8Ki7j3ItmVScRhXgR7rhmzYTVXItYgMEHcPpBGpLSXzwZz2Eqz93RR42X2IBc
	 jJaFRC0k/V6pmakZ5TFwiXK4TmaKe8pNl0Dy2WlXxt0odFfRJNd4h17ZFjDNIC8wZG97P
	 cHG1iV7oDUHesuAhyYxoqssrD3pdCeZdUxWtd4HAZ7G0N7PhyjaCbNETZTRFQaC9n+r4f
	 OhvFZ6hlHM1YHDhgtdA0D7FakfswMqZCJW6IEsd3JAjnMZfxtBO1tugqF3fvqBOQ6RKoa
	 VRnr5+pEQloKXulDA0fZzU6Ht5ed7gbmbi4ipYeQfpXk9kDzdzoI64OHOIeh7NZHbhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZPdZeLxX8S5sqWWOcuRtFhy3zH0VXfZ5RQ00cafotTg=;
	b=hq04mSdr8e+habgNuqP3Fi3U7CQBWxTXwTouIc2vE+1MgOFSlO/j/bVhT0tLlI1dn1T1
	 tdf8w3YBJnchaCC1R+0btrYRwCn+l8BeueQRpCzvrmaqsywfpBAa9JecftCMrSw86nyy/
	 sOvnrLLVjJ8rGFeVwJLhcx4pPiy2Z8aogUqh+Q5HX9RnKbv9JBNVzL0IQG1dP9HhUIduC
	 gd+HxLtAOpRWRIzSqTgYJQfzKTdspLbrAvKUxLwbKv1E9zZYSigAf/Jpsio1BLZv/dFQ9
	 csVMrZoPNRapGeGWexMwVCsbTOmiYFVkOH6xqlg/TTzKPI13mrrM/Zs/mTbH/y1uUlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpIs6wst;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D40606A320;
	Thu, 19 Nov 2026 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpIs6wst
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231F11F000C4;
	Thu, 19 Nov 2026 00:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048517;
	bh=ZPdZeLxX8S5sqWWOcuRtFhy3zH0VXfZ5RQ00cafotTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpIs6wstXvHGHB/meZrqjFw/kS5A10Ya0WscLF/NTk7kv6vijuw/SI4KXcx/JtC+7
	 KP+KaEBz9KdwBYijV7x8M+YWJyPCbRFWWA+ENmVh3nrJ4vxV+FqYgqITv9uCaFOMc5
	 rbFKZ74nYNfulg2U79MrUPwNr60VM6SriMa70MdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2022/2857] swim: Check error register during sector read
Date: Wed, 18 Nov 2026 15:50:56 +0100
Message-ID: <20261118150314.210307335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit d66bdef0a3083fed1a0fc4f0ee1c85b26476b21c ]

Clear the error register only once before a sector read operation. Don't
clear it afterwards -- the caller needs it. Check the error register in
swim_read_sector() and return the appropriate error when necessary. Fully
validate the sector header. Don't terminate the search loop early just
because an erroneous sector header showed up.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/efabd807f4ecf5cbc05b60e91ed69aa4c10691a8.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c     | 13 +++++++------
 drivers/block/swim_asm.S |  8 --------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 796d1ddd4702b..3e9789f8a17b4 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -483,20 +483,21 @@ static inline int swim_read_sector(struct floppy_state *fs,
 
 	local_irq_save(flags);
 	for (i = 0; i < 36; i++) {
-		ret = swim_read_sector_header(base, &header);
-		if (!ret && (header.sector == sector)) {
+		if (swim_read_sector_header(base, &header) ||
+		    swim_read(base, error) || header.track != track ||
+		    header.side != side || header.size != 2)
+			continue;
+		if (header.sector == sector) {
 			/* found */
 
 			ret = swim_read_sector_data(base, buffer);
+			if (swim_read(base, error))
+				ret = -EIO;
 			break;
 		}
 	}
 	local_irq_restore(flags);
 
-	if ((header.side != side)  || (header.track != track) ||
-	     (header.sector != sector))
-		return 0;
-
 	return ret;
 }
 
diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 81c824923336c..fcf574ced85ec 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -67,7 +67,6 @@ mfm_read_addrmark:
 	movew	#seek_time, %d2
 
 wait_header_init:
-	tstb	%a3@(read_error - read_mark)
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
@@ -140,8 +139,6 @@ crc1:	tstb	%a2@
 	andb	#.Lhr_crc_error, %d5
 	bne	signal_nonyb
 
-	tstb	%a3@(read_error - read_mark)
-
 	moveq	#0, %d0
 signal_nonyb:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
@@ -166,7 +163,6 @@ mfm_read_data:
 	movew	#seek_time, %d2
 
 wait_data_init:
-	tstb	%a3@(read_error - read_mark)
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
@@ -191,8 +187,6 @@ wait_data_mark_byte:
 
 	/* read data */
 
-	tstb	%a3@(read_error - read_mark)
-
 	movel	#sector_size-1, %d4		/* sector size */
 read_new_data:
 	movew	#max_retry, %d2
@@ -234,8 +228,6 @@ data_crc1:
 	andb	#.Lhr_crc_error, %d5
 	bne	data_exit
 
-	tstb	%a3@(read_error - read_mark)
-
 	/* return number of bytes read */
 
 	movel	#sector_size, %d0
-- 
2.53.0



