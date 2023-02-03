Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20AAD5A
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 18:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C03FC433D2;
	Fri,  3 Feb 2023 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675450461;
	bh=KpbB9U31eyYcPCUWMcMZPGeAmyR4pElU4bKz0xNDqaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qb1V4xYtg++gArDvcPF8OsFBbjLwUfq1XsPTOU2oqUEZ15q7f3P+Scms/Tc44UYu0
	 R/hIScdZN88Qr+LzEq/Ogg8TujOmk8tisepnVD9r56kssNIfTYgi1sKauBeiUnR/Ij
	 ak0atbxW1FRB9AsElV2E3w1fEsQN9qYX70yhuVYxtDqpO8N2oF6xo+x6yS8KrHwJ+k
	 dzAYHVymXtNLu03Ah3WRYTN8Frkpyhi1j9h6nr3BRCZRPrgGhImIXZl4S7D50GtidQ
	 EW1fX1ObggiyVGZ3mWUP/cvP7sEVeU8o6LQQfAZWvE5wGEMr3AoQ/keiLY6aaQMfGO
	 lABlEr17f4pJw==
Date: Fri, 3 Feb 2023 10:54:19 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <Y91YWzopMMGF1Lgh@sol.localdomain>
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net>
 <Y906Hz3UWYxoxYdD@kroah.com>
 <20230203171826.GA1500930@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203171826.GA1500930@roeck-us.net>

On Fri, Feb 03, 2023 at 09:18:26AM -0800, Guenter Roeck wrote:
> On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> > > On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.231 release.
> > > > There are 134 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > Building ia64:defconfig ... failed
> > > --------------
> > > Error log:
> > > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > > arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> > > arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> > > 
> > > Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
> > 
> > Yup, it does!
> > 
> > Eric, any help with this?
> > 
> 
> Adding "#include <linux/sched/task.h>" to the affected file would probably
> be the easy fix. I did a quick check, and it works.
> 
> Note that the same problem is seen in v4.14.y and v4.19.y. Later
> kernels don't have the problem.
> 

This problem arises because <linux/mm.h> transitively includes
<linux/sched/task.h> in 5.10 and later, but not in 5.4 and earlier.

Greg, any preference for how to handle this situation?

Just add '#include <linux/sched/task.h>' to the affected .c file (and hope there
are no more affected .c files in the other arch directories) and call it a day?

Or should we backport the transitive inclusion (i.e., the #include added by
commit 80fbaf1c3f29)?  Or move the declaration of make_task_dead() into
<linux/kernel.h> so that it's next to do_exit()?

- Eric
