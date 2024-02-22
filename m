Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34B4133284;
	Thu, 22 Feb 2024 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708608084; cv=none; b=V87omIeqBjzxw66HFvtJuiKthZU2OKFjDhzK6doRo7FZZdvvo6pz+RssjGleauDDIKUR+OjVJk2/wD7/oyykOLTZ2GEMyO6BYmNoSUgq34NRSwaUdbFOI4X/aGbOIJW90V+55NJgHVUb8n11ytFoLZhvFXQ3TVKuuT7vzZ8wVzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708608084; c=relaxed/simple;
	bh=xcTY52q2ylGFoTBRUjq7TdWYkgN6e4ulWhPL6YVDF0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNvRdDUQGv9ZoRs84IJwc9zCPhXGo+uUe9C0UUMup7d6fvfhDznwOkpP6U4lcVg1NDtpxqxcvj/VaauDUFXX5n79gkjABlSZOibrso7gfyGveyT2hUpPUQrwWva8srUKapNvKgd/j784XCe+4SVxfJLlt3zjCaJf3AITpx78IBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qkljTMwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qkljTMwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030A9C43394;
	Thu, 22 Feb 2024 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708608084;
	bh=xcTY52q2ylGFoTBRUjq7TdWYkgN6e4ulWhPL6YVDF0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkljTMwk1cWQZeDihgqFY3qjHp1WD4gniXmzskUokzib3aH6I/s/JklArtcK0emFu
	 uBx0V5EVYdRc8CxQu9BnzgdJwZVIcrxHlqES71g/AQ2gHP1S0LMuL8FpyEtkIYgHTM
	 YbNvOnr75johAbjv0735bW/mZvFOo8vd6zz+k1k3SCpd+Gv87vu1GESHWsq9UjEkSC
	 3746eNIDxKmeZFo42xlw5/6Fml/r/EOm5Dht3rViGz/ZbBgQvjbR9PQnYbcHmvnmk0
	 ZglhJueITHtJVjrImBbixK6OrKg8AAzEUn2eDSfjmMVDfy4+Ufpltjc4ZuQL8Vi1yY
	 JbKrfozgS056w==
From: Will Deacon <will@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	linux-arm-kernel@lists.infradead.org,
	Joerg Roedel <joro@8bytes.org>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v3] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
Date: Thu, 22 Feb 2024 13:21:09 +0000
Message-Id: <170860525230.21606.13716127943718563315.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v3-11978fc67151+112-smmu_cd_atomic_jgg@nvidia.com>
References: <0-v3-11978fc67151+112-smmu_cd_atomic_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 21 Feb 2024 20:27:02 -0400, Jason Gunthorpe wrote:
> If the SMMU is configured to use a two level CD table then
> arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
> GFP_KERNEL. Due to recent changes this is being done under a spinlock to
> iterate over the device list - thus it will trigger a sleeping while
> atomic warning:
> 
>   arm_smmu_sva_set_dev_pasid()
>     mutex_lock(&sva_lock);
>     __arm_smmu_sva_bind()
>      arm_smmu_mmu_notifier_get()
>       spin_lock_irqsave()
>       arm_smmu_write_ctx_desc()
> 	arm_smmu_get_cd_ptr()
>          arm_smmu_alloc_cd_leaf_table()
> 	  dmam_alloc_coherent(GFP_KERNEL)
> 
> [...]

Thanks guys, this looks really good now.

Applied to will (for-joerg/arm-smmu/fixes), thanks!

[1/1] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
      https://git.kernel.org/will/c/b5bf7778b722

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
