Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B2420E8
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 09:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EEEC433EF;
	Tue,  7 Feb 2023 09:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675762839;
	bh=SQUviBUizO1hZYWn0mGXkIEt73F60h6UPfc9e8NjHlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLgqWMxPaRcK93ejaMDk0ZS9rUUfQShy2rQJjThlOh4LbXOcd3rRd7Z1MC754y5ME
	 +T1GW1WEN/EpWgUMM+J/hUE2NNMXZfSzqqplRA3Q6IgJPGczYLVMjvfIwPV8yUA5H9
	 LRXwbtWrWFBk3IuSmlcIt22esE/fKwKc+aymxy5Q=
Date: Tue, 7 Feb 2023 10:40:33 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Shaoying Xu <shaoyi@amazon.com>
Cc: dsahern@kernel.org, idosch@nvidia.com, kuba@kernel.org,
	patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 60/67] ipv4: Fix incorrect route flushing when source
 address is deleted
Message-ID: <Y+IckeUtbE/UfOz/@kroah.com>
References: <20221212130920.482075438@linuxfoundation.org>
 <20230205053100.15903-1-shaoyi@amazon.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205053100.15903-1-shaoyi@amazon.com>

On Sun, Feb 05, 2023 at 05:30:58AM +0000, Shaoying Xu wrote:
> On Mon, 12 Dec 2022 14:17:35 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > [ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]
> > 
> > Cited commit added the table ID to the FIB info structure, but did not
> > prevent structures with different table IDs from being consolidated.
> > This can lead to routes being flushed from a VRF when an address is
> > deleted from a different VRF.
> > 
> > Fix by taking the table ID into account when looking for a matching FIB
> > info. This is already done for FIB info structures backed by a nexthop
> > object in fib_find_info_nh().
> > 
> > Add test cases that fail before the fix:
> > 
> >  # ./fib_tests.sh -t ipv4_del_addr
> > 
> >  IPv4 delete address route tests
> >      Regular FIB info
> >      TEST: Route removed from VRF when source address deleted            [ OK ]
> >      TEST: Route in default VRF not removed                              [ OK ]
> >      TEST: Route removed in default VRF when source address deleted      [ OK ]
> >      TEST: Route in VRF is not removed by address delete                 [ OK ]
> >      Identical FIB info with different table ID
> >      TEST: Route removed from VRF when source address deleted            [FAIL]
> >      TEST: Route in default VRF not removed                              [ OK ]
> >  RTNETLINK answers: File exists
> >      TEST: Route removed in default VRF when source address deleted      [ OK ]
> >      TEST: Route in VRF is not removed by address delete                 [FAIL]
> > 
> >  Tests passed:   6
> >  Tests failed:   2
> > 
> > And pass after:
> > 
> >  # ./fib_tests.sh -t ipv4_del_addr
> > 
> >  IPv4 delete address route tests
> >      Regular FIB info
> >      TEST: Route removed from VRF when source address deleted            [ OK ]
> >      TEST: Route in default VRF not removed                              [ OK ]
> >      TEST: Route removed in default VRF when source address deleted      [ OK ]
> >      TEST: Route in VRF is not removed by address delete                 [ OK ]
> >      Identical FIB info with different table ID
> >      TEST: Route removed from VRF when source address deleted            [ OK ]
> >      TEST: Route in default VRF not removed                              [ OK ]
> >      TEST: Route removed in default VRF when source address deleted      [ OK ]
> >      TEST: Route in VRF is not removed by address delete                 [ OK ]
> > 
> >  Tests passed:   8
> >  Tests failed:   0
> > 
> > Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  net/ipv4/fib_semantics.c                 |    1 +
> >  tools/testing/selftests/net/fib_tests.sh | 1727 ----------------------
> >  2 files changed, 1 insertion(+), 1727 deletions(-)
> >  delete mode 100755 tools/testing/selftests/net/fib_tests.sh
> 
> Hi Greg,
> 
> Sorry for last unclear message without context. I found this commit deleted
> the whole fib_tests.sh that causes new failure in kselftests run. Looking at
> the upstream patch [1] and given the context that ipv4_del_addr test is not
> available to kernel 5.4, I added the revert patch and new backport of this
> commit to resolve the potential mistake.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f96a3d74554df537b6db5c99c27c80e7afadc8d1
> 
> Thanks,
> Shaoying
> 
> Ido Schimmel (1):
>   ipv4: Fix incorrect route flushing when source address is deleted
> 
> Shaoying Xu (1):
>   Revert "ipv4: Fix incorrect route flushing when source address is
>     deleted"
> 
>  tools/testing/selftests/net/fib_tests.sh | 1727 ++++++++++++++++++++++
>  1 file changed, 1727 insertions(+)
>  create mode 100755 tools/testing/selftests/net/fib_tests.sh

See my comments on patch 1/2 here, can you fix that up and resend these?

thanks,

greg k-h
