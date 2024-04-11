Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5DE168DD;
	Thu, 11 Apr 2024 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712848215; cv=none; b=GRd1XYRbwHxFm7WPmZ1dHoX/q0InXg7hlxNV0R1/7qpKmxk8m+fpPndIUobgVQjDc3tO751l9r4sBIhIl7nLvd2Ad13W/HARg2woGL3eZkCyDetM7CAAr2PD9RfbG4059v2KI62DTdzYTdCg1lFSgCVoHAhxJZuCpc3YzhCUo9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712848215; c=relaxed/simple;
	bh=RgCuXoj5qiS0w7iaRf3GxVN7CusvwjfATAsJPn0aHek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HYsfM1e6KHV4wzXmKnN64IcAiFDhZaSLDyLlbfctOXce95SqDvjmhPtnwh3iVgxyCGSvSXL5zg8FkS9o6NAfbajb5Cuzb0TVttXoPtToOFR/VCxgyFAsbK8ELfa4URdUOBp+k+RszqTxZoCdk0VOWizI2fnziXv48c8jzcGHp10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwFOZIsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwFOZIsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8473C072AA;
	Thu, 11 Apr 2024 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712848215;
	bh=RgCuXoj5qiS0w7iaRf3GxVN7CusvwjfATAsJPn0aHek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwFOZIsLeokD/CdNKjDC+Dd4ZIZrs3LVZ1eI/XQ2DMjXB2GztfODiYHff/FKFv3yC
	 nT9EfCvj0ACpFyViRI2Q8i17GwotaODoizC75qqt14YuzdABzqeewn4LgsuLzycN82
	 AlA5tHUPJjtNptiuuq7+oIp+KbeUoKof5PjjDKnk=
Date: Thu, 11 Apr 2024 17:10:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Max Reitz <mreitz@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 045/215] fuse: store fuse_conn in fuse_req
Message-ID: <2024041159-creamlike-prognosis-b9fc@gregkh>
References: <20240411095424.875421572@linuxfoundation.org>
 <20240411095426.249853460@linuxfoundation.org>
 <CAOssrKfFgJcKK1RGbo4bDy0DkQ57Fe3Q9H89Jwgjh9yVj3qwJg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOssrKfFgJcKK1RGbo4bDy0DkQ57Fe3Q9H89Jwgjh9yVj3qwJg@mail.gmail.com>

On Thu, Apr 11, 2024 at 12:38:17PM +0200, Miklos Szeredi wrote:
> On Thu, Apr 11, 2024 at 12:16 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Max Reitz <mreitz@redhat.com>
> >
> > [ Upstream commit 24754db2728a87c513cc480c70c09072a7a40ba6 ]
> >
> > Every fuse_req belongs to a fuse_conn.  Right now, we always know which
> > fuse_conn that is based on the respective device, but we want to allow
> > multiple (sub)mounts per single connection, and then the corresponding
> > filesystem is not going to be so trivial to obtain.
> >
> > Storing a pointer to the associated fuse_conn in every fuse_req will
> > allow us to trivially find any request's superblock (and thus
> > filesystem) even then.
> >
> > Signed-off-by: Max Reitz <mreitz@redhat.com>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > Stable-dep-of: b1fe686a765e ("fuse: don't unhash root")
> 
> Why are this and the following patch marked as dependencies of
> b1fe686a765e ("fuse: don't unhash root")?
> 
> I think they are completely independent.   While backporting them is
> probably harmless, it should not be needed.

Good point, they were not needed, now dropped both of them, thanks for
the review!

greg k-h
