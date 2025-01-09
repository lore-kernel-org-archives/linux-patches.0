Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE682010EF;
	Thu,  9 Jan 2025 11:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736423194; cv=none; b=tBxUxpyR4w+v9z6uskforWA2Z2hMgS+oI4SiJrwn47LqsbWQsF5b1Daqb5Z92U2GjhQH6pO4WbwZAWkWMDoePU+iEUl0YSk4gIt5ao/FUXrs7rxMgvUrr/LR9uFwaI2Yo1M5Rh3xMf+cOs7GTjt61FdvUwQFHOO9rTYCJW+RUXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736423194; c=relaxed/simple;
	bh=H9eA+ejVhVauhCwjmVMYIRD2dwBKM9fp8Rs1XAnOzmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kU/HHHY8v1gY/CLtdRoVA2tYxFtm7pkfR1bqXZvJ4C06L1jCAfDcm2fZcO8/yPArCewqPbd3X0w07ZkZBdbKkXDbPDmWZPzyoCg14wfesap1geDx80Utvl3iF3CZiv7hs9+w5eEuWXtvu819O6+rGx0TBoTieAUsG/1y1s1/y2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xbgg10Or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xbgg10Or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDBAC4CED2;
	Thu,  9 Jan 2025 11:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736423193;
	bh=H9eA+ejVhVauhCwjmVMYIRD2dwBKM9fp8Rs1XAnOzmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xbgg10OrH4pVeN3JEgauUXLIuDmGpt3VoNvaa3Xg73D1VgpP1YVh2p/5K4ESnvcOH
	 ujqBu3R8ERofX+KcVySR0DiifqxKx10G31XukoR32+N6dVYkHuAOlLjCS/4ndvVt+t
	 7Ez6iOjMRPJGkvoGUCAKcITQ5vuFtepGRVvVNWOk=
Date: Thu, 9 Jan 2025 12:46:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6] ceph: give up on paths longer than PATH_MAX
Message-ID: <2025010912-deputize-frolic-7381@gregkh>
References: <20250107155010.2658845-1-idryomov@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250107155010.2658845-1-idryomov@gmail.com>

On Tue, Jan 07, 2025 at 04:50:08PM +0100, Ilya Dryomov wrote:
> From: Max Kellermann <max.kellermann@ionos.com>
> 
> commit 550f7ca98ee028a606aa75705a7e77b1bd11720f upstream.
> 
> If the full path to be built by ceph_mdsc_build_path() happens to be
> longer than PATH_MAX, then this function will enter an endless (retry)
> loop, effectively blocking the whole task.  Most of the machine
> becomes unusable, making this a very simple and effective DoS
> vulnerability.
> 
> I cannot imagine why this retry was ever implemented, but it seems
> rather useless and harmful to me.  Let's remove it and fail with
> ENAMETOOLONG instead.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Dario Weiﬂer <dario@cure53.de>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Alex Markuze <amarkuze@redhat.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> [idryomov@gmail.com: backport to 6.6: pr_warn() is still in use]
> ---
>  fs/ceph/mds_client.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Thank you, I've dropped the "large" ceph patches from 6.6.y now and
added this one instead.

greg k-h
