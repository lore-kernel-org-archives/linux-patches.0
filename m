Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FE9488203;
	Fri,  2 Oct 2026 12:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790942968; cv=none; b=QvntvlLQeQplDlbzqHBRPy4cIMisDCPQLzgXMrfT6xmOF/0lgQmpNCcHn0NCiQP11ECr56vMoz9uVxQ+EKMdWfe8LwOuUm/ABelDX8eVBxtJSxVFs4jZFhKpfEgJSpkytB/bfKu3X6bBLSsmJf2l71Y7mPR01lqDpJIhNbsZ8LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790942968; c=relaxed/simple;
	bh=W8FeOYNlxGug5AhEUqFLkWZCjm4C8xEaDvrtB/9OcXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwIsMPlJc0D1nvo4cU2V6N5rbT4uP2bDgtORkWy3CB60x6QLVrjL/dKkxFy6Od76Cnml4wdfSn3i266iCXK7QAvI/rfdbpIC2lADd7sDo+HCQPpCIXP0gYYKXMoxKQJU7yur5ZjrPFxBtVRRe/Nsdme+dLCHQx1cIudg7SLNmVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFVZV3u7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFVZV3u7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A101F000FF;
	Fri,  2 Oct 2026 12:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790942965;
	bh=Gq1j9BjnQVF0ss1314JH7djQYahfbsG5BcoE5F/CIV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cFVZV3u77WWt/n+qT9zL2+xzuDGdxsGZ1s6TSNxb5nNj0vabskmu8pRQiutePxlAH
	 5LU7TYFGF7pDCAwbqCgpYeqvOT8QxsSkP8BQbdnnp2zs8IKGRPVQlhsaoNmHxc7c/N
	 mxpLSlzq10k9sDjRdQmA1ortfEepw7gTU7eXCqfI=
Date: Fri, 2 Oct 2026 14:09:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>, Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 341/877] fs: avoid repeated scans in evict_inodes()
Message-ID: <2026100223-idealist-eatery-53bc@gregkh>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152422.027976780@linuxfoundation.org>
 <0fee0444-1e42-4b1f-b7ac-234b5e19bb43@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fee0444-1e42-4b1f-b7ac-234b5e19bb43@oracle.com>

On Fri, Oct 02, 2026 at 01:28:39AM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:50 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Julian Sun <sunjunchao@bytedance.com>
> > 
> > [ Upstream commit 7459c021874246c196f397686e100702f059b9e7 ]
> > 
> > We observed hung tasks when users attempted to unmount a filesystem
> > after its disk had been removed while still in use. During device
> > removal, fs_bdev_mark_dead() calls evict_inodes() while holding s_umount.
> > 
> > Each time evict_inodes() drops s_inode_list_lock to reschedule, it
> > restarts the walk from the head of s_inodes. With many referenced inodes
> > at the head of the list, these restarts repeatedly scan the same inodes
> > without reclaiming them. This can keep s_umount held for a long time,
> > blocking concurrent umount attempts and triggering hung-task reports.
> > 
> > Keep the current inode, already marked I_FREEING, out of the disposal
> > batch until s_inode_list_lock is reacquired. Resume the walk from this
> > inode and dispose of it in a later batch or at the end of the walk.
> > 
> > The zero-refcount and state checks under i_lock allow this walker to
> > claim the inode by setting I_FREEING and removing it from the LRU.
> > Other reclaimers skip the inode, leaving this walker responsible for
> > eviction. Only evict() removes it from s_inodes, so keeping it out of
> > the disposal batch ensures that it remains on the list while the lock
> > is dropped. After reacquiring the lock, reading its current next pointer
> > accounts for concurrent removal of following inodes.
> > 
> > The existing inode lifetime rules prohibit acquiring a reference to an
> > inode marked I_FREEING or I_WILL_FREE. __iget() requires its caller to
> > hold i_lock and establish that taking a reference is valid. Inode lookup
> > and igrab() check these flags under i_lock when acquiring a reference
> > from zero. ihold() requires an existing reference, which would keep
> > i_count nonzero and prevent this walker from claiming the inode. These
> > rules already allow iput_final() and the inode shrinker to release
> > i_lock after setting I_FREEING and before eviction completes.
> > 
> > A temporary __iget() reference would also keep the inode on the list,
> > but its release must preserve last-reference handling. Another user can
> > acquire a reference, update lazy timestamps and drop its reference while
> > the pin is held. If the pin becomes the last reference, dropping it with
> > atomic_dec_and_test() and evicting directly bypasses iput()'s lazytime
> > handling and can lose those timestamp updates.
> > 
> > Releasing the pin with iput() preserves that handling, but does not
> > guarantee eviction. fs_bdev_mark_dead() runs with SB_ACTIVE set, so iput()
> > may retain the inode in cache, whereas evict_inodes() must evict eligible
> > zero-reference inodes. The inode may also have been freed when iput()
> > returns, so the walker cannot then use it to force eviction. Using
> > I_FREEING preserves the existing eviction behavior without introducing
> > an additional last-reference transition.
> > 
> > The xfstests auto group passed on ext4 and XFS with known unrelated
> > failures excluded. No new issues were observed, and the previously
> > reproducible hung task no longer occurs with this patch.
> > 
> > Fixes: ac05fbb40062 ("inode: don't softlockup when evicting inodes")
> > Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> > Link: https://patch.msgid.link/20260915044912.3183440-1-sunjunchao@bytedance.com
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi Greg/Sasha,
> 
> An AI assisted backport review flagged this, and I checked the upstream
> code against the 6.12.y tip f4ffa8dc360b.
> 
> Upstream 7459c0218742 uses the current inode's successor after
> relocking:
> 
>     struct inode *inode;
>     LIST_HEAD(dispose);
> 
>     spin_lock(&sb->s_inode_list_lock);
>     list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>         /* ... intervening source omitted ... */
>         if (need_resched()) {
>             spin_unlock(&sb->s_inode_list_lock);
>             cond_resched();
>             dispose_list(&dispose);
>             spin_lock(&sb->s_inode_list_lock);
>         }
>         list_add(&inode->i_lru, &dispose);
> 
> 6.12.y retains the cached-successor iterator:
> 
>     struct inode *inode, *next;
>     LIST_HEAD(dispose);
> 
>     spin_lock(&sb->s_inode_list_lock);
>     list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
>         /* ... intervening source omitted ... */
>         if (need_resched()) {
>             spin_unlock(&sb->s_inode_list_lock);
>             cond_resched();
>             dispose_list(&dispose);
>             spin_lock(&sb->s_inode_list_lock);
>         }
>         list_add(&inode->i_lru, &dispose);
> 
> I_FREEING protects inode, but the safe iterator's cached next can be
> detached or freed while the lock is dropped.  The 6.12's invalidate_inodes()
> differs from upstream's disk-removal trigger.
> 
> I think 6.12.y needs the two-line iterator change from
> 3bc4e4410830d556b0f40dfa6671bfcaeacc1599 ("vfs: Remove unnecessary
> list_for_each_entry_safe() from evict_inodes()") before this backport,
> thoughts?

If it's needed, it needs to be backported here and to older stable
kernels, and it needs a manual backport as it doesn't apply cleanly.

thanks,

greg k-h
