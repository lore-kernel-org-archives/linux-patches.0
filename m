Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD3312FB18;
	Fri, 16 Feb 2024 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708100934; cv=none; b=sOww8gTZM8EV9kJZIfeJ8Ur4G+VT8pD67SADOH5Cee+s6BJeFQRaySK6bdnpenpgDQ1d+pCDDe2n/BfMwEH6yRCh+di6P1guuZkReF/SEOu1qwNtI/JjSHt3uI+V/PQdkM0zoebI54vCQOnh30KM8a9/lmibXJ09WYPKeC9ttow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708100934; c=relaxed/simple;
	bh=bLayoZaZJLZiF5BMJqBebQLCc+RBwyhci3ZXz7tlJMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uS+im3yjui+jqWmUx0iG5pRDsAx7hwwaSGb0L/LCzfADA/qiMRuqdPJilg+7jSEawxlhr+oFkjiqOmCi7ceyyneuLHcwdMEpZtqsmK8ZpRAVkNlUoGymTy1EMQVcR36nEGFis2/3HDNxghGyWcWUqeF15iEMS3zu4IANz6GCpCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krob6DhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krob6DhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F7FC433C7;
	Fri, 16 Feb 2024 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708100934;
	bh=bLayoZaZJLZiF5BMJqBebQLCc+RBwyhci3ZXz7tlJMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=krob6DhGMHFi1yO0jo5VUTbEo0bOL7nK+lnOcMUcxZCCEvNFnktE8Ik+Vv19iMdwV
	 xrtviPpTD/7N+XnLu8Ds2ujzxszL1tRgQviMaufpHWGoNJkrGXhW+MATA5OHsepKEP
	 YllORJMXxrpXwrgTDbLCZWMBA4gV82a1FA82gN9ggJRiMeJg+yT+r/m2T9vlzL7o13
	 V+EAps5cCqhgF+MFwd1P6FtWjqePxRDbecuixlPABVczSzme1Yot66/qBB3faMhuK3
	 xZj4zg20BKtSgS5XBRK/KoUYP/7mz9FHNe0ahFw11NycFL+COgiKNb0z4hqfOCGw35
	 4lMcJs6rwCwRg==
Date: Fri, 16 Feb 2024 16:28:47 +0000
From: Will Deacon <will@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240216162847.GA2292@willie-the-truck>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <02fac0ab-07ac-448e-ae4e-26788ed4fce9@arm.com>
 <a0c62629-999f-4aa1-86c7-3104811f84d0@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0c62629-999f-4aa1-86c7-3104811f84d0@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 15, 2024 at 08:11:38PM +0000, Robin Murphy wrote:
> On 2024-02-15 6:42 pm, Robin Murphy wrote:
> [...]
> > > > > +static void arm_smmu_get_ste_used(const __le64 *ent, __le64
> > > > > *used_bits)
> > > > >   {
> > > > > +    unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG,
> > > > > le64_to_cpu(ent[0]));
> > > > > +
> > > > > +    used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
> > > > > +    if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
> > > > > +        return;
> > > > > +
> > > > > +    /*
> > > > > +     * See 13.5 Summary of attribute/permission
> > > > > configuration fields for the
> > > > > +     * SHCFG behavior. It is only used for BYPASS,
> > > > > including S1DSS BYPASS,
> > > > > +     * and S2 only.
> > > > > +     */
> > > > > +    if (cfg == STRTAB_STE_0_CFG_BYPASS ||
> > > > > +        cfg == STRTAB_STE_0_CFG_S2_TRANS ||
> > > > > +        (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
> > > > > +         FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> > > > > +             STRTAB_STE_1_S1DSS_BYPASS))
> > > > > +        used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > > > 
> > > > Huh, SHCFG is really getting in the way here, isn't it?
> > > 
> > > I wouldn't say that.. It is just a complicated bit of the spec. One of
> > > the things we recently did was to audit all the cache settings and, at
> > > least, we then realized that SHCFG was being subtly used by S2 as
> > > well..
> > 
> > Yeah, that really shouldn't be subtle; incoming attributes are replaced
> > by S1 translation, thus they are relevant to not-S1 configs.
> 
> That said, in this specific case I don't understand why we're worrying about
> SHCFG here at all - we're never going to make use of any value other than
> "use incoming" because we can't rely on it being implemented in the first
> place, and even if it is, we really don't want to start getting into the
> forced-coherency notion that the DMA layer can'#t understand and devicetree
> can't describe.

Yup, that's exactly what I'm thinking. We currently set it to NSH when
translation is enabled, so that the stage-2 shareability is effectively
an override. However, the device is either coherent, or it isn't, and so
we should just leave this always set to "use incoming" in my opinion,
which means we no longer need to care about qword 1 for the bypass case.

Will
