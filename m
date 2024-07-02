Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB51DFE3;
	Tue,  2 Jul 2024 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719945849; cv=none; b=O1kq4DvM0UUKuuvKcIPLNdxaQZehYodWXockVOaQ0T0fOviIHtDZbB/z5Y1hOeWzi9VL5MkNlGwyH38b701skQLdpc714Gef4tL7N6R9xl7ptqaP621ZQDSNcFlznZhVBUFrUiwzHK+muyQJcREFqJU5Ebxt/mHaeDd7jUXwJK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719945849; c=relaxed/simple;
	bh=66C8i7qkSrSY41acZyFnGawC/LjDY1QgwSkwsu5VS0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8uvzAoyLPbjWm7OUzf1ynnhPKIyQ9aXgXCRD/XDYjBlDEyiokPlEF1rR1cplKduKFdfcxjifa6eCtOj90KKwDKrDpEn4Zg+kUvzL1rt2raPUAwV5iv39D2kAkRZcwMBOCGly53zzxcpKkFZKM3xqsy9v+7rBQO6e/4K3a9U0bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mozSCd3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mozSCd3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A26CC116B1;
	Tue,  2 Jul 2024 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719945848;
	bh=66C8i7qkSrSY41acZyFnGawC/LjDY1QgwSkwsu5VS0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mozSCd3LQ4RR4NXWH3TWUirzOerfyBPpGY5vbezVXVhKptqYwaKVkHjtOMullnQms
	 BO3Ivdyj1unEps6wUFIOk6/kPPXD+ALZ7ttiujz31i3BaFsxsGEMsv5Iqub/ofZM5P
	 rhXBLe5PrAUO94C+iZefDL0gXyJmlPrkMo8dLBp2R9Hx+/esqZhH+JojmC6P8Re7vm
	 AYfQ+4Gc9CGqaAeiTQF2Amw29D3ggxFGKp7wPCiLBHufPSEXFNGBiPZAs0vD2wFsz+
	 /JOiOoTkCuX5z9X82lW9dU3fG60c5WxOPUzK7VBGdNsDP4U9IlQzSOfhW9Mz+iDKW6
	 uxHj4/KKWzJBQ==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 00/10] Tidy some minor things in the stream table/cd table area
Date: Tue,  2 Jul 2024 19:43:57 +0100
Message-Id: <171993432202.3894040.591624933816619356.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 10 Jun 2024 21:31:09 -0300, Jason Gunthorpe wrote:
> Will pointed out that two places referring to the CD/STE struct did not
> get the new types. While auditing this code a few more oddities were
> noticed. Based on a feedback from Mostafa and Nicolin a few more things
> were fixed up too
> 
> - Use types for all the HW structures everywhere even for the L1
>   descriptors that are just a single 8 bytes. This helps with clarity of
>   what everthing is pointing at
> - Use indexing helpers for the STE/CD two level calculations
> - Use sizeof(struct X) instead of open coded math on constants. The sizeof
>   naturally follows the type of the related variable in almost all cases
> - Remove redundant dma_addr_t's and save some memory
> - Remove redundant devm usage
> - Use the modern rbtree API
> 
> [...]

Applied first two to will (for-joerg/arm-smmu/updates), thanks!

[01/10] iommu/arm-smmu-v3: Do not zero the strtab twice
        https://git.kernel.org/will/c/c84c5ab76c9c
[02/10] iommu/arm-smmu-v3: Shrink the strtab l1_desc array
        https://git.kernel.org/will/c/a4d75360f7a6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
