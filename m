Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3BC1D040D;
	Wed,  2 Oct 2024 14:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879165; cv=none; b=l6jZKpEHMirSAP5ls2KoyAd54Q7UCxO1TYl4flCVL+CkYjP7VD4mrgo0C2UcEJ6Sk3XyJP45tGUtsaTSYbO35nQACa9tJGtBZzUpmMqqTlDQFmz3ABiPtkTlInRBzP0AmHxn4A4syvIDDPOXcmIcQGkRVwA6GMJcxkZ4DOXXgwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879165; c=relaxed/simple;
	bh=6oGEqDB3GmakXsATepVlIdI8ASmLnHA0VdoVnq8jyEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ9OqS9Ssitsau76Zq50qKV69PfkhFBYEwXn9HrxoPR/pDNV+pe+6FCPA2/QSk2eGjnrtnxc7xiJHbCm+zDkO9PPCK5a/s8F2J+OAn0e/fAbhcm2gE9IdxrdeuK/Y/K0UcsMtMCCbMF1Mq/tIKrKKlloFMnTmh9jnhZkNT1Keos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeCiK/I9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeCiK/I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08795C4CEC2;
	Wed,  2 Oct 2024 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879165;
	bh=6oGEqDB3GmakXsATepVlIdI8ASmLnHA0VdoVnq8jyEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeCiK/I976s4qvRb+JuH2jbVjQtupdGVooZkjbcHLb7W0V5ep6FfzDp0k32OeZyFY
	 Jc4PMzWGBOhaI32oXoL51H1wstcFB6KMgVQKr12BLbz/raC4+AiWRKaJJ9qhWeeg8T
	 Wdkj3srbg32Kn4VQYPDIozdP/gyogYvcHBrDZhVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/538] crypto: xor - fix template benchmarking
Date: Wed,  2 Oct 2024 14:54:03 +0200
Message-ID: <20241002125752.150399564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



