Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82DB3EBF2C;
	Sat, 14 Feb 2026 01:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031043; cv=none; b=oSlr82Uhifhl0wioZ9a8QsfX6QHcC3KX1qPDxcKnRfonHiZg+PBwAk9u+9ZiX8/yxVRKgzgEXNKwH+Inix5fEUfAYnxxA8DH/CPgKwG+OqBx6KFqGalHfJiXyCsxG5LtGX0JfJVC+d1INZo5cTdpc6Wdfg3RE4KlscHbEAkV8t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031043; c=relaxed/simple;
	bh=IHLSzAI8hzsmf9fNj5gAaE0rSGj5WCwBgegvgiHMZuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lrn5fkJTgSTdjHECAcUUfac3ruo1N0/HvWsoE9K8BAj0IkuA8peiD6rTZKUPs4NwWOuLALRx7lg3BjQxMT3AKf2hhIHafZGJD5yocpy+TZLbWu2t+DI2V+hqieTUxqwQREw2EMlAEOZQS1Qhor1JELDL2m7Ph1YXmxwyxev8JLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZrZuHNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZrZuHNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3BEC116C6;
	Sat, 14 Feb 2026 01:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031043;
	bh=IHLSzAI8hzsmf9fNj5gAaE0rSGj5WCwBgegvgiHMZuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZrZuHNPVF//z5tQKn6IZVDM3Skg6PtDodxzQqwKPCPzmrwVCnYAwFAqkLq3anxeo
	 aQBA2atlHY08kttS2D6E6ODBlw0YE3NHHMux0RTIhKU8BhzAolCKyVdICtsLSLLhmw
	 exkXWTZAPSVKtrXpVy+heHaiHqLw6dWoxldtJJVIB8Va14Mzu9Y0XDwoEZ8sZ762Ub
	 7XzDNqMIIAXPVOomPhlffsxz/39qvsA5uic8NOH+JE48S7Gkwd8ct9vCytYG6B+G9h
	 ierDGAFiMiypUpW7/sTej4xeQlT/x10thlFfF1v7fDBO26rDW/JMF7/8hNaDmQ8aPj
	 oo+ayEJX3o+wg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-5.10] media: cx25821: Fix a resource leak in cx25821_dev_setup()
Date: Fri, 13 Feb 2026 19:58:35 -0500
Message-ID: <20260214010245.3671907-35-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 68cd8ac994cac38a305200f638b30e13c690753b ]

Add release_mem_region() if ioremap() fails to release the memory
region obtained by cx25821_get_resources().

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of cx25821 Resource Leak Fix

### 1. Commit Message Analysis

The commit message is clear and direct: "Fix a resource leak in
cx25821_dev_setup()". It describes adding a `release_mem_region()` call
when `ioremap()` fails, to release the memory region previously obtained
by `cx25821_get_resources()`. This is a classic error-path resource leak
fix.

### 2. Code Change Analysis

The change is a **single line addition**:

```c
release_mem_region(dev->base_io_addr, pci_resource_len(dev->pci, 0));
```

**The bug mechanism:**
- `cx25821_get_resources()` is called earlier in `cx25821_dev_setup()`
  and successfully acquires a memory region via `request_mem_region()`.
- Later, `ioremap()` is called. If `ioremap()` fails, the function
  returns `-ENOMEM`.
- However, before this fix, the memory region obtained by
  `cx25821_get_resources()` was **never released** on this error path.
- The existing `cx25821_iounmap(dev)` call handles unmapping but doesn't
  release the memory region that was requested.

This is a textbook resource leak on an error path — one of the most
common and well-understood bug patterns in Linux kernel stable
backports.

### 3. Classification

- **Bug type**: Resource leak (memory region not released on error path)
- **Category**: Error path fix — fits squarely in the "cleanup that
  fixes a real bug" pattern
- **Severity**: Medium — the leaked memory region would prevent the
  resource from being reused until reboot, though this only triggers
  when `ioremap()` fails (which is rare but real, especially under
  memory pressure)

### 4. Scope and Risk Assessment

- **Lines changed**: 1 line added
- **Files touched**: 1 file (`drivers/media/pci/cx25821/cx25821-core.c`)
- **Risk**: Extremely low — adding a `release_mem_region()` call on a
  failure path is well-understood and cannot cause any regression. It
  only executes when `ioremap()` has already failed.
- **Subsystem**: PCI media driver (cx25821) — a specific video capture
  card driver

### 5. User Impact

- The cx25821 is a Conexant video capture chipset used in real hardware.
  Users of this hardware who encounter an `ioremap()` failure would have
  a resource leak that prevents the memory region from being reclaimed.
- While the error condition (ioremap failure) is uncommon, when it does
  occur, the resource leak is permanent until reboot.

### 6. Stability Indicators

- Signed off by Hans Verkuil, a well-known and experienced media
  subsystem maintainer
- The fix is trivially correct — it matches the standard pattern for
  releasing resources on error paths
- The change has no dependencies on other commits

### 7. Dependency Check

- The `release_mem_region()` function and the cx25821 driver have
  existed for a very long time in the kernel
- No dependencies on newer code — this will apply cleanly to any stable
  tree that contains the cx25821 driver

### 8. Stable Kernel Criteria

- **Obviously correct**: Yes — standard resource cleanup pattern
- **Fixes a real bug**: Yes — resource leak on error path
- **Small and contained**: Yes — 1 line, 1 file
- **No new features**: Correct — pure bug fix
- **Tested**: Accepted by subsystem maintainer

### Conclusion

This is a minimal, surgical fix for a resource leak on an error path. It
adds a single `release_mem_region()` call when `ioremap()` fails,
preventing a memory region from being leaked. The fix is obviously
correct, has zero regression risk, and follows a well-established
pattern. It meets all stable kernel criteria.

**YES**

 drivers/media/pci/cx25821/cx25821-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 6627fa9166d30..a7336be444748 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -908,6 +908,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	if (!dev->lmmio) {
 		CX25821_ERR("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
+		release_mem_region(dev->base_io_addr, pci_resource_len(dev->pci, 0));
 		cx25821_iounmap(dev);
 		return -ENOMEM;
 	}
-- 
2.51.0

