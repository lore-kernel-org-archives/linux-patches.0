Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7DE439F62;
	Mon, 14 Sep 2026 10:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789381948; cv=none; b=YLLJ67VVLUwo3VWB+yJ6tFFptbmmkrU+ZXuN4QtuCo0mHTCP5kgAWqPZqtvGaU47kHITrGaKjXlHK2jC28VXtilOS10C1RZG0ImKq2H84CmClkaXa4KBF+dugkGS7Tg11NLmYUBVammV6RfMVp2XByC7zwC+yfPcRoSrZVx+fhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789381948; c=relaxed/simple;
	bh=uOQS5nU+lbm7MutuD/hlvlfEKBTgiHUjTe8XEtyPLnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCrJ87BKREu6I4BDiUlA96D334sG3D68lBDyfQnN4Vhy0bg7CZJ90ketJax9W9eYtdksrde1Nbb+BVyTIju9ffBPOhDVZG710/AGqM9fc0my6W8403MQUqmgNFfb7LP9ssBJj18zjwa5Gn0IsMqAtJvX0IQ4otgP9fDJMN8rjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jb2r5S7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jb2r5S7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2617E1F0089A;
	Mon, 14 Sep 2026 10:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789381946;
	bh=/wBRRRrArsOTKJNkve9FfrVVzG8bxwNqMCrFO8eimgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jb2r5S7irhFbprm5jagSGb9ynbuuJeqP4P2+flQugS7/a+kgxfoFLrTn5aYpwEIcZ
	 7D8mRBbZJ9Ng8ANBnh6hCYrlrpMfOZ5Qix63ggaUbYVzGKXC6L6uB0QIFYIGkhWAxs
	 AVjeHA7MEfIOdXkjZpnDZNo8lE2EYzSAVNlCEfTM=
Date: Mon, 14 Sep 2026 12:32:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 1069/1191] virtio_balloon: disable indirect
 descriptors
Message-ID: <2026091438-resigned-unnerve-312d@gregkh>
References: <20260912065548.086904252@linuxfoundation.org>
 <20260912065612.183814840@linuxfoundation.org>
 <20260912132127-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912132127-mutt-send-email-mst@kernel.org>

On Sat, Sep 12, 2026 at 01:22:24PM -0400, Michael S. Tsirkin wrote:
> On Sat, Sep 12, 2026 at 09:03:17AM +0200, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > 
> > [ Upstream commit 281eb4732aae5473141b84e106fe906c69b2ff3d ]
> > 
> > The page reporting callback submits an sg list to the reporting
> > virtqueue.  With VIRTIO_RING_F_INDIRECT_DESC negotiated and
> > total_sg > 1 (which it typically is), virtqueue_add reports it to the
> > host by allocating an indirect descriptor via kmalloc(GFP_KERNEL).
> > 
> > This is not pretty: the reporting worker isolates potentially hundreds
> > of MB of free pages from the buddy allocator (reported pages are at
> > least pageblock_order, and the sg can contain up to
> > PAGE_REPORTING_CAPACITY entries of varying orders).  As the result,
> > very theoretically, the kmalloc might trigger OOM when we have in fact a
> > ton of free memory.
> > 
> > Clear VIRTIO_RING_F_INDIRECT_DESC, to avoid using indirect descriptors.
> > 
> > Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
> > Assisted-by: Claude:claude-opus-4-6
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Message-ID: <73fac8a629fd9aca7bb3265ac243a769c28af25d.1783232420.git.mst@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> this is, as the patch description says, theoretical.
> Doesn't that make it ineligible for stable?

Possibly, many things that are described as "theoretical" really aren't
:)

So, let's just leave it in for now unless it's broken?

thanks

greg k-h
