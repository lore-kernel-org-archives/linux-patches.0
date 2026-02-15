Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51702F290E;
	Sun, 15 Feb 2026 17:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177285; cv=none; b=l/ugQG7b06sgLQH1RQ0UE1/zrpm5yGWJyBUmVOxVmHMQtqdO4OtdtuAPaoZEFjRMtemixfnPFEMUGSRuDFYVHAkWMieajfhXld9dRpIvX1h24Aq4qcJt3nbJGkNyB6UtZIj5axtgRxPmWGnmIz84VSPvnItgcbkJ44TfnLzdh/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177285; c=relaxed/simple;
	bh=pYnGs/3Blk+Jl+2IOlkkNoJYHPaKrmAvSWEFOYdnE0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bld7chGJv6qnhN2qoJ5YuLw7qhKZtqGeQIY/pBeni5XmRGHDViL1QyQgIX7au2KPZcXugX7XdrpTFK9eCkF5qrwNZduCL/N8cXib0ls8Vb3p8q2l2ZJ43O13rhYXaRZBQRX5qM4KnZbmoE/rDgoSRRKSR1DUabLa/6mEzOjqiwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFJ1BYwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFJ1BYwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DD8C19423;
	Sun, 15 Feb 2026 17:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177285;
	bh=pYnGs/3Blk+Jl+2IOlkkNoJYHPaKrmAvSWEFOYdnE0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFJ1BYwxkmB/AlWSQPrpNdENeVqYdPWF4kiA8y04Gf/FeuwRTNrA27BpUDBxNIOEV
	 jOguxLOINITTtdPbQXLhPmfgBsvATr2hATPboQvKlP+Y4bMyoaKji5QSrzpqDONzMW
	 kG3miW7W0lIXcyb9gB/DpZ7MmugkvcRzSTZ5Yb9d3O9dRimSebxtw4tizTColrHG9P
	 meVUIh4w/w2lQWAvbhN7hHIEzCS3EpEhJkmS/SFLtApOXJPNuN06BcZv/31xYfpcLC
	 CZBgO2/zyBPEoBQEwjRxjmHZ+cXJVf3GIvWr9/+dwo4SZugjQVyA/me2WeOk+8DIsp
	 //xYH1xUCeEMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	andersson@kernel.org,
	Frank.Li@nxp.com,
	linux-remoteproc@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.1] remoteproc: imx_dsp_rproc: Skip RP_MBOX_SUSPEND_SYSTEM when mailbox TX channel is uninitialized
Date: Sun, 15 Feb 2026 12:41:11 -0500
Message-ID: <20260215174120.2390402-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215174120.2390402-1-sashal@kernel.org>
References: <20260215174120.2390402-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Iuliana Prodan <iuliana.prodan@nxp.com>

[ Upstream commit d62e0e92e589c53c4320ed5914af5fe103f5ce7e ]

Firmwares that do not use mailbox communication (e.g., the hello_world
sample) leave priv->tx_ch as NULL. The current suspend logic
unconditionally sends RP_MBOX_SUSPEND_SYSTEM, which is invalid without
an initialized TX channel.

Detect the no_mailboxes case early and skip sending the suspend
message. Instead, proceed directly to the runtime PM suspend path,
which is the correct behavior for firmwares that cannot respond to
mailbox requests.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/20251204122825.756106-1-iuliana.prodan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So `no_mailboxes` was introduced in v6.4. This means the bug only
affects kernels v6.4+. Let me check which stable trees are currently
maintained.

Now let me understand the actual bug severity more precisely. From the
code analysis:

1. When `no_mailboxes=1` is set, `imx_dsp_rproc_mbox_no_alloc()` is
   used, which is a no-op — `priv->tx_ch` stays NULL.
2. During suspend, `imx_dsp_suspend()` calls
   `mbox_send_message(priv->tx_ch, ...)` where `priv->tx_ch` is NULL.
3. `mbox_send_message()` checks `if (!chan || !chan->cl)` and returns
   `-EINVAL` — so it **does NOT crash**.
4. However, the return value is `-EINVAL` (negative), so the error path
   is taken: `dev_err()` is printed and the function returns the error
   code.
5. This causes **suspend to fail** with an error, which means the system
   **cannot suspend** when using `no_mailboxes` mode.

