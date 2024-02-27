Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFA8135A43;
	Tue, 27 Feb 2024 13:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709039203; cv=none; b=ZYR+bZUxwDkoyZk+9FHIJsNbqCa0nr7KtTqehmmxBhUuEZZOpVetR92ZGPs0eCiUFqRS2BqwG3Dq48jGRIu7GfrDeeE7XNSTrE1iTQFQchJ/QoCheah+t7cWV9fKBf8wWuxJUBSDAid+uo+hhRSB2R0lCAZzbtbKKngQRziNlaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709039203; c=relaxed/simple;
	bh=cWrp7k8207wfYiJiyKnbllOkvNE+9uygA5yZwMOmx9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWjw+WttirsdZhQsXt9aBshlVgtaZlxS/Qmq5wXYTnkDCayFeX5zqHLBNH5EA2U8WzjeIxqIDLobIVA6A+sJyLW03xVPFB1Bis7jXuoF/4N9oWlDgY47BtZ9oowFnIy7Z85E+kxEc3syeX4EJOreHveui+zmY7DKBCcNUseQJy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ac6uDRK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ac6uDRK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5229C433C7;
	Tue, 27 Feb 2024 13:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709039202;
	bh=cWrp7k8207wfYiJiyKnbllOkvNE+9uygA5yZwMOmx9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ac6uDRK6umKJlCmO8tXY3wE5EOfhF0ihyBNRb7YZMcHorpnAHHtEdhoof9/DpKpZm
	 LD49jPch2O/agkevAw6JpFxmeonQGXHZmNxhSdruw1vmJJC0dBXLNwj72oSv0OkmbN
	 a0aB4bZSNJ40BtbJ0ih2GSqiQqp1BNGUOIIkNU9Y=
Date: Tue, 27 Feb 2024 14:06:39 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Baokun Li <libaokun1@huawei.com>
Cc: stable@vger.kernel.org, sashal@kernel.org, tytso@mit.edu, jack@suse.cz,
	patches@lists.linux.dev, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 5.15 2/2] ext4: avoid bb_free and bb_fragments
 inconsistency in mb_free_blocks()
Message-ID: <2024022725-broadly-gave-6b16@gregkh>
References: <20240227130050.805571-1-libaokun1@huawei.com>
 <20240227130050.805571-2-libaokun1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227130050.805571-2-libaokun1@huawei.com>

On Tue, Feb 27, 2024 at 09:00:50PM +0800, Baokun Li wrote:
> commit 2331fd4a49864e1571b4f50aa3aa1536ed6220d0 upstream.
> 
> After updating bb_free in mb_free_blocks, it is possible to return without
> updating bb_fragments because the block being freed is found to have
> already been freed, which leads to inconsistency between bb_free and
> bb_fragments.
> 
> Since the group may be unlocked in ext4_grp_locked_error(), this can lead
> to problems such as dividing by zero when calculating the average fragment
> length. Hence move the update of bb_free to after the block double-free
> check guarantees that the corresponding statistics are updated only after
> the core block bitmap is modified.
> 
> Fixes: eabe0444df90 ("ext4: speed-up releasing blocks on commit")
> CC:  <stable@vger.kernel.org> # 3.10
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20240104142040.2835097-5-libaokun1@huawei.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  fs/ext4/mballoc.c | 39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)

We also need this for 5.10.y and older, right?

Queued up now, thanks!

greg k-h
