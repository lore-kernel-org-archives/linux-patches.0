Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51B63043C3;
	Sat, 25 Oct 2025 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409616; cv=none; b=JAfEn+krEo7nSxthFyoBp0C/zWLjYUzw+j8rznsK4Zcm4tMbGp+lkKYZTjfRGmKwmny1i+N/WTKHS/0cCYs6u8gZF8vooYz7zYWo0VNGHq/IRT9LU4NT8NSWbBHnztvQch5lLPr2ydPcTIvfQIZ0tSWAp/t6lDj2G9FGIn+sIQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409616; c=relaxed/simple;
	bh=CAAk3gHXalDR00ODyyfY7Sqie6YTQpskynNVq6gGl6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LYBA6/9U/CchfbppvMmqgbMQbTMjhYSIw31qqTc/TDM3kUpyfiSEXjv0+YmD/9NjWBqedfGY6I9TUA0SZVY/uaZbA8cer3G1xH5O4gtrx5iLQg6Q+SHfTtpr34UgK9uy877AnHHhJGEQBefAMU7Ng2jnem1+Iy8HDgyZX7BmRSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/fVUF0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/fVUF0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18752C4CEF5;
	Sat, 25 Oct 2025 16:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409616;
	bh=CAAk3gHXalDR00ODyyfY7Sqie6YTQpskynNVq6gGl6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/fVUF0EsMn+JG4ymrToaq5xoKvNjXClJW8tp7v4YA3t+Nf68iYaEbxzHgDWp2i+L
	 +wfn+PBJ7bptWR7p44lIxyI1iNxGDMkXqtF1A2M82vXuo9Rze516UwiA+yKwtQiLNM
	 exm/EQPDToUXWkd4TrPl+oawgDZfysGQYZSdQHQbzwGxQYZO6m02rMncV4Sg+tzx6X
	 RpW2rX72kS0SFeo6mZRlSDinu14WqMnlCDH5UwiHxCNP5dIQVswSVqBDAdDNcL04Nz
	 +8nuy9ITEzdvUYTRh9xVWsdeBS8S7KcQFRXanl/UKROPaCzQ3b+TOyDoP695rIgMh2
	 R/SMPynaFjNNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ecree.xilinx@gmail.com,
	jdamato@fastly.com,
	gal@nvidia.com,
	dxu@dxuuu.xyz,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] selftests: drv-net: rss_ctx: fix the queue count check
Date: Sat, 25 Oct 2025 12:00:25 -0400
Message-ID: <20251025160905.3857885-394-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c158b5a570a188b990ef10ded172b8b93e737826 ]

Commit 0d6ccfe6b319 ("selftests: drv-net: rss_ctx: check for all-zero keys")
added a skip exception if NIC has fewer than 3 queues enabled,
but it's just constructing the object, it's not actually rising
this exception.

Before:

  # Exception| net.lib.py.utils.CmdExitFailure: Command failed: ethtool -X enp1s0 equal 3 hkey d1:cc:77:47:9d:ea:15:f2:b9:6c:ef:68:62:c0:45:d5:b0:99:7d:cf:29:53:40:06:3d:8e:b9:bc:d4:70:89:b8:8d:59:04:ea:a9:c2:21:b3:55:b8:ab:6b:d9:48:b4:bd:4c:ff:a5:f0:a8:c2
  not ok 1 rss_ctx.test_rss_key_indir

After:

  ok 1 rss_ctx.test_rss_key_indir # SKIP Device has fewer than 3 queues (or doesn't support queue stats)

Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250827173558.3259072-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: In
  `tools/testing/selftests/drivers/net/hw/rss_ctx.py:121`,
  `test_rss_key_indir()` used to instantiate `KsftSkipEx(...)` without
  raising it. That meant the test didn’t actually skip when the device
  had fewer than 3 RX queues and proceeded to run `ethtool -X ... equal
  3 ...`, causing a failure on such hardware. The patch changes that
  line to `raise KsftSkipEx("Device has fewer than 3 queues (or doesn't
  support queue stats)")`, correctly converting the intended skip into
  an actual skip.
