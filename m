Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24C2301708;
	Tue, 31 Mar 2026 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976506; cv=none; b=H03V/qWfG1y0YoKtgpPGF1YFjLZJWunhqQ50HNafPeASaePTew8OeBBnrnyZwXtnYrsD6rZ9PKwtU/mXq4bYHCgE8sFdBr5cohtgBDE+8owvzR4e77qsCdib2myq3DeqAbx1G3z0tywPfmro5LwqOkLgoRsYljIcL6e4t6mtrhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976506; c=relaxed/simple;
	bh=I2Q7z86sdIk89hcqk7wf/iqafhwawu71A9eBsITwxc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo/KU5cDOmkgLBcPdrK3zly78M6Ig1WDNH7zRHUQIPs23PiuDsKOtbhnG/QztvEMyItrYcwnqTwVIVG4dKkTGM/ASgTGlmaSNIPP2JYD+0YKfj4/C30HGQxZNggjUHJ/9yBJ3yt4q/LkTxeDjX3ZjpgrGKMlhIGwp9gJC6zICoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm3O/saI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm3O/saI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F90BC19423;
	Tue, 31 Mar 2026 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976505;
	bh=I2Q7z86sdIk89hcqk7wf/iqafhwawu71A9eBsITwxc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vm3O/saIYQCUT0+MiXe+l/dRd5wr1ku+EGCja9Ug3+Pm+KAA/oQJ//IYXMGU65g3n
	 IHnkdi/vk8I/z0p+BXBpjlS0ZyFhTj8KaanZ8BUv+Ci3j3MOgI0eEJ/ri91iuxLpJj
	 wWWxHP4Yv8sX6gZiR3FkLMsgJXQopEMNFcmlHUZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/309] dma-mapping: add missing `inline` for `dma_free_attrs`
Date: Tue, 31 Mar 2026 18:20:21 +0200
Message-ID: <20260331161757.826619105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aa36a0d1d9df6..190eab9f5e8c2 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -240,8 +240,8 @@ static inline void *dma_alloc_attrs(struct device *dev, size_t size,
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



