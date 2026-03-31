Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049393FAE08;
	Tue, 31 Mar 2026 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974377; cv=none; b=XVhVTz/gHCv4JjqoOAfQHig90FlT/M+K5f2FIhf7agEX+Rby5hjSQKGU6rY6uwPTnnvitgF52uETH9OKgiFiscigNKCNbxSuNq7V4S+v6ndT10cxklfWGZRwHYJi/5XI/NfTItuEGTQcT7cHoWq3Lwl9NLZjIwueggqi8O1XCmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974377; c=relaxed/simple;
	bh=UFJo34f9ytznBuUdLFvQ3bQp3EGbMF5ZCiHCbZA0HW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fep6O/Q5KdeY4RKHMr8RZwgUEQcgOP6LsqgmzAvjM6BnLLsdgPmG5x+6OMo6GyW6yyoetqTL0xvQUCYec5l0XwQdcB4fEibwUruvsJmKwoD4QVpr/54rA3XEKpYJscose9gWJqLQD7kWj/9e/LXzdlse+cq6dndTEENZF2rtG6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRvT36gb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRvT36gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2FEC19423;
	Tue, 31 Mar 2026 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974376;
	bh=UFJo34f9ytznBuUdLFvQ3bQp3EGbMF5ZCiHCbZA0HW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRvT36gbki8keEBRlK6JBmmRBCHZHlbdQ1yE6bRcOp5CuXsQuTNYJH03VIRmrjCyL
	 B7BmrnmuWF/ci3RSYBnFL8oiK6MJj7rCdepUNADkIpF3HeF+5Gx+dhrIxoNBB/fIKG
	 vKmU0Vl3vIV8MdONTnYF9Ievuzx8mMczdCNLjfCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/175] dma-mapping: add missing `inline` for `dma_free_attrs`
Date: Tue, 31 Mar 2026 18:20:45 +0200
Message-ID: <20260331161732.026725843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 2cdaff22ed26f1e619aa2b43f27bb84f2c6ef8f8 ]

Under an UML build for an upcoming series [1], I got `-Wstatic-in-inline`
for `dma_free_attrs`:

      BINDGEN rust/bindings/bindings_generated.rs - due to target missing
    In file included from rust/helpers/helpers.c:59:
    rust/helpers/dma.c:17:2: warning: static function 'dma_free_attrs' is used in an inline function with external linkage [-Wstatic-in-inline]
       17 |         dma_free_attrs(dev, size, cpu_addr, dma_handle, attrs);
          |         ^
    rust/helpers/dma.c:12:1: note: use 'static' to give inline function 'rust_helper_dma_free_attrs' internal linkage
       12 | __rust_helper void rust_helper_dma_free_attrs(struct device *dev, size_t size,
          | ^
          | static

The issue is that `dma_free_attrs` was not marked `inline` when it was
introduced alongside the rest of the stubs.

Thus mark it.

Fixes: ed6ccf10f24b ("dma-mapping: properly stub out the DMA API for !CONFIG_HAS_DMA")
Closes: https://lore.kernel.org/rust-for-linux/20260322194616.89847-1-ojeda@kernel.org/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260325015548.70912-1-ojeda@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-mapping.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 608e8296ba206..d5cd7b243b87d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -219,8 +219,8 @@ static inline void *dma_alloc_attrs(struct device *dev, size_t size,
 {
 	return NULL;
 }
-static void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
-		dma_addr_t dma_handle, unsigned long attrs)
+static inline void dma_free_attrs(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t dma_handle, unsigned long attrs)
 {
 }
 static inline void *dmam_alloc_attrs(struct device *dev, size_t size,
-- 
2.51.0



