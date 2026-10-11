Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8AE4334A5;
	Sun, 11 Oct 2026 10:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791712886; cv=none; b=rD/0etC5mrQhA3DRSBFNn1Q5hoHsHIFWbjXRXq0a2/6QzkBPLC6DH5gp4G2rX2OYOYPrJVgOaL5KZuAkwjIfRx+zrOTj0JrlPJIHhpiBn2DOHeIEcq4aQ+wRQBvBVfrtznZMi0JIyB59n6MHjf1tLdA8T5P7Ihhn5464Y440vpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791712886; c=relaxed/simple;
	bh=oQjTLbhqQXy3eKN7hhZQQgN8wOhaEsZoY+dEA/ddxi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdn2Wi4m3Tt9Pyj86oPq5RWKKf7EvDNLbjmY4uMBXkif08xBvhKyOn5y8G4GJE5rX8HcPFD5YsBRFEPvDQ+aujKrpmfVRtaKuaMyaDAzlGtPXr8Ex+4EAt3UTdjiHNz4GeUdjOjhurnI4bG13OhexQWDlwM1qwmrJJ2Mk8y0cYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxWVtgd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxWVtgd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777681F0089B;
	Sun, 11 Oct 2026 10:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791712884;
	bh=jv5LHdMOSSNsU4g1DFEw/WcPRQk7rQdmJi3MIXkLK6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=yxWVtgd8H3LbZvZNxq9lmZnPE/qxWaoFe54rx7LN3opIWcYQu4PvmEZX0ZSVL0PKz
	 3+6P6C5/ePht0aISv7S6YIZNsgDLiQG63EVMPvyuLayYqJeJoh3G6+ir5TnBmmyyRV
	 RYHlwSh7ZkP4bVlD/e7jaRnhKmY8vQz3TaymAdY4=
Date: Sun, 11 Oct 2026 12:01:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 7.2 203/428] rust_binder: reschedule node refcount update
 on thread exit
Message-ID: <2026101102-barrack-subsiding-65e3@gregkh>
References: <20261009140946.008206689@linuxfoundation.org>
 <20261009140950.590490061@linuxfoundation.org>
 <20261010070504.73698-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010070504.73698-1-kmehltretter@gmail.com>

On Sat, Oct 10, 2026 at 09:05:04AM +0200, Karl Mehltretter wrote:
> [...]
> > Cc: stable <stable@kernel.org>
> > Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > Link: https://patch.msgid.link/20260903-binder-thread-exit-node-v1-1-be09ff14f6a4@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> [...]
> > --- a/drivers/android/binder/node.rs
> > +++ b/drivers/android/binder/node.rs
> [...]
> > @@ -733,7 +733,21 @@ impl DeliverToRead for Node {
> [...]
> > +    fn cancel(self: DArc<Self>) {
> > +        let _drop_outside_lock;
> > +        let mut owner_inner = self.owner.inner.lock();
> [...]
> > +        if let Some(node) = ListArc::try_from_arc_borrow(self.as_arc_borrow()) {
> > +            _drop_outside_lock = owner_inner.push_work(&self.owner, node);
> > +        }
> > +    }
> [...]
> > --- a/drivers/android/binder/node/wrapper.rs
> > +++ b/drivers/android/binder/node/wrapper.rs
> > @@ -57,7 +57,39 @@ impl DeliverToRead for NodeWrapper {
> [...]
> > +    fn cancel(self: DArc<Self>) {
> > +        let _drop_outside_lock;
> > +        let node = &self.node;
> > +        let mut owner_inner = node.owner.inner.lock();
> [...]
> > +            if let Some(node2) = ListArc::try_from_arc_borrow(node.as_arc_borrow()) {
> > +                ds.has_pushed_node = true;
> > +                _drop_outside_lock = owner_inner.push_work(&node.owner, node2);
> 
> I object to this patch as queued: it causes compile errors with
> CONFIG_ANDROID_BINDER_IPC_RUST=y.
> 
> The upstream commit was written on top of dbb17c9ea756 ("rust_binder:
> move (e)poll wait queue to Process"), which added the Process argument
> to ProcessInner::push_work(). That commit is not in 7.2, where
> push_work() still takes only the work item, so the two new calls do not
> compile. dbb17c9ea756 is a performance change with no Fixes: or stable
> tag, so I am not suggesting to add it.
> 
> An LLM agent assisted with the review and the build test.
> 
> With CONFIG_RUST=y and CONFIG_ANDROID_BINDER_IPC_RUST=y (x86_64
> defconfig otherwise, LLVM=1, rustc 1.98.0), "make drivers/android/" on
> the review tip 77b730c57839 fails:
> 
>   error[E0061]: this method takes 1 argument but 2 arguments were supplied
>     --> drivers/android/binder/node/wrapper.rs:86:50
>   note: method defined here
>     --> drivers/android/binder/process.rs:173:19
> 
>   error[E0061]: this method takes 1 argument but 2 arguments were supplied
>     --> drivers/android/binder/node.rs:748:46
> 
> ANDROID_BINDER_IPC_RUST depends on !ANDROID_BINDER_IPC, so a build with
> the C binder enabled does not compile this code.
> 
> With this patch reverted the same build passes. It also passes with both
> calls changed to the one-argument form, push_work(node) and
> push_work(node2), but that is only compile-tested.
> 

THanks, I missed this for some reason my builds were not picking up the
rust version of this.  Now dropped from both queues, thanks for testing
and letting us know.

greg k-h
