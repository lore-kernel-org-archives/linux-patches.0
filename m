Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CA11863
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 09:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9A4C433EF;
	Fri,  3 Feb 2023 09:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675416329;
	bh=vbvQLdXJzz3U3wn+spS+rWmWUdndzQ+tvfvHBwXLkHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FNd+o2FbnK06zKV8CS/JtFjckF7RN+wlkuqa+bwd17Nn7hkWEcNcUKxs6dY0VCaun
	 naKtvFjtxlcbSZ4KyIvlSMBUQBBI7oK2BxkYmOL7SlQrZeDPHNgqFNwTGyNaK/BaGR
	 izYDNnYARXnxooTSmNbAzwDKJT0v4aeLp689d3ho=
Date: Fri, 3 Feb 2023 10:25:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>, Dan Carpenter <error27@gmail.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.4 185/658] xprtrdma: Fix regbuf data not freed in
 rpcrdma_req_create()
Message-ID: <Y9zS/nOrhDLzV4r9@kroah.com>
References: <20230116154909.645460653@linuxfoundation.org>
 <20230116154917.918263147@linuxfoundation.org>
 <4d2928e1-c836-b817-3dc2-3fe9adcaf2d6@oracle.com>
 <Y81RIkI9ygwWvheM@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y81RIkI9ygwWvheM@kroah.com>

On Sun, Jan 22, 2023 at 04:07:14PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Jan 19, 2023 at 11:39:35AM +0530, Harshit Mogalapalli wrote:
> > Hi,
> > 
> > On 16/01/23 9:14 pm, Greg Kroah-Hartman wrote:
> > > From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> > > 
> > > [ Upstream commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 ]
> > > 
> > > If rdma receive buffer allocate failed, should call rpcrdma_regbuf_free()
> > > to free the send buffer, otherwise, the buffer data will be leaked.
> > > 
> > > Fixes: bb93a1ae2bf4 ("xprtrdma: Allocate req's regbufs at xprt create time")
> > > Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> > > Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >   net/sunrpc/xprtrdma/verbs.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> > > index 0f4d39fdb48f..e13115bbe719 100644
> > > --- a/net/sunrpc/xprtrdma/verbs.c
> > > +++ b/net/sunrpc/xprtrdma/verbs.c
> > > @@ -1037,6 +1037,7 @@ struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t size,
> > >   	kfree(req->rl_sendbuf);
> > >   out3:
> > >   	kfree(req->rl_rdmabuf);
> > > +	rpcrdma_regbuf_free(req->rl_sendbuf);
> > 
> > I think this introduces a double free in rpcrdma_req_create() [5.4.y]
> > 
> > Copying the function from 5.4.229 post the above patch here.
> > 
> > Comments added with //// marker.
> > 
> > struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t
> > size,
> >                                        gfp_t flags)
> > {
> >         struct rpcrdma_buffer *buffer = &r_xprt->rx_buf;
> >         struct rpcrdma_regbuf *rb;
> >         struct rpcrdma_req *req;
> >         size_t maxhdrsize;
> > 
> >         req = kzalloc(sizeof(*req), flags);
> >         if (req == NULL)
> >                 goto out1;
> > 
> >         /* Compute maximum header buffer size in bytes */
> >         maxhdrsize = rpcrdma_fixed_maxsz + 3 +
> >                      r_xprt->rx_ia.ri_max_segs * rpcrdma_readchunk_maxsz;
> >         maxhdrsize *= sizeof(__be32);
> >         rb = rpcrdma_regbuf_alloc(__roundup_pow_of_two(maxhdrsize),
> >                                   DMA_TO_DEVICE, flags);
> >         if (!rb)
> >                 goto out2;
> >         req->rl_rdmabuf = rb;
> >         xdr_buf_init(&req->rl_hdrbuf, rdmab_data(rb), rdmab_length(rb));
> > 
> >         req->rl_sendbuf = rpcrdma_regbuf_alloc(size, DMA_TO_DEVICE, flags);
> >         if (!req->rl_sendbuf)
> >                 goto out3;
> > 
> >         req->rl_recvbuf = rpcrdma_regbuf_alloc(size, DMA_NONE, flags);
> >         if (!req->rl_recvbuf)
> >                 goto out4; ///// let us say we hit this.
> > 
> >         INIT_LIST_HEAD(&req->rl_free_mrs);
> >         INIT_LIST_HEAD(&req->rl_registered);
> >         spin_lock(&buffer->rb_lock);
> >         list_add(&req->rl_all, &buffer->rb_allreqs);
> >         spin_unlock(&buffer->rb_lock);
> >         return req;
> > 
> > out4:
> >         kfree(req->rl_sendbuf);
> > //// free of (req->rl_sendbuf)
> > out3:
> >         kfree(req->rl_rdmabuf);
> >         rpcrdma_regbuf_free(req->rl_sendbuf);
> > //// double free of req->rl_sendbuf, we have a kfree in rpcrdma_regbuf_free.
> > 
> > out2:
> >         kfree(req);
> > out1:
> >         return NULL;
> > }
> > 
> > Found using smatch.
> > 
> > I looked at the history of the function, the reason is that we don't have
> > commit b78de1dca00376aaba7a58bb5fe21c1606524abe in 5.4.y
> > 
> > This problem is only in 5.4.y not seen in newer LTS.
> > 
> > Please correct me if I am missing something here.
> > 
> 
> I think you are correct.  I'll look into fixing it on Monday, thanks for
> the review!

I've just reverted this commit from the tree now, a working backport
would be appreciated :)

thanks,

greg k-h
