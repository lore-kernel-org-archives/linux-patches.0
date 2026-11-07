Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062297;
	b=z3D2spo/XB+YB2SDtiekPZGQ2nUYBwpBzxwPrSdTvcNHzvJPMtYFxCAhAN1uKgB7Tfqd
	 ayOB9svqd9RFkt1yc5BRsvtVZEKfKQHESo2NC0c9+jeZ8QQj1OJIYNziGQc7lqonoPOaO
	 nZL00pgAWCHcO0s9LFnsJPPctpWCJvGmamuwB7Cu1ebnyzrR9kn4SYF79PLxeoE7sxkbM
	 qQTPeW79n5I6+yRsRWp+WpJ3l8DQDSahS1uR0oyeNzVEMhX4r8z1eW3BpZqo4t/ZXu2fJ
	 +KkxHjPu2EYLVYHCxkGG7oHxVzc3Gz9LVDrTEFOnEZt9RVfoCN3KcIaftGArib+ikgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wwLNa1mh8CwZ6SIbQ939BfCLOKZ7nAJhEq6Zb8a5gFI=;
	b=klvTWavaWerESIwM/aNHbNMj4l9g/FN3dILnojUZbZMeoYLlsf1K1ZqtPiu4iwQ95LMh
	 Osf7zb4U3TLeQxI85pnBM6zLHqGP9uBMLQ0bHlgwd198lmS1pCKQOvg2LAMfikJPguu3N
	 ZgGyvvV0uUCCbsg/LKl3c+bv8JVAD8rXRfCB4062BbbbwMcenR0YRoDbIR5cq5ouZmV35
	 ruN5c5rtNBlfmEqtFo6lH5rqyIGPWvg7SJWowNJVuw1lb2dG5perKEDg6biS7+ZN86Xyp
	 bsKlw7tAj+A6qE18wNF+iRb9i+zS8MFcrYU4GRBFkz+lP0MQOFO2zy84zd57On4r9ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hp2m5E2o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795FD606D81D;
	Sat,  7 Nov 2026 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hp2m5E2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2776F1F0089F;
	Sat,  7 Nov 2026 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062297;
	bh=wwLNa1mh8CwZ6SIbQ939BfCLOKZ7nAJhEq6Zb8a5gFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hp2m5E2ok/9/IJCyT+zvdyrzFhNQXDSqPXCEEOKccHWLwwfBW+5fWBjjuHfMuYM4y
	 QbgJk5WViBgovckMREdxXK7AX5Te1LBvEdZqF+AdnMATySD0hEh3eKVkZSZyACHyFO
	 5gyieE8GxMoTtfPIVhfwYapKuG+xswi+UAVOQWBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1233/1536] mtd: parsers: qcom: fix offset/size overflow on large partitions
Date: Sat,  7 Nov 2026 08:54:09 -0500
Message-ID: <20261107135032.389330555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



