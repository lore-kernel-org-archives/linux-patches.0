Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B7559A1E4;
	Mon, 19 Oct 2026 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418355; cv=none; b=tttWtuQ2jWAR1FJJXC3qTHe6WS77bb4jE2cjB9ensaCY6JB/YNoK59qZt46R/kWpgGbo38Ur7oELoPNtV4v83jqc1P0xxaT4rFETYOqtvOPKq+yXrZB9ZJmmjS/vTNt+pSH+WXslT9kep7WVwveoS4DbqbuxtEci2pce/gvyQmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418355; c=relaxed/simple;
	bh=4v+Q+yf40A3JrQnzEe04WecvtS4tmrTkKXvwJlcREuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ec7Lc1ZXg7w27I6PhQw9xYONA+jUn0mhPt6ekeHW6tQtGSMen9Uzwgflj2Hcx/P/b3+5oY/I42t3CXdNzs/KJIs+lpRXK7JOYwZ4qm/Do5uZSu/rY0QefmTeEGMJ3zfqiMS/tTAqyFyu/JdH4MOdxVFsPDYykZVC47vmDgNILDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmxiUX3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmxiUX3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3923D1F000C8;
	Mon, 19 Oct 2026 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418353;
	bh=HSVvtdLhyfDEZ79n3urAObHOsfBV/iJhpsAYZse2t9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmxiUX3P/tDS/GIfd+7VK8+kEcTdPkXp4Ic6PtRhAoFdb2E4pey3UveJt8i+Go8VG
	 BdnjK1ne5u4oUglRPMiRh+Khq9MYvYRDl3cu5xJDXZTwp8wL7nWdjXbgk0grm/k27P
	 aStxXZj6+6mBL1M2LURduRo0CFGQkAE86Wkasem1DrpBEHXt6jiTFelcRtgZ1CD4Eq
	 in65GVglRUnPPJvjNzfevipqFMKhu42Ct9+7+CX3gd1wSCCsr8cs8jyHNNXXKfAIpP
	 Fsb6bkawo1BttC1yLYsgPHhn6AIY9bI867lEjzgux//25MbL62DwpukdUdYLyhXeWR
	 QMSgtrlSjUBNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] spi: qpic-snand: free OOB buffer with ECC context
Date: Mon, 19 Oct 2026 09:47:58 -0400
Message-ID: <20261019135441.1420968-187-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5504e50ffbcf97b3b6ed3740532497922c96a1f1 ]

qcom_spi_ecc_init_ctx_pipelined() allocates qspi->oob_buf as part of the
pipelined ECC context setup. The buffer is then used by the raw and ECC
page I/O paths through the NAND ECC context.

The matching cleanup callback only frees the qpic_ecc structure, and the
init error path also skips the OOB buffer after it has been allocated.
Free qspi->oob_buf on both paths and clear the pointer so the ECC context
teardown owns all resources allocated during init.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260616151129.76060-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[spi/qpic-snand] [free] free OOB buffer with ECC context`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Link:
  https://patch.msgid.link/20260616151129.76060-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (SPI maintainer)
- Pipeline-only tags ignored: `[Upstream commit 5504e50ffbcf…]`,
  `Signed-off-by: Sasha Levin`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable` (absence expected)

**Step 1.3 — Body**
Record: `qcom_spi_ecc_init_ctx_pipelined()` allocates `qspi->oob_buf`.
Cleanup only frees `qpic_ecc`. Init error path after allocation also
skips the OOB buffer. Symptom: leaked kmalloc buffer on ECC teardown and
on init failure after the buffer exists. Root cause: allocation is not
owned by the ECC cleanup/error path.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised. Explicit resource-leak fix (`free` / missing
`kfree`).

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: `drivers/spi/spi-qpic-snand.c` only; **+5 / −1**. Functions:
`qcom_spi_ecc_init_ctx_pipelined`, `qcom_spi_ecc_cleanup_ctx_pipelined`.
Single-file surgical fix. Trailing newline at EOF removed (harmless).

