Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEBA230BE9;
	Sun, 15 Feb 2026 17:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177291; cv=none; b=oY1eYSRrD6XCHUhVlUWuH/+ZOwWzn25gV/HrXxDfEtJvtWsh09F3nffnBUnAkaUHb5OulGiQf0If45i1QZhREAUztr8Jk9cyiq8LNeBdFDM3iRhWIVFpzB+SRIKRUn3SESScMT3s9RY2l6dhg6w9oVHQMiA5FMzPMZBvq07otsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177291; c=relaxed/simple;
	bh=VU9AD3Rwy7q/KyQTMvgn8QsNsTFm8W8TgF2zUUaw9Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mq1Ujsa4xiTblXcV8eR1ROuuwJjh2hdr1LuGRuNAbGDIjxS2U+p+UgplmsvKEZW2HdTbeop05bHJTRd1PyLg2v72N2V3OemtcyGCqZRiUWmvI2wYVla3Ils1GmWc18VN21/E65eWSEePCLtohb8VnlMkWBO7HCl2GMgsGIg2NNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIqK5SUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIqK5SUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881EBC2BC86;
	Sun, 15 Feb 2026 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177291;
	bh=VU9AD3Rwy7q/KyQTMvgn8QsNsTFm8W8TgF2zUUaw9Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIqK5SUwV8Y+2EL/jJMdAhP9nqWq3s+TmvTHkMjKj930NbtelN4rcDP16Mp0P2h1q
	 vnFKESoGd6SyHzdjEXVCq7KRTJp7JZa9Kp2gXB8kuXYGNI6jcA15q01mHuiWOn6YQJ
	 5yvsBdmYt6ybxfrw27BUwQ1TYib7qMwtDKvbgQ5cdXpy56vN+5ec3aNCaECYkERVnH
	 IeihQpuSbNGobedNcECff8XCk4KVzLEnMM3W9h9HZ97HDQnYF+YSVjAh++U1yWPwzH
	 939F6HsplPZkE8ZHJdxHYpic9Va0LoJs7VmTyqxFRiGjRzLeuuqntdEs6uED8tLdYq
	 7+55va0oPwBfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Otto=20Pfl=C3=BCger?= <otto.pflueger@abscue.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	orsonzhai@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] mailbox: sprd: clear delivery flag before handling TX done
Date: Sun, 15 Feb 2026 12:41:16 -0500
Message-ID: <20260215174120.2390402-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215174120.2390402-1-sashal@kernel.org>
References: <20260215174120.2390402-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Otto Pflüger <otto.pflueger@abscue.de>

[ Upstream commit c77661d60d4223bf2ff10d409beb0c3b2021183b ]

If there are any pending messages in the mailbox queue, they are sent
as soon as a TX done event arrives from the driver. This may trigger a
new delivery interrupt while the previous one is still being handled.
If the delivery status is cleared after this, the interrupt is lost.
To prevent this from happening, clear the delivery status immediately
after checking it and before any new messages are sent.

Signed-off-by: Otto Pflüger <otto.pflueger@abscue.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The function is essentially identical across all versions (only a typo
"traget" → "target" changed in a separate commit). The patch will apply
cleanly to all stable trees.

## 3. Classification

**Bug type**: Race condition / lost interrupt in interrupt handler
**Category**: Driver bug fix - interrupt handling race
**Severity**: Medium-High - lost interrupts can cause mailbox
communication stalls/hangs

## 4. Scope and Risk Assessment

- **Lines changed**: 5 insertions, 5 deletions (10 line diff, but
  effectively just moving 5 lines)
- **Files touched**: 1 file only (`drivers/mailbox/sprd-mailbox.c`)
- **Risk**: Extremely low - no logic change, just reordering operations
- **Correctness**: The fix is clearly correct - the status register
  value is already captured in `fifo_sts` before clearing, so all
  subsequent reads use the captured value

## 5. User Impact

