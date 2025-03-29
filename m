Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D0315A85A;
	Sat, 29 Mar 2025 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743236924; cv=none; b=L+wAks/VcNN17SE+AZe/OxO6L7u6VCXK0IAZiC7dJaeV8FZembGMHKrKSZPpA9EOPTDVEuWHGDBnxjLaE/tGlogZAKorx/pfHaHrGAIMA47YiFhLO1EzKAmMzEIWL9M9F0NKdYT8gLadJAlPXqHRL55e4kRafGw1UK9Ktdkgd3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743236924; c=relaxed/simple;
	bh=/Y0PnAry3P+lu2EWsUl8DZKWfjWeK1OijiNVJKBk2UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmIe0fKof279uLULlrZl+AFibfReC3xO3xwukqDGtLxYhlAIDbYh8GEH5Aqni3T0KPOJ3jGyzfFEn+9C6itWbDbfXyWGVQYoHAwzDChfjQAGFZQREdnV6klqjCzyHM9Df4nqvDGc/m+5JBReHkY5w5JFjxhNOvBU3R8VCsiswBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhzaC2d8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhzaC2d8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE395C4CEE2;
	Sat, 29 Mar 2025 08:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743236924;
	bh=/Y0PnAry3P+lu2EWsUl8DZKWfjWeK1OijiNVJKBk2UQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XhzaC2d8qBH4zfhoyOEMSISPp/Hb9Q8jXw+MeJa8omrtsOmTSfkP2m+v4goSRjYha
	 YWKpPWyOHULwOKCTx1kbHrjH85kHDdX4APc1G98kL/EBqDuV0W71gyAqbgoQbxgWJx
	 D0+KNTJerCjZkvhYNNFIPpzOjq77n9OTXtzQiR/Q=
Date: Sat, 29 Mar 2025 09:28:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 462/462] net: ipv6: fix dst refleaks in rpl, seg6
 and ioam6 lwtunnels
Message-ID: <2025032924-antidote-spent-3210@gregkh>
References: <20250311145758.343076290@linuxfoundation.org>
 <20250311145816.586107514@linuxfoundation.org>
 <5d14c4f54dc785eb3fc8aa1207ad492d52b6de57.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d14c4f54dc785eb3fc8aa1207ad492d52b6de57.camel@decadent.org.uk>

On Fri, Mar 28, 2025 at 10:50:05PM +0100, Ben Hutchings wrote:
> On Tue, 2025-03-11 at 16:02 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jakub Kicinski <kuba@kernel.org>
> > 
> > commit c71a192976ded2f2f416d03c4f595cdd4478b825 upstream.
> > 
> > dst_cache_get() gives us a reference, we need to release it.
> > 
> > Discovered by the ioam6.sh test, kmemleak was recently fixed
> > to catch per-cpu memory leaks.
> > 
> > Fixes: 985ec6f5e623 ("net: ipv6: rpl_iptunnel: mitigate 2-realloc issue")
> 
> The 5.10 branch does not include backports of:
> 
> > Fixes: 40475b63761a ("net: ipv6: seg6_iptunnel: mitigate 2-realloc issue")
> > Fixes: dce525185bc9 ("net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue")
> 
> so the changes this makes to seg6_iptunnel.c are incorrect and appear to
> introduce a UAF.

Ick.  Should I just revert it?

thanks,

greg k-h
