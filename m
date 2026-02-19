Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E213164D0;
	Thu, 19 Feb 2026 02:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466715; cv=none; b=JQpV2X65EL0JjbHY6MjZmwmWHBf/nSnJOu0cQCQvzCX2psd+M5kzJ8qj345J2hG6JNK5NBbB2vNBaIksYMAy/34ISfoHvN1LUTudDy4ionUaj9vhFJr6KaT4eqAbZhZcNGn4ggG2fsOyLGc8/zWUewI+N5AK2GzUpYDAqyfQWOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466715; c=relaxed/simple;
	bh=CJhzGH3sAa0J4fOkP0CpNIISd/xcJc3TRjy4YycFwTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Grnh7XjYWSiIIv/52c9mzI5oifRR3SN7CT/9R6AQzqnS+GdQJYdCy7Ef4bykJaphigHkssX6MV7zlpm3AVdwsTYvagrER/iEFWJIk6n+0KV9H8UvAB0Dsf/pD0gJ7nc5lWRHN3k6GOvaTpGt4UekTHL0Vi+oGRZRMp823tP7R5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n74SW63m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n74SW63m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B13C19425;
	Thu, 19 Feb 2026 02:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466715;
	bh=CJhzGH3sAa0J4fOkP0CpNIISd/xcJc3TRjy4YycFwTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n74SW63m3g2vdXmFe3PM5znz6KRPmNRYMfgHOkvKjEl98qnQTDDxvmylU6XbUbAXg
	 lUdFncUSLM1ksgLt6Odpy0PbmiQaHrtGuGmuh89xzmS9EORRxSz2MMKLf7ZmbxGGuc
	 NloIThis473MS7v/DH5MkWbffUHpZNHXIJt4gVg6neLGGxKIhmPpYEBAdmfX9cb5Tv
	 /mAD+Hx9iaJvTjlGHOtnbrHRxbiXJj+RU54z2Ih3MwFJ7QRGq0NXCN1YBN7XV6jA72
	 kDGj6YPpYX5EfuWm7cHJDIahKfDHgHIeZkhjKffXO/9aa9wa5aozGF0UEn16vFabmX
	 QfO3OysVSxRRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <legoffic.clement@gmail.com>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	dmaengine@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] dmaengine: stm32-mdma: initialize m2m_hw_period and ccr to fix warnings
Date: Wed, 18 Feb 2026 21:04:16 -0500
Message-ID: <20260219020422.1539798-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit aaf3bc0265744adbc2d364964ef409cf118d193d ]

m2m_hw_period is initialized only when chan_config->m2m_hw is true. This
triggers a warning:
‘m2m_hw_period’ may be used uninitialized [-Wmaybe-uninitialized]
Although m2m_hw_period is only used when chan_config->m2m_hw is true and
ignored otherwise, initialize it unconditionally to 0.

ccr is initialized by stm32_mdma_set_xfer_param() when the sg list is not
empty. This triggers a warning:
‘ccr’ may be used uninitialized [-Wmaybe-uninitialized]
Indeed, it could be used uninitialized if the sg list is empty. Initialize
it to 0.

Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Reviewed-by: Clément Le Goffic <legoffic.clement@gmail.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/20251217-mdma_warnings_fix-v2-1-340200e0bb55@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I can see `sg_len` is passed from the DMA framework's `prep_slave_sg`
callback. While the DMA framework generally doesn't call this with
`sg_len == 0`, there's no explicit guard against it in this function.
The `stm32_mdma_alloc_desc` with `sg_len == 0` might succeed (allocating
a descriptor with 0 nodes), allowing execution to reach
`stm32_mdma_setup_xfer` with an empty list.

### Verification

- **Read the actual code**: Confirmed `ccr` is used at lines 777-779
  after the for_each_sg loop, and if `sg_len == 0`, `ccr` is never
  initialized by `stm32_mdma_set_xfer_param()`.
- **Caller analysis**: `stm32_mdma_setup_xfer` is called from
  `stm32_mdma_prep_slave_sg` at line 809 with `sg_len` from the DMA
  framework - no explicit guard for `sg_len == 0`.
- **m2m_hw_period**: Confirmed at lines 737-738 and 749-750/758-759 that
  it's only used when `chan_config->m2m_hw` is true (false positive
  warning).
- **Risk assessment**: The change is a trivial initialization, zero
  regression risk.
- **Could NOT verify**: Whether any real-world code path actually passes
  `sg_len == 0` to `prep_slave_sg` (unverified, but defensive
  initialization is correct practice).

### Conclusion

This is a very low-risk fix that:
1. Silences compiler warnings (useful for clean builds)
2. Fixes a real (if potentially rare) uninitialized variable bug for
   `ccr`

The fix is trivially correct, one line, zero regression risk, and fixes
a genuine code correctness issue. While it's borderline because the
primary framing is "fix warnings" and the affected driver is
STM32-specific, the `ccr` uninitialized variable is a real bug that
could cause DMA hardware misconfiguration, and the fix has absolutely no
downside.

**YES**

 drivers/dma/stm32/stm32-mdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/stm32/stm32-mdma.c b/drivers/dma/stm32/stm32-mdma.c
index 080c1c725216c..b87d41b234df1 100644
--- a/drivers/dma/stm32/stm32-mdma.c
+++ b/drivers/dma/stm32/stm32-mdma.c
@@ -731,7 +731,7 @@ static int stm32_mdma_setup_xfer(struct stm32_mdma_chan *chan,
 	struct stm32_mdma_chan_config *chan_config = &chan->chan_config;
 	struct scatterlist *sg;
 	dma_addr_t src_addr, dst_addr;
-	u32 m2m_hw_period, ccr, ctcr, ctbr;
+	u32 m2m_hw_period = 0, ccr = 0, ctcr, ctbr;
 	int i, ret = 0;
 
 	if (chan_config->m2m_hw)
-- 
2.51.0

