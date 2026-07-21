Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBCE46AA6B;
	Tue, 21 Jul 2026 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648350; cv=none; b=RJHZJqDkT8lA2clhO4S3BRn3m6RynEoW2BRLA5M707uIHS9IDOyS/b+WQcG+cPYMcSNvz+LAkUxX/CPtEIWu9EHQfBKxLl+JibjAGZjagDKLxgjzD1IjKGV0CsEsioFN5R7SdVy5Eaw2XpJpPMjmUxYguh59N7sUQp4MrB8VyOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648350; c=relaxed/simple;
	bh=TC7qvndFwvYit37MfLt0K3kJlZzJPCI2ztYEsMVvR1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/zt3ogg2qolHiQv/PcMnyov0SVGl0CoX/ikWbKJCbxEMTNewqZsnO19Y17z2g9OwWNNTne59e5zgxcuw7mV4yQQd9+jmggNzwgygcgfEuMM97oXln5V3WN6mb1ZdO2fnq13W8pLcxYPzXa1QkVS3/FGWKywph6YWSQO4tkCHdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQ1gesQf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQ1gesQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2431F000E9;
	Tue, 21 Jul 2026 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648349;
	bh=mBCxPD3vZM36e8oxDbQfUOMfwjRTyF6c7NHu4yIY6Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQ1gesQfBCNOo+CikuNpo5iQqIUf34s2Qic582eikODC9I+nJcrjnslOidi4x3tIx
	 FDvS8CaCrEVwkVU0BZHFgWsKHboU0xVMKxI5cW/QBznjtStaBqSD6ljVKPRY0BGtMi
	 eLQxxdL/PiDTd56ZKKjytiBMPSwcvSap4qtVjLKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0165/2077] crypto: atmel-sha204a - fix blocking and non-blocking rng logic
Date: Tue, 21 Jul 2026 16:57:18 +0200
Message-ID: <20260721152556.582377342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 987eadae2007a6..aa1db7ac2bb2a2 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -54,8 +54,8 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(sizeof(work_data->cmd.data), max);
-		memcpy(data, &work_data->cmd.data, max);
+		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+		memcpy(data, &work_data->cmd.data[RSP_DATA_IDX], max);
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
@@ -93,8 +93,8 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
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



