Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7EC258A;
	Fri, 30 May 2025 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748623602; cv=none; b=ozj2RfIgFpRH3pke/aHNvPe1YLr+vEtdKSi+/a8un9xV3HFPfB52S45+paMjUJZhB6burOpUdA9PZbkCxChrRTsxgP9svTh7lK/zl93hUr3r8YxMR19/8HW6dyAkmiIgS25mjh1AEgSpkcTnE1CbJFUd4ZxgKxeM8w2gYIcdR/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748623602; c=relaxed/simple;
	bh=JNZPc9zJ36La3cCD6hIFAeviana5v0tpbK8AmKneEb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chtjx5W5+Q503kI98nRYrPd/q2eJdp/YyGgR8FwKSSpfw1HiR4qvYsPi64RhDlLpX9QRr9LRasVYVEATTY+T2vnls98/7bKVsA45jNBb6hcZEW4JujH9AFHO5zaZSnA6ybcd9L0r1LipjxNjucgAoCz0KImQCqnK45NpX7I6HTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhhAdAFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhhAdAFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34474C4CEE9;
	Fri, 30 May 2025 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748623601;
	bh=JNZPc9zJ36La3cCD6hIFAeviana5v0tpbK8AmKneEb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XhhAdAFGAFYgJEh8ijb/JoeZafNVL1XjIsXUbPB4g1+MIZT4tdGndQoODSgJmY53z
	 Q/T0POtERwBR4udf+nScGnof88KtvSmehlNKeW/dd6lXQ1BjFxcyDdK1dt79ibu6ml
	 go/AVKtQ6i1D11hUGuw4k1y3H6yron2Dg1B3+gWJmHzsUanu2z70s4IVpxXKvshr+s
	 0BPjpfIWpuVF1YOoirTm9Ec5EIJaSydiU0d73t1Pl3qhkKDqCWpYxyUhis1FZtiRwZ
	 I2m2BQohh7QB2Fyldn6dJgM7EpyA3s1XvKN+fb6lO9SErsQe2KWOpYs5loY2SQeosg
	 CC67eXKJpbtGA==
Date: Fri, 30 May 2025 09:46:37 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>, Davidlohr Bueso <dave@stgolabs.net>,
	kdevops@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 030/783] fs/buffer: split locking for pagecache
 lookups
Message-ID: <aDng7V4R818rgdjW@bombadil.infradead.org>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162514.350990133@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527162514.350990133@linuxfoundation.org>

On Tue, May 27, 2025 at 06:17:07PM +0200, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Davidlohr Bueso <dave@stgolabs.net>
> 
> [ Upstream commit 7ffe3de53a885dbb5836541c2178bd07d1bad7df ]
> 
> Callers of __find_get_block() may or may not allow for blocking
> semantics, and is currently assumed that it will not. Layout
> two paths based on this. The the private_lock scheme will
> continued to be used for atomic contexts. Otherwise take the
> folio lock instead, which protects the buffers, such as
> vs migration and try_to_free_buffers().
> 
> Per the "hack idea", the latter can alleviate contention on
> the private_lock for bdev mappings. For reasons of determinism
> and avoid making bugs hard to reproduce, the trylocking is not
> attempted.
> 
> No change in semantics. All lookup users still take the spinlock.

As noted to Sasha before, one of these changes apply to stable kernels,
since buffer-heads lacked folio min order support until v6.15. So these
patches from Davidlohr are not fixing anything on older kernels.

  Luis
