Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0088E2F39B5;
	Sun, 15 Feb 2026 17:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177287; cv=none; b=oXOF2gtTLxlPVEvrt/TleuYfoDv/HYGK3f08TUZtsASfh6iiJLr4yDwQHJgNFZFg1Shy5iBx7joyjv6mfRAtPzohsVXsj2WIGyD9EqPEnQpqxY//Drwy6TUxSYolM59h5VtZEjVMx/K18Whg15F0kAtmXDz4h7WjiNt/9XYllOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177287; c=relaxed/simple;
	bh=Onj3uK0+DVYfeYgAG9nSvweyD5qgloOkVKT5YJbRa88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HYFUEACcddGfQClPPQfuPLzjZyFHDLrC0PoMUK3QZL7TLkZWLmpZpccuF5H3J7sHS81+Khq78VReWFUX+JVKmrB39OD6nlyeF9U5g8kQec0F9XxRGwNFuZ7n6D8ATl+lvnSrcqrlwpw+JVIHj/QCdqqk7LpzufV/SP1jUi+i5w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaCVE5xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaCVE5xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B274AC4CEF7;
	Sun, 15 Feb 2026 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177286;
	bh=Onj3uK0+DVYfeYgAG9nSvweyD5qgloOkVKT5YJbRa88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaCVE5xq+92K01+7EwCkIRF+/yWgvGM0mI3lN3csy2e+BVpuIg0Rz6V+CIBohWFNX
	 1N69IBrN+cgcPcjLKEPj0/sv2IWsNNYoMT/Akz228fze4o5HCAtqSpPlHi+mFo64Hk
	 uCpGITm3IsQ3Ko01DonmGKiSbVrnen1hPYToU1VBLdZnmUI1W3Bse8nG6KpM15wUBP
	 sLbV+ri1twVD/goNf3gd8X8KfieW6AxvRv2qNODjuWjvUaRsQib6aIRlK8E+lFBSL4
	 reqtbCNSWL6Dpp4xPQ1HZ9wEhQICRZlaJUWDG9WInRBn5Yn2WCEq6RHeC7o7VjcjRb
	 u2KgBz301B98w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Li@nxp.com,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.1] mailbox: imx: Skip the suspend flag for i.MX7ULP
Date: Sun, 15 Feb 2026 12:41:12 -0500
Message-ID: <20260215174120.2390402-4-sashal@kernel.org>
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

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit 673b570825ace0dcb2ac0c676080559d505c6f40 ]