**Step 2.2 — Flow**
Record:
- **err_free_ecc_cfg:** previously `kfree(ecc_cfg)` only → also
  `kfree(oob_buf)` and NULL it. Covers failures after `kmalloc` (notably
  `qcom_alloc_bam_transaction()` `-ENOMEM`) and is a no-op if `oob_buf`
  is still NULL.
- **cleanup_ctx:** previously only `kfree(ecc_cfg)` → get `snandc` via
  `nand_to_qcom_snand()`, free `oob_buf`, NULL it, then free `ecc_cfg`.

**Step 2.3 — Bug mechanism**
Record: **resource leak**. `oob_buf` is `kmalloc(mtd->writesize +
mtd->oobsize)` (typically a few KB). `qspi` itself is `devm_kzalloc`, so
the buffer is **not** device-managed. `nanddev_find_ecc_configuration()`
does **not** call `cleanup_ctx` when `init_ctx` fails, so the error-path
`kfree` is required. Successful attach then `spinand_cleanup()` / probe-
error after ECC init also leak without the cleanup change.

**Step 2.4 — Fix quality**
Record: Obviously correct. `kfree(NULL)` is safe because `qspi` is
zeroed in probe (`devm_kzalloc`). NULLing after free avoids a later
double-free if cleanup runs after the error path. Regression risk is
very low: no locking, API, or I/O-path change. `QPIC_QSPI_NUM_CS` is 1,
so no multi-chip sharing of `oob_buf`.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Driver added in `7304d1909080` (2025-02-24, Md Sadre Alam):
allocated `oob_buf` in init and never freed it in cleanup.
`d450cdd9c4398` (2025-03) only freed `ecc_cfg` when OOB alloc failed.
`65cb56d49f6ede` (in v6.18.53) unified `err_free_ecc_cfg` still only
`kfree(ecc_cfg)`. Bug present since the driver landed.

**Step 3.2 — Fixes: tag**
Record: None. Introducer is `7304d1909080`; `git merge-base --is-
ancestor 7304d1909080 v6.18.53` → yes. The earlier leak fix
`d450cdd9c4398` is also in v6.18.53 and is incomplete for `oob_buf`.

**Step 3.3 — File history**
Record: Related: `d450cdd9c4398` (ecc_cfg leak), `f48d805035042`
(kzalloc→kmalloc; still no free). Standalone; not `N/M`. Later autosel
commits (quad mode, ECC strength) are not prerequisites.

**Step 3.4 — Author**
Record: Pengpeng Hou has this one SPI qpic commit here; not the original
driver author. SPI maintainer Mark Brown applied it to `spi/for-7.3`.

**Step 3.5 — Dependencies**
Record: Needs `nand_to_qcom_snand()`, `qspi->oob_buf`,
`err_free_ecc_cfg`, and `qcom_spi_ecc_cleanup_ctx_pipelined()`. All
exist in v6.18.53. Standalone.

## Phase 4: Mailing list

**Step 4.1**
Record: `b4 dig -c 5504e50ffbcf` →
https://patch.msgid.link/20260616151129.76060-1-pengpeng@iscas.ac.cn
`b4 dig -a`: **v1 only**. Thread: author submission + Mark Brown
“Applied to … for-7.3”. No NAK, no requested respin.

**Step 4.2**
Record: `b4 dig -w`: To Mark Brown; Cc linux-spi, linux-kernel.
Maintainer applied it.

**Step 4.3**
Record: No bugzilla/syzbot. Leak found by code inspection.

**Step 4.4**
Record: Single-patch series, self-contained.

**Step 4.5**
Record: **UNVERIFIED** — lore.kernel.org/stable blocked by Anubis (403).
No local evidence this was rejected for stable.

## Phase 5: Semantic analysis

**Step 5.1**
Record: `qcom_spi_ecc_init_ctx_pipelined`,
`qcom_spi_ecc_cleanup_ctx_pipelined`.

**Step 5.2**
Record: Wired as `.init_ctx` / `.cleanup_ctx` on
`qcom_spi_ecc_engine_ops_pipelined`. Call chain: `nand_ecc_init_ctx` /
`nand_ecc_cleanup_ctx` → `nanddev_ecc_engine_init` /
`nanddev_ecc_engine_cleanup` → `spinand_init` error paths and
`spinand_cleanup` from `spinand_probe` failure and `spinand_remove`.

