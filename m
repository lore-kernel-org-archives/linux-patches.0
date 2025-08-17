Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D267118B0F;
	Sun, 17 Aug 2025 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755453251; cv=none; b=hjQP0srT6BLOHmWkHIPGNDJ8f0Cu8XJf3Rpigv8FksD6dYeXFd1YQk3vmc6gxRCC0GzSoFSJ9qXTM5j5ziYES7nSC44/u8JWesvKmietXoELnzAERFkbCAQwURgHWtLTJHY5SeioF+M/0iU6YvlqTEa/yeU48l/9S3eXHGdLKEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755453251; c=relaxed/simple;
	bh=AWxBCR1YNmeLAjJszWAA+mzEzsg3PTqols401lDzSzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fd2bHQNeMtVsJrbGneCrwCU9tZ0iE7J4xl0dMILnUO/hXRsky5zby3rDPpo3+wGx4Y5vahqFqhPWrz/WQPnPS7N33yxpM15kx5PpWdrl11KNYFm++O1VPzrQcKVGsPA7iI0dyb7a4cqdSd8JEG1Ek3G2h1Wc1SZ894J5e5XIoWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=uRv5uskq; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="uRv5uskq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a4gbBqFhXGOuoVAOnCZOsI2cJBlBh9XBztbKD6V8TVM=; b=uRv5uskqMbtObr1FeWydiLuud3
	JD6qABBaz+Tg5QdmUSVLkPI55LiOqffExOg/oeSfYAznt3keiZBmSOV013+f+5OUHHI421mMJSFIt
	yKtgqC0T9ItmaT1Ml8mkkPvRDI/EqJS+BnGd0z6Dv+670hlUQc64LlQhr1EsTTDXBl36U4U/YNm0L
	2TfAauNsIVCvmcupp0paBrq08AdtORaASMxq5Aj89sr8z2wPD3P8yWaF8lFOwgzWJOsJqyT6AVZaR
	AtM6yWFfwP9qehfxYVwKJW2hlsJN+0pXP0yJYocg6opWfNYFpLNRwyvwlqeBY0fKC0NBAQRjrKMnM
	ZZqk7/hA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unha1-0000000BVZA-3pu0;
	Sun, 17 Aug 2025 17:54:06 +0000
Date: Sun, 17 Aug 2025 18:54:05 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Askar Safin <safinaskar@zohomail.com>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	cyphar@cyphar.com, Ian Kent <raven@themaw.net>,
	linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>,
	autofs mailing list <autofs@vger.kernel.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH 4/4] vfs: fs/namei.c: if RESOLVE_NO_XDEV passed to
 openat2, don't *trigger* automounts
Message-ID: <20250817175405.GZ222315@ZenIV>
References: <20250817171513.259291-1-safinaskar@zohomail.com>
 <20250817171513.259291-5-safinaskar@zohomail.com>
 <20250817175319.GY222315@ZenIV>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817175319.GY222315@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Aug 17, 2025 at 06:53:19PM +0100, Al Viro wrote:
> On Sun, Aug 17, 2025 at 05:15:13PM +0000, Askar Safin wrote:
> 
> > @@ -1472,6 +1484,10 @@ static int __traverse_mounts(struct path *path, unsigned flags, bool *jumped,
> >  		/* Allow the filesystem to manage the transit without i_rwsem
> >  		 * being held. */
> >  		if (flags & DCACHE_MANAGE_TRANSIT) {
> > +			if (lookup_flags & LOOKUP_NO_XDEV) {
> > +				ret = -EXDEV;
> > +				break;
> 
> I don't thing it's right in RCU mode, if nothing else...

Nevermind, that's a non-RCU path.
