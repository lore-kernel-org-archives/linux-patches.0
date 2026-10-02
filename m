Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85BD493D36;
	Fri,  2 Oct 2026 12:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790942826; cv=none; b=chvDV8urYpvzkUpV1g47KVvhCZ4fWtgV5m5IOB4KXtEsa8/C+szGUdp9ZLfJpKDr+IqkDOd0MWvFZhLbT/RWr4CQKRuN3e6NTp8mD0XGsZTIZ7bI5VHWucCe/qhHii1TbIVtjtGKfHE4j36D3yuLzKxpPUVQz8Fsh9m1uecnZFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790942826; c=relaxed/simple;
	bh=DN2VihKa8HS1wfBPu4XjXQVKJo70TQXWiWuMgEJ6avU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTQa9B3vbas2oKFwk7QXpO32kweqNn62YcIJreLYbTv4BvSBpEbpBesQ6bKOGzExt8Tm0kWBZX+BhnMm8Zf0W8AEAt7cDS0h5zIuPPE3A+ABSIteDwFDlgyqAhuKrZq82suplImNWVS0UoB4o3UnJLBznKwPUd7fW0RYEOef5Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9o45g5O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9o45g5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26951F000FF;
	Fri,  2 Oct 2026 12:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790942819;
	bh=Pm8rWrJZrgG1YAvqCTosgiFdFn1gFztt0Q/WXv8EjmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T9o45g5OZDJtfLrh4IUpISaqEvwL6MB5el4Wpa1ejYnAsvhTMsj8YfnYOSG9E+GdI
	 751Gepfao7oKj1RdPbwh1zoTn21g8HFMBAyPdcbTNIz2yMMGabj9gxTkKMW109yWx5
	 BwX4IYPLoSkol642sArpZD9EP/9aF+Gi0NfskDx0=
Date: Fri, 2 Oct 2026 14:06:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 098/877] neighbour: Convert RTM_GETNEIGHTBL to RCU.
Message-ID: <2026100244-rebirth-granite-a629@gregkh>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152416.851103679@linuxfoundation.org>
 <1fabd24d-724d-455f-8cc2-2e42c2dbd2b3@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fabd24d-724d-455f-8cc2-2e42c2dbd2b3@oracle.com>

On Fri, Oct 02, 2026 at 01:04:58AM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:46 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kuniyuki Iwashima <kuniyu@google.com>
> > 
> > [ Upstream commit 4ae34be500649ec452ac1fc2748958683ad9b55d ]
> > 
> > neightbl_dump_info() calls these functions for each neigh_tables[]
> > entry:
> > 
> >    1. neightbl_fill_info() for tbl->parms
> >    2. neightbl_fill_param_info() for tbl->parms_list (except tbl->parms)
> > 
> > Both functions rely on the table lock (read_lock_bh(&tbl->lock))
> > and RTNL is not needed.
> > 
> > Let's fetch the table under RCU and convert RTM_GETNEIGHTBL to RCU.
> > 
> > Note that the first entry of tbl->parms_list is tbl->parms.list and
> > embedded in neigh_table, so list_next_entry() is safe.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > Link: https://patch.msgid.link/20251022054004.2514876-4-kuniyu@google.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi Greg/Sasha,
> 
> An AI-assisted review flagged a reader/writer mismatch. I independently
> checked upstream and 6.12.y at f4ffa8dc360b.
> 
> Upstream neigh_parms_release() in net/core/neighbour.c has:
> 
> write_lock_bh(&tbl->lock);
> list_del_rcu(&parms->list);
> parms->dead = 1;
> write_unlock_bh(&tbl->lock);
> netdev_put(parms->dev, &parms->dev_tracker);
> call_rcu(&parms->rcu_head, neigh_rcu_free_parms);
> 
> 6.12.y has
> net/core/neighbour.c:
> 
> write_lock_bh(&tbl->lock);
> list_del(&parms->list);
> parms->dead = 1;
> write_unlock_bh(&tbl->lock);
> netdev_put(parms->dev, &parms->dev_tracker);
> call_rcu(&parms->rcu_head, neigh_rcu_free_parms);
> 
> neightbl_dump_info() now uses RCU, but list_del() poisons the removed
> node's forward link. A reader can follow that poisoned pointer despite
> delayed free.
> 
> I think 6.12 should take 06d6322280d95757cef1e3ee0fc62c644629523e
> ("neighbour: Use RCU list helpers for neigh_parms.list writers.") and
> 35d7c70870338aa6a367b9e4ed528914320b0be0 ("neighbour: Annotate access to
> neigh_parms fields.") before this conversion, retaining the later dump
> fixes, thoughts?

Already dropped, thanks.

greg k-h
