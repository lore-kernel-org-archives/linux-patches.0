Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1F7143890;
	Tue, 23 Apr 2024 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908466; cv=none; b=qEE5yhPpeaiuF+smjQnHkOEa2L7/A0X9eeXpUTY50ZAd1nz7/6gbdMsIcySk/Z8dmXiY/xY3czqqm7UQQCpAV9rXDbkZzZwHCMpDzlSBFpfO2bQT8N8br/goQtGC16ENCBsQrrIujUWVpxO611Mgg2vt3kQX82fVFwgp639I9+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908466; c=relaxed/simple;
	bh=A8RkWRz49beC7lmbfMxj3+eUuRq8n1REJjw5VJbRnFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU5kf17eDCE68JPXK6gmtUmKXuFymXsTjkD+kbKnSmNNOO2n7qJcsUJWLBCT2wR0PtfVoeSBX/+MaAOyzf3mCcxzApUkqWLQG7FIvqfRQ8MA2oTDAg1Tib3divG64Hj0z38JAJxaN0gZH3t/KnIbzi6+GvwjJFKP0J3PKpLqQJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubNUt0Vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubNUt0Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B26C116B1;
	Tue, 23 Apr 2024 21:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908466;
	bh=A8RkWRz49beC7lmbfMxj3+eUuRq8n1REJjw5VJbRnFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubNUt0VbJwwyzei26AeGZtWk1xnlJ0m0gs8WgKGuRDMqYzRu0MaKmg/naYIUyI9FQ
	 RORfgShbvgvo4t2EVeP4LgrOpegZvIc9CO+X3gEs44EHdxAoWd8eqjoPEE+MnTeXww
	 DSTsSKSD9Vj8bQl5rHbnrvBqbSSte5EX6L7SjHXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoyong Wang <guoyong.wang@mediatek.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.8 006/158] random: handle creditable entropy from atomic process context
Date: Tue, 23 Apr 2024 14:37:08 -0700
Message-ID: <20240423213856.047790653@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit e871abcda3b67d0820b4182ebe93435624e9c6a4 upstream.

The entropy accounting changes a static key when the RNG has
initialized, since it only ever initializes once. Static key changes,
however, cannot be made from atomic context, so depending on where the
last creditable entropy comes from, the static key change might need to
be deferred to a worker.

Previously the code used the execute_in_process_context() helper
function, which accounts for whether or not the caller is
in_interrupt(). However, that doesn't account for the case where the
caller is actually in process context but is holding a spinlock.

This turned out to be the case with input_handle_event() in
drivers/input/input.c contributing entropy:

  [<ffffffd613025ba0>] die+0xa8/0x2fc
  [<ffffffd613027428>] bug_handler+0x44/0xec
  [<ffffffd613016964>] brk_handler+0x90/0x144
  [<ffffffd613041e58>] do_debug_exception+0xa0/0x148
  [<ffffffd61400c208>] el1_dbg+0x60/0x7c
  [<ffffffd61400c000>] el1h_64_sync_handler+0x38/0x90
  [<ffffffd613011294>] el1h_64_sync+0x64/0x6c
  [<ffffffd613102d88>] __might_resched+0x1fc/0x2e8
  [<ffffffd613102b54>] __might_sleep+0x44/0x7c
  [<ffffffd6130b6eac>] cpus_read_lock+0x1c/0xec
  [<ffffffd6132c2820>] static_key_enable+0x14/0x38
  [<ffffffd61400ac08>] crng_set_ready+0x14/0x28
  [<ffffffd6130df4dc>] execute_in_process_context+0xb8/0xf8
  [<ffffffd61400ab30>] _credit_init_bits+0x118/0x1dc
  [<ffffffd6138580c8>] add_timer_randomness+0x264/0x270
  [<ffffffd613857e54>] add_input_randomness+0x38/0x48
  [<ffffffd613a80f94>] input_handle_event+0x2b8/0x490
  [<ffffffd613a81310>] input_event+0x6c/0x98

According to Guoyong, it's not really possible to refactor the various
drivers to never hold a spinlock there. And in_atomic() isn't reliable.

So, rather than trying to be too fancy, just punt the change in the
static key to a workqueue always. There's basically no drawback of doing
this, as the code already needed to account for the static key not
changing immediately, and given that it's just an optimization, there's
not exactly a hurry to change the static key right away, so deferal is
fine.

Reported-by: Guoyong Wang <guoyong.wang@mediatek.com>
Cc: stable@vger.kernel.org
Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -702,7 +702,7 @@ static void extract_entropy(void *buf, s
 
 static void __cold _credit_init_bits(size_t bits)
 {
-	static struct execute_work set_ready;
+	static DECLARE_WORK(set_ready, crng_set_ready);
 	unsigned int new, orig, add;
 	unsigned long flags;
 
@@ -718,8 +718,8 @@ static void __cold _credit_init_bits(siz
 
 	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS) {
 		crng_reseed(NULL); /* Sets crng_init to CRNG_READY under base_crng.lock. */
-		if (static_key_initialized)
-			execute_in_process_context(crng_set_ready, &set_ready);
+		if (static_key_initialized && system_unbound_wq)
+			queue_work(system_unbound_wq, &set_ready);
 		atomic_notifier_call_chain(&random_ready_notifier, 0, NULL);
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
@@ -890,8 +890,8 @@ void __init random_init(void)
 
 	/*
 	 * If we were initialized by the cpu or bootloader before jump labels
-	 * are initialized, then we should enable the static branch here, where
-	 * it's guaranteed that jump labels have been initialized.
+	 * or workqueues are initialized, then we should enable the static
+	 * branch here, where it's guaranteed that these have been initialized.
 	 */
 	if (!static_branch_likely(&crng_is_ready) && crng_init >= CRNG_READY)
 		crng_set_ready(NULL);


