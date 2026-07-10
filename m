Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6863B14D0;
	Fri, 10 Jul 2026 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684205; cv=none; b=QpH3zHQF43tiejAhDGGZUtiX+sDbDyQO944Zxt5i4M8W3qRJOnaDofA9bk+QkKFt9IyfH3MS3AxAEKv5r4oI30bhy79qKjdXV5E7bxP0VUSjNf/zzpgq2JzV7Wa60aMgT2To2G5TUkbL/HatsESv4bPy5iwTrbvuEcg9jV05cS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684205; c=relaxed/simple;
	bh=0zdUmkAYIu7TQbO2qzGSlCDJ1NiHeK0hsVM5PwrAi6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2vZNe9h+t2KDbQgf9wZZfkzcXo7fdNbEv+eeZr0GwWFd5xT5ADwqz4VdEiWagjGJ7tbQw9797fXYXLdw4yvgWZ3gLy32cuAnbtr0f02Wj7ol/x4sPwNUGknu/3SKRolTy5yMOdY9M52oN3ph6q7IA2eyO1GSHOuvpGHa89OVy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKqurUcQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKqurUcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4241F000E9;
	Fri, 10 Jul 2026 11:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783684198;
	bh=2ECyTCPkkExKTnkYMGZphcdxdGDUw94pbpd/km7z2oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKqurUcQTSjci0lkPk6+JLcBJkSr7HjUNiblOcgJuoTh2XO5ODX0QrhqfC2slDQHn
	 cZhN4lB8D+283fL3m8CQL+d+6bxMU+iebQxBN5TAwgPKdP70ybiqd/nDMn3yfyAE8Z
	 I/PDCEw03rgzlN2zVeCsSBOQC+HmeR1ZtWGMAexM=
Date: Fri, 10 Jul 2026 13:49:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dominik =?utf-8?Q?Wo=C5=BAniak?= <stalion@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 6.12 187/204] nfsd: check get_user() return when reading
 princhashlen
Message-ID: <2026071043-dicing-arousal-ae51@gregkh>
References: <20260702155118.667618796@linuxfoundation.org>
 <20260702155122.580017616@linuxfoundation.org>
 <17cce379-76ca-49fd-91e7-1a486de62d2a@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17cce379-76ca-49fd-91e7-1a486de62d2a@oracle.com>

On Fri, Jul 10, 2026 at 04:58:41PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> 
> Sorry, I couldn't send this in 48 hrs of testing timeline.
> 
> On 02/07/26 9:50 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dominik Woźniak <stalion@gmail.com>
> > 
> > commit e186fa1c057f5eccb22afb1e83e34c0627085868 upstream.
> > 
> > In __cld_pipe_inprogress_downcall(), the get_user() that reads
> > princhashlen from the userspace cld_msg_v2 buffer does not check its
> > return value. A failing copy leaves princhashlen with uninitialised
> > stack contents, which are then used to drive memdup_user() and stored
> > as princhash.len on the resulting reclaim record. The other get_user()
> > calls in this function all check the return; only this one is missed,
> > which is most likely a copy-paste oversight from when v2 upcalls were
> > introduced.
> > 
> 
> I ran an AI-assisted backport review and verified a leak in the released
> 6.12.95 equivalent of this patch, 0ec4aaa488ff (“nfsd: check get_user()
> return when reading princhashlen”), this is only in 6.19-rc1+
> 
> Upstream e186fa1c057f uses an automatically cleaned-up temporary:
> 
>   	char *namecopy __free(kfree) = NULL;
>   	...
>   	namecopy = memdup_user(...);
>   	...
>   	if (get_user(princhashlen, ...))
>   		return -EFAULT;
> 
>   But 6.12 retains the older manual ownership model:
> 
>   	name.data = memdup_user(...);
>   	...
>   	if (get_user(princhashlen, ...))
>   		return -EFAULT;
> 
> Thus a fault while reading cp_len after the name copy succeeds leaks
> name.data. The upstream early return relies on 4552f4e3f2c9 ("nfsd:
> change nfs4_client_to_reclaim() to allocate data"), which introduced the
> scoped cleanup, but that commit is not present in 6.12.y.
> 
> Maybe we should fix this up with a downstream backport ? That looks like a
> simple approach to me.

Yes, that would be good, can you send a fix for it?

thanks,

greg k-h