This affects users of Spreadtrum/Unisoc SoCs (primarily mobile devices
and some embedded platforms, including some Android devices). Lost
mailbox interrupts can cause:
- Communication stalls between CPU cores
- Potential system hangs if mailbox is used for critical inter-processor
  communication
- Message loss and protocol failures

## 6. Stability Indicators

- Commit by someone who clearly understands the hardware and the bug
  mechanism
- Accepted by the subsystem maintainer (Jassi Brar)
- The fix pattern (clear status before processing, not after) is a well-
  known best practice for interrupt handlers

## 7. Dependency Check

The fix has no dependencies on other commits. It modifies the same
`sprd_mbox_inbox_isr` function that has existed since the driver's
introduction in v5.8, with minimal changes in between. The patch should
apply cleanly to all stable trees containing this driver.

## Verification

- **git log** showed `sprd-mailbox.c` was introduced in commit
  `ca27fc26cd221` (v5.8)
- **git show** of the original commit confirmed the buggy pattern
  (clear-after-process) has been present since the driver's initial
  version
- **git tag --contains** confirmed the driver exists in stable trees
  (5.10.y, 5.15.y, 6.1.y, etc.)
- **Code trace**: Verified `mbox_chan_txdone()` → `tx_tick()` →
  `msg_submit()` → `send_data()` call chain in
  `drivers/mailbox/mailbox.c` confirms that `mbox_chan_txdone()` can
  trigger new message transmission (line 70:
  `chan->mbox->ops->send_data(chan, data)`)
- **Code comparison**: Verified the inbox ISR function is essentially
  unchanged between initial commit and current mainline, confirming
  clean backport
- **File read**: Confirmed current tree still has the buggy ordering
  (line 184-187 has writel after the while loop)
- The fix commit is `c77661d60d422`, 5 lines added / 5 deleted, single
  file

## Summary

This is a clear, well-understood race condition fix in an interrupt
handler. The bug causes lost mailbox interrupts when a TX completion
triggers immediate re-sending of a new message. The fix is minimal (just
reordering existing code), obviously correct, affects a single driver
file, and applies cleanly to all stable trees. It fixes a real bug that
can cause communication failures on Unisoc/Spreadtrum SoC platforms.
This is a textbook example of a good stable backport candidate.

**YES**

 drivers/mailbox/sprd-mailbox.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/sprd-mailbox.c b/drivers/mailbox/sprd-mailbox.c
index c1a5fe6cc8771..46d0c34177ab9 100644
--- a/drivers/mailbox/sprd-mailbox.c
+++ b/drivers/mailbox/sprd-mailbox.c
@@ -166,6 +166,11 @@ static irqreturn_t sprd_mbox_inbox_isr(int irq, void *data)
 		return IRQ_NONE;
 	}
 
+	/* Clear FIFO delivery and overflow status first */
+	writel(fifo_sts &
+	       (SPRD_INBOX_FIFO_DELIVER_MASK | SPRD_INBOX_FIFO_OVERLOW_MASK),
+	       priv->inbox_base + SPRD_MBOX_FIFO_RST);
+
 	while (send_sts) {
 		id = __ffs(send_sts);
 		send_sts &= (send_sts - 1);
@@ -181,11 +186,6 @@ static irqreturn_t sprd_mbox_inbox_isr(int irq, void *data)
 			mbox_chan_txdone(chan, 0);
 	}
 
-	/* Clear FIFO delivery and overflow status */
-	writel(fifo_sts &
-	       (SPRD_INBOX_FIFO_DELIVER_MASK | SPRD_INBOX_FIFO_OVERLOW_MASK),
-	       priv->inbox_base + SPRD_MBOX_FIFO_RST);
-
 	/* Clear irq status */
 	writel(SPRD_MBOX_IRQ_CLR, priv->inbox_base + SPRD_MBOX_IRQ_STS);
 
-- 
2.51.0