In current imx-mailbox driver, the MU IRQ is configured with
'IRQF_NO_SUSPEND' flag set. So during linux suspend/resume flow,
the MU IRQ is always enabled. With commit 892cb524ae8a ("mailbox: imx:
fix wakeup failure from freeze mode"), if the MU IRQ is triggered after
the priv->suspended flag has been set, the system suspend will be
aborted.

On i.MX7ULP platform, certain drivers that depend on rpmsg may need
to send rpmsg request and receive an acknowledgment from the remote
core during the late_suspend stage. Early suspend abort is not
expected, and the i.MX7ULP already has additional hardware and
software to make sure the system can be wakeup from freeze mode
correctly when MU IRQ is trigger.

Skip the 'suspend' flag handling logic on i.MX7ULP to avoid the
early abort when doing suspend.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I understand the full picture:

1. Commit 892cb524ae8a added `priv->suspend` flag and
   `pm_system_wakeup()` call in the ISR to handle freeze mode wakeup.
2. `pm_system_wakeup()` aborts the ongoing suspend process.
3. On i.MX7ULP, during `late_suspend`, drivers send rpmsg to the remote
   core and expect a response. This triggers the MU IRQ, which in turn
   calls `pm_system_wakeup()` and aborts suspend — an undesirable
   behavior on this platform.
4. The fix adds a per-platform flag `skip_suspend_flag` to skip the
   suspend flag logic for i.MX7ULP, which has its own hardware
   mechanisms for handling wakeup.

### Stable Kernel Assessment

**Bug severity**: This is a **suspend failure** on i.MX7ULP — the system
cannot properly enter suspend/freeze mode. This is a significant
functional regression for i.MX7ULP users caused by commit 892cb524ae8a.

**Fix quality**:
- Small, contained (adds 1 bool field + 1 config line + 2 conditional
  checks)
- Platform-specific — only affects i.MX7ULP; all other platforms are
  unchanged
- Low regression risk — it simply disables a feature that was causing
  problems on this specific platform
- Reviewed by Peng Fan (NXP maintainer)

**Fits stable criteria**:
- Fixes a real bug (suspend failure)
- Small and contained
- Obviously correct
- Platform-specific quirk/workaround — this falls squarely in the
  "hardware quirk" category

**Dependencies**: Requires commit 892cb524ae8a ("mailbox: imx: fix
wakeup failure from freeze mode") to be present. That commit is in
v5.18+, so applicable stable trees (6.1.y, 6.6.y, 6.12.y) all have it.

**Risk**: Very low. The change only affects the i.MX7ULP platform and
simply skips suspend flag logic that was causing problems. If the bool
field is false (default for all other platforms), behavior is completely
unchanged.

### Verification

- **git show 892cb524ae8a**: Verified that commit introduced the
  `priv->suspend` flag and `pm_system_wakeup()` call in `imx_mu_isr()`,
  confirming the mechanism described in the commit message.
- **git tag --contains 892cb524ae8a**: Confirmed the prerequisite commit
  is in v5.18+, so all active LTS trees (6.1.y, 6.6.y, 6.12.y) contain
  it.
- **git tag --contains 673b570825ace**: Confirmed the commit under
  review is post-v6.19 (in development tree).
- **Grep for `priv->suspend`**: Verified the ISR check at line 564 —
  when suspend flag is set and MU IRQ fires, `pm_system_wakeup()` is
  called, which aborts suspend.
- **Code review of diff**: Verified only i.MX7ULP config gets
  `skip_suspend_flag = true`; all other platform configs default to
  false (zero-initialized), so behavior is unchanged for non-i.MX7ULP
  platforms.
- **Unverified**: Cannot directly verify user reports of suspend failure
  on i.MX7ULP, but the commit message clearly describes the mechanism
  and the author is from NXP (the SoC vendor).

### Conclusion

This is a platform-specific hardware workaround that fixes suspend
failure on i.MX7ULP. It's small, well-scoped, reviewed by the subsystem
maintainer, and has essentially zero regression risk for other
platforms. It fits the "hardware quirk" exception category for stable
backports. The prerequisite commit exists in all active LTS trees.

**YES**

 drivers/mailbox/imx-mailbox.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 6778afc64a048..003f9236c35e0 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -122,6 +122,7 @@ struct imx_mu_dcfg {
 	u32	xRR;		/* Receive Register0 */
 	u32	xSR[IMX_MU_xSR_MAX];	/* Status Registers */
 	u32	xCR[IMX_MU_xCR_MAX];	/* Control Registers */
+	bool	skip_suspend_flag;
 };
 
 #define IMX_MU_xSR_GIPn(type, x) (type & IMX_MU_V2 ? BIT(x) : BIT(28 + (3 - (x))))
@@ -988,6 +989,7 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx7ulp = {
 	.xRR	= 0x40,
 	.xSR	= {0x60, 0x60, 0x60, 0x60},
 	.xCR	= {0x64, 0x64, 0x64, 0x64, 0x64},
+	.skip_suspend_flag = true,
 };
 
 static const struct imx_mu_dcfg imx_mu_cfg_imx8ulp = {
@@ -1071,7 +1073,8 @@ static int __maybe_unused imx_mu_suspend_noirq(struct device *dev)
 			priv->xcr[i] = imx_mu_read(priv, priv->dcfg->xCR[i]);
 	}
 
-	priv->suspend = true;
+	if (!priv->dcfg->skip_suspend_flag)
+		priv->suspend = true;
 
 	return 0;
 }
@@ -1094,7 +1097,8 @@ static int __maybe_unused imx_mu_resume_noirq(struct device *dev)
 			imx_mu_write(priv, priv->xcr[i], priv->dcfg->xCR[i]);
 	}
 
-	priv->suspend = false;
+	if (!priv->dcfg->skip_suspend_flag)
+		priv->suspend = false;
 
 	return 0;
 }
-- 
2.51.0

