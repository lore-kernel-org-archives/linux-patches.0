Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B684A0EE8;
	Thu, 17 Sep 2026 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637059; cv=none; b=LspEXWxGR61o3yV5pgoDrgE8k/d7z/5BI0wMZv8TJtgvqEpW8RCq/pjQIZMUEEuUjsI1QJTQkmHjkBNfHZ2eVyZiKnw5pWU9asL/U18Zdyx+60onqCgZQj1g2d8At5Tmd/EVzy9L6+ALurcqQn5emATJV1tixdcWWPAz0UNEnrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637059; c=relaxed/simple;
	bh=sIT7gK6myMlC0MkhhrFdGW+pdZ57n54Ge/impHw3fJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkEV45zJuhMN/jN1N1hgAAJNA8qGDznh2eQFGU8sn6lp+uMz/994YqrEorLQuj6FO2TpV8lHXZvov3ts1eW1OhJuzHah2TFrGB4Io6Nkv+DNOhWl+iFovlQN5fXEPY/PBQUXZ7bmzFfMVYFzCPlxtJ8yz7GYo2w4eR6YH/r7AdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L7GdL8vs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L7GdL8vs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 916F41476;
	Thu, 17 Sep 2026 02:24:13 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5C313F7B4;
	Thu, 17 Sep 2026 02:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789637057; bh=sIT7gK6myMlC0MkhhrFdGW+pdZ57n54Ge/impHw3fJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L7GdL8vsGKEmaHpBo+qCZDuZPOa023qP2/nhUH2BJ4KcPpmnDmpj3kiwXlwm2J6gl
	 U2T14K+mz6GUdh3g1YVTF+ze9PPzmY86a8koarA7M/h2I/iyGS9Y/gWaekuiodFmM8
	 MIaWPPL8o5Wibq6sTWKEvcDyq8MV5L3te6jCQL7U=
Date: Thu, 17 Sep 2026 10:24:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v6 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <aquxuBnh6pdxu4-8@J2N7QTR9R3>
References: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>

Hi Jason,

Nit on terminology below.

On Wed, Sep 16, 2026 at 09:27:42PM -0300, Jason Gunthorpe wrote:
> The erratum (MMU-700: #3777127, S3: #3673557) deals with under
> invalidation of a CONT PTE grouping in the SMMU. The recommended work
> around is to use a Range Invalidate (RIL) that spans the entire CONT. The
> only user of CONT in the kernel right now is through SVA sharing a CPU
> page table that contains a CONT created by the mm.

As someone familiar with VMSA, I've never seen "RIL" used to describe a
range invalidate and I think using that in the code below is confusing.
I *think* "RIL" has come from "SMMUv3.2-RIL", which is the SMMU feature
for Range Invalidate *and* Level hint, where "RI" is Range Invalidate,
and "L" is Level.

Can we please spell that out as "range invalidate" or "range op"
(matching the arm64 architecture code) rather than "RIL"?

That'll be easier to follow, especially as nothing in the code mentions
what "RIL" means -- that's only mentioned in this commit message.

Mark.
