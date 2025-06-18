Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B62C08B8;
	Wed, 18 Jun 2025 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750252365; cv=none; b=YPvbNC/rSSHqOCqIGrQnFumzq6GFVjy8GOQrD+Bye/k3KIBdYPv6VbGCS4sqbRbagpn5n9rrEEjE/R43OPqASuKz2wDNpO0RK+mf2XeNrbgvpLW+DAxufUJAyeP29G44VS8F3gis3YpCr8qaU0Qx1MEvVhjPcOm5MXDPRO2MKh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750252365; c=relaxed/simple;
	bh=lIDwulnuYpOLQvsL+G51Tv4UsOI2sXi1FXKur4Zb/eM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miF2OvVVjZijerC++tzbHHJkK8mjqfYxMtAwQd/zUUhfhHbV+Xmbv/+DyWTYdpmv69dTHyrkMI3Dl/DWWDu90VPtwcdY3SiU75e5LugWX8EcBERUrWOaM4nsA2oiAtZbgYuLGyr3jWqqsojLm0hxP+4YorAPkPkkMCq24/Tl5Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tln+2KRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tln+2KRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4B5C4CEE7;
	Wed, 18 Jun 2025 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750252363;
	bh=lIDwulnuYpOLQvsL+G51Tv4UsOI2sXi1FXKur4Zb/eM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tln+2KRv2TsMnpB1aQR6qR+rYGiosvwPp0uo3ZcWNzy+YpbCieVDp6OUsaGCG1/z/
	 J/9eISiEKWmyVz9rWN1jRtnj6phkb6OY8hoknzNvFHM67Ogl8G444U4DCwH9y7ZAms
	 0atO5Z4gE1qrszJhGhS1R4gQPAWR+1ZIOtZ+hklQ=
Date: Wed, 18 Jun 2025 15:12:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 186/780] udp_tunnel: use static call for GRO hooks
 when possible
Message-ID: <2025061832-small-dexterous-29db@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <20250617152459.054731860@linuxfoundation.org>
 <bc44f920-a1fa-489e-bc2e-f2e3acef7b5a@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc44f920-a1fa-489e-bc2e-f2e3acef7b5a@redhat.com>

On Tue, Jun 17, 2025 at 06:33:56PM +0200, Paolo Abeni wrote:
> On 6/17/25 5:18 PM, Greg Kroah-Hartman wrote:
> > 6.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Paolo Abeni <pabeni@redhat.com>
> > 
> > [ Upstream commit 5d7f5b2f6b935517ee5fd8058dc32342a5cba3e1 ]
> > 
> > It's quite common to have a single UDP tunnel type active in the
> > whole system. In such a case we can replace the indirect call for
> > the UDP tunnel GRO callback with a static call.
> > 
> > Add the related accounting in the control path and switch to static
> > call when possible. To keep the code simple use a static array for
> > the registered tunnel types, and size such array based on the kernel
> > config.
> > 
> > Note that there are valid kernel configurations leading to
> > UDP_MAX_TUNNEL_TYPES == 0 even with IS_ENABLED(CONFIG_NET_UDP_TUNNEL),
> > Explicitly skip the accounting in such a case, to avoid compile warning
> > when accessing "udp_tunnel_gro_types".
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Reviewed-by: Willem de Bruijn <willemb@google.com>
> > Link: https://patch.msgid.link/53d156cdfddcc9678449e873cc83e68fa1582653.1744040675.git.pabeni@redhat.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Stable-dep-of: c26c192c3d48 ("udp: properly deal with xfrm encap and ADDRFORM")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This, the previous patch (185/780 -  udp_tunnel: create a fastpath GRO
> lookup.) and the next one (187/780 - udp: properly deal with xfrm encap
> and ADDRFORM) are not intended for stable trees.
> 
> 185 && 186 are about performance improvement, and 187 fixes a bug
> introduced by them, and is irrelevant otherwise.

Thanks for letting me know, all now dropped.

greg k-h
