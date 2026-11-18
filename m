Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022236;
	b=2Jw2ocSDFLkoCZSMzCfWer6VMS5Zq0U0TWG+XKL/1Dw5fNULnZNe9pFldfrce/LMUnY1
	 6pdtZ1Sf94NgeYBio21b7cHCAgbaHsoytxnygNfhTYhzswIQgsBUeU82xWAJM8aIjtWav
	 lGojYoyHC44Ywh62apHVY7n+cvNMivuvng/qekwP05bmIFLoU5cpeE/rqbE1XzL9X1GC/
	 oP9pVq1BTuEMdz5n6bguxDGjM6wa777Jxje/Ku9SUsNCQTch6UHPknUMW7qYYfHEImRqW
	 0+nyGfZhp4gLpQE2V8aPbaE9TZKMpWBkTfIWwZbgRRNm4MJzfjuYuFPoJ7B1W/qVGzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qK3aPM/+2tRiRfJ/mvMgsM1uewSJ6EIQFfEP0VXTY64=;
	b=DCqaUv3qte+sWiQggm/ruz1goi9pDYDXnAPqNK/63cTYCIlFFfZaoBK/C4Y7FcovWBMs
	 OjXO3scbNZu/nk0IhDuB6U5WpGssSguOx+AtwSKvnpyVe4PII3aGBwfbfcZextTr+YxXp
	 aXrrUQujYM0Av8j9rzz1EvzCL1JrJ8W1WvJzFfBReLobuP+yWGAijPYP0Ja5hFhw0mIpf
	 a13jPjZ4XqF0SIjm+Q2G5jsu3ZQ1mmJ6twa4nz0RdaOY1Xsb4H8k6pgV8J950f/OMo8YS
	 ljX309E148WeO6olpip/qM8XUpHJp2OGjx5WgCuPfAC5COhPDNSYKr73RC151HS6FIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tB1Vp9iU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC37606A32C;
	Wed, 18 Nov 2026 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tB1Vp9iU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812571F000C6;
	Wed, 18 Nov 2026 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022236;
	bh=qK3aPM/+2tRiRfJ/mvMgsM1uewSJ6EIQFfEP0VXTY64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tB1Vp9iUTxnVbN7iTv363dKyWt798VJX/rOEN63Ch7H1HuEpSChsqlxVtURKVpJbi
	 ENFS2WOyRCrYcPq3Wh9rEI83fnMfL8nnrjhIy0m5rj+pI3N6AzVoSsXwsrPt/MOAAO
	 WkAd1n+RlKkSCga4XdmVcqUI1h6nb+KrhbhEwx18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2591/2651] block: apply the segment size to the integrity buffer
Date: Wed, 18 Nov 2026 16:03:51 +0100
Message-ID: <20261118150417.546097817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 26edfdee11eb2afe08fb5f874edcdf0786d6b66c ]

The integrity buffer is a single segment and must not exceed
max_segment_size. max_integrity_io_size() applies that limit to the data
size instead, which is off by a factor of 64 for 8 bytes of PI per 512
bytes of data. A SCSI host that doesn't set a maximum segment size gets
64KiB, lpfc and qla2xxx among them, so a DIX disk behind one of those
does no IO above 64KiB.

Limit the buffer and derive the data size from that, which makes it 4MiB
for that case.

Fixes: ec7f31b2a2d3 ("block: make bio auto-integrity deadlock safe")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-45-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c8bcd6c570bd4..b5d247474e777 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1814,11 +1814,12 @@ static inline int bio_split_rw_at(struct bio *bio,
  */
 static inline unsigned int max_integrity_io_size(struct queue_limits *lim)
 {
-	u64 max_intervals;
+	unsigned int buf_size = min_t(unsigned int, lim->max_segment_size,
+				      BLK_INTEGRITY_MAX_SIZE);
 
-	max_intervals = BLK_INTEGRITY_MAX_SIZE / lim->integrity.metadata_size;
-	return min_t(u64, lim->max_segment_size,
-		max_intervals << lim->integrity.interval_exp);
+	return min_t(u64, UINT_MAX,
+		(u64)(buf_size / lim->integrity.metadata_size) <<
+			lim->integrity.interval_exp);
 }
 
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
-- 
2.53.0



