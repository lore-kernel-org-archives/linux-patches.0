Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F36111BB;
	Wed, 20 Sep 2023 10:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF22C433C8;
	Wed, 20 Sep 2023 10:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695206715;
	bh=JugKkRU1X5rlumprCvTfvliuik27QKBGnmfChQ51VtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0S0tEb+VLi12h64gO4CuGvecaMFC5e19Gongi+LH/kAPQd6rkoQNPtKmmAORZDr8e
	 Be6rS8Q9MrvPZtQZm48G3aKKzKhvvoN2Zr6YEjQbV5BNCXtv2aQTmq8zxbUzgK84OQ
	 oFkgMCBCH/uxkCGtN6+rNx5I4XEwVNdG7gTRT6HE=
Date: Wed, 20 Sep 2023 12:45:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <2023092044-porthole-impeding-e539@gregkh>
References: <20230917191040.964416434@linuxfoundation.org>
 <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>
 <2023092032-applied-gave-0bff@gregkh>
 <76525b1a-6857-434d-86ee-3c2ff4db0e4c@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76525b1a-6857-434d-86ee-3c2ff4db0e4c@linux.microsoft.com>

On Wed, Sep 20, 2023 at 12:21:37PM +0200, Jeremi Piotrowski wrote:
> On 9/20/2023 11:25 AM, Greg Kroah-Hartman wrote:
> > On Wed, Sep 20, 2023 at 10:43:56AM +0200, Michal Hocko wrote:
> >> On Wed 20-09-23 01:11:01, Jeremi Piotrowski wrote:
> >>> On Sun, Sep 17, 2023 at 09:12:40PM +0200, Greg Kroah-Hartman wrote:
> >>>> 6.1-stable review patch.  If anyone has any objections, please let me know.
> >>>>
> >>>> ------------------
> >>>
> >>> Hi Greg/Michal,
> >>>
> >>> This commit breaks userspace which makes it a bad commit for mainline and an
> >>> even worse commit for stable.
> >>>
> >>> We ingested 6.1.54 into our nightly testing and found that runc fails to gather
> >>> cgroup statistics (when reading kmem.limit_in_bytes). The same code is vendored
> >>> into kubelet and kubelet fails to start if this operation fails. 6.1.53 is
> >>> fine.
> >>
> >> Could you expand some more on why is the file read? It doesn't support
> >> writing to it for some time so how does reading it helps in any sense?
> >>
> >> Anyway, I do agree that the stable backport should be reverted.
> > 
> > That will just postpone the breakage, we really shouldn't break
> > userspace.
> > 
> > That being said, having userspace "break" because a file is no longer
> > present is not good coding style on the userspace side at all.  That's
> > why we have sysfs and single-value-files now, if the file isn't present,
> > then userspace instantly notices and can handle it.  Much easier than
> > the old-style multi-fields-in-one-file problem.
> > 
> 
> The memcg files in this case are single-value, but userspace expects to be able
> to read memcg limits when it can read the usage (indicating MEMCG is enabled).
> If it can't - then something is off, and the node is marked unhealthy.
> 
> >>>> Address this by wiping out the file completely and effectively get back to
> >>>> pre 4.5 era and CONFIG_MEMCG_KMEM=n configuration.
> > 
> > The fact that this is a valid option (i.e. no file) with that config
> > option disabled makes me want to keep this as well, as how does
> > userspace handle this option disabled at all?  Or old kernels?
> > 
> 
> Userspace has had to handle the case of MEMCG_KMEM=n, but that had 2 cases so far:
> 
> limits/usage/max_usage/failcnt files are all available or none of them are available.
> 
> Now it needs to handle 3 of 4 files being available, but only for kmem (and not plain
> memory, memsw or kmem.tcp). That's an inconsistency.
> 
> > I can drop this from stable kernels, but again, this feels like the runc
> > developers are just postponing the problem...
> >
> 
> Since cgroups v1 is deprecated, I think the runc developers haven't touched this part
> of the code in years and expected it to keep working while they wait for the long tail
> of usage to die out.

Ok, then we should revert this, I'll go drop it in the stable trees, it
should also be reverted in Linus's tree too.

thanks,

greg k-h