**Step 5.3**
Record: Init: `kzalloc(ecc_cfg)`, `kmalloc(oob_buf)`,
`qcom_free_bam_transaction` / `qcom_alloc_bam_transaction`. Cleanup:
`kfree` only.

**Step 5.4**
Record: Reachable on Qualcomm IPQ9574 SPI-NAND attach/detach (boot
device on many boards). Unprivileged userspace cannot typically unbind
without privilege; leak still hits rmmod, unbind, and failed probe after
ECC init.

**Step 5.5**
Record: Same driver’s earlier `ecc_cfg` leak (`d450cdd9c4398`) used the
same pattern. `data_buf` is an op pointer, not a matching leak. MTK SNFI
cleanup only frees its ecc cfg (different allocation model).

## Phase 6: This tree (v6.18.53 / 6.18.y)

**Step 6.1**
Record: `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`. `make
kernelversion` → 6.18.53.
`git merge-base --is-ancestor f320c3a8b1119 v6.18.53` → **NO** (not in
baseline).
v6.18.53 still has:
```
err_free_ecc_cfg:
        kfree(ecc_cfg);
        return ret;
…
static void qcom_spi_ecc_cleanup_ctx_pipelined(...)
{
        struct qpic_ecc *ecc_cfg = nand_to_ecc_ctx(nand);
        kfree(ecc_cfg);
}
```
and still allocates `snandc->qspi->oob_buf`. Driver is in v6.18
(`7304d1909080` is an ancestor of `v6.18`).

**Step 6.2**
Record: `patch --dry-run` of this diff onto v6.18.53’s file: **clean
apply**. Context around `err_free_ecc_cfg` / cleanup matches.

**Step 6.3**
Record: Incomplete leak fix `d450cdd9c4398` is already here; it does not
free `oob_buf`. No other equivalent fix in v6.18.53.

## Phase 7: Subsystem

**Step 7.1**
Record: `drivers/spi` QPIC SPI-NAND (`CONFIG_SPI_QPIC_SNAND`,
`ARCH_QCOM`). Compatible `qcom,ipq9574-snand`. **PERIPHERAL** but real
embedded/router hardware; NAND is often boot/rootfs.

**Step 7.2**
Record: Active in 6.16–6.18 (ECC validation, BAM txn, 8-bit ECC,
unregister-on-remove). Leak is original, not a new-code regression.

## Phase 8: Impact and risk

**Step 8.1**
Record: Qualcomm IPQ9574 QPIC SPI-NAND users only.

**Step 8.2**
Record: Triggers: (1) `init_ctx` failure after `kmalloc` (BAM realloc
`-ENOMEM`) — cleanup not called; (2) later `spinand_init` failure; (3)
`spinand_remove` / unbind / rmmod. Not a hot-path unbounded leak. Not
unprivileged.

**Step 8.3**
Record: Failure mode: leaked page-sized+OOB kmalloc. Severity **MEDIUM**
(not oops/corruption; real leak on teardown and some probe errors).

**Step 8.4**
Record: Benefit: medium for this hardware (correct lifetime of ECC-init
allocations; matches prior leak fix in the same function). Risk: **very
low** (5 lines, `kfree`+NULL). Ratio favors backport.

## Phase 9: Synthesis

**For:** Real `kmalloc` leak in this 6.18 tree; error path cannot rely
on cleanup; 5-line obviously correct fix; applies cleanly; no new API;
maintainer accepted v1; same class as `d450cdd9c4398` already in 6.18.

**Against:** Not a crash/security issue; no reporter; driver is
Qualcomm-specific; leak is small and not a hot-path OOM.

**Unresolved:** Stable-list discussion (lore blocked).

**Stable rules:**
1. Obviously correct and tested? **PASS** — `kfree`/`NULL`; maintainer
   applied v1.
2. Real user-visible bug? **PASS** — leak on probe-error and remove for
   IPQ9574 SPI-NAND.
3. Important? **PASS** — resource leak on teardown/error; same pattern
   routinely taken for stable (not a crash; still a real leak of non-
   devm memory).
