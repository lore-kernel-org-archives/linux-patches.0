Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC62253929;
	Mon, 12 May 2025 07:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747036028; cv=none; b=FrPyeUkFhpq9388DK6NCp4VwdrpMk1M3/rYUKjLxi7AnV7xwgTa5a8BKtlpzcP2thn5dq4VhOemvZHiRY6+v3sKX850SYq7sYH/JEMogxgEE0gvPwfzEpjs2WxwlIT8kMy4AhYPKephAVMQTNkDNwcbcRY/h11fF4pKpzKCO6/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747036028; c=relaxed/simple;
	bh=psmNOYtnv8pKbBB+YwR64a2qRy7BuUJnfYdP3LoWlLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cfHnQeIahH0z3qNgWODYe1eHe7nuR1dR0nT0qB5vRsGg9sN1Rgu2MTMhg5pglQlfOXGIwGWkUh0mXmMlnjNCtsqfbhGpfoKNCpt8JiNd356UCutqADX3NXTzY+ZglNGnmevQd1SUbW7X9LKIs7NVyBVr95qchlGokVGE7D21vKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGkwsk4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGkwsk4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D5EC4CEE7;
	Mon, 12 May 2025 07:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747036027;
	bh=psmNOYtnv8pKbBB+YwR64a2qRy7BuUJnfYdP3LoWlLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nGkwsk4Df5QM0cMW34rfTLRaZflrp7vnp2y93vrsJ2NUZu1VeNEwOC10SNhdF0+PW
	 KCO17KivRdceP11JmT50P9osJkMBz5SIvL+cVwQ+J6d+WnOIdaNPF+WZDcAzPwrv5v
	 xaWt0L3hc/jT0zVOOsNI/crUP4KsfyIr/KbrHeUsb3TkoVRSDA0hf1SYLnC2SFd2O7
	 Jb5HqacxB3rKMxJxUHVglxoUEyc7l4xrg5tJvR3j0p1gCXn8UkFqgCdWBKbkYMtVwP
	 SVEePStefzo0+TdyiW8atRTs69cwANz9nMDrSj1ei7x/i5on76fORuUZOA/rPxi7cp
	 VMAFwWdIZT9PQ==
Date: Mon, 12 May 2025 09:47:02 +0200
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
Subject: Re: [PATCH] rust: devres: fix doctest build under `!CONFIG_PCI`
Message-ID: <aCGndjmLQMXM76I3@pollux>
References: <20250511182533.1016163-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250511182533.1016163-1-ojeda@kernel.org>

On Sun, May 11, 2025 at 08:25:33PM +0200, Miguel Ojeda wrote:
> The doctest requires `CONFIG_PCI`:
> 
>     error[E0432]: unresolved import `kernel::pci`
>         --> rust/doctests_kernel_generated.rs:2689:44
>          |
>     2689 | use kernel::{device::Core, devres::Devres, pci};
>          |                                            ^^^ no `pci` in the root
>          |
>     note: found an item that was configured out
>         --> rust/kernel/lib.rs:96:9
>     note: the item is gated here
>         --> rust/kernel/lib.rs:95:1
> 
> Thus conditionally compile it (which still checks the syntax).
> 
> Fixes: f301cb978c06 ("rust: devres: implement Devres::access()")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Good catch!

Once we have the platform ioremap() abstractions [1], which are always built-in,
we should use those for the doctests. Maybe this could be a good first issue.

Applied to nova-next, thanks!

[1] https://lore.kernel.org/rust-for-linux/20250509-topics-tyr-platform_iomem-v8-3-e9f1725a40da@collabora.com/
