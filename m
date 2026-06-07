Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076FF243387;
	Sun,  7 Jun 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780844624; cv=none; b=nwLiWbH1a537sDVQ9dlnfKTzPNiTvHyJOafahoG1tjSnp2sy14nBjdH0rtTcovokqmSuQHOs8tDyHxJwJgrpuXjy4gCub5tWaawi/2NwMwbx1grzuckxwKQogBLUE6/aJJS0VAqvafM0YBGvAhMvX2bSqteCp4RpVOd7wQsg9Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780844624; c=relaxed/simple;
	bh=/J5n8J3YoaYjsjj0/1RcMbmCp33LRAswhlJXies9Sbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKr1z57rKmozDzL2fbbmLUcv4crK5Jv+kRB3dDwWANtTkscLnthefpJJAs8YhZsk60Xxa5WD/4vOYawln63J6h2XcjoAk6FLW644xluV0b/Ku1HKIWOk5ksDPT3pHCo9aHFIm9gFulWp48fko20hhdwducbhfNIRrj8piqMhtRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OemTHbqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OemTHbqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93871F00893;
	Sun,  7 Jun 2026 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780844623;
	bh=SYGPCVsO0pzj7zz/LmnIqaKwdK1SmteuqABvRk6oT2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OemTHbqsDFvau4drDS9ZPHG7N2dLJ63KyYsaptuuMAGwqJEnHOoQR7Fx7TQjjjJm2
	 C8Et0M7tBsNHqbM3QLe5zAHx13PDWqD4jEpQHxG6H/ZIobLdhLp6NFT3N/ysB9O6ku
	 gZ4642dYOSvP8iQj+QgLYvpJuiUulWD67cfaqhO8=
Date: Sun, 7 Jun 2026 16:50:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@suse.com>, Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>, Liam Howlett <liam@infradead.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 015/332] kernel/fork: validate exit_signal in
 kernel_clone()
Message-ID: <2026060759-anyway-straining-d394@gregkh>
References: <20260607095728.031258202@linuxfoundation.org>
 <20260607095728.598854921@linuxfoundation.org>
 <aiVOEKt9QL5cvkwz@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiVOEKt9QL5cvkwz@redhat.com>

On Sun, Jun 07, 2026 at 12:55:12PM +0200, Oleg Nesterov wrote:
> On 06/07, Greg Kroah-Hartman wrote:
> >
> > 7.0-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Deepanshu Kartikey <kartikey406@gmail.com>
> >
> > [ Upstream commit 09e7827e785729f391c8d46dc71becce70d296ab ]
> 
> I don't think this is the -stable material.
> 
> > Note that this is a user-visible change: previously, passing an invalid
> > exit_signal to clone() was silently accepted.  The man page for clone()
> > does not document any defined behavior for invalid exit_signal values, so
> > rejecting them with -EINVAL is the correct behavior.  It is unlikely that
> > any sane application relies on passing an invalid exit_signal.
> 
> Yes...
> 
> This patch is the preparation for another commit 0f8e38eeb995b
> ("do_notify_parent: sanitize the valid_signal() checks").

Then why does it have:
	Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
in the body of the changelog?  That's why we picked it up, is that not
correct?

Should it be dropped from all stable queues then?

thanks,

greg k-h
