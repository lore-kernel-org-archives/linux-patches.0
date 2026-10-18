Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4303876A0
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 17:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345220; cv=none; b=maCHL21mfwwHo2uEHPS4wdyGwSxKCSvvCDpOmYSwGF+Q/4oQ5/Xcr6UAwVRALVUyZ4Lluh4LtLVPuVz3nkY+tbUOCTuPdi5aDAl3bymx3Ol2tNYL6AmKG9k8RXV0SX+qY7auygOLMg9UTujKqmQhZVxVbj/pwDSD5ZyI5pPp8Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345220; c=relaxed/simple;
	bh=03wOdN0QqpNw0B5wbOQxOLCbp9B3KFMzooqxQafR8vU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3eNKoDK2t1Ww70vUcK17dTLaf7ZZhu2B6fk2CcnIfBemtLzLqdsKkxWMeqbjCao2UPi9x6OO04y9xn2hMmbRGlgo7EhMneZfvoiOAf3Uye2k5lU65TtegRlXcWvzOTMJvU03Hc4dnINIDo7QnuttbM2A3jgc366D2G15FYUeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M/bDqVmh; arc=none smtp.client-ip=91.218.175.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M/bDqVmh"
X-Envelope-To: patches@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=03wOdN0QqpNw0B5wbOQxOLCbp9B3KFMzooqxQafR8vU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792345215; v=1; x=1792950015;
 b=M/bDqVmhGYZKqNnkkCGFdt64nMmWNhE2ZC2KCC2pCIniBnpN7iVnfozwV5MdVmUkc5XloPA8
 L2fxlPwWWnPcqpQXE0mTiuaHPSH2aFJlxtlIX3lAw9oJc4ESh5+alvaZtruLy0873NWDyG4M2Pu
 cIHpNra89ah65MnqW+40sIqU=
X-Envelope-To: patches@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cb3488b75a0f913e;
	Sun, 18 Oct 2026 17:40:10 +0000
X-Mizu-Trace-ID: cb3488b75a0f913e
X-Migadu-Flow: FLOW_OUT
Date: Mon, 19 Oct 2026 01:40:52 +0800
From: Chen Yu <chen.yu@linux.dev>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, ben.horgan@arm.com, james.morse@arm.com,
	Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
	tglx@linutronix.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
	peternewman@google.com, yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 3/5] x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG
 scope property to x86 resource
Message-ID: <atUEpF4pd4YBncbL@three-body>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <c873c62e78f335df6f7b99cb0cf0ccbcdd62b09e.1791406459.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c873c62e78f335df6f7b99cb0cf0ccbcdd62b09e.1791406459.git.reinette.chatre@intel.com>

Hi Reinette,

On Wed, Oct 07, 2026 at 02:06:45PM -0700, Reinette Chatre wrote:
> 
> MSR_IA32_L{2,3}_QOS_CFG enable code and data prioritization on x86. On
> Intel the registers have the scope of the associated cache while on AMD
> they have CPU scope. The scope is recorded as a property of the cache
> resource's control, of which each cache resource currently supports only
> one.
> 
> The scope of MSR_IA32_L{2,3}_QOS_CFG is only relevant to x86. Even so, the
> property is found among the resctrl filesystem's cache properties while only
> x86 code sets and reads it. Keeping the property with the cache control
> properties would also duplicate it across all controls of a resource when
> resources support multiple controls.
> 
> Make the scope of MSR_IA32_L{2,3}_QOS_CFG a property of the x86 hardware
> resource and name it for the registers it describes now that it no longer
> needs to be generic.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

[ ... ]

> @@ -140,6 +143,7 @@ struct rdt_hw_resource {
>  	unsigned int		mon_scale;
>  	unsigned int		mbm_width;
>  	bool			cdp_enabled;
> +	bool			qos_cfg_has_cpu_scope;
>  	bool			mbm_cntr_assign_enabled;
>  	bool			sdciae_enabled;
>  };

It seems that some flags are in resource scope, while others are in the controller's scope,
cache's flags are in the resource scope, MB's flags are in controller's scope, for example "linear".
For now, there is only one controller under the L2/L3 cache resource, so it might
not be duplicated if we keep qos_cfg_has_cpu_scope in the controller scope to keep consistence? Or do
you mean if in the future there are multiple controllers under this cache resource, all controllers'
flags (e.g., qos_cfg_has_cpu_scope) would still share the same value, so it is OK to put the flag in
the cache resource? If yes, the code looks good to me,

Review-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
