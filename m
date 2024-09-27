Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40186BFC0;
	Fri, 27 Sep 2024 07:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727420849; cv=none; b=aBJeQsWvJ9myHCvsNK2eWhDNtbrAMD4KCV+77PXGSh4wT1U+eDA2z3lFOipjxvh8ZTiAInCVJYOMzCS4RqfRlSuMuY9DR026SMB/uzFpaRk2AUe4Y1eP1n4Lcuz3Usd1ouaBSN+J5/68qBeO4zrqEjuVv9Mbc6YRIdApoay9B0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727420849; c=relaxed/simple;
	bh=0pN/FVXMLL/Lcvoo8wfhkksqQ4A1BZQ5jXNtvo48RqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3AcXbI4NDzDHRghcF31FOG5yNoUWbiOlmkVVE71DOd5GRLPWQBB94MGnq148S1gb8UdG+fxjFxrkU2GJCw3rTtRlclwWSe9XEbQGGfhZ/uVDsEaNtVVI2MLiqH4YX0tDERQJHYK945qVycfNg6y2LOBrPQSqLkEIUhOuWkLA7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5Icthn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5Icthn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D22C4CEC4;
	Fri, 27 Sep 2024 07:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727420848;
	bh=0pN/FVXMLL/Lcvoo8wfhkksqQ4A1BZQ5jXNtvo48RqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h5Icthn0tjVkusQWTw2dJme7wOhjwZW3sApzZFB9hwygaQ2s4gwODpKEwpqCyXtcD
	 9Hv6bCFf8GOEC0TOsiRvSfvCQ6iD7G6cyk59EJyUKwTrf91lprdmMmtFpaZZNuUra7
	 OyWPVqFaAo6yQdIt/QcCWx1PZb9SJ0kynzccK+Vs=
Date: Fri, 27 Sep 2024 09:07:15 +0200
From: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To: duanqiangwen@net-swift.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"'David S. Miller'" <davem@davemloft.net>,
	'Sasha Levin' <sashal@kernel.org>
Subject: Re: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
Message-ID: <2024092728-mobster-whole-8130@gregkh>
References: <20240430103058.010791820@linuxfoundation.org>
 <20240430103059.311606449@linuxfoundation.org>
 <000201db1081$45ae0660$d10a1320$@net-swift.com>
 <2024092715-olive-disallow-e28c@gregkh>
 <001701db10aa$d3fd7710$7bf86530$@net-swift.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001701db10aa$d3fd7710$7bf86530$@net-swift.com>

On Fri, Sep 27, 2024 at 02:59:42PM +0800, duanqiangwen@net-swift.com wrote:
> > -----Original Message-----
> > From: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
> > Sent: 2024年9月27日 14:53
> > To: duanqiangwen@net-swift.com
> > Cc: stable@vger.kernel.org; patches@lists.linux.dev; 'David S. Miller'
> > <davem@davemloft.net>; 'Sasha Levin' <sashal@kernel.org>
> > Subject: Re: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
> > 
> > On Fri, Sep 27, 2024 at 10:02:14AM +0800, duanqiangwen@net-swift.com
> > wrote:
> > > > -----Original Message-----
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Sent: 2024年4月30日 18:38
> > > > To: stable@vger.kernel.org
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > > patches@lists.linux.dev; Duanqiang Wen <duanqiangwen@net-
> > swift.com>;
> > > > David S. Miller <davem@davemloft.net>; Sasha Levin
> > > > <sashal@kernel.org>
> > > > Subject: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors
> > > > failed
> > > >
> > > > 6.6-stable review patch.  If anyone has any objections, please let
> > > > me
> > > know.
> > > >
> > > > ------------------
> > > >
> > > > From: Duanqiang Wen <duanqiangwen@net-swift.com>
> > > >
> > > > [ Upstream commit 69197dfc64007b5292cc960581548f41ccd44828 ]
> > > >
> > > > driver needs queue msix vectors and one misc irq vector, but only
> > > > queue vectors need irq affinity.
> > > > when num_online_cpus is less than chip max msix vectors, driver will
> > > acquire
> > > > (num_online_cpus + 1) vecotrs, and call
> > > > pci_alloc_irq_vectors_affinity functions with affinity params
> > > > without setting pre_vectors or
> > > post_vectors, it
> > > > will cause return error code -ENOSPC.
> > > > Misc irq vector is vector 0, driver need to set affinity params
> > > .pre_vectors = 1.
> > > >
> > > > Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
> > > > Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
> > > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > > b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > > index e078f4071dc23..be434c833c69c 100644
> > > > --- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > > +++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > > @@ -1585,7 +1585,7 @@ static void wx_set_num_queues(struct wx *wx)
> > > >   */
> > > >  static int wx_acquire_msix_vectors(struct wx *wx)  {
> > > > -	struct irq_affinity affd = {0, };
> > > > +	struct irq_affinity affd = { .pre_vectors = 1 };
> > > >  	int nvecs, i;
> > > >
> > > >  	nvecs = min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);
> > > > --
> > > > 2.43.0
> > > >
> > > This patch in kernel-6.6 and kernel 6.7 will cause problems. In
> > > kernel-6.6 and kernel 6.7, Wangxun txgbe & ngbe driver adjust misc irq
> > > to vector 0 not yet.  How to revert it in
> > > kernel-6.6 and kernel-6.7 stable?>
> > 
> > Please send a revert.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Should I send revert to stable/master repo? I only wan't to revert it in 6.6.y and 6.7.y.

6.7 is no longer being maintained, please see the front page of
kernel.org for the listed versions that are.

> How maintainer recognize this revert should be applied in different tags?

Explain in the changelog why this is only relevant for one branch and
not all the others.

thanks,

greg k-h
