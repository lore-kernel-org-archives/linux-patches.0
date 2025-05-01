Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C825B1E2;
	Thu,  1 May 2025 08:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746086642; cv=none; b=CUEMoK0jhuKnC2tCYIhRED7hKV9IAQ2u+3Wh/T6aF41K3jw8sOCe9w0vxtaEebWgBMspBopmL7BBBfY0XFoPXMP2TpGt4tUxz6ohhq8grn1BhaxOkdiOu/o81EzKtBjEaoGtryijRBN777lxvdndv6aOSBleesAA6P6nGF5GLSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746086642; c=relaxed/simple;
	bh=FrLlyf/zQU3F+r4XElWenJtWwdZ9x7pgnKF2V1e/y1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dD1ljagCP6NuLaVEUdl22MbNhkbPibC93w0A5At198VwB+JaGjQJbTgjUUpOKM7AB/S27WUeJSr6s8Bzgi53fPysCoUpspesxv6+7K3js9WRfoqkUQhWIVNdYNkTT44iyZe1hM8LZ45FNOPxRJ+KAV/GUSbK8EeudbE5NDkbeBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3wRn7lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3wRn7lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058F7C4CEE3;
	Thu,  1 May 2025 08:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746086641;
	bh=FrLlyf/zQU3F+r4XElWenJtWwdZ9x7pgnKF2V1e/y1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T3wRn7lvbL63Clu6iAAOyqkUBzXeVmCRs8AXWk5jCKSmC9LqeI1+0YxehWu8zH8f6
	 g0VRtO52tk3uVWTIBXHPm4Pi+DqDo0jCjjrzFqYj119IsOSlydXCLHKhZ36UCsJl/4
	 iNWWN3NDnt+OmrZIKwRzBX/oKc3g/R/Z/S7MMJig=
Date: Thu, 1 May 2025 10:03:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Tai, Gerrard" <gerrard.tai@starlabs.sg>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 003/373] codel: remove sch->q.qlen check before
 qdisc_tree_reduce_backlog()
Message-ID: <2025050131-fragrant-famine-eb32@gregkh>
References: <20250429161123.119104857@linuxfoundation.org>
 <20250429161123.269149769@linuxfoundation.org>
 <CAHcdcOnHVSAF9DOjGqSWrZYiS-5LyXHimdVou6zf-6zZyvZhPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHcdcOnHVSAF9DOjGqSWrZYiS-5LyXHimdVou6zf-6zZyvZhPg@mail.gmail.com>

On Wed, Apr 30, 2025 at 04:12:39PM +0800, Tai, Gerrard wrote:
> Hi,
> 
> I have a question regarding the patchset this patch belongs to.
> 
> I saw the recent netdev thread
> https://lore.kernel.org/stable/6fa68b02-cf82-aeca-56e6-e3b8565b22f4@applied-asynchrony.com/
> and noticed that for the patchset
> https://lore.kernel.org/all/174410343500.1831514.15019771038334698036.git-patchwork-notify@kernel.org/
> only patch 06/11 "codel: remove sch->q.qlen check before
> qdisc_tree_reduce_backlog()" was pulled into 6.6, 6.1, 6.12, 6.13, 6.14
> stable. This was to fix a UAF vulnerability.
> 
> In this case for the 5.15 release (and 5.10 and 5.4), the rest of the set
> is once again excluded. I'm not familiar with the process of pulling kernel
> patches so I may be missing something - is excluding the rest of the
> patchset intentional?
> 
> >From my understanding, this patch depends on the previous patches to work.
> Without patches 01-05 which make various classful qdiscs' qlen_notify()
> idempotent, if an fq_codel's dequeue() routine empties the fq_codel qdisc,
> it will be doubly deactivated - first in the parent qlen_notify and then
> again in the parent dequeue. For instance, in the case of parent drr,
> the double deactivation will either cause a fault on an invalid address,
> or trigger a splat if list checks are compiled into the kernel. This is
> also why the original unpatched code included the qlen check in the first
> place.
> 
> I think that the rest of the patchset should be pulled as well, for all
> releases.

Can you submit that whole series then?  I've dropped this single patch
from all of the other queues for now.

thanks,

greg k-h
