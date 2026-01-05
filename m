Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC71EE033;
	Mon,  5 Jan 2026 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767621323; cv=none; b=JM+cH1w5P6Yrj8uV0q2RQHtTcuqbODYbuRTdKdBQ547m4iimRnOfbW0K/YkaH9eyOLTEB8Id2soJhNmiFRqjn4/WWzNFkTnmxbTCuD2aWbjcauP84XYrUDiKeF18AHiyn67SH7jYiKGcMCT+fCQso6PLxXUtie+lwXtHjxrRTbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767621323; c=relaxed/simple;
	bh=R3prR7NAkm/pmZYemezAYazX63wtmQSKkG62w/kXMDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsb1rRbBSODQ3Otiv570zzr0M83aIbhLT/73eLlPYKtarFltllGj8cmw17DcgYucFZQx3Ya+9omsN7L2KM55ySW3anWIE8SaZsQA3q+0blq0Ku+dDddGIgefaAZq23I4Yo+3qTK3kEym3BEicbHZShuTJh8qHKnFDGCtKHcd05U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3UAcCP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3UAcCP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A05C116D0;
	Mon,  5 Jan 2026 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767621322;
	bh=R3prR7NAkm/pmZYemezAYazX63wtmQSKkG62w/kXMDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3UAcCP1534dpLzg8qmXWc5cdQtOo674VKbLWo/HU9KIQ+83VAQ4ZctLaqBpfLWvX
	 2hvZJH0BCEu1Dj/fighKJJCA5yO6+KnWJViRgUmxZaiTGweeP0W57bosnXhNG69S4d
	 cTZifnrIf+YiJ+/Mj0WiovaKbxcwi8K9zvCiDvcs=
Date: Mon, 5 Jan 2026 14:55:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 052/430] gfs2: Fix use of bio_chain
Message-ID: <2026010551-recite-vacant-01fd@gregkh>
References: <20251229160724.139406961@linuxfoundation.org>
 <20251229160726.283681845@linuxfoundation.org>
 <CANubcdVnWRkJ8x7zLGKih+uY0D0cE8jGmF_dx7+iDb5sgBWtQg@mail.gmail.com>
 <2026010240-certify-refined-7c02@gregkh>
 <CANubcdW2z9AEdML4sV9XEXFeDUUzbt20istLuZ9s=zUoPvjDLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdW2z9AEdML4sV9XEXFeDUUzbt20istLuZ9s=zUoPvjDLQ@mail.gmail.com>

On Sat, Jan 03, 2026 at 02:26:01PM +0800, Stephen Zhang wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> 于2026年1月2日周五 14:49写道：
> >
> > On Wed, Dec 31, 2025 at 07:54:45PM +0800, Stephen Zhang wrote:
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> 于2025年12月30日周二 00:16写道：
> > > >
> > > > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Andreas Gruenbacher <agruenba@redhat.com>
> > > >
> > > > [ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]
> > > >
> > > > In gfs2_chain_bio(), the call to bio_chain() has its arguments swapped.
> > > > The result is leaked bios and incorrect synchronization (only the last
> > > > bio will actually be waited for).  This code is only used during mount
> > > > and filesystem thaw, so the bug normally won't be noticeable.
> > > >
> > > > Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
> > > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  fs/gfs2/lops.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> > > > index 9c8c305a75c46..914d03f6c4e82 100644
> > > > --- a/fs/gfs2/lops.c
> > > > +++ b/fs/gfs2/lops.c
> > > > @@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
> > > >         new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
> > > >         bio_clone_blkg_association(new, prev);
> > > >         new->bi_iter.bi_sector = bio_end_sector(prev);
> > > > -       bio_chain(new, prev);
> > > > +       bio_chain(prev, new);
> > > >         submit_bio(prev);
> > > >         return new;
> > > >  }
> > > > --
> > >
> > > Hi Greg,
> > >
> > > I believe this patch should be excluded from the stable series. Please
> > > refer to the discussion in the linked thread, which clarifies the reasoning:
> > >
> > > https://lore.kernel.org/gfs2/tencent_B55495E8E88EEE66CC2C7A1E6FBC2FC16C0A@qq.com/T/#mad18b8492e01daa939c7d958200802c9603b6c73
> >
> > What exactly is the reasoning?  Why not just take these submitted
> > patches when they hit Linus's tree as well?
> >
> 
> My understanding is that this patch didn't actually fix anything and
> instead introduced a new bug by mistake. Since it was merged, a
> second patch had to be submitted to revert/correct the original "fix."
> 
> Therefore, for the stable series, the appropriate action is to simply
> drop this incorrect fix.

It's best to take the revert as well, to keep in sync, otherwise scripts
will keep trying to apply the original.  What is the revert's git id?

thanks,

greg k-h
