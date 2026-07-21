Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA12946EC8E;
	Tue, 21 Jul 2026 19:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661634; cv=none; b=ljzOo/d5Lf6hNRw2nE+ZmnwsgWIxsTs8zouDGvSYeJqNCoq42xoer0/WPr61dGHArozSq3HBA+YMyb0uQ9pMge9vbAC92zVZOKHxsf87/nGpqCx5rFLEDyusaOu2VRhmFil4cBVWL83wUs821EajzxhF5Hi81GHuj2aWbcOJdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661634; c=relaxed/simple;
	bh=Vh7CcyqJz54/wTbKiIUEhQC8Wasd43pRnied4D+UaTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSvU86w5AgNpjmIIE7C/BsuktIz8x8x89swOiuCR9lmd0U+0gNM65xVsic7hFQIv4fBBuEu9Z29KWpczisM2Si+/Vwu+clml2z/JXd6j/nql/CPgkSyozRs1bTTKUTUbA8ve0w0tRtnCIMl0UlqrdRmQZkev0PJN0+W26O6g9ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp326H+M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp326H+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC011F000E9;
	Tue, 21 Jul 2026 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661632;
	bh=vFPXRtg+mPnZbERPZUkUAiSrGcVUmOTjcR7w1jEJL1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tp326H+MBHAWchVIgf4lmx4Krc+kPMGoP6CLNV0JD7kjt1nfM4jNAUvvfFlgrj2QI
	 FrgmqSIGop0lBuJlhUOdhomOIuWSgBVKjkeA+w+gK/gLvdNoFkXpgw8fmIS4HtoQBd
	 E1nIOc3wD7JukB5M9r7eJiBaDybmgP6UtnHOPokI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0097/1276] crypto: atmel-sha204a - fix blocking and non-blocking rng logic
Date: Tue, 21 Jul 2026 17:09:00 +0200
Message-ID: <20260721152448.267172488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Lothar Rubusch <l.rubusch@gmail.com>

[ Upstream commit 319400fc5ee15db5793aa45f854968141326effc ]

The blocking and non-blocking paths were failing to provide valid entropy
due to improper buffer management. Reading the buffer starting from byte 1,
only fetch the 32 bytes of random data from the return message.

Tested on an Atmel SHA204A device.

Before (here for blocking), tests showed repeatedly reading reduced bytes.
$ head -c 32 /dev/hwrng | hexdump -C
00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020

After, the result will be similar to the following:
$ head -c 32 /dev/hwrng | hexdump -C
00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
00000020

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
Tested-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha204a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 1add8dcd306f09..a1f2b8d955a927 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -48,8 +48,8 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(sizeof(work_data->cmd.data), max);
-		memcpy(data, &work_data->cmd.data, max);
+		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+		memcpy(data, &work_data->cmd.data[RSP_DATA_IDX], max);
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc(sizeof(*work_data), GFP_ATOMIC);
@@ -87,8 +87,8 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
 	if (ret)
 		return ret;
 
-	max = min(sizeof(cmd.data), max);
-	memcpy(data, cmd.data, max);
+	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+	memcpy(data, &cmd.data[RSP_DATA_IDX], max);
 
 	return max;
 }
-- 
2.53.0



