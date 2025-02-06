Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F522DF8D;
	Thu,  6 Feb 2025 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852069; cv=none; b=aABlyh/6ZvSAbhVKgiNG9jSBd7He9rnNgRZ2oCCTvQn0ShMb1sD6hHOOLGYHGMUNS6I5/1IJWzT+uPkmabRkHw8QHeMZRZaUI9UDK/Zz9zUVrUQxhArt0jPQCGft9RMpl4nezLbhx+EFB6LKCJ5NoeUA/GtjrFDYxpsgEmdAsko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852069; c=relaxed/simple;
	bh=eu5rYNsFCWJsbIAVYuyIpHxvYuLxXi5RArsfhond16o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxRGi0YBQTq92PwrlXI7Pt34H6ySwCDaevoSNy3Xg9YMjqXSTsY23yJ/y9Ce7wYXIFF169NGu3a/1OBgh7+v5RPlyWpouxmAP7Bw1M49o844DEb7TwaM1mXX8ulpwKiPDFBTD6WSRp3dZikLV6DDTkOaYYbPIUQ7n9YbI/2VirY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBlw2U9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBlw2U9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7165C4CEDD;
	Thu,  6 Feb 2025 14:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738852069;
	bh=eu5rYNsFCWJsbIAVYuyIpHxvYuLxXi5RArsfhond16o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TBlw2U9ZF5hAu7/d318TfIPQQSBWGbQHgvhMcQAbVD9uT9ANZ3Yh5C/fZpNypkbXz
	 wx5a/owvHGqAFEy57ormwB6SNOHHordiVXo5XWITjGcyDhkWEuEI4Cf51/b3lHa4TC
	 mxAZnqegM8gZLu+URsLh4YyyfIrrALt9M6xDYhqQ=
Date: Thu, 6 Feb 2025 06:13:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Edward Cree <ecree.xilinx@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 502/590] net: ethtool: only allow set_rxnfc with rss
 + ring_cookie if driver opts in
Message-ID: <2025020648-tilt-subtotal-c90c@gregkh>
References: <20250205134455.220373560@linuxfoundation.org>
 <20250205134514.474132731@linuxfoundation.org>
 <2614b0ce-0b34-03e3-3744-0b91fdd0a32b@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2614b0ce-0b34-03e3-3744-0b91fdd0a32b@gmail.com>

On Wed, Feb 05, 2025 at 10:27:50PM +0000, Edward Cree wrote:
> On 05/02/2025 13:44, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Edward Cree <ecree.xilinx@gmail.com>
> > 
> > [ Upstream commit 9e43ad7a1edef268acac603e1975c8f50a20d02f ]
> > 
> > Ethtool ntuple filters with FLOW_RSS were originally defined as adding
> >  the base queue ID (ring_cookie) to the value from the indirection table,
> >  so that the same table could distribute over more than one set of queues
> >  when used by different filters.
> > However, some drivers / hardware ignore the ring_cookie, and simply use
> >  the indirection table entries as queue IDs directly.  Thus, for drivers
> >  which have not opted in by setting ethtool_ops.cap_rss_rxnfc_adds to
> >  declare that they support the original (addition) semantics, reject in
> >  ethtool_set_rxnfc any filter which combines FLOW_RSS and a nonzero ring.
> > (For a ring_cookie of zero, both behaviours are equivalent.)
> > Set the cap bit in sfc, as it is known to support this feature.
> > 
> > Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> > Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> > Link: https://patch.msgid.link/cc3da0844083b0e301a33092a6299e4042b65221.1731499022.git.ecree.xilinx@gmail.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Stable-dep-of: 4f5a52adeb1a ("ethtool: Fix set RXNFC command with symmetric RSS hash")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> If you're taking this you probably also want the very recent
> 2b91cc1214b1 ("ethtool: ntuple: fix rss + ring_cookie check")
> which fixes a bug in this patch.

Thanks, I'll go queue that up now.

greg k-h
