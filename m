Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AB650A84;
	Tue, 23 Jan 2024 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706030963; cv=none; b=sT/Uw5tTU6yzbE+SjC8EMh2GFrv/luWx16xVPYiepv5bk3wIBo3i5duu4hHKF5ihv1OTZOhB451cambo89R0uX9t8/mwk6xN50aM+UMPw7tEjDnYpg1nRih07kCmUdIr/ERYcD4vdHyU6w4DZRdrXUZWTptzGhb2JUpOJSqMQrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706030963; c=relaxed/simple;
	bh=z62UMuNCMKGp8GNJ3uX3+j0wkJVjrdanvuIaLH5C5UU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MIXv0MGr3jhn0glClYzleoswxsjiVl7K73s3meZx0egpIMu9j1qrZ6FvdDSdfKFS4kO6s55TFIRwi9l15J7RkEZCqQe0euJgeZ+Pow9mu/29z/12WfICwn57KoTUvXs/Tir+RvntdKE5YPTdlmbhXUjFsrH6dBF5l9tq/RqdvH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4GMT2Wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4GMT2Wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA15C433F1;
	Tue, 23 Jan 2024 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706030963;
	bh=z62UMuNCMKGp8GNJ3uX3+j0wkJVjrdanvuIaLH5C5UU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d4GMT2WbtUTLFc2SroR8SlSCJOSgN9Mz3qkUrNjYbYPXz8Mfl5TNSCTFSaBZUAAm7
	 V93bNti5pbmVpRUZmydhdQnCIkh4SC1f4pOU7QMbzmVI89BZhX9kM9Y+nJ/7/sn7ro
	 p3snmACoI855YdARXy74ATH1tJX4igPTbro7d5lg=
Date: Tue, 23 Jan 2024 09:29:18 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Carlos Llamas <cmllamas@google.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>, Todd Kjos <tkjos@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 167/194] binder: print warnings when detecting oneway
 spamming.
Message-ID: <2024012311-acts-bullfrog-721c@gregkh>
References: <20240122235719.206965081@linuxfoundation.org>
 <20240122235726.366071549@linuxfoundation.org>
 <Za_V3pUCssU9we2u@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za_V3pUCssU9we2u@google.com>

On Tue, Jan 23, 2024 at 03:06:06PM +0000, Carlos Llamas wrote:
> On Mon, Jan 22, 2024 at 03:58:17PM -0800, Greg Kroah-Hartman wrote:
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Martijn Coenen <maco@android.com>
> > 
> > [ Upstream commit 261e7818f06ec51e488e007f787ccd7e77272918 ]
> > 
> > The most common cause of the binder transaction buffer filling up is a
> > client rapidly firing oneway transactions into a process, before it has
> > a chance to handle them. Yet the root cause of this is often hard to
> > debug, because either the system or the app will stop, and by that time
> > binder debug information we dump in bugreports is no longer relevant.
> > 
> > This change warns as soon as a process dips below 80% of its oneway
> > space (less than 100kB available in the configuration), when any one
> > process is responsible for either more than 50 transactions, or more
> > than 50% of the oneway space.
> > 
> > Signed-off-by: Martijn Coenen <maco@android.com>
> > Acked-by: Todd Kjos <tkjos@google.com>
> > Link: https://lore.kernel.org/r/20200821122544.1277051-1-maco@android.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Stable-dep-of: c6d05e0762ab ("binder: fix unused alloc->free_async_space")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> I think we should drop this patch from the 5.4 stable queue. I assume it
> was pulled in as a dependency of patch c6d05e0762ab ("binder: fix unused
> alloc->free_async_space"). However, I have instead fixed the conflicts
> for that backport here:
> https://lore.kernel.org/all/20240122235725.449688589@linuxfoundation.org/
> 
> I was not aware that this patch was being backported and now we have the
> following missing hunk in this v5.4 series:
> 
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index abff1bafcc43..9b5c4d446efa 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -344,8 +344,7 @@ static bool debug_low_async_space_locked(struct binder_alloc *alloc, int pid)
>                         continue;
>                 if (!buffer->async_transaction)
>                         continue;
> -               total_alloc_size += binder_alloc_buffer_size(alloc, buffer)
> -                       + sizeof(struct binder_buffer);
> +               total_alloc_size += binder_alloc_buffer_size(alloc, buffer);
>                 num_buffers++;
>         }
> 
> 
> Dropping this patch fixes this problem. After all it doesn't fix
> anything so we don't need it here.
> 
> Sorry for all the binder backporting mess.

I've dropped this now, thanks!

greg k-h