4. Small/contained? **PASS** — 5 lines, one file.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — clean on v6.18.53.

**Exception category:** none (ordinary leak fix).

This tree is **6.18.y**. The buggy allocation and missing free are
present. The patch is a minimal, correct leak fix with negligible
regression risk.

### What it solves for stable users
On IPQ9574 QPIC SPI-NAND, ECC init allocates an OOB scratch buffer that
is never freed. Failed attach after that allocation, and every
unbind/rmmod, leaks that buffer. 6.18 already had a partial leak fix for
`ecc_cfg` only.

### Risk vs benefit
Benefit is a real leak fix for in-tree hardware. Risk is a handful of
`kfree`s on error/teardown.

---

Verification:
- [Phase 1] Subject/tags: free OOB buffer; SOB Hou + Brown; Link msgid;
  no Fixes/Reported-by
- [Phase 2] Diff: +5/−1 in `spi-qpic-snand.c`; `kfree(oob_buf)` + NULL
  on `err_free_ecc_cfg` and cleanup
- [Phase 2] v6.18.53 still lacks those `kfree`s;
  `kmalloc(writesize+oobsize)` present
- [Phase 2] `qspi = devm_kzalloc` at probe → `oob_buf` starts NULL;
  `kfree(NULL)` safe
- [Phase 3] Introducer `7304d1909080` is ancestor of v6.18 and v6.18.53
- [Phase 3] `d450cdd9c4398` in v6.18.53 frees only `ecc_cfg` on OOB
  alloc failure
- [Phase 3] `65cb56d49f6ede` in v6.18.53; `err_free_ecc_cfg` still only
  frees `ecc_cfg`
- [Phase 3] Candidate `f320c3a8b1119` is **not** an ancestor of v6.18.53
- [Phase 4] `b4 dig`: lore thread, v1 only; Brown applied to
  spi/for-7.3; no NAK
- [Phase 4] WebFetch lore/msgid 403; curl lore/stable hit Anubis —
  UNVERIFIED stable-list history
- [Phase 5] Callers: `nand_ecc_cleanup_ctx` →
  `nanddev_ecc_engine_cleanup` → `spinand_cleanup` (probe err + remove)
- [Phase 5] `nanddev_find_ecc_configuration()` returns on `init_ctx`
  failure **without** `cleanup_ctx`
- [Phase 5] `QPIC_QSPI_NUM_CS` is 1
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb;
  kernelversion 6.18.53
- [Phase 6] `patch --dry-run` onto v6.18.53 file: success
- [Phase 6] `nand_to_qcom_snand()` exists in v6.18.53
- [Phase 7] `CONFIG_SPI_QPIC_SNAND` depends on `ARCH_QCOM`; OF
  `qcom,ipq9574-snand`
- [Phase 8] Failure: kmalloc leak, MEDIUM; not oops/corruption
- UNVERIFIED: whether linux-stable ever discussed this patch (lore
  blocked)

**YES**

 drivers/spi/spi-qpic-snand.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 222e4aa7ee488..919e847c061db 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -394,14 +394,19 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 	return 0;
 
 err_free_ecc_cfg:
+	kfree(snandc->qspi->oob_buf);
+	snandc->qspi->oob_buf = NULL;
 	kfree(ecc_cfg);
 	return ret;
 }
 
 static void qcom_spi_ecc_cleanup_ctx_pipelined(struct nand_device *nand)
 {
+	struct qcom_nand_controller *snandc = nand_to_qcom_snand(nand);
 	struct qpic_ecc *ecc_cfg = nand_to_ecc_ctx(nand);
 
+	kfree(snandc->qspi->oob_buf);
+	snandc->qspi->oob_buf = NULL;
 	kfree(ecc_cfg);
 }
 
@@ -1660,4 +1665,3 @@ module_platform_driver(qcom_spi_driver);
 MODULE_DESCRIPTION("SPI driver for QPIC QSPI cores");
 MODULE_AUTHOR("Md Sadre Alam <quic_mdalam@quicinc.com>");
 MODULE_LICENSE("GPL");
-
-- 
2.53.0

