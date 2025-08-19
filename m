Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC79E3112DA;
	Tue, 19 Aug 2025 08:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755591870; cv=none; b=WQmi/NMlLbvJ48uJJLKyy+tB2s6MChiVTnuizI7WuNf2/79ZFUEnImh9ToWVBR2B9zdvBnrVuRKj3ZOUywAJBPGgw25IPlx+j8vdX3vDscaIvhXxapw7zbrkQ28VojY2mAbx/OXI35TmA6TIpvGG1ngIoFws+XYsDq+D3wF8uCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755591870; c=relaxed/simple;
	bh=ZJVKKlhoK5MloOsFk0QoS92DYRu7S6VSuroXG1Bvf6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2Ag9HOD8QXBwnjxULN9/hI9yp7hfoKVTmBs1jPrz1Am3wZ1wMxtSk4uPFVPae8u3f6MF1vLH9x7RLm0u5KhsjWrjC0tYTlu0BRAxNUvTtZxmXOIiFb79Ghiq2hl+ogTAfCVkOulP3FxBtcZerIF7D3SMEwhdWa06aj6DgZFGy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuYpJtcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuYpJtcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57F8C4CEF1;
	Tue, 19 Aug 2025 08:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755591869;
	bh=ZJVKKlhoK5MloOsFk0QoS92DYRu7S6VSuroXG1Bvf6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TuYpJtcj3Kzw5INyiyL7BNlAU1vB02e0c+U+9PvQ672s+ihWG1E5MnMzSszKkPWMc
	 SnKYH4PArSf39wBUdXe53faug5gAQGq5eTW1XBDIboo3Nqxs+Zb6dFyuxamzAAwBJ4
	 yqgi47iN/PvSv8AT7yjpLw/ew15NOPetJwmlNIzXwX6DvSIf70BimP7MxZKM9f9nTY
	 8AOgyJyifD9q99Vlgfub37uvJXN+Q4QIBt8vH5LKvuHGdF3qVY+q3Cr8s5QfCEckhL
	 7Nrv5rHVqywHzQzuPH4I2U3ib+9bwJbQkk9guz3riOuFPRNHeX6CF6LB/61VY5dBKo
	 yP4cAEUTIDP3A==
Date: Tue, 19 Aug 2025 10:24:22 +0200
From: Christian Brauner <brauner@kernel.org>
To: Askar Safin <safinaskar@zohomail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	cyphar@cyphar.com, Ian Kent <raven@themaw.net>, linux-fsdevel@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, autofs mailing list <autofs@vger.kernel.org>, 
	patches@lists.linux.dev
Subject: Re: [PATCH 0/4] vfs: if RESOLVE_NO_XDEV passed to openat2, don't
 *trigger* automounts
Message-ID: <20250819-handlanger-explizit-b0a0debe7bc6@brauner>
References: <20250817171513.259291-1-safinaskar@zohomail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250817171513.259291-1-safinaskar@zohomail.com>

On Sun, Aug 17, 2025 at 05:15:09PM +0000, Askar Safin wrote:
> openat2 had a bug: if we pass RESOLVE_NO_XDEV, then openat2
> doesn't traverse through automounts, but may still trigger them.
> See this link for full bug report with reproducer:
> https://lore.kernel.org/linux-fsdevel/20250817075252.4137628-1-safinaskar@zohomail.com/
> 
> This patchset fixes the bug.

Thanks, this looks all sane. Once you've addressed all comments I'll get
this into -next.

> RESOLVE_NO_XDEV logic hopefully becomes more clear:
> now we immediately fail when we cross mountpoints.
> 
> I think this patchset should get to -fixes and stable trees.
> 
> I split everything to very small commits to make
> everything as bisectable as possible.

Thanks! But as said ealier in the thread folding the first three
preparatory patches is fine.

> 
> Minimal testing was performed. I tested that my original
> reproducer doesn't reproduce anymore. And I did boot-test
> with localmodconfig in qemu
> 
> I'm not very attached to this patchset. I. e. I will not be offended
> if someone else will submit different fix for this bug.
> 
> Askar Safin (4):
>   vfs: fs/namei.c: move cross-device check to traverse_mounts
>   vfs: fs/namei.c: remove LOOKUP_NO_XDEV check from handle_mounts
>   vfs: fs/namei.c: move cross-device check to __traverse_mounts
>   vfs: fs/namei.c: if RESOLVE_NO_XDEV passed to openat2, don't *trigger*
>     automounts
> 
>  fs/namei.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> -- 
> 2.47.2
> 
