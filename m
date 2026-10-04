Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6724A3CE4A3;
	Sun,  4 Oct 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132655; cv=none; b=YHnwc/uj6PzjBNZdPAM2TxOE+FvpOUo/eoy0xXTuW/u+oTKoCBKeBMZUamQMUa/ef6EHVVwR8zByd37/nHyp3K0bufra7i/bFpKqjiz54y0xTmQ6Nr7jT7Ibconj4UHK6G6vghg6K81hcOUmwv3XyGkZJbRvRF4uczIXs/1fGjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132655; c=relaxed/simple;
	bh=g2UOLsKpjHs+vwQ/G9/vKr58Vkwyj8qThrLz/+t1tnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ev/iw9Wr+0ZgzzY4pRRc7u7ZdOg9Ya5o7vupONqubMiblHTrXcf9rsPPMn1xZPJYeRc3A2RSU/j8Ltrm8IkkvaH8abd+UKipMWfK+IoBUq6Wy/gVGrREEUdo/36q8w89eX6pVMR9vOKQ2K431pFo8VrGYxqcpALB0IHwREfrR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qd7+JUc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qd7+JUc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87511F000FF;
	Sun,  4 Oct 2026 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791132653;
	bh=nuVSHKSsMcwtQfVcd+p5GkIpu47wINMtbXzXIQ+YSfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qd7+JUc5YcezLGcxNrrUt2ZGcbHq5Nnl64L9F7w6P081ics21AFO5Pi1EF+bficqF
	 ILF5iCvM1+npNc3fNxjlt4vXiXjaSX1T5tWYDpS6ERnIb0GVU+ae/ed3g7fYvZ0ezT
	 uoQxUmwhw8Asd6cGVT6eS66lx+0qdJFmTvVitZx92uWcH4QpBjmJlBiEaQ7nZsPYIu
	 Pq+PQcM9ZkwFPWY0OvnJc1Pt/RNJ1upzv0GfWP5jQgKu0txcj8uB18EWzbF5+9AnjR
	 CnYRjDnTf1hL4w8RP7EWM8IRWeXqWeKyNEVEuNMU/Qz8teax2q02PQlmNySu347aV8
	 UDuMYzdaoy6uw==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <peaan@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v8 0/9] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Sun,  4 Oct 2026 17:50:41 +0100
Message-ID: <179112946237.2363163.15333874894190883676.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 02 Oct 2026 22:23:19 -0300, Jason Gunthorpe wrote:
> [ This is part of the patch pile to move SMMUv3 over to the generic page
> table, the precursor patches have been merged now. What's left:
>  1) Organize the SMMUv3 invalidation flow so iommupt can use it
>  2) Use the generic iommu page table for SMMUv3
> 
> The first patch should ideally go to -rc
> 
> [...]

Applied first seven to iommu (arm/smmu/updates), thanks!

[1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT under invalidation with SVA
      https://git.kernel.org/iommu/c/84c6089a365f
[2/9] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
      https://git.kernel.org/iommu/c/0a6cd4ac9252
[3/9] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
      https://git.kernel.org/iommu/c/a9573c2847e9
[4/9] iommu/arm-smmu-v3: Optimize range invalidation for latency
      https://git.kernel.org/iommu/c/5a158b29766c
[5/9] iommu/arm-smmu-v3: Keep track in arm_smmu_invs if range invalidation is used
      https://git.kernel.org/iommu/c/fc62cd069cf7
[6/9] iommu/arm-smmu-v3: Precompute the invalidation commands
      https://git.kernel.org/iommu/c/bc5c3475d63c
[7/9] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
      https://git.kernel.org/iommu/c/d587faf66828

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
