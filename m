Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F8170A07;
	Fri, 27 Sep 2024 06:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727420017; cv=none; b=KrPWZtM7OY0N9XW/6LpqesrzhN4ra313DCEdzEOQGQP1LRha8hH2jMW9vGPunANfPq2j7ZS7a640L5ZL+1B1FlpsxqT6LOFEzgblvOKlBsz40LUGR1DtUdSBqR3dp3VfNPLUoRsU4++xWwt9tbPohwZAfOxjtQCxjS5ya+JQqZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727420017; c=relaxed/simple;
	bh=EOx7KnJpaRC3/oO51NOY+yWVEiHs0Cfmd0bnhIuQ6tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8SCzqAJqh4FFQnZILbj6003tZaejzN+nRiqtxDhL62OfXPz955cD/B/GhJ0rVSC0rAoy0+tdfs7lEACnFZ8Jb2ZmJdrWsjptTUUwp6p3zX/wUpbfDUz+JD+d4YrirYgA2lXV2/r0CGNFg06/AIfmMAKUM7n1SeakoctncZHnLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1gRIoq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1gRIoq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F253EC4CEC4;
	Fri, 27 Sep 2024 06:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727420017;
	bh=EOx7KnJpaRC3/oO51NOY+yWVEiHs0Cfmd0bnhIuQ6tQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b1gRIoq8Idp5cw7TfBhUd1LymGxaZw2WOLYu8Tqcd9P0I3Jo2mKqlc1TR4bJSav9r
	 iEPGZahLB/8rL3EftvSU6LVDB+IKgcxyB+VAsZTN4UodE2cpzMAs6UDYUJHNaASx+z
	 0973XIs8i5Qdgk40Pg1bvLYAxKxzrnt5/J38MlYo=
Date: Fri, 27 Sep 2024 08:53:24 +0200
From: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To: duanqiangwen@net-swift.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"'David S. Miller'" <davem@davemloft.net>,
	'Sasha Levin' <sashal@kernel.org>
Subject: Re: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
Message-ID: <2024092715-olive-disallow-e28c@gregkh>
References: <20240430103058.010791820@linuxfoundation.org>
 <20240430103059.311606449@linuxfoundation.org>
 <000201db1081$45ae0660$d10a1320$@net-swift.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000201db1081$45ae0660$d10a1320$@net-swift.com>

On Fri, Sep 27, 2024 at 10:02:14AM +0800, duanqiangwen@net-swift.com wrote:
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 2024年4月30日 18:38
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > patches@lists.linux.dev; Duanqiang Wen <duanqiangwen@net-swift.com>;
> > David S. Miller <davem@davemloft.net>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
> > 
> > 6.6-stable review patch.  If anyone has any objections, please let me
> know.
> > 
> > ------------------
> > 
> > From: Duanqiang Wen <duanqiangwen@net-swift.com>
> > 
> > [ Upstream commit 69197dfc64007b5292cc960581548f41ccd44828 ]
> > 
> > driver needs queue msix vectors and one misc irq vector, but only queue
> > vectors need irq affinity.
> > when num_online_cpus is less than chip max msix vectors, driver will
> acquire
> > (num_online_cpus + 1) vecotrs, and call pci_alloc_irq_vectors_affinity
> > functions with affinity params without setting pre_vectors or
> post_vectors, it
> > will cause return error code -ENOSPC.
> > Misc irq vector is vector 0, driver need to set affinity params
> .pre_vectors = 1.
> > 
> > Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
> > Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > index e078f4071dc23..be434c833c69c 100644
> > --- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > +++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > @@ -1585,7 +1585,7 @@ static void wx_set_num_queues(struct wx *wx)
> >   */
> >  static int wx_acquire_msix_vectors(struct wx *wx)  {
> > -	struct irq_affinity affd = {0, };
> > +	struct irq_affinity affd = { .pre_vectors = 1 };
> >  	int nvecs, i;
> > 
> >  	nvecs = min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);
> > --
> > 2.43.0
> > 
> This patch in kernel-6.6 and kernel 6.7 will cause problems. In kernel-6.6
> and kernel 6.7, 
> Wangxun txgbe & ngbe driver adjust misc irq to vector 0 not yet.  How to
> revert it in
> kernel-6.6 and kernel-6.7 stable?> 

Please send a revert.

thanks,

greg k-h
