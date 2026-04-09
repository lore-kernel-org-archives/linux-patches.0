Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101393A9D97;
	Thu,  9 Apr 2026 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775725742; cv=none; b=nHUSLfT91FB7NY2agPnq/GVrwVa13n7myvmSzYq0zNf0pxWv56HWAnl5+cFC47GHDCL9HDoTiASOXRNnz1Pgm9nFdn0cFZj/74/h67D7hyYbhjcY64C6v7LZJzyKHRjG0LlfGnL++sm7RSfOuIDMV+XGW3HxnrDJwHh/qM7Lh1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775725742; c=relaxed/simple;
	bh=cQ8YUMWxvx77aKgABzUhh6MBcqcwDfR6dAvsmhbi5Z0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZJYtQrGGkeOXLDwyr7kUtinusLB9YGsPkWZWQQL1goB165UsJ2klPZh+zBHq/CMoSwGDpZcg/fd5b9cOvCj2dQRyXxU+Uag9FvSt11k7NHx8wWaNys5QdAZW6UtRKIhOH2wcyzA5IAXvDM5X3MbJaR0nPxhPupq0aFWM1mA+G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reYWCeKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reYWCeKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD9BC19424;
	Thu,  9 Apr 2026 09:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775725741;
	bh=cQ8YUMWxvx77aKgABzUhh6MBcqcwDfR6dAvsmhbi5Z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=reYWCeKvx3unKdHBtlS2UHR0FWVLFBYQvrcdVmSSY5GvwiAhrYbN89BxB1+ZCuEGs
	 mHpCO4TFeOjhZDzIYQxwegyG0xUFHqAgVUbUlKaFthQx4I8gjR0bhi9bivd9UVyx0k
	 QPnwROhTnDwTAJKFyhgaYt2u3ZRTmRWqxOkq3654=
Date: Thu, 9 Apr 2026 11:08:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Long Li <leo.lilong@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.19 008/311] xfs: close crash window in attr dabtree
 inactivation
Message-ID: <2026040946-persuader-usual-edf6@gregkh>
References: <20260408175939.393281918@linuxfoundation.org>
 <20260408175939.720196538@linuxfoundation.org>
 <adb9X3tSH8vdqKw-@localhost.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adb9X3tSH8vdqKw-@localhost.localdomain>

On Thu, Apr 09, 2026 at 09:14:07AM +0800, Long Li wrote:
> On Wed, Apr 08, 2026 at 08:00:08PM +0200, Greg Kroah-Hartman wrote:
> > 6.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Long Li <leo.lilong@huawei.com>
> > 
> > [ Upstream commit b854e1c4eff3473b6d3a9ae74129ac5c48bc0b61 ]
> > 
> > When inactivating an inode with node-format extended attributes,
> > xfs_attr3_node_inactive() invalidates all child leaf/node blocks via
> > xfs_trans_binval(), but intentionally does not remove the corresponding
> > entries from their parent node blocks.  The implicit assumption is that
> > xfs_attr_inactive() will truncate the entire attr fork to zero extents
> > afterwards, so log recovery will never reach the root node and follow
> > those stale pointers.
> > 
> > However, if a log shutdown occurs after the leaf/node block cancellations
> > commit but before the attr bmap truncation commits, this assumption
> > breaks.  Recovery replays the attr bmap intact (the inode still has
> > attr fork extents), but suppresses replay of all cancelled leaf/node
> > blocks, maybe leaving them as stale data on disk.  On the next mount,
> > xlog_recover_process_iunlinks() retries inactivation and attempts to
> > read the root node via the attr bmap. If the root node was not replayed,
> > reading the unreplayed root block triggers a metadata verification
> > failure immediately; if it was replayed, following its child pointers
> > to unreplayed child blocks triggers the same failure:
> > 
> >  XFS (pmem0): Metadata corruption detected at
> >  xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
> >  XFS (pmem0): Unmount and run xfs_repair
> >  XFS (pmem0): First 128 bytes of corrupted metadata buffer:
> >  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117
> > 
> > Fix this in two places:
> > 
> > In xfs_attr3_node_inactive(), after calling xfs_trans_binval() on a
> > child block, immediately remove the entry that references it from the
> > parent node in the same transaction.  This eliminates the window where
> > the parent holds a pointer to a cancelled block.  Once all children are
> > removed, the now-empty root node is converted to a leaf block within the
> > same transaction. This node-to-leaf conversion is necessary for crash
> > safety. If the system shutdown after the empty node is written to the
> > log but before the second-phase bmap truncation commits, log recovery
> > will attempt to verify the root block on disk. xfs_da3_node_verify()
> > does not permit a node block with count == 0; such a block will fail
> > verification and trigger a metadata corruption shutdown. on the other
> > hand, leaf blocks are allowed to have this transient state.
> > 
> > In xfs_attr_inactive(), split the attr fork truncation into two explicit
> > phases.  First, truncate all extents beyond the root block (the child
> > extents whose parent references have already been removed above).
> > Second, invalidate the root block and truncate the attr bmap to zero in
> > a single transaction.  The two operations in the second phase must be
> > atomic: as long as the attr bmap has any non-zero length, recovery can
> > follow it to the root block, so the root block invalidation must commit
> > together with the bmap-to-zero truncation.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> Hi, Greg
> 
> The current patch depends on upstream e942498385bf ("xfs: only assert new
> size for datafork during truncate extents"), otherwise, an assertion failure
> will be triggered during attr fork truncation.
> 
> The following four patches are in the same patch set:
> 
>   b854e1c4eff3 xfs: close crash window in attr dabtree inactivation
>   e65bb55d7f8c xfs: factor out xfs_attr3_leaf_init
>   ce4e789cf356 xfs: factor out xfs_attr3_node_entry_remove
>   e942498385bf xfs: only assert new size for datafork during truncate extents

Thanks for letting me know, I've now queued up the missing patch.

greg k-h
