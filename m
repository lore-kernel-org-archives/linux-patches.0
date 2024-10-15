Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DB41F709F;
	Tue, 15 Oct 2024 11:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992368; cv=none; b=E4V2L2i9AKgy90TpocxQMOOjr9tgAb4EG0DL8f+7QApb4rcC5KQs6CawmgBiuNSKB8ZRKCmq34tEDs0Md9FMLmT3R5apZF6r3Am1EQ5LEqZI6oqziz+NYOQuOT/dhQSe37Qj9QRI6xGnvlVelyX0Hid2+YiA3rZlD5E3CrOQKhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992368; c=relaxed/simple;
	bh=RBXmazthF+ezKXnwmmD5/Mj8uFxT9snWVz84GGJ8ckE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqHjNj2cjzZwl3GIWJZSl5YWdS3NZlQkMFXzxK5c2FCkTJIJvFZoJKOHXvkmFbh3MO1IGvlE2ru0W/bIgnlkAk+GMyEh8IlkaOrqgNIwIaJNOEbCGb4P+N9ch+FHNc/ebaqF1BxQMUwhGNQx6jxrYbdIjixXSlBCkJjXkZc51D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owM56+dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owM56+dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC25C4CEC6;
	Tue, 15 Oct 2024 11:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992368;
	bh=RBXmazthF+ezKXnwmmD5/Mj8uFxT9snWVz84GGJ8ckE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owM56+dcML0q7yGPoPL6SJzU4tP1hYYEsfNJa/NjuUUpz9GLRiHxD4hQO9quP6sQA
	 Gqiz1taf935be8nvitA4x8hWOrEppsO1F0U4ngDA5bKcCCm+26l4njuehynkR/Tavx
	 mso441SRUvnvg3UpL/k0cf/wTQR/1fqWldlU3BWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/691] crypto: xor - fix template benchmarking
Date: Tue, 15 Oct 2024 13:20:44 +0200
Message-ID: <20241015112444.172181437@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Helge Deller <deller@kernel.org>

[ Upstream commit ab9a244c396aae4aaa34b2399b82fc15ec2df8c1 ]

Commit c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
switched from using jiffies to ktime-based performance benchmarking.

This works nicely on machines which have a fine-grained ktime()
clocksource as e.g. x86 machines with TSC.
But other machines, e.g. my 4-way HP PARISC server, don't have such
fine-grained clocksources, which is why it seems that 800 xor loops
take zero seconds, which then shows up in the logs as:

 xor: measuring software checksum speed
    8regs           : -1018167296 MB/sec
    8regs_prefetch  : -1018167296 MB/sec
    32regs          : -1018167296 MB/sec
    32regs_prefetch : -1018167296 MB/sec

Fix this with some small modifications to the existing code to improve
the algorithm to always produce correct results without introducing
major delays for architectures with a fine-grained ktime()
clocksource:
a) Delay start of the timing until ktime() just advanced. On machines
with a fast ktime() this should be just one additional ktime() call.
b) Count the number of loops. Run at minimum 800 loops and finish
earliest when the ktime() counter has progressed.

With that the throughput can now be calculated more accurately under all
conditions.

Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: John David Anglin <dave.anglin@bell.net>

v2:
- clean up coding style (noticed & suggested by Herbert Xu)
- rephrased & fixed typo in commit message

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xor.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index 8e72e5d5db0de..56aa3169e8717 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -83,33 +83,30 @@ static void __init
 do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 {
 	int speed;
-	int i, j;
-	ktime_t min, start, diff;
+	unsigned long reps;
+	ktime_t min, start, t0;
 
 	tmpl->next = template_list;
 	template_list = tmpl;
 
 	preempt_disable();
 
-	min = (ktime_t)S64_MAX;
-	for (i = 0; i < 3; i++) {
-		start = ktime_get();
-		for (j = 0; j < REPS; j++) {
-			mb(); /* prevent loop optimization */
-			tmpl->do_2(BENCH_SIZE, b1, b2);
-			mb();
-		}
-		diff = ktime_sub(ktime_get(), start);
-		if (diff < min)
-			min = diff;
-	}
+	reps = 0;
+	t0 = ktime_get();
+	/* delay start until time has advanced */
+	while ((start = ktime_get()) == t0)
+		cpu_relax();
+	do {
+		mb(); /* prevent loop optimization */
+		tmpl->do_2(BENCH_SIZE, b1, b2);
+		mb();
+	} while (reps++ < REPS || (t0 = ktime_get()) == start);
+	min = ktime_sub(t0, start);
 
 	preempt_enable();
 
 	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
-	if (!min)
-		min = 1;
-	speed = (1000 * REPS * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
+	speed = (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
 	tmpl->speed = speed;
 
 	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
-- 
2.43.0



