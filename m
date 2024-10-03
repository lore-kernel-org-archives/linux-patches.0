Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4C3208A9;
	Thu,  3 Oct 2024 07:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727939950; cv=none; b=alNqEUUz/AE6mSE8uT+Ue0pMtni4sTGcFwyKal4vRUbs6bjExKnEoHj443ZoV4I46sJemPUqSAeYnHwppacf3XoGKvUp/AWubQ9n+uwmBCohgudISsS+J/nWDXojS0A4CKA8Fm8WTryhJxDENddJbBza5N7MG/Oa+mFYRIR+QzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727939950; c=relaxed/simple;
	bh=l++B4Wh7uo+0hneCH3ghQ5jp3lBYse6c8Si5F2NEaKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fx/9hplTv31v9SBTmzsLHZd1JD7vIOC+EQw9VTT8WNMHWtWTXBJWmW5++9KR0+HjVwymZCldDw+oCfMbIyfAoDhxDOvZRZer2zuTM8g0eEVL+uVmWWt+HsYF6vXumq2kh9/BQmqrQrMq1p9w/DCZKtPSzyfNhuDfwbRwFn0QR0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEzvHmD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEzvHmD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D376FC4CEC7;
	Thu,  3 Oct 2024 07:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727939950;
	bh=l++B4Wh7uo+0hneCH3ghQ5jp3lBYse6c8Si5F2NEaKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UEzvHmD8j4auXmEOMZHb9pBF+Y5RAV+PmSVw4blaZDPosp94Uosa3g6ItZzbuJrrE
	 O1pe4ZSLZ9ChkNAjp2VG9gL8mLgJkxkXYUxr1lclN1/ed5GE/Nykq0KbEsyoAp27q0
	 GN9bMnLXc2jn8elUc3a38n9s5Hxn8CySKz1ejhEc=
Date: Thu, 3 Oct 2024 09:19:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Youzhong Yang <youzhong@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
Message-ID: <2024100330-drew-clothing-79c1@gregkh>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>

On Wed, Oct 02, 2024 at 10:12:32AM -0400, Youzhong Yang wrote:
> My understanding is that the following 4 commits together fix the leaking issue:
> 
> nfsd: add list_head nf_gc to struct nfsd_file
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8e6e2ffa6569a205f1805cbaeca143b556581da6
> 
> nfsd: fix refcount leak when file is unhashed after being found
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8a7926176378460e0d91e02b03f0ff20a8709a60
> 
> nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=81a95c2b1d605743220f28db04b8da13a65c4059
> 
> nfsd: count nfsd_file allocations
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=700bb4ff912f954345286e065ff145753a1d5bbe
> 
> The first two are essential but it's better to have the last two commits too.

So right now only the 2nd and 3rd are in the tree, do we really need the
others as well?  And if so, why were none of these marked for a stable
inclusion?

Can they wait for the next round of releases?

thanks,

greg k-h
