Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036582;
	b=pSFnLpd3Y49V3elxi0DqLoWZi9mkY7h8SwmMuNyPTdXMC8sohrqoW9bEgPPvoSIwlKNc
	 MQINGBmAP/KLiPHNynX5n0mRNIlm7WGgkz67beZ7AdzCfY8QMxEbNS4ohpzsOcoUad7mA
	 HNH4qZ+eXgIWiUfaKd/IYBZ8f6/HIVf41yVSe0ydAxsJcxW85ITL84MYlajIXACQA8cTg
	 KmZn7uIFyMdWQ3HaMXw8N95bmhieFIMVnqeChF578f6f9kS3CtW7zPmZNMUMOwCTNpEqC
	 NXa0KQCZBv5KKtWQ8dEYr/VV9xHzUKXWy8Qsis/1ZnSuQ5+q8wUr3nEIPgj+STAE2kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7oNsktwka7mvtvZat2ZRgfunxoUlPnt80qfF5mehdTw=;
	b=veUg2X/VKbQWeCB9gJqIxhMyWVjOADWZkfWdtjNJYTTFP4qTk5Z1P5cQhswa6nAtlgY2
	 I+D4DSpBV/Wj1H1NJsWTRrdUwlClvq7GbKiRKah3mGHfoxLcxn6P+m1OS+AywAB/KVQfq
	 UXNjpm4rvbzf4Ta8OD3X1VDA86sRStCe2+cLf6P2I2IQMSw5qh79iMRq797PUCljPnz2X
	 XZTjy4FgMPZh3sqCf+e3/6q2aDyKcAPUrgdhWfQ3g4I6yUEtoKQ9U+G9BzIy7yv7s3bYw
	 3mrmPAEnt8+KVo5e9dz/6nSrqYwIX4wIQhZdADol69gwxqO7RHZ3jghKbEMUSMCMMxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hqd0JQMz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD349606A332;
	Wed, 18 Nov 2026 21:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hqd0JQMz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E470E1F000C4;
	Wed, 18 Nov 2026 21:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036582;
	bh=7oNsktwka7mvtvZat2ZRgfunxoUlPnt80qfF5mehdTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hqd0JQMzIXm2bSlpRRmL5TCP7ddcuOnYlkecomR5eoty4VfnFXSUvbu6cfaKJ2ahn
	 bluA7U5nJ3to/qGZMYPYz6COYqk+qVWeiGoL3P2Qd/JqRGRQ5bRvBRLd8cceoAgMf7
	 +FN8RaCiCawSM/dAoI1XdIynTVOMWhsusKRt9+O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1068/3318] mtd: parsers: qcom: fix offset/size overflow on large partitions
Date: Wed, 18 Nov 2026 15:28:10 +0100
Message-ID: <20261118150352.008038453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 2f7fa8d90694d21dce68ceabd8383252b111cfea ]

In parse_qcomsmem_part() the partition offset and size are computed as

	parts[j].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
	parts[j].size   = le32_to_cpu(pentry->length) * mtd->erasesize;

Both le32_to_cpu() and mtd->erasesize are 32-bit (u32). The multiply is
therefore evaluated in 32-bit arithmetic and the product is truncated to
32 bits before being widened and stored into the 64-bit (u64)
parts[j].offset / parts[j].size fields, so the 64-bit destinations are
never used at their full width.

The SMEM partition table is firmware-provided and the per-entry offset
and length are not bounds-checked against the device geometry (only
numparts is capped). On a sufficiently large flash, a partition whose
(offset|length) * erasesize is >= 2^32 gets a silently truncated
offset/size and is mapped to the wrong region of the master MTD, which
can overlap or extend into an unintended area.

Cast one operand to u64 so the multiplication is performed in 64-bit and
the result fits the 64-bit fields without truncation.

Found by static analysis tool CodeQL.

Fixes: 803eb124e1a6 ("mtd: parsers: Add Qcom SMEM parser")
Cc: stable@vger.kernel.org
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/qcomsmempart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/parsers/qcomsmempart.c b/drivers/mtd/parsers/qcomsmempart.c
index 4311b89d8df00..b12d87c3b0232 100644
--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -143,9 +143,9 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 			*c = tolower(*c);
 
 		parts[j].name = name;
-		parts[j].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
+		parts[j].offset = (u64)le32_to_cpu(pentry->offset) * mtd->erasesize;
 		parts[j].mask_flags = pentry->attr;
-		parts[j].size = le32_to_cpu(pentry->length) * mtd->erasesize;
+		parts[j].size = (u64)le32_to_cpu(pentry->length) * mtd->erasesize;
 		pr_debug("%d: %s offs=0x%08x size=0x%08x attr:0x%08x\n",
 			 i, pentry->name, le32_to_cpu(pentry->offset),
 			 le32_to_cpu(pentry->length), pentry->attr);
-- 
2.53.0



