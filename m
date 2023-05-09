Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A974D20F7
	for <patches@lists.linux.dev>; Tue,  9 May 2023 08:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECEAC433D2;
	Tue,  9 May 2023 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683622000;
	bh=Rosg6MIt+oWekqphy3JytZbJCDw525kHM44ZeRKAImo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UpK6iwdYthvcjHN6+BKNYjrGU+DfDKrInQ+XVJ3y3LF2xzUsyz0f7cMpW0Z3+s0a6
	 RovtM+pwcK3eCbIQqgQaGmCcLA8md8hEEk79Sah39rXSCBXtA72kOindkgCAA7IQj+
	 wLTIVZFV1dJvJsaFby6YJtzwZHsyCI93l4bRPI5A=
Date: Tue, 9 May 2023 10:46:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: gary@garyguo.net, alex.gaynor@gmail.com, benno.lossin@proton.me,
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com,
	linux-kernel@vger.kernel.org, ojeda@kernel.org,
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org,
	wedsonaf@gmail.com
Subject: Re: [PATCH v2] rust: error: add missing error codes
Message-ID: <2023050937-scouring-truck-d7c0@gregkh>
References: <20230508124701.443ba331.gary@garyguo.net>
 <20230509080700.1608146-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509080700.1608146-1-aliceryhl@google.com>

On Tue, May 09, 2023 at 08:07:00AM +0000, Alice Ryhl wrote:
> On Mon, 8 May 2023 12:47:01 +0100
> Gary Guo <gary@garyguo.net> wrote:
> > On Thu,  4 May 2023 06:48:54 +0000
> > Alice Ryhl <aliceryhl@google.com> wrote:
> > > This adds the error codes from `include/linux/errno.h` to the list of
> > > Rust error constants. These errors were not included originally, because
> > > they are not supposed to be visible from userspace. However, they are
> > > still a perfectly valid error to use when writing a kernel driver. For
> > > example, you might want to return ERESTARTSYS if you receive a signal
> > > during a call to `schedule`.
> > 
> > `include/linux/errno.h` also includes all of `asm/errno.h`,
> > which defines EDEADLK - EHWPOISON, which is not included in this patch.
> > I feel like these error codes should be added first?
> 
> It seems like there are a lot of asm/errno.h files:
> 
> $ find . -name errno.h
> ./arch/powerpc/include/uapi/asm/errno.h
> ./arch/mips/include/asm/errno.h
> ./arch/mips/include/uapi/asm/errno.h
> ./arch/alpha/include/uapi/asm/errno.h
> ./arch/parisc/include/uapi/asm/errno.h
> ./arch/sparc/include/uapi/asm/errno.h
> ./arch/x86/include/generated/uapi/asm/errno.h
> ./tools/arch/powerpc/include/uapi/asm/errno.h
> ./tools/arch/mips/include/asm/errno.h
> ./tools/arch/mips/include/uapi/asm/errno.h
> ./tools/arch/alpha/include/uapi/asm/errno.h
> ./tools/arch/parisc/include/uapi/asm/errno.h
> ./tools/arch/sparc/include/uapi/asm/errno.h
> ./tools/arch/x86/include/uapi/asm/errno.h
> ./tools/include/nolibc/errno.h
> ./tools/include/uapi/asm/errno.h
> ./tools/include/uapi/asm-generic/errno.h

You can ignore the tool ones.

> ./include/uapi/asm-generic/errno.h
> ./include/uapi/linux/errno.h
> ./include/linux/errno.h
> 
> How should I proceed with this? You mention EDEADLK - EHWPOISON, but its
> not clear to me which asm/errno.h file I should base this on.

It depends on which arch you are building for.  That's why we have
per-platform errno.h files, the values are different for different ones.
So you need to handle them all properly somehow.  How is rust going to
handle per-arch stuff like this?

thanks,

greg k-h
