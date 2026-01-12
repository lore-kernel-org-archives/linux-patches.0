Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCF42EB840;
	Mon, 12 Jan 2026 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229963; cv=none; b=WuAYLOLOVvYJxi7l+5Lviqlgan5PwEXx6ylKEl/pGCDLffnY1Yla4wPFgza2gGKzn664CcgsOWkERSsyVI8cYfamriXzkpyzmnX90jEtsPAgi4g6nUb+X194MlX7Y0hRkrAav+V43QSzhwici8ktY91USEUnECL+t7SJyEDRJfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229963; c=relaxed/simple;
	bh=aoNZSkoUZ0CeTuQbzC1WKUULM3GlF9x8csRxu63dhi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fsKgoq43QdkKPqk5LYe/i1n3eRBzFBA80lGG/yyD+TlasbgPCHB0q3oqDJKV0qn4mV2Hl9qDYD8pse0FZFuk24/wyQ4pv6IDL7hAIsTwzc7+2YiXWe6IiqVzXf6oAF6wDNnO1CQNuQ5BSHoKUNmNMgUo5EhFGeFtf+c4wZBezvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDis71s8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDis71s8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ABAC19424;
	Mon, 12 Jan 2026 14:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229963;
	bh=aoNZSkoUZ0CeTuQbzC1WKUULM3GlF9x8csRxu63dhi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDis71s8BXeVbL3X3GsZVnhTSg5KEpD4Z1zAu2eniD4vJdcNpQMi8oYSnUtkAEukX
	 Z2a/Hl+EBkEPf6I+IJZ+wRaPPRVGuvvrtTSJxdJdaXRbTF85doFrfrJg1vtpzs2HJQ
	 3YnPPi3ED5iiTHGs1TqEQ5G5jjEZea9Vy4zjKXeDumKjPUE7/p4kes5K14GOulR8E5
	 cKnGQwSPBmioSMMXpBuFxDKqGZNE4lG1Vk8dLbNis0/e7KUmaNGyrIusueVDqK5zO3
	 I4fdN95aYz/hcfLxcTSS9+MubqFdekXdoPl0hPIIRzhFfSkXm/Oi7+m86MitN7m1RO
	 Zq2ttC6xptnHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Even Xu <even.xu@intel.com>,
	Rui Zhang <rui1.zhang@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	andriy.shevchenko@linux.intel.com,
	fourier.thomas@gmail.com
Subject: [PATCH AUTOSEL 6.18] HID: Intel-thc-hid: Intel-thc: Add safety check for reading DMA buffer
Date: Mon, 12 Jan 2026 09:58:25 -0500
Message-ID: <20260112145840.724774-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Even Xu <even.xu@intel.com>

[ Upstream commit a9a917998d172ec117f9e9de1919174153c0ace4 ]

Add DMA buffer readiness check before reading DMA buffer to avoid
unexpected NULL pointer accessing.

Signed-off-by: Even Xu <even.xu@intel.com>
Tested-by: Rui Zhang <rui1.zhang@intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Summary

| Aspect | Assessment |
|--------|------------|
| **Bug Type** | NULL pointer dereference (kernel crash/oops) |
| **Fix Size** | 4 lines added |
| **Risk** | Very low - adds defensive check before pointer access |
| **Driver Availability** | Added in v6.14, exists in 6.14.x stable tree
|
| **Testing** | Has Tested-by tag from Intel |

### Technical Analysis

The bug is straightforward: in `read_dma_buffer()`, after checking
bounds on the PRD table index, the code directly accesses:
```c
prd_tbl = &read_config->prd_tbls[prd_table_index];  // Could be NULL
sg = read_config->sgls[prd_table_index];             // Could be NULL
```

If DMA buffers haven't been properly initialized (race condition during
device init/probe or error path), this causes a NULL pointer dereference
leading to a kernel crash.

The fix adds a simple and obviously correct NULL check:
```c
if (!read_config->prd_tbls || !read_config->sgls[prd_table_index]) {
    dev_err_once(dev->dev, "PRD tables are not ready yet\n");
    return -EINVAL;
}
```

### Stable Kernel Criteria Check

| Criterion | Met? |
|-----------|------|
| Obviously correct and tested | ✅ Yes - Simple NULL check, has Tested-
by |
| Fixes a real bug | ✅ Yes - NULL pointer dereference crash |
| Fixes important issue | ✅ Yes - Kernel crash/oops |
| Small and contained | ✅ Yes - 4 lines, 1 file |
| No new features | ✅ Yes - Pure bug fix |

### Risk vs Benefit

- **Benefit:** Prevents kernel crashes on Intel THC devices when DMA
  buffers are accessed before ready
- **Risk:** Minimal - the check can only trigger an early return with
  error on an already-buggy condition
- **Scope:** Limited to Intel THC driver (touchscreens/touchpads on
  Intel platforms)

### Conclusion

This is an excellent stable backport candidate. It fixes a NULL pointer
dereference that causes kernel crashes, using a minimal and obviously
correct defensive check. The driver exists in 6.14.x stable tree, and
users with Intel THC touch devices would benefit from this fix. The
change has been tested and is trivially reviewable.

**YES**

 drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c
index 82b8854843e05..e1aadae4eb244 100644
--- a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c
+++ b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c
@@ -573,6 +573,11 @@ static int read_dma_buffer(struct thc_device *dev,
 		return -EINVAL;
 	}
 
+	if (!read_config->prd_tbls || !read_config->sgls[prd_table_index]) {
+		dev_err_once(dev->dev, "PRD tables are not ready yet\n");
+		return -EINVAL;
+	}
+
 	prd_tbl = &read_config->prd_tbls[prd_table_index];
 	mes_len = calc_message_len(prd_tbl, &nent);
 	if (mes_len > read_config->max_packet_size) {
-- 
2.51.0

