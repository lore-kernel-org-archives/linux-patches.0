Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3B3DDB04;
	Thu, 24 Sep 2026 07:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790234906; cv=none; b=P14ejPa8rdFA9M56Og7zJ1wA38KYIrZ9JOSSjKxytRD+d9W3nSzr1bIB7ofBBkmAR7S9UG2rGDj1DjLG7UVVhmGW4tPRuvYhhXLS0c4zMWZuJyh/U8XsEDgNyJVKRsNEsikVfMgKSXr0KLNkOsVxOGOwDu5GHJOTmCeVZVpF8hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790234906; c=relaxed/simple;
	bh=JJ5+dug3n2FxGQ+j4RtUvaHQN/pI5uCR3wdNBgrddJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak5nfuqsoudRsQnwo5JAH9q5FmenCaeiee01TkrgZPwwJWm0SqZKeqEJjFJIhrGYnGhlALkj2/W8mwAudN4QkbDbJdVRp6j6NRccSqMY40vnPhg0O0WIKNnJ9NSMcxRMxQh9zHhzA4++gs4dCqdromh57rdUlJRUC/kjP7N6vic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7FawaXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7FawaXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C973D1F000FF;
	Thu, 24 Sep 2026 07:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790234905;
	bh=960Fi68hyARxmknpn6sduNDYLXNiIsoUQ0fe2oc+3GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n7FawaXyS0MLzxo1zvGKx7cY56c64ZnCPgnI83YdsIK/uy7oGjhC5042G3HmwqHev
	 nJ+MjTbpF9x0TerV9uTOo1vOfOekgtyDAvhIi1apk7TAJ8kmAm0edRp0UBRUHyuFfa
	 /pmqfZh6U6AFcREivFHyQlND6sCy81IaHHBPhJHU=
Date: Thu, 24 Sep 2026 09:28:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 129/398] net: bcmgenet: convert RX path to page_pool
Message-ID: <2026092430-contently-pungent-f0cc@gregkh>
References: <20260923140643.441954610@linuxfoundation.org>
 <20260923140646.783275824@linuxfoundation.org>
 <20260924065839.56793-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924065839.56793-1-kmehltretter@gmail.com>

On Thu, Sep 24, 2026 at 08:58:39AM +0200, Karl Mehltretter wrote:
> I have a small objection to taking patch 129 into 6.18.y only as a
> dependency for patch 130.
> 
> My LLM agent helped me running these tests.
> 
> On a 64 KiB arm64 kernel in a custom QEMU Pi 400 model with functional
> GENET v5 DMA, patch 129 increased the socket receive-memory charge per
> 512-byte UDP datagram from 2,752 to 65,792 bytes.
> 
> With the same 512 KiB socket receive-buffer limit, this reduced the number
> of queued datagrams from 190 to 7 and increased socket receive-buffer drops
> from 810 to 993 per 1,000 datagrams. I obtained the same result in five
> bursts.
> 
> The page-pool conversion otherwise worked in this test, and physical Pi 400
> testing with 4 KiB pages found no correctness failure. However, patch 130
> was also verified on the Pi 400 to work without patch 129 after a small
> contextual adaptation.
> 
> I would appreciate the BCMGENET maintainers' view on whether this page-pool
> conversion is appropriate for 6.18.y.
> 
> Please consider omitting patch 129 from 6.18.y and applying that adapted
> version of patch 130 directly.

But when you update to a newer release, that memory increase will
happen, right?  So why not fix the root problem upstream first?

Also, there is no context here in the email, please always include that
when replying.

thanks,

greg k-h
