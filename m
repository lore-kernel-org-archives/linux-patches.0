Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF652236F2;
	Sat, 14 Feb 2026 01:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031250; cv=none; b=bWJiySfMSAqD2KKFoCj+gY5+HUh20d0MVHTKSWlkHuyR1h+LADQ/ZarjPxyjiOSOITBqQ7mVqpWONy4IGk6JONcjA3f2fPKU3Q0bfUSX5QOOXGYJ0hda5hHSrySPaRq7YrRMgI3GjRQlHyLNaMmAGKIwgb82Nm01pXjE2ngGm74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031250; c=relaxed/simple;
	bh=rUf2YWStDOv0T/x/+XHVe93kZS6aDX70u2J67qZ+hfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/2vZNR6XVpWqa8/3AN109ESN4VKkaNwaKH/lMC8i6hXR40qK0xYPULYD8HwnHys3ur7dbb9vkCllqAuyOtLwWnJ1MknZbWVSu0PWRuJFZg8LybyYjem+SjeQgraOjAFI74FAmUDpz2UU30K1ixf22x9sjUXkfxXBuWAvFqnAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HI2M17Jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HI2M17Jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D129C116C6;
	Sat, 14 Feb 2026 01:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031249;
	bh=rUf2YWStDOv0T/x/+XHVe93kZS6aDX70u2J67qZ+hfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HI2M17JnIl13cqi62UPDNVw/E4VasaT6pog6u2b2FtgGrA5nq5buFGmhIldIc6CLz
	 f/eu8kEpSxyzvbb15cHr59LAJA6zOgWGmXfC1vWtb8NQY1hLyZjwTXPBFrLLg8S1wR
	 XMlq8yk2bT6HVpjd8Qd4XWOxO8U57b8DZegVpy0/Pt28SpxvrJmEoOkSUBLntff4Bw
	 AzTTabnfb1tZMv30LxUFIWjepQerURZCVukV67vvdx2YOchAIndX5HgXsA6YILI3Bp
	 fPT0MwP/9nqOPyBtjDV77Nzik1uHNsml7YXiRdWgAaFky60H7ick7MJ9vRpF2ROH82
	 NVALisCmp9wCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] spi: spi-mem: Protect dirmap_create() with spi_mem_access_start/end
Date: Fri, 13 Feb 2026 20:00:00 -0500
Message-ID: <20260214010245.3671907-120-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
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

From: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>

[ Upstream commit 53f826ff5e0e3ecb279862ca7cce1491b94bb017 ]

spi_mem_dirmap_create() may reconfigure controller-wide settings,
which can interfere with concurrent transfers to other devices
sharing the same SPI controller but using different chip selects.

Wrap the ->dirmap_create() callback with spi_mem_access_start() and
spi_mem_access_end() to serialize access and prevent cross-CS
interference during dirmap creation.

This patch has been verified on a setup where a SPI TPM is connected
to CS0 of a SPI controller, while a SPI NOR flash is connected to CS1
of the same controller. Without this patch, spi_mem_dirmap_create()
for the SPI NOR flash interferes with ongoing SPI TPM data transfers,
resulting in failure to create the TPM device. This was tested on an
ASPEED AST2700 EVB.

Signed-off-by: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://patch.msgid.link/20260120123005.1392071-2-chin-ting_kuo@aspeedtech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. Pattern Consistency

The pattern is **completely consistent** with existing code. Looking at
the existing usages:
- `exec_op` (line 405-413): wrapped with start/end
- `dirmap_read` (line 849-855): wrapped with start/end
- `dirmap_write` (line 895-901): wrapped with start/end
- `poll_status` (line 967-975): wrapped with start/end
- **`dirmap_create`**: was **NOT** wrapped — this is the bug being fixed

The `dirmap_create` callback was the only mem_ops callback **missing**
this serialization. This is clearly an oversight/bug.

### 4. What the Serialization Does

`spi_mem_access_start()`:
1. Flushes the SPI message queue to prevent preemption of regular
   transfers
2. Handles runtime PM
3. Acquires `bus_lock_mutex` and `io_mutex`

This is the standard mechanism for serializing SPI memory operations
against each other and against regular SPI transfers. Without it,
`dirmap_create` can race with:
- Normal SPI transfers to other devices (like the TPM in the test case)
- Other spi-mem operations

### 5. Bug Severity and Impact

- **Concrete failure**: TPM device creation fails, meaning the TPM is
  completely unusable
- **Real hardware**: Tested on ASPEED AST2700 EVB, but this affects any
  multi-CS SPI controller setup
- **TPM implications**: TPM is security-critical hardware (used for
  secure boot, disk encryption, attestation)
- **Multi-CS SPI is common**: Many embedded systems have multiple SPI
  devices on one controller

### 6. Risk Assessment

**Very low risk:**
- The change adds exactly the same serialization pattern used by all
  other spi-mem callbacks
- It's a small, surgical change (~12 lines of actual change)
- The error handling is correct (kfree on failure, proper return)
- Reviewed by Paul Menzel, merged by Mark Brown (SPI maintainer)
- Existing code in the file already demonstrates this exact pattern 4
  times

**No dependency concerns:**
- `spi_mem_access_start()` and `spi_mem_access_end()` have existed since
  the spi-mem subsystem was created
- No new functions or APIs introduced
- Will apply cleanly to any stable tree that has spi-mem support

### 7. Classification

This is a **race condition fix** — specifically, missing serialization
for a controller-wide operation. The `dirmap_create` callback can modify
controller-wide settings (like register configurations for direct
mapping) without holding the bus lock, allowing concurrent transfers on
other chip selects to see inconsistent state or interfere.

### 8. Stable Criteria Checklist

- **Obviously correct**: Yes — follows the exact pattern of every other
  callback in the same file
- **Fixes a real bug**: Yes — verified failure on real hardware (TPM
  device creation failure)
- **Important issue**: Yes — prevents device creation failure, affects
  security-critical hardware (TPM)
- **Small and contained**: Yes — single file, ~12 lines of change
- **No new features**: Correct — only adds missing serialization
- **No new APIs**: Correct

### Conclusion

This is a textbook stable backport candidate. It fixes a real race
condition that causes device creation failure on multi-CS SPI
controllers. The fix is small, follows existing patterns exactly, is
well-tested on real hardware, and has been reviewed by maintainers. The
risk of regression is minimal since it's simply adding the same locking
used by all other spi-mem operations.

**YES**

 drivers/spi/spi-mem.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 6c7921469b90b..965673bac98b9 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -719,9 +719,18 @@ spi_mem_dirmap_create(struct spi_mem *mem,
 
 	desc->mem = mem;
 	desc->info = *info;
-	if (ctlr->mem_ops && ctlr->mem_ops->dirmap_create)
+	if (ctlr->mem_ops && ctlr->mem_ops->dirmap_create) {
+		ret = spi_mem_access_start(mem);
+		if (ret) {
+			kfree(desc);
+			return ERR_PTR(ret);
+		}
+
 		ret = ctlr->mem_ops->dirmap_create(desc);
 
+		spi_mem_access_end(mem);
+	}
+
 	if (ret) {
 		desc->nodirmap = true;
 		if (!spi_mem_supports_op(desc->mem, &desc->info.op_tmpl))
-- 
2.51.0

