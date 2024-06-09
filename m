Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9015249F9;
	Sun,  9 Jun 2024 11:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717931134; cv=none; b=BKAhGtV8GgSPtQFuF9LJV+moVjI5soEaPd/cBQeDUwZaJI13gooWgMbdaBrPn47sI9DadvNvfssCAI+FU68gVk86b0hadAYGkskjggS2Q2kAAcb6QU+3xPxWqywzoK/YhtsXLz0J89YwHmjMjTOnBH80JE2rViTCZfUyllaxvlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717931134; c=relaxed/simple;
	bh=X0pcd9jwDAco3NHJo3/FG+Snk468Do0Iac4GiNoSj/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tku4VjPjvLCtN15J2S5kt/u1cAwWFERTf1Si3UAFqg8POr1nBMrJdoE3jKeUU+v+eg64Xs0mQrP+xO2dt0L2AM+cwPzwMw82F4Chrtm7BQ1rZ52mYSgB2WFYil7b9aeZZAv6pJSLvGHyaVLilMaGKqODTO166GthujteZsKFobY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dE4KKh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dE4KKh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32334C2BD10;
	Sun,  9 Jun 2024 11:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717931134;
	bh=X0pcd9jwDAco3NHJo3/FG+Snk468Do0Iac4GiNoSj/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2dE4KKh1yi1yeJISMvz1EoWnk2PDPEl6oMxEhfvEi4yU3PN6vnUK/1C0SXhfxsH2p
	 jU/1dFpu5mZac8hWK2XarlIDA2VsYCg2+wN5Bgutq2dswg25jNo0eG5VdaXqh3Cf4+
	 /QK443w8JyOB3NscZxlwpH20ftUNTW4Mo8fxoWIE=
Date: Sun, 9 Jun 2024 13:05:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
	kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 617/744] nilfs2: make superblock data array index
 computation sparse friendly
Message-ID: <2024060919-maturity-geek-143b@gregkh>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240606131752.295435490@linuxfoundation.org>
 <CAKFNMo=+e+tOPQ4r3ZvyO_wCoCoQw9=OErnKFwkQ9qqovDKSMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKFNMo=+e+tOPQ4r3ZvyO_wCoCoQw9=OErnKFwkQ9qqovDKSMg@mail.gmail.com>

On Fri, Jun 07, 2024 at 04:26:38AM +0900, Ryusuke Konishi wrote:
> On Thu, Jun 6, 2024 at 11:22 PM Greg Kroah-Hartman wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> >
> > [ Upstream commit 91d743a9c8299de1fc1b47428d8bb4c85face00f ]
> >
> 
> Hi Greg,
> 
> I have twice raised the suspicion that this patch should not be
> eligible for stable backport because it is not a bugfix (it just fixes
> a false positive sparse warning).  And you dropped it the first time
> [1][2].
> 
> [1] https://lkml.kernel.org/r/CAKFNMo=kyzbvfLrTv8JhuY=e7-fkjtpL3DvcQ1r+RUPPeC4S9A@mail.gmail.com
> [2] https://lkml.kernel.org/r/CAKFNMontZ54JxOyK0_xy8P_SfpE0swgq9wiPUErnZ-yrO7wOJA@mail.gmail.com
> 
> On Tue, May 28, 2024 at 3:28 AM Greg KH <greg@kroah.com> wrote:
> > > This commit fixes the sparse warning output by build "make C=1" with
> > > the sparse check, but does not fix any operational bugs.
> > >
> > > Therefore, if fixing a harmless sparse warning does not meet the
> > > requirements for backporting to stable trees (I assume it does),
> > > please drop it as it is a false positive pickup.  Sorry if the
> > > "Fixes:" tag is confusing.
> > >
> > > The same goes for the same patch queued to other stable-trees.
> >
> > Now dropped, thanks!
> >
> > greg k-h
> 
> Perhaps due to the confusing Fixes tag, this patch appears to have
> been picked up again.
> Unless the criteria for its inclusion or exclusion have changed, I
> think this was selected by mistake.  Please check.

Yeah, good catch, now dropped, again.

greg k-h
