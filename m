Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B15947E0;
	Wed,  9 Sep 2026 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963556; cv=none; b=CTm2XxXQNw5V3YyL53TyCBD+6nVYjXeZfxT/ekRSf+xHfc6b9tFTs8mUzkVAs564gLQ1WMQJB2HU3J9kZ7u0PrI9BDN/dY0oL0aVbmkGZkMBEfztwcONV75G+sxdBVFFm7AYKnf/RkRQYcNvAAsh0v9lpyAq72Lsacy/FIOT5OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963556; c=relaxed/simple;
	bh=Lz33BzNm7bQ4KVyE7uX803HauNByUI/eVMLxzoumIfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwiVdcjR2OD5g5HGlX3tr+Evn//FW4HJ7qaSsNjEK5N25RWCMa6+FWtlgy0A8T5hsvd/X731e1HzGbKexGrEFbFIFAjMMKey/J826/MmOEE1fiH5115eeIUWBAjCWv9g7qcG9Uwg0FAdZh/D/e7Ry4tkxPjgezZCYafbspc7rz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+MIwd/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+MIwd/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD211F00A3D;
	Wed,  9 Sep 2026 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963554;
	bh=78MALdAaoINIydQE0vh8oLNRU6eMNwPQ//8wDXmBor0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+MIwd/ekPDfowPt1OWoj9z+OC8BI8FxSzye/KlBEKBs9M7IqlG3HBi2kgNPyZTxc
	 6em8bFx/wU6o0V5dJKrpcjJ+rc6ylP9VfoFrh9nv3rtKlaDvZzJ0PvvGDDTHxSUvcg
	 0D76qV+aKlc+zTzJKz8knPrgz5f8FY7FMP2YR9/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ju Nan <junan76@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Antonio Borneo <antonio.borneo@foss.st.com>
Subject: [PATCH 6.18 081/583] irqchip/stm32mp-exti: Fix the unit of the hwspinlock timeout
Date: Wed,  9 Sep 2026 15:36:06 +0200
Message-ID: <20260909134240.921673396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ju Nan <junan76@163.com>

commit d31fbbade43f880b7e59e2b3a72722fe2725d93f upstream.

HWSPNLCK_TIMEOUT is passed to hwspin_lock_timeout_in_atomic(), whose
timeout argument is in milliseconds, not microseconds:

  atomic_delay += HWSPINLOCK_RETRY_DELAY_US;
  if (atomic_delay > to * 1000)
          return -ETIMEDOUT;

So stm32mp_exti_set_type() asks for a 1 second timeout where the comment
next to the macro says it wants 1 millisecond. The semaphore is polled
with udelay() from a section that holds chip_data->rlock, a
raw_spinlock_t, so preemption stays disabled for the whole wait on every
configuration, PREEMPT_RT included.

The hwspinlock core documents this explicitly:

  If the mode is HWLOCK_IN_ATOMIC (called from an atomic context) the
  timeout is handled with busy-waiting delays, hence shall not exceed
  few msecs.

Fixes: 5257169ade8c ("irqchip/stm32-exti: Use the hwspin_lock_timeout_in_atomic() API")
Signed-off-by: Ju Nan <junan76@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Radu Rendec <radu@rendec.net>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260821024756.24927-2-junan76@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-stm32mp-exti.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-stm32mp-exti.c
+++ b/drivers/irqchip/irq-stm32mp-exti.c
@@ -23,7 +23,7 @@
 
 #define IRQS_PER_BANK			32
 
-#define HWSPNLCK_TIMEOUT		1000 /* usec */
+#define HWSPNLCK_TIMEOUT_MS		1
 
 #define EXTI_EnCIDCFGR(n)		(0x180 + (n) * 4)
 #define EXTI_HWCFGR1			0x3f0
@@ -377,7 +377,7 @@ static int stm32mp_exti_set_type(struct
 	raw_spin_lock(&chip_data->rlock);
 
 	if (hwlock) {
-		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT);
+		err = hwspin_lock_timeout_in_atomic(hwlock, HWSPNLCK_TIMEOUT_MS);
 		if (err) {
 			pr_err("%s can't get hwspinlock (%d)\n", __func__, err);
 			goto unlock;


