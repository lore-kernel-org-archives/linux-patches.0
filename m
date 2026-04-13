Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB52234E770;
	Mon, 13 Apr 2026 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776091393; cv=none; b=i2DZG+9p8s9oRxYBQeS09Q7/ok9V0m1bQ3fd6K/796ErHXyMu4zXCMNA4P6lfVuZ08xCyjgpZjFROhcPdsdnykyVziQbdfW4UNHhSIzdW1QN1PkQej2MSqkujfFQJCTm+VTMMISfrsch+zirgeZVV4o+CD36Bk1qH+YNjjNWnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776091393; c=relaxed/simple;
	bh=S9/5nD/BmhAg1xmwlbHDlKXhWlSnjy5574Zphpo3Egk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yge+nzA5HiNoP1moExCPInPwrAmHJVzCXWUgM8PBXaWjDylGY/BIhvk0V9gh1PSkLED8PXd8jFDXvxJysIYYaBaUm7gVC1b/QlNbenKedSh7qHS01uxmujMUziSjhrZQSgmRKKVtRLNQU09AIieeRHUqTRCQ4Lk5CdPsDtmvVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CaJz/0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CaJz/0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2126CC2BCAF;
	Mon, 13 Apr 2026 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776091392;
	bh=S9/5nD/BmhAg1xmwlbHDlKXhWlSnjy5574Zphpo3Egk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1CaJz/0XBdbNh6UlQuVV+wyYUTUJK+KYJe7ZjfOGL+MTmpJ4TzglwLmdbqZk2b3jF
	 aUP6qhN1q1/NJUzDTaffLmDmWN2o9YXgAfrkv8hAbo3bUHHUHc62XA7iSbOWC8uJUx
	 ynPkQUhS0nH69HLNv8HQR9KvjpNAmSi7vck00zKc=
Date: Mon, 13 Apr 2026 16:43:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jianqiang kang <jianqkang@sina.cn>
Cc: stable@vger.kernel.org, imv4bel@gmail.com, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, marcel@holtmann.org,
	johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
	kuba@kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, luiz.von.dentz@intel.com
Subject: Re: [PATCH 5.10.y] Bluetooth: SCO: Fix use-after-free in
 sco_recv_frame() due to missing sock_hold
Message-ID: <2026041356-revise-uncorrupt-ba4d@gregkh>
References: <20260409074429.740279-1-jianqkang@sina.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409074429.740279-1-jianqkang@sina.cn>

On Thu, Apr 09, 2026 at 03:44:29PM +0800, Jianqiang kang wrote:
> From: Hyunwoo Kim <imv4bel@gmail.com>
> 
> [ Upstream commit 598dbba9919c5e36c54fe1709b557d64120cb94b ]
> 
> sco_recv_frame() reads conn->sk under sco_conn_lock() but immediately
> releases the lock without holding a reference to the socket. A concurrent
> close() can free the socket between the lock release and the subsequent
> sk->sk_state access, resulting in a use-after-free.
> 
> Other functions in the same file (sco_sock_timeout(), sco_conn_del())
> correctly use sco_sock_hold() to safely hold a reference under the lock.
> 
> Fix by using sco_sock_hold() to take a reference before releasing the
> lock, and adding sock_put() on all exit paths.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
> ---
>  net/bluetooth/sco.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

This breaks the build, how was it tested?

confused,

greg k-h
