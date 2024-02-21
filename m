Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2D2524CE;
	Wed, 21 Feb 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708520923; cv=none; b=F1EqlqrAAyL0mTpyQ+zRWTTRP1bj0w2/Tm64asg4b+KH7rUKXfb86ymx1Avncl3impd3THxfYPKdyfLySosoKB6IlX51aSxXEZVEtq6Un/9kck7YAA1WKqF8IurPCNXkNrIc4ST/CMHfS/HvDW50vNApTLhLaIzGy7nHJ5LTNP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708520923; c=relaxed/simple;
	bh=jWoOg1V3ZThyRBKOVb7CEjqeK+QlKbeiCOerKjWohKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JG+pAP+EAc1IpBhysaPCdo8NmIIG6Uz8xS/mDLWobVAy8hjsKYApCVHi3WKYmdnL8GAndBA3F4aeKz/xvmHn4IxxWIvVXSRTLnTdkNwg1/+AqcSo42E0XgVTmsI8kAz84M5I/EMFlhmRF0s/IBT2khoFd7tML5gjYTVEXtXrA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VR6VtHUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VR6VtHUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB203C433C7;
	Wed, 21 Feb 2024 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708520923;
	bh=jWoOg1V3ZThyRBKOVb7CEjqeK+QlKbeiCOerKjWohKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VR6VtHUZRBrkF7H32n3NJFdlo8JZZu4fgycdTWNsmSldCRCPzGCarxAnpX/beNQGi
	 uEqMf7thFW8ScsFPy6xuVZ8pc1fuqsi6S6Yf+kMKWpI3QI5d51XhRXSllSXLhP2K4V
	 bUePi69dWiy57uMwbvI6Uwfz8KK+IjWURHL/lkc9xdWH9ho9FO1JqeTO2G0gy4f/1b
	 pePso22REMFeyFbId+mdXi+Qe6LIpb6Pg5YUtk6TzPZwuDF9wTXxKqYHwGNPt06m+z
	 uTQuiwvxm8mr6o9ZFJ/fXQJIi+h7hoMm/u+Y+lKCA381OzW8t5wWNyFDgqeMavvEwO
	 4sJ1ZwOe1evyw==
Date: Wed, 21 Feb 2024 13:08:37 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Shavit <mshavit@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240221130837.GA7273@willie-the-truck>
References: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
 <20240216120512.GA1841@willie-the-truck>
 <20240216123606.GA13330@nvidia.com>
 <CAKHBV27eBnCrnXeaoqONWksh89tfX1b0=yvLfTkxviU_wKG_mw@mail.gmail.com>
 <20240217132446.GJ13330@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240217132446.GJ13330@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sat, Feb 17, 2024 at 09:24:46AM -0400, Jason Gunthorpe wrote:
> On Sat, Feb 17, 2024 at 08:25:36PM +0800, Michael Shavit wrote:
> 
> > Calling arm_smmu_write_ctx_desc requires the CD which we get from the
> > mmu_notifiers list...which makes it a bit more complicated than
> > that.
> 
> @@ -404,9 +384,15 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
>                 goto err_free_bond;
>         }
>  
> +       ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
> +       if (ret)
> +               goto err_put_notifier;
> +

Please can you spin a v3 with this folded in?

Will
