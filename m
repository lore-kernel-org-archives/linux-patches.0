Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F6B199FC1;
	Tue, 22 Oct 2024 13:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729603274; cv=none; b=M0mhgI6/1zRmbIlWpiUtu0DK3V5DwMjrvQHrooVjVreEonpjc2hc+75wOrzV4S2Bpa9hkP05dRiUz858oJ3Y2/S2ex3+pmS//CE6XjyR7FVM5oMkXu5DoyuAhzBpNy6WHxkVwPVRAjyrKF8TytiG/2pruBFo2RVQPoy10Ush6Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729603274; c=relaxed/simple;
	bh=djY8BWbzviAEmaIq62OOtZ+V3ZfiHmf2TA98F361Ymw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfoOVqCm5TqWKd/oAGyXeLEvc0oI2cFgIITEeD38UGoDMxUw1NII7NnaQpmgr//n1+j/wxSM4WD08cIptHgzHCi8WdgVwaCopOnGsxdBGebmpiGt6ak3l0y7kCP5pnsdBIBWxAkyvTt+7gg6/xJ6Xx06L63Aa9YKFK2e4+D1y2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+GfWEzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+GfWEzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0109DC4CEC7;
	Tue, 22 Oct 2024 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729603273;
	bh=djY8BWbzviAEmaIq62OOtZ+V3ZfiHmf2TA98F361Ymw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U+GfWEzyoR5Luhd+y79H1u5GZr5qIY4G/lNfeizlVoiY9IIrjtIdVWxzbNEXE/X3s
	 HYY/X1+fLD6HstwUL3OtuDeDEeGwuk3WePYPd9rdvgfIZF9uYrFJHr7usj9WTsqmDX
	 7wp0/+llcKhfO9YR8L5DbyOnV7ljYyvMIZHkIaGc=
Date: Tue, 22 Oct 2024 15:21:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Uladzislau Rezki <urezki@gmail.com>,
	Ben Greear <greearb@candelatech.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
Message-ID: <2024102255-sycamore-porthole-b91a@gregkh>
References: <20241021102259.324175287@linuxfoundation.org>
 <20241021102300.282974151@linuxfoundation.org>
 <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com>
 <ZxZ_uX0e1iEKZMk5@pc636>
 <2024102130-tweet-wheat-0e55@gregkh>
 <fb0cd50e-5525-4521-aa1d-f919ae19f77d@suse.cz>
 <CAJuCfpFU1tLc_wvAGu1T3WximLFRARVxBtJTm0bOfgqt_MnYyA@mail.gmail.com>
 <CAJuCfpFzgYvCTOWNDq55tG+xPVdJ5Rc2DjH6Ltzrc7--U4Kv5Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFzgYvCTOWNDq55tG+xPVdJ5Rc2DjH6Ltzrc7--U4Kv5Q@mail.gmail.com>

On Mon, Oct 21, 2024 at 10:12:13AM -0700, Suren Baghdasaryan wrote:
> On Mon, Oct 21, 2024 at 10:06 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Mon, Oct 21, 2024 at 10:04 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> > >
> > > On 10/21/24 18:57, Greg Kroah-Hartman wrote:
> > > > On Mon, Oct 21, 2024 at 06:22:17PM +0200, Uladzislau Rezki wrote:
> > > >> On Mon, Oct 21, 2024 at 09:16:43AM -0700, Ben Greear wrote:
> > > >> > On 10/21/24 03:23, Greg Kroah-Hartman wrote:
> > > >> > > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > > >> >
> > > >> > This won't compile in my 6.11 tree (as of last week), I think it needs more
> > > >> > upstream patches and/or a different work-around.
> > > >> >
> > > >> > Possibly that has already been backported into 6.11 stable and I just haven't
> > > >> > seen it yet.
> > > >> >
> > > >> Right. The kvfree_rcu_barrier() will appear starting from 6.12 kernel.
> > > >
> > > > Ick, how is it building on all of my tests?  What config option am I
> > > > missing?
> > >
> > > Most likely CONFIG_MEM_ALLOC_PROFILING
> > > Depends on: PROC_FS [=y] && !DEBUG_FORCE_WEAK_PER_CPU [=n]
> >
> > Yes, it's disabled by default.
> 
> 6.11 backports including prerequisite patch are posted at
> https://lore.kernel.org/all/20241021171003.2907935-1-surenb@google.com/

Thanks, I'll go drop this one from the tree for now and take those for
the next stable release.

greg k-h
