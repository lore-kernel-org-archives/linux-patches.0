Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0C3B9D9D;
	Tue, 21 Jul 2026 22:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671388; cv=none; b=ibHmr3Qc00xQAeyEpLIzGolMe6FXjvH+xV0cEDnrx6DkXc2+ZZsPOxFqXWTg+rfr8vWkVsnxoEZntLnSSGL1yYZv610/9gk18RzD7NYgedkAvPtN1dqPY+NUGgrt2342adNYaMciz++XV6xRu4sKRpII1XbbMjzi2UMwMLmxyh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671388; c=relaxed/simple;
	bh=NHnRAKt3kXMLrVhdSblPdXJuP0sRGauhfI9paSZ7Zh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqu8Ou7oBxxKFU1PaEdkCWJ9JiekN/nuvHDaHqvxC7zzTG4ODlvnm1xzBkxsBED37sZoBo7xs1OqhwtrccJR0MawxZx4mUJPDdRD6+IHWI9iLL5zdth4oA7woQ3GO40XyWuqNOucAiB6UEqZZz/KSmlCM7kU9eXDOJOJQr8qq+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZKxRwLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZKxRwLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5511F000E9;
	Tue, 21 Jul 2026 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671387;
	bh=rsOSOp/mkWlqXzxC6aAPt4rz4ef36d7tP4PlMU+HZBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZKxRwLE9Q9ZOHSvJxUZ6Wso1wexPwIP305QGKGLqbzT1qXnFrZ56tbnwyc1LMWO8
	 CHVl2sRxbAZ4r74KqqLm8afJmd9G442XBDYLO1bHfYrBa34MRnLqRScZ4HSEcEQJE3
	 zkTnLVWZH3irocrv/NnpUahmgzXjV0x6nRQo1twg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/843] crypto: atmel-sha204a - fix blocking and non-blocking rng logic
Date: Tue, 21 Jul 2026 17:17:43 +0200
Message-ID: <20260721152411.145821158@linuxfoundation.org>
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
index 0ef92109ce22a3..2ac5ec9b5ea2a0 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -47,8 +47,8 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(sizeof(work_data->cmd.data), max);
-		memcpy(data, &work_data->cmd.data, max);
+		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+		memcpy(data, &work_data->cmd.data[RSP_DATA_IDX], max);
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc(sizeof(*work_data), GFP_ATOMIC);
@@ -85,8 +85,8 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
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



