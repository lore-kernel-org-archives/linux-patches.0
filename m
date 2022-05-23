Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14492F27
	for <patches@lists.linux.dev>; Mon, 23 May 2022 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NPVP0vP+ExmNroRIHFq1qAD6xpWTFjMAiNHPjfVwZHs=; b=ELvOYeRnaJaljBF9bn7TrryW0X
	Idy3hj2oF4skLt14h3gGeXSbKVmNEQ+zOmAq+TfdEh9NbZ/0XGz/MXFB0xU8fuJuUp2NnxmLFkd/E
	tz9t12EEbZ6SYURJp/2/fSBW+kDV3tq0tF+O05/5NHSLVQdy5GIl2YBTiPhzzcs4wqHrm7Ux3TTCp
	IJB/Kb7KeoU2wu5FF4yqeh+HJQ7EMxjcTmD4bwiYlHWZc5KVqiwSrjEAdNUDVhAh80joDt0vp9MtF
	wcyB2EP0oDwJPsQcsPx+Jhtmw7fZQScA53pA/FIH7+P//5cENFcALfga+orkN77ZbuMFs9PGfKiHI
	ovXWuwIA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ntC0w-005Q5a-21; Mon, 23 May 2022 17:38:42 +0000
Date: Mon, 23 May 2022 10:38:42 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Pankaj Raghav <pankydev8@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	patches@lists.linux.dev, amir73il@gmail.com, tytso@mit.edu,
	josef@toxicpanda.com, jmeneghi@redhat.com, jake@lwn.net
Subject: Re: [PATCH 3/4] playbooks: add a common playbook a git reset task
 for kdevops
Message-ID: <YovGojXJQMbGQkqu@bombadil.infradead.org>
References: <20220513193831.4136212-1-mcgrof@kernel.org>
 <20220513193831.4136212-4-mcgrof@kernel.org>
 <20220520144405.uzzejos24qizwa5c@quentin>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520144405.uzzejos24qizwa5c@quentin>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, May 20, 2022 at 04:44:05PM +0200, Pankaj Raghav wrote:
> Hi Luis,
> 
> On Fri, May 13, 2022 at 12:38:30PM -0700, Luis Chamberlain wrote:
> > Two playbooks share the concept of git cloning kdevops into
> > the target nodes (guests, cloud hosts, baremetal hosts) so that
> > expunge files can be used for avoiding tests. If you decide
> > you want to change the URL for that git tree it may not be
> > so obvious what to do.
> > 
> > Fortunately the solution is simple. You just tell ansible to use
> > the new git tree URL. That's it. It won't remove the old directory
> > and things work as expected.
> > 
> > But since we use the kdevops git tree on both fstests and blktests
> > it is not so obvious to developers that the thing to do here is
> > to just run 'make fstests' or 'make blktests' and even that is not
> > as efficient as that will also re-clone the fstests or blktests
> > tree respectively. When we just want to reset the kdevops git tree
> > we currently have no semantics to specify that. But since this is
> > a common post-deployment goal, just add a common playbook that let's
> > us do common tasks.
> > 
> > All we need then is the kconfig logic to define when some commmon
> > tasks might make sense. So to reset your kdevops git tree, all you
> > have to do now is change the configuration for it, then run:
> > 
> > make
> > make kdevops-git-reset
> > 
> 
> While I do like the idea of having this option, I still do not
> understand the main use case to have it as a separate make target.
> Wouldn't the developer already put the custom kdevops tree with
> CONFIG_WORKFLOW_KDEVOPS_GIT during the initial make menuconfig phase?

For initial setup yes. The value of the new make target is for when
you already deployed kdevops, and now you want to change the git URL
for the guests if they have workflows which clone kdevops for using
expunges when testing such as with fstests and blktest.

> I am just trying to understand the usecase when someone wants to change
> the kdevops tree after a test run. Maybe I am missing something here.

That is right, the use case here of the new make target is so that a
user can change the target kdevops tree on the guests if they are
working with fstests and blktests. Otherwise then the git tree will
only change on the host. If you ran 'make fstests' for instance you
git cloned fstests, compiled and installed it, but the kdevops tree
was also cloned and used on each guest so to ensure only tests which
are not expunged for the target test are run. Without this new make
target if you wanted to reset the git tree on the guests you'd have to
re-run 'make fstests'. Where as with the new target, it's just a one
liner.

  Luis
