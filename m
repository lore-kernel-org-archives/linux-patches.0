Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA942224CC;
	Sun,  4 Feb 2024 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050938; cv=none; b=P0vdqxOQgoyzarrZCIUVKlHYbi6yO4kwR4NuHiQxlO2eLU4+a1NsjEDzBZ8mhN2IsSstVHT0k7wvwEl+/plskx6M4ljJJwJjykwZDVKtuT0vj3HclGprP5CU5/+MrdKELQTuwC808MG2KHn/bsomCJWcHKuSZUYPlN1mp+lZnrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050938; c=relaxed/simple;
	bh=VBXqlcvuMvwJAtCakU0gN/L6AJp/s7dueWzRgXmt7n0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWoFdgqOyeX7wqCdWGht14mZGHCPwrOIgUXhgO5Ocp4aJBRYHF3c0wOQKcL+iho0rLEajCGVpQHnI+xo0CiEpvbO1iMbj25CAUL99YW9KiusK1eOE++r6RREkclMYPExBFUvDhL6ZrPtDNCr9Ns/TjjwripUZSaw0jelHtEUfI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itMXrW/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itMXrW/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5E9C433F1;
	Sun,  4 Feb 2024 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707050937;
	bh=VBXqlcvuMvwJAtCakU0gN/L6AJp/s7dueWzRgXmt7n0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=itMXrW/DGSUd0znBsyWOpuK6tstKhac8kGEiknawhHo+XrJOI6aPGto0KL8bu1hjJ
	 AcH+8s5pJHco88Ql2SrTdCSPVotY8aGNFVFlf39Qn8ncEbLMEU4C05NQNWnwYQ/dEB
	 PTFHMxfRweB1xpLBe1u46egdD9TBIFaW0OtliiMk=
Date: Sun, 4 Feb 2024 04:48:55 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	=?utf-8?B?0KHRgtCw0YEg0J3QuNGH0LjQv9C+0YDQvtCy0LjRhw==?= <stasn77@gmail.com>,
	Linux Regressions <regressions@lists.linux.dev>
Subject: Re: [PATCH 6.6 295/322] netfilter: ipset: fix performance regression
 in swap operation
Message-ID: <2024020441-grumpily-crumb-03c3@gregkh>
References: <20240203035359.041730947@linuxfoundation.org>
 <20240203035408.592513874@linuxfoundation.org>
 <Zb81_PFP54xFYQSd@archie.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zb81_PFP54xFYQSd@archie.me>

On Sun, Feb 04, 2024 at 02:00:12PM +0700, Bagas Sanjaya wrote:
> On Fri, Feb 02, 2024 at 08:06:32PM -0800, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jozsef Kadlecsik <kadlec@netfilter.org>
> > 
> > [ Upstream commit 97f7cf1cd80eeed3b7c808b7c12463295c751001 ]
> > 
> > The patch "netfilter: ipset: fix race condition between swap/destroy
> > and kernel side add/del/test", commit 28628fa9 fixes a race condition.
> > But the synchronize_rcu() added to the swap function unnecessarily slows
> > it down: it can safely be moved to destroy and use call_rcu() instead.
> > 
> > Eric Dumazet pointed out that simply calling the destroy functions as
> > rcu callback does not work: sets with timeout use garbage collectors
> > which need cancelling at destroy which can wait. Therefore the destroy
> > functions are split into two: cancelling garbage collectors safely at
> > executing the command received by netlink and moving the remaining
> > part only into the rcu callback.
> 
> Hi,
> 
> Стас Ничипорович <stasn77@gmail.com> reported ipset kernel panic with this
> patch [1]. He noted that reverting it fixed the regression.
> 
> Thanks.
> 
> [1]: https://lore.kernel.org/stable/CAH37n11s_8qjBaDrao3PKct4FriCWNXHWBBHe-ddMYHSw4wK0Q@mail.gmail.com/

Is this also an issue in Linus's tree?

thanks,

greg k-h