This is a real functional bug — suspend is broken when the
`no_mailboxes` module parameter is used. It won't crash, but it prevents
the system from suspending, which is a significant issue for
embedded/power-managed systems.

## Summary of Analysis

### What the commit fixes
When the `no_mailboxes` module parameter is set (firmware doesn't use
mailbox communication), `priv->tx_ch` remains NULL. The suspend function
`imx_dsp_suspend()` unconditionally tries to send a message via the
mailbox TX channel, which fails with `-EINVAL` when the channel is NULL.
This causes **system suspend to fail** for all users of the
`no_mailboxes` configuration.

The fix adds a NULL check for `priv->tx_ch` before the
`mbox_send_message()` call, skipping the mailbox communication and going
directly to the PM runtime suspend path — which is the correct behavior
for firmwares that don't use mailbox.

### Stable kernel criteria assessment
1. **Obviously correct and tested**: Yes — a simple NULL check that
   mirrors the existing pattern in `imx_dsp_rproc_kick()` (line 764).
   Signed off by the NXP developer and the remoteproc maintainer.
2. **Fixes a real bug**: Yes — suspend is broken when `no_mailboxes=1`.
3. **Important issue**: Moderate — it prevents system suspend for
   affected configurations (embedded i.MX DSP users with no-mailbox
   firmwares). On embedded/battery-powered devices, inability to suspend
   is a significant problem.
4. **Small and contained**: Yes — 9 lines added (NULL check + comment +
   debug message), single file, single function.
5. **No new features**: Correct — this is purely a bug fix.

### Risk assessment
- **Very low risk**: The added NULL check only triggers when
  `priv->tx_ch` is NULL (the no-mailbox case). It has zero impact on the
  normal mailbox path.
- The pattern is already established in the same driver
  (`imx_dsp_rproc_kick()` at line 764).
- The fix is self-contained with no dependencies on other patches.

### Affected versions
The `no_mailboxes` module parameter was introduced in commit
`11bb42a94648a` which landed in v6.4. The bug exists from v6.4 onwards.
Currently maintained stable trees v6.6.y and v6.12.y would both be
affected.

### Verification
- **Verified**: `mbox_send_message()` in `drivers/mailbox/mailbox.c:249`
  returns `-EINVAL` when `chan` is NULL (not a crash, but causes suspend
  failure since the error is propagated).
- **Verified**: `priv->tx_ch` starts as NULL (zeroed by
  `devm_rproc_alloc`) and remains NULL when
  `imx_dsp_rproc_mbox_no_alloc()` is used (it's a no-op, confirmed at
  line 635-638).
- **Verified**: `no_mailboxes` module parameter was introduced in commit
  `11bb42a94648a` (v6.4 cycle), confirmed via `git log -S
  "no_mailboxes"`.
- **Verified**: The existing `imx_dsp_rproc_kick()` function already has
  an identical defensive NULL check for `priv->tx_ch` at line 764,
  confirming the fix pattern is established.
- **Verified**: The `imx_dsp_suspend()` function returns the error from
  `mbox_send_message()` (line 1251), so a `-EINVAL` return causes
  suspend to fail entirely.
- **Verified**: The driver was introduced in `ec0e5549f3586d` (Oct 2021,
  v5.16 cycle), so it exists in multiple stable trees.
- **Verified**: The patch was reviewed and merged by remoteproc
  maintainer Mathieu Poirier, with a Link to the mailing list
  discussion.

This is a clean, small, obviously correct bug fix for a real problem
(broken suspend) in a specific but important use case (no-mailbox
firmware on i.MX DSP). It follows an established pattern in the same
driver and has very low regression risk.

**YES**

 drivers/remoteproc/imx_dsp_rproc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index 5130a35214c92..f51deaacc7008 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -1242,6 +1242,15 @@ static int imx_dsp_suspend(struct device *dev)
 	if (rproc->state != RPROC_RUNNING)
 		goto out;
 
+	/*
+	 * No channel available for sending messages;
+	 * indicates no mailboxes present, so trigger PM runtime suspend
+	 */
+	if (!priv->tx_ch) {
+		dev_dbg(dev, "No initialized mbox tx channel, suspend directly.\n");
+		goto out;
+	}
+
 	reinit_completion(&priv->pm_comp);
 
 	/* Tell DSP that suspend is happening */
-- 
2.51.0

