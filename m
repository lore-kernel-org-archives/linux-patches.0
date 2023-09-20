Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB504125C1;
	Wed, 20 Sep 2023 09:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0BEC433C9;
	Wed, 20 Sep 2023 09:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695201910;
	bh=+Vx4pZyRUu1fyYPhOi72zytZP5DFTTN2SI/8tCaJRjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NvoSEPeffyivIH5CT28GoxlHRWvGT8nI6rZcrGnSCP6Lnm79ksnS8+6TA8PxN+yi3
	 0KQ5ntj66H6wThAh66/jNwsM7jK10nRNss2HY4PTf1Zz8rlT8jUkwcY1pywD/KVdw0
	 2pxPMqnHxiFvS8l7uCnCacHDJvfR0m35IK2MZ7lM=
Date: Wed, 20 Sep 2023 11:25:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Hocko <mhocko@suse.com>,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <2023092032-applied-gave-0bff@gregkh>
References: <20230917191040.964416434@linuxfoundation.org>
 <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>

On Wed, Sep 20, 2023 at 10:43:56AM +0200, Michal Hocko wrote:
> On Wed 20-09-23 01:11:01, Jeremi Piotrowski wrote:
> > On Sun, Sep 17, 2023 at 09:12:40PM +0200, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > 
> > Hi Greg/Michal,
> > 
> > This commit breaks userspace which makes it a bad commit for mainline and an
> > even worse commit for stable.
> > 
> > We ingested 6.1.54 into our nightly testing and found that runc fails to gather
> > cgroup statistics (when reading kmem.limit_in_bytes). The same code is vendored
> > into kubelet and kubelet fails to start if this operation fails. 6.1.53 is
> > fine.
> 
> Could you expand some more on why is the file read? It doesn't support
> writing to it for some time so how does reading it helps in any sense?
> 
> Anyway, I do agree that the stable backport should be reverted.

That will just postpone the breakage, we really shouldn't break
userspace.

That being said, having userspace "break" because a file is no longer
present is not good coding style on the userspace side at all.  That's
why we have sysfs and single-value-files now, if the file isn't present,
then userspace instantly notices and can handle it.  Much easier than
the old-style multi-fields-in-one-file problem.

> > > Address this by wiping out the file completely and effectively get back to
> > > pre 4.5 era and CONFIG_MEMCG_KMEM=n configuration.

The fact that this is a valid option (i.e. no file) with that config
option disabled makes me want to keep this as well, as how does
userspace handle this option disabled at all?  Or old kernels?

I can drop this from stable kernels, but again, this feels like the runc
developers are just postponing the problem...

thanks,

greg k-h
