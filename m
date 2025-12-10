Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F3921D3F4;
	Wed, 10 Dec 2025 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338597; cv=none; b=MbSzaKveSlRcNeicqpByFLKgI0HqinAe5QvSYIDlRwUOgKpYbNObB+DktDLjch5JmWKlhgxYjWDLlc3IiQpHYN+QMntkhRttlFfWDm0cmqvliiq+OLFrQ6V39O3Rzb6hzMzZeP7DgaRp8Eo0CzioJdCYZB7wmYoI5ejTm119S1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338597; c=relaxed/simple;
	bh=B9c4Di13C7XVEZK62c7zzFp+JvpgWm0lvIYVqsSa+uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2mxy4hA6ZM30bGSCkZ2uM2JvKFiz/GIS70NG8hOfOoPxF5rnXgRdAR8KMR2pFdLv42KpTUQMG7YH1td+oXmRqFYsnzWFxfoQ4AxX4ZgecjAVAEcecynO7Ipz1exk+TwCxDVH7lLICSObfCwl9E0wcjKrKxjF+fonXoOwkKeUsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twnX1+cR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twnX1+cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9775BC4CEF1;
	Wed, 10 Dec 2025 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338596;
	bh=B9c4Di13C7XVEZK62c7zzFp+JvpgWm0lvIYVqsSa+uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twnX1+cRG3p51CZ2Ti0MOWo2o8kqtDgjDEfMzcTSypaWQhvqWXHCL4nk/K8URk4m7
	 qBogbAxr3BUucQJKqnsU+tUXCQuEVZ7waMCBK44t8cHnpUhL1noGlLoI4o+MWSq8In
	 wClZQGshImpiKj6phjw3rJREHKJVXQI8knd13ulguTcIHgLpNf5YUGit/pks9rQvCi
	 j4R4GAMdt4A79Fc0/O0DAxlymzldjRuThgWE5GupVMveC8/lQoxR+i15RAy0MO15kV
	 0sTmctwrikZEL9i6HssBA+2zxhsHk9SCWl0cTi9FJ2brtSYocwdPZaxdAwe361iUJ2
	 fBqa4j3bjbVyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-5.10] firmware: imx: scu-irq: Init workqueue before request mbox channel
Date: Tue,  9 Dec 2025 22:48:58 -0500
Message-ID: <20251210034915.2268617-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 81fb53feb66a3aefbf6fcab73bb8d06f5b0c54ad ]

With mailbox channel requested, there is possibility that interrupts may
come in, so need to make sure the workqueue is initialized before
the queue is scheduled by mailbox rx callback.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### What the Bug Is

This commit fixes a classic **initialization race condition** in the
i.MX SCU IRQ driver. The problem is:

1. `mbox_request_channel_byname(cl, "gip3")` is called, which sets up a
   mailbox channel with `imx_scu_irq_callback` as the receive callback
2. Once the channel is established, interrupts from the System
   Controller Unit (SCU) can trigger the callback **at any time**
3. The callback (`imx_scu_irq_callback` at line 175-178) calls
   `schedule_work(&imx_sc_irq_work)`
4. **But** `INIT_WORK(&imx_sc_irq_work, ...)` was being called **after**
   the mailbox channel was requested

If an interrupt arrives in the window between
`mbox_request_channel_byname()` and `INIT_WORK()`, it would schedule an
uninitialized work struct, leading to undefined behavior, crashes, or
memory corruption in the workqueue subsystem.

### The Fix

The fix is trivially correct: move `INIT_WORK()` to **before**
`mbox_request_channel_byname()`. This ensures the work struct is
properly initialized before any callback can possibly use it.

### Bug Origin

The bug was introduced in commit `851826c7566e9` ("firmware: imx: enable
imx scu general irq function") in kernel v5.2-rc1 when this driver was
first created. The initialization order was wrong from the very
beginning.

### Stable Kernel Criteria Assessment

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Yes - classic "initialize before use" pattern |
| Fixes real bug | ✅ Yes - race condition causing potential crashes |
| Small and contained | ✅ Yes - moves one line of code |
| No new features | ✅ Correct - purely a fix |
| Tested | ✅ Has Reviewed-by from NXP engineer |
| Low risk | ✅ Cannot introduce regressions |

### Risk vs. Benefit

- **Risk**: Extremely low - the work struct must be initialized before
  use regardless of when the first interrupt arrives; moving
  initialization earlier cannot break anything
- **Benefit**: Prevents crashes on i.MX SoC platforms (used in embedded
  systems, automotive, IoT devices) where early interrupts could trigger
  the race

### Dependencies

None - this is a self-contained single-line reordering fix that should
apply cleanly to any kernel with this driver (5.2+).

### Conclusion

This is an ideal stable backport candidate. It fixes a real
initialization race condition that can cause crashes, the fix is
obviously correct (a single line moved earlier in the initialization
sequence), it's minimal and surgical, and it affects real users of i.MX
SoC platforms. The only missing element is an explicit `Cc:
stable@vger.kernel.org` tag, but the fix clearly meets all stable kernel
rules.

**YES**

 drivers/firmware/imx/imx-scu-irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/imx-scu-irq.c b/drivers/firmware/imx/imx-scu-irq.c
index 6125cccc9ba79..53bde775a1bf6 100644
--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -214,6 +214,8 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 	cl->dev = dev;
 	cl->rx_callback = imx_scu_irq_callback;
 
+	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
+
 	/* SCU general IRQ uses general interrupt channel 3 */
 	ch = mbox_request_channel_byname(cl, "gip3");
 	if (IS_ERR(ch)) {
@@ -223,8 +225,6 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 		return ret;
 	}
 
-	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
-
 	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
 				       "#mbox-cells", 0, &spec))
 		i = of_alias_get_id(spec.np, "mu");
-- 
2.51.0

