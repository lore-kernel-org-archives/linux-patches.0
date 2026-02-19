Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818B52D3A89;
	Thu, 19 Feb 2026 02:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466676; cv=none; b=jStpSb//9b6f2PYXHtkaxWcdQr4ecit4oWUsk6JwSeGadlGVsaPh/rZJqAl2XsdGbIhz2iVCSoP59DcENhG3K2jbhFmaAO2jgHZd0NHZqzDpaFftI/nwxkwwf7PyktafD03xaVAD5udw8rYurn4dgRazu5S3ZNTokqDps9kwXrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466676; c=relaxed/simple;
	bh=hzqMcCE7I9b7PJkGfcQlFga9XvhC5pEt2XGRzJjH95g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mgW21zoooDtNB1fZtZVdyaXIXvBL6O44UAqyU7f6D0T2KQYrdaMOwBSEk/VqxYJ2L/BnWNE35wj+Rz6W7SNPF/xZ9unZ7G4TuHk04blwHGf/HgswBYnXgQGolT4uX7lvt7+Y7WajMg0E8hrvd9YpCeiLt4Eyuuzs/pv42MyknJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTy6G3c8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTy6G3c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F87C19422;
	Thu, 19 Feb 2026 02:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466676;
	bh=hzqMcCE7I9b7PJkGfcQlFga9XvhC5pEt2XGRzJjH95g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTy6G3c8Q3Z0vH8fc290c/M/Li5BhFVS0O2MWDA8kwBRgqxob/loR3rYDKBdVEMQW
	 eXiv+DMdywYd2+/69raQtFnm0oX+S05rDNV5BJAw4R0vncLLclNBZB5CgrH0s9q/pg
	 BX6dvNEIZFArXQHPeZi79G7AobNQfFn2IqjLlE6LjQ9LizmetJHp9hYVkrLd8RQiKA
	 M9nKADBdsN70cUYeAwW00rb6P9JAiS3tMWe6EX3rdyVEeAlZFX+jzER+WpRLU46LrP
	 2P3mDSNPyyzJ66cH2EWsV9jfl5uWdWONKq2aCRFu2zTS4MZIK8CPX+fAgHdM4w11ge
	 UyjbcUkSUedHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	jic23@kernel.org,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] iio: magnetometer: Remove IRQF_ONESHOT
Date: Wed, 18 Feb 2026 21:03:46 -0500
Message-ID: <20260219020422.1539798-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit a54e9440925e6617c98669066b4753c4cdcea8a0 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.
The flag also disallows force-threading of the primary handler and the
irq-core will warn about this.
The force-threading functionality is required on PREEMPT_RT because the
handler is using locks with can sleep on PREEMPT_RT.

Remove IRQF_ONESHOT from irqflags.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

`IRQF_ONESHOT` has been in this driver since 2013, so it's present in
all stable trees that contain this driver.

## Classification

This fix addresses a **real bug on PREEMPT_RT kernels**:
- With `IRQF_ONESHOT` set, `irq_setup_forced_threading()` returns early
  (line 1295 of `kernel/irq/manage.c`), preventing the interrupt handler
  from being force-threaded
- On PREEMPT_RT, spinlocks become sleeping locks. `wake_up()` in the
  handler acquires a wait queue spinlock, which can sleep under RT
- Running this handler in hardirq context (non-threaded) on an RT kernel
  can cause sleeping-in-atomic-context bugs, warnings, or system
  instability

## Risk Assessment

**Change scope**: Minimal — removes one flag (`IRQF_ONESHOT`) from one
`devm_request_irq()` call.

**Risk**: Very low.
- On non-RT kernels: `IRQF_ONESHOT` was already semantically meaningless
  since there's no threaded handler. The flag only affects behavior when
  a threaded handler is present (masks the line until the thread runs).
  With only a primary handler, the interrupt line is naturally masked
  while the handler runs anyway.
- On RT kernels: This fix is essential for correct operation.
- The handler (`ak8975_irq_handler`) just does `set_bit()` and
  `wake_up()` — it's trivially simple.

**Quality signals**:
- `Tested-by: Geert Uytterhoeven` (well-known kernel developer)
- `Reviewed-by: Andy Shevchenko` (prolific reviewer)
- `Reviewed-by: Nuno Sá` (IIO maintainer)
- Part of a well-established pattern of similar fixes across multiple
  subsystems (I found 12+ similar commits)

## Stable Kernel Criteria

1. **Obviously correct and tested**: Yes — the flag has no semantic
   meaning for primary-only handlers, and it has multiple reviews +
   testing
2. **Fixes a real bug**: Yes — on PREEMPT_RT, this prevents sleeping-in-
   atomic-context (and on non-RT prevents force-threading which could be
   useful)
3. **Important issue**: Moderate — affects PREEMPT_RT users of this
   magnetometer, and also triggers warnings
4. **Small and contained**: Yes — single character-level change
5. **No new features**: Correct — only removes an incorrect flag
6. **Applies cleanly**: Likely yes — the surrounding code hasn't changed
   significantly

## Verification

- **Read `ak8975_irq_handler`** (line 557-565): Confirmed it's a
  primary-only handler returning `IRQ_HANDLED` (not `IRQ_WAKE_THREAD`),
  and the call uses `devm_request_irq()` (not
  `devm_request_threaded_irq()`)
- **Read `irq_setup_forced_threading()`**
  (kernel/irq/manage.c:1291-1296): Confirmed that `IRQF_ONESHOT` in the
  flags causes the function to return 0, bypassing force-threading
- **git log --grep** confirmed this is part of a well-known series of
  12+ similar fixes across multiple subsystems
- **git log -S** confirmed `IRQF_ONESHOT` has been present since 2013
  (commit 94a6d5cf7caa5), meaning it exists in all active stable trees
- The handler uses `wake_up()` which acquires a spinlock — verified this
  is problematic in hardirq context on RT where spinlocks become
  sleeping locks

## Conclusion

This is a small, well-reviewed, well-tested fix that corrects a bug
affecting PREEMPT_RT kernels (and removes a semantically incorrect flag
on all kernels). The change is minimal risk — removing a flag that was
never appropriate for a primary-only interrupt handler. It's part of a
well-established pattern of identical fixes across the kernel. It meets
all stable kernel criteria.

**YES**

 drivers/iio/magnetometer/ak8975.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 3fd0171e5d69b..d30315ad85ded 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -581,7 +581,7 @@ static int ak8975_setup_irq(struct ak8975_data *data)
 		irq = gpiod_to_irq(data->eoc_gpiod);
 
 	rc = devm_request_irq(&client->dev, irq, ak8975_irq_handler,
-			      IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+			      IRQF_TRIGGER_RISING,
 			      dev_name(&client->dev), data);
 	if (rc < 0) {
 		dev_err(&client->dev, "irq %d request failed: %d\n", irq, rc);
-- 
2.51.0

