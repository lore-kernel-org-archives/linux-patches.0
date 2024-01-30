Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22B0129A9B;
	Tue, 30 Jan 2024 16:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706632534; cv=none; b=hMFasV3o479GaJEyXLQoQgGpoctLBj+xtm1fLcsef3d1/IdTNG0iQFyKU9MT/SmiFTIoe+XBMncRkkvrwNPs3rSjn+LNTMnV5WvOkXZdyMP/iot1XARZu5si6T3td/k+6I0IsY9qexjj/Aq2WAply/uncDoPuLl8Wuu3JOVI/KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706632534; c=relaxed/simple;
	bh=PKiVkrb8gj474ShKj8vG0TUwph6AYc1yEkyAji/63Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcY5AedJjxndfHel7pEkEfn4HDWkdSPTY1ZQssNoZGzUqmhSQGKh3LnES47WZivr8U7Iykva/y1d1TMFgMYSNdDO4LIW4WIT7JwAAAT3YGqqZOVOGp/a9LFMqJ+ege+LIVFfyWmh3mi8AjEzUMSJ0lG7BXnCJ85Vch5eSJXNMws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AC9pzC/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AC9pzC/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A92CC43330;
	Tue, 30 Jan 2024 16:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706632534;
	bh=PKiVkrb8gj474ShKj8vG0TUwph6AYc1yEkyAji/63Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AC9pzC/TqRyZjLc/gLjxnkZqoWyuvwWRFbcoy7o+tBbFK0E5u3sXGsezyf/X/E/yp
	 agNtx9h/6/9mLPkiN9ontmqPq+VZMTpVM3rmi+5L7WvOjlEXjMTQhgrdZFyyEC54fN
	 pQ6oJ6TqoCCNFDGTXfUvJ98yVIFNVCLnAaf0Nw6Q=
Date: Tue, 30 Jan 2024 08:21:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.7 125/346] mm/sparsemem: fix race in accessing
 memory_section->usage
Message-ID: <2024013044-snowiness-abreast-2a47@gregkh>
References: <20240129170016.356158639@linuxfoundation.org>
 <20240129170020.057681007@linuxfoundation.org>
 <81752462-c6c7-4a65-b9f2-371573e15499@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81752462-c6c7-4a65-b9f2-371573e15499@kernel.org>

On Tue, Jan 30, 2024 at 07:00:36AM +0100, Jiri Slaby wrote:
> On 29. 01. 24, 18:02, Greg Kroah-Hartman wrote:
> > 6.7-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Charan Teja Kalla <quic_charante@quicinc.com>
> > 
> > commit 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 upstream.
> 
> Hi,
> 
> our machinery (git-fixes) says, this is needed as a fix:
> commit f6564fce256a3944aa1bc76cb3c40e792d97c1eb
> Author: Marco Elver <elver@google.com>
> Date:   Thu Jan 18 11:59:14 2024 +0100
> 
>     mm, kmsan: fix infinite recursion due to RCU critical section
> 
> 
> Leaving up to the recipients to decide, as I have no idea…

That commit just got merged into Linus's tree, AND it is not marked for
stable, which is worrying as I have to get the developers's approval to
add any non-cc-stable mm patch to the tree because they said they would
always mark them properly :)

So I can't take it just yet...

thanks,

greg k-h
