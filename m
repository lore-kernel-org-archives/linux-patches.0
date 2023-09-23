Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE39163B9
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 08:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2E0C433C8;
	Sat, 23 Sep 2023 08:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695457512;
	bh=Bs7Fw0q6rolAT4THIz/C5APhEhLEGgSsQjNskd5c+QQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t+dAaj8x9X4YxMC3dlT0lUPRkO7w7nobFsxmUAs9WiIAAwm3lxoEFQu48mx3g30RF
	 cxNEJG+FFbY+9JFLONb4SU+4XvAXsAvisg0BS8/DF8Sxoh464B06XvKxINlixmDjPr
	 YCakWi7jWcbKufH3lrjqxOFDUG1rHHnWTlvKRgH8=
Date: Sat, 23 Sep 2023 10:25:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev, Hao Luo <haoluo@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.4 326/367] libbpf: Free btf_vmlinux when closing
 bpf_object
Message-ID: <2023092303-rotting-strum-1509@gregkh>
References: <20230920112858.471730572@linuxfoundation.org>
 <20230920112906.975001366@linuxfoundation.org>
 <e7e9df6b-d3c1-0fad-1cea-94dc74dbf281@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7e9df6b-d3c1-0fad-1cea-94dc74dbf281@oracle.com>

On Wed, Sep 20, 2023 at 06:58:45PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 20/09/23 5:01 pm, Greg Kroah-Hartman wrote:
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hao Luo <haoluo@google.com>
> > 
> > [ Upstream commit 29d67fdebc42af6466d1909c60fdd1ef4f3e5240 ]
> > 
> > I hit a memory leak when testing bpf_program__set_attach_target().
> > Basically, set_attach_target() may allocate btf_vmlinux, for example,
> > when setting attach target for bpf_iter programs. But btf_vmlinux
> > is freed only in bpf_object_load(), which means if we only open
> > bpf object but not load it, setting attach target may leak
> > btf_vmlinux.
> > 
> > So let's free btf_vmlinux in bpf_object__close() anyway.
> > 
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > Link: https://lore.kernel.org/bpf/20230822193840.1509809-1-haoluo@google.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   tools/lib/bpf/libbpf.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index b8849812449c3..343018632d2d1 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4202,6 +4202,7 @@ void bpf_object__close(struct bpf_object *obj)
> >   	bpf_object__elf_finish(obj);
> >   	bpf_object__unload(obj);
> >   	btf__free(obj->btf);
> > +	btf__free(obj->btf_vmlinux);
> 
> 
> This patch introduces a build failure.
> 
> libbpf.c: In function 'bpf_object__close':
> libbpf.c:4205:22: error: 'struct bpf_object' has no member named
> 'btf_vmlinux'
>  4205 |         btf__free(obj->btf_vmlinux);
>       |                      ^~
> 
> This struct member "btf_vmlinux" is added in commit a6ed02cac690 ("libbpf:
> Load btf_vmlinux only once per object.") which is not in 5.4.y
> 
> So I think we should drop this patch.

Now dropped, thanks.

greg k-h
