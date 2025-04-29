Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF5E250C0C;
	Tue, 29 Apr 2025 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950550; cv=none; b=Tw0X+YE3u9aPbbvEhIeTjevwnAhw0ynUl94rzTY/9C0ze9POGLPUpPRlWiNJ2fe0FEZZJhZQsWwWfTOQnfEkekSD6+DEArBYNmH/jojqFVH0ygSWKL+B5DptuDrOTcMvfV6Yly/0r3004R3uc4VSIeFf4+ghaID6vxm4Y9xmPo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950550; c=relaxed/simple;
	bh=cZo3zRIK2OoxRCc8DP2NAvhQPeEvQnvMCaZrZIodnTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ob21D6rRPZHji2m/xtpc5lUnhBpNxzqB3QFp+/KW12t52rkamOMMZHIpCtChV4ePpuVYG1op+lWy0nL1ZeFjifUz6VdeMwbXAALf7Fff5BO/KgHXhB+teRFPNZ6vOOJiyDTR5RG5GcJ7bJY4LEzJG9x5WQ52ZhRlRzfuHGHif2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5iyh3hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5iyh3hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EACEC4CEE3;
	Tue, 29 Apr 2025 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745950550;
	bh=cZo3zRIK2OoxRCc8DP2NAvhQPeEvQnvMCaZrZIodnTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e5iyh3hITc4zQ1/5fIp/NyuDkipQOYyj4RpR1aNk9PmTnUQAc696UkfAlGXKSelfA
	 5eXhQ3Ex/DASvs2/e6SJO29tg8yRmyYUI1pRFlk2PW4Egu5EtMi0lOZ2Pk13Np55WF
	 xsWPaMHat3poB082saSEaWN5BDrXvYYMFPVP6q8zBATEJ1HZY0l5RUHcCv3r1tpEiY
	 cJvWlwi396q+Cur0tDH8tgKPnDOFYuD7N7VMrryeiasoWLJNpAhHcxeFCXkqYg02bf
	 t3IM33pPU/6vujWZ0T6bKt+I/oUbG8N9UYXzpZhC35d1aJhC4sWqtyUasXxBtCSi88
	 g8inSOWMtq+5Q==
Date: Tue, 29 Apr 2025 20:15:44 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] rust: device: allow `dead_code` for `Device<>::parent()`
Message-ID: <aBEXUG7QH0ymRuLm@pollux>
References: <20250429150346.392050-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429150346.392050-1-ojeda@kernel.org>

On Tue, Apr 29, 2025 at 05:03:46PM +0200, Miguel Ojeda wrote:
> When `CONFIG_AUXILIARY_BUS` is disabled, `parent()` is still dead code:
> 
>     error: method `parent` is never used
>       --> rust/kernel/device.rs:71:19
>        |
>     64 | impl<Ctx: DeviceContext> Device<Ctx> {
>        | ------------------------------------ method in this implementation
>     ...
>     71 |     pub(crate) fn parent(&self) -> Option<&Self> {
>        |                   ^^^^^^
>        |
>        = note: `-D dead-code` implied by `-D warnings`
>        = help: to override `-D warnings` add `#[allow(dead_code)]`
> 
> Thus reintroduce the `expect`, but now as an `allow`, and do so as
> `dead_code` since that is narrower.
> 
> Fixes: ce735e73dd59 ("rust: auxiliary: add auxiliary device / driver abstractions")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Good catch, thanks!

I wonder if for such or similar cases we want something like

	macro_rules! cfg_expect {
	    (not($cfg:meta) => $lint:ident, $item:item) => {
		#[cfg(not($cfg))]
		#[expect($lint)]
		$item

		#[cfg($cfg)]
		$item
	    };
	}

which could be used like this:

    cfg_expect!(not(CONFIG_FEATURE) => dead_code,
        pub(crate) fn foo(&self) {
            // noop
        }
    );

Maybe there is a much better solution I don't know about.
