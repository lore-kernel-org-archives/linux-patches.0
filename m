Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF05834D4DE;
	Mon, 31 Aug 2026 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140369; cv=none; b=rDx1Xkofh+0NFGqSjEGAgv5zOEPP/SfhFlOsApLJncA600wuLxbnX5woI59UP0g7ZXAa5rAaurqLp0iwRt5oYb81+1XAH+EREZFs51zly+R+6y7rkzcb+Ztsdp9PLz9mRuki9FbAxbytH1dXI5LQ4r2FE0SVRahKEyOwfhlCKYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140369; c=relaxed/simple;
	bh=9dS6Fo9EnoLDQjbrVzqG6iRKB2jX9Pp2xrfCfFPXPbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcyk+jXXy1GUozOFqZ4e7UALxZy/9yWm34tnTGrhpRHHvZF5dEyGTXjocQKuQgVLPs04roGxRvNZZyNqLaaQg0rBbyOAG427I4eXs2KQ92bVX/H82XOBV/XO5kn8hrd68N4zOq25nUBrAO+lDNbxTHdgbiQ/rMRgSz15WfWsbFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jp5+yMga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jp5+yMga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8924C1F00A3E;
	Mon, 31 Aug 2026 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140368;
	bh=jQYv0gfUgmV1y+NvjLlTs/G5BSTdBQoBpDqm9vLltr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jp5+yMgaNfVZxVKsT0MjTUHllhZIocjXCKqSROWAmiqbGFYq2Lkd7VWJZQyxM09t1
	 8CYLkfIEsWmKYnlWJ4NyIaRNcZR8HsZ9MMvxyg4kwVH1R0GgbTh6hoZ+B723ARJtlL
	 /mHh/uN8q2G0HBIszy2L8pFz8C5In+SQKHJkqjTMLsIbIJcj1KYPyyGFyD5RGPc3hE
	 btoDzZWaa1LcZNrsXhK99imr0eoCw7JXWBmDmAmAuq7cbvQQUJK4NuzkNaHbXaiy4C
	 M7vz80TC+A1FgZw6GbfnycCcf1kf2Du3AjHcw6O2dRX1p9kKUsY8gC/D6bPcKmk6Si
	 i7SHbe6Vfkl+w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 120/272] smb: client: use kvzalloc() for megabyte buffer in simple fallocate
Date: Sun, 30 Aug 2026 21:39:11 -0400
Message-ID: <20260830194900.0006-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <e0c06969-1c39-4f19-a61f-1e0524d2a6de@oracle.com>
References: <e0c06969-1c39-4f19-a61f-1e0524d2a6de@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I ran an AI-assisted backport review of d1bc345f6229 and checked the
> finding against the 5.15.217 SMB Direct path. The kvzalloc() fallback is
> not safe in that older transport implementation.
>
> Upstream already maps KVEC iterators page by page with:
>
>         if (is_vmalloc_or_module_addr((void *)kaddr))
>                 page = vmalloc_to_page((void *)kaddr);
>         else
>                 page = virt_to_page((void *)kaddr);

Agreed. On 6.1/5.15/5.10 that buffer reaches sg_set_buf(), which is
virt_to_page() based, so a kvzalloc() that falls back to vmalloc
DMA-maps the wrong page. 6.6 and newer build the SGE list from an
iterator and are fine.

Reverted on 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