- Exact change: In
  `tools/testing/selftests/drivers/net/hw/rss_ctx.py:121`, replace a
  bare `KsftSkipEx(...)` construction with `raise KsftSkipEx(...)`.
- Impacted flow: `test_rss_key_indir()` computes `qcnt =
  len(_get_rx_cnts(cfg))` and then checks `if qcnt < 3`. Previously,
  because the exception wasn’t raised, the function continued into
  operations that require at least 3 queues (e.g., `ethtool(f"-X
  {cfg.ifname} equal 3 hkey ...")`,
  `tools/testing/selftests/drivers/net/hw/rss_ctx.py:143`), yielding
  spurious failures on devices with <3 queues.
- User-visible failure mode: Matches the commit message’s “Before” case
  where `ethtool -X ... equal 3 ...` fails due to insufficient queues
  instead of the test printing a TAP SKIP.
- Correctness with harness: Raising `KsftSkipEx` is the established
  mechanism for skipping tests; the ksft runner handles it and prints
  “ok ... # SKIP ...” (see
  `tools/testing/selftests/net/lib/py/ksft.py:255`, which catches
  `KsftSkipEx` and produces a SKIP result). The fix aligns `rss_ctx.py`
  with that contract.
- Consistency with other tests: Numerous selftests use `raise
  KsftSkipEx(...)` for capability-based skips, e.g.
  `tools/testing/selftests/drivers/net/stats.py:34` and
  `tools/testing/selftests/drivers/net/hw/rss_api.py:21`. The change in
  `rss_ctx.py` brings it in line with common practice across the tree.
- Scope and risk: Single-line change in selftests only; no kernel code
  or ABI touched. Very low regression risk and no side effects on
  runtime or API.
- Containment: Only affects the `drv-net` selftest path and only the
  behavior when devices have <3 queues (or when qstats-based queue
  enumeration leads to that conclusion). It does not alter any test
  logic beyond ensuring the intended early skip is actually executed.
- No architectural changes: The patch does not introduce new features or
  rework logic—just corrects an exception handling mistake.
- Stable criteria fit:
  - Fixes a real bug in the selftest (false failures on common hardware
    configurations).
  - Minimal, targeted change with negligible risk.
  - Improves CI/test reliability for stable users without affecting the
    kernel.
  - No new dependencies or features.
- Security considerations: None—selftests only; no exposure to kernel
  paths or privilege boundaries.
- Backport breadth: Safe to apply to maintained stable trees that
  include `tools/testing/selftests/drivers/net/hw/rss_ctx.py` and the
  ksft Python harness (which already defines and handles `KsftSkipEx` as
  seen in `tools/testing/selftests/net/lib/py/ksft.py:22` and
  `tools/testing/selftests/net/lib/py/ksft.py:255`).
- Note on commit message: There’s no Fixes tag, but the rationale and
  diff are clear and meet stable rules for a small, correctness-only
  test fix.

 tools/testing/selftests/drivers/net/hw/rss_ctx.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/rss_ctx.py b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
index 7bb552f8b1826..9838b8457e5a6 100755
--- a/tools/testing/selftests/drivers/net/hw/rss_ctx.py
+++ b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
@@ -118,7 +118,7 @@ def test_rss_key_indir(cfg):
 
     qcnt = len(_get_rx_cnts(cfg))
     if qcnt < 3:
-        KsftSkipEx("Device has fewer than 3 queues (or doesn't support queue stats)")
+        raise KsftSkipEx("Device has fewer than 3 queues (or doesn't support queue stats)")
 
     data = get_rss(cfg)
     want_keys = ['rss-hash-key', 'rss-hash-function', 'rss-indirection-table']
-- 
2.51.0

