Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226A22F5D
	for <patches@lists.linux.dev>; Wed, 21 Sep 2022 11:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C663C433D6;
	Wed, 21 Sep 2022 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1663760806;
	bh=zzApFJtlF2vVGaeOdclIO2YCUDHgmUL8bWPaMWu56O8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2K3Okgx70QTOprd6gQeOss5QT1quuEbtX7VidECZdD0VmJqvKxMor3DtgIK/1Rbz5
	 xVKcbZD0kv1BPss4TYCh189zpn0KD5n/XQ2HKU/DIEzHEsrtK0C1BqU3PLHJEEYLz7
	 Ydmu1yCwhkwGRoG/wukDUslGSMuHJyk34dFxVyvQ=
Date: Wed, 21 Sep 2022 13:46:44 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, ojeda@kernel.org,
	alex.gaynor@gmail.com, ark.email@gmail.com,
	bjorn3_gh@protonmail.com, bobo1239@web.de, bonifaido@gmail.com,
	boqun.feng@gmail.com, davidgow@google.com, dev@niklasmohrin.de,
	dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, gary@garyguo.net,
	geofft@ldpreload.com, jarkko@kernel.org, john.m.baublitz@gmail.com,
	leseulartichaut@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, m.falkowski@samsung.com, me@kloenk.de,
	milan@mdaverde.com, mjmouse9999@gmail.com, patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org, thesven73@gmail.com,
	torvalds@linux-foundation.org, viktor@v-gar.de, wedsonaf@google.com,
	Andreas Hindborg <andreas.hindborg@wdc.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
Message-ID: <Yyr5pKpjib/yqk5e@kroah.com>
References: <20220805154231.31257-13-ojeda@kernel.org>
 <Yu5Bex9zU6KJpcEm@yadro.com>
 <CANiq72=3j2NM2kS8iw14G6MnGirb0=O6XQyCsY9vVgsZ1DfLaQ@mail.gmail.com>
 <Yyr0PmHaxvJ0r4hm@yadro.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyr0PmHaxvJ0r4hm@yadro.com>

On Wed, Sep 21, 2022 at 02:23:42PM +0300, Konstantin Shelekhin wrote:
> On Sat, Aug 06, 2022 at 01:22:52PM +0200, Miguel Ojeda wrote:
> > On Sat, Aug 6, 2022 at 12:25 PM Konstantin Shelekhin
> > <k.shelekhin@yadro.com> wrote:
> > >
> > > I sense possible problems here. It's common for a kernel code to pass
> > > flags during memory allocations.
> > 
> > Yes, of course. We will support this, but how exactly it will look
> > like, to what extent upstream Rust's `alloc` could support our use
> > cases, etc. has been on discussion for a long time.
> > 
> > For instance, see https://github.com/Rust-for-Linux/linux/pull/815 for
> > a potential extension trait approach with no allocator carried on the
> > type that Andreas wrote after a discussion in the last informal call:
> > 
> >     let a = Box::try_new_atomic(101)?;
> 
> In my opinion, the rest of the thread clearly shows that the
> conservative approach is currently the only solid option. I suggest the
> following explicit API:
> 
>   let a = Box::try_new(size, flags)?;
>   Vec::try_push(item, flags)?;
> 
> etc. Whadda you think?

Please, yes.  This fits the current kernel memory allocation pattern and
allows for proper propagation of the allocation flags as needed through
the system.  This is going to be required in any non-trivial kernel code
anyway, might as well do it correct from the beginning.

It also allows for flags to change over time, which also happens.

thanks,

greg k-h
