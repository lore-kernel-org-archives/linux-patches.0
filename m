Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33140222D7F;
	Thu, 12 Dec 2024 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020147; cv=none; b=Jax3NMsg/AR/aKn84jDE2LJOFaihPgv71cRD6IaGhyrgDLWNA5MJWEARuCKve3DKYPLGve626QglhfrrH1QyQR2vtLenYbOvhOTRI2qzntY3G/NrxLS0OSD0mjShusOWEucKIlF7/vo/BrlRpKX30x5G7shAR3/nufGHykih6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020147; c=relaxed/simple;
	bh=iL9KFQwOL83ywQ4qE9O/HvmYj/sSamcPIC1u5zo4FLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2DElTSI3F+8FHD82MqArJpoLzwv4spdHnSeO+B7t6JgtQdnNYLGoHca56SAPfUGTD30b29zt+3+dTuf6qtdWopAksAxn79oP7+NtTuB4FQLU9TsZnMoJufLKIicMssQ98xcz2G04B7Uq6JdX+deWi5oFmOQeZv4wd2+vNaac+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8sdI4fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8sdI4fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64373C4CECE;
	Thu, 12 Dec 2024 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020147;
	bh=iL9KFQwOL83ywQ4qE9O/HvmYj/sSamcPIC1u5zo4FLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8sdI4fvdEf3NMSmhtk0uW4h6Hj32ELp0JBGG7ptS/psN2SQGcd/gs8x8Cu0/HwIo
	 eUe1brh2N6BuHFHQE2VlM+IYmixiCP+/Rzh7/S9UyHinFxTOtQjgXj2FRFA2kcU/iM
	 DMSOvNm69N5//xhJVDu+xl/EGGGAa1R3N42m2+hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 359/772] dma: allow dma_get_cache_alignment() to be overridden by the arch code
Date: Thu, 12 Dec 2024 15:55:04 +0100
Message-ID: <20241212144404.751067955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 8c57da28dc3df4e091474a004b5596c9b88a3be0 upstream.

On arm64, ARCH_DMA_MINALIGN is larger than most cache line size
configurations deployed.  Allow an architecture to override
dma_get_cache_alignment() in order to return a run-time probed value (e.g.
cache_line_size()).

Link: https://lkml.kernel.org/r/20230612153201.554742-3-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dma-mapping.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -544,6 +544,7 @@ static inline int dma_set_min_align_mask
 	return 0;
 }
 
+#ifndef dma_get_cache_alignment
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_HAS_DMA_MINALIGN
@@ -551,6 +552,7 @@ static inline int dma_get_cache_alignmen
 #endif
 	return 1;
 }
+#endif
 
 static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)


