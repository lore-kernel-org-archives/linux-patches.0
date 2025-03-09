Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09DA1B2EF2;
	Sun,  9 Mar 2025 09:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513868; cv=none; b=p3CYcsJ5u+0oJeVLmjabh0UCW+MoMg5P4stQuu9GgaKEkLYpvtx4RfGLEyH6G3UIxD1tYz/WgvW4wFzrdqFPvcJr5VMJAIp3pdUafvJ8dm/Dy3qtPWq8AH2Xs1E1oiEec5ZD8zJiTaO7Ymdb3zSJ/pvysxEohivg9ultsAY96zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513868; c=relaxed/simple;
	bh=jbft38EME4Lb1rB4rI1Ryh26bE9ZQkn0FcVHmId6jlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AaoCC0z4l2NF7F9SwU7l4zNTGE2ynwqLTkKyGPPHAGn0PbiUTrkl5tirqHB2tXUpQvROhDCSX9TEgYN5oXlM4ahLLpJLf4TZT+n8TT588Hb79flqVf/bdrjvBTR9nMPDaQqUJ3MSPCqhN93J4J147kYpH7vJUkddgo+epvCQSOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJi6tOh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJi6tOh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464D0C4CEE5;
	Sun,  9 Mar 2025 09:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513868;
	bh=jbft38EME4Lb1rB4rI1Ryh26bE9ZQkn0FcVHmId6jlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJi6tOh0vtc4k5zThT+C+SjiYtfJH7odPrNFkagTboAhPHh2fH/CC20rDx7N1efEV
	 FHnQYHwc8RkvONi7Aq4vrWKcpU9dqRcGUU3Vv3g7cHG5JJOSBzmkqbGqN/rRxO+0Tu
	 yb+oKv/PQgX/vCtsujQ3ovvu5DfLZ9lKmUEVgD3I=
Date: Sun, 9 Mar 2025 10:47:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev
Subject: Re: [PATCH 6.12.y 00/60] `alloc`, `#[expect]` and "Custom FFI"
Message-ID: <2025030918-enzyme-conch-b489@gregkh>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>

On Fri, Mar 07, 2025 at 11:49:07PM +0100, Miguel Ojeda wrote:
> Hi Greg, Sasha,
> 
> Please consider this series for 6.12.y. It should apply cleanly on top
> of v6.12.18.
> 
> These are the patches to backport the `alloc` series for Rust, which
> will be useful for Rust Android Binder and others. It also means that,
> with this applied, we will not rely on the standard library `alloc` (and
> the unstable `cfg` option we used) anymore in any stable kernel that
> supports several Rust versions, so e.g. upstream Rust could consider
> removing that `cfg` if they needed.
> 
> The entire series of cherry-picks apply almost cleanly (only 2 trivial
> conflicts) -- to achieve that, I included the `#[expect]` support, which
> will make future backports that use that feature easier anyway. That
> series also enabled some Clippy warnings. We could reduce the series,
> but the end result is warning-free and Clippy is opt-in anyway.
> Out-of-tree code could, of course, see some warnings if they use it.
> 
> I also included a bunch of Clippy warnings cleanups for the DRM QR Code
> to have this series clean up to Rust 1.85.0 (the latest stable), but
> I could send them separately if needed.
> 
> Finally, I included the "Custom FFI" series backport, which in turn
> solves the arm64 + Rust 1.85.0 + `CONFIG_RUST_FW_LOADER_ABSTRACTIONS=y`
> issue. It will also make future patches easier to backport, since we
> will have the same `ffi::` types.
> 
> I tested that the entire series builds between every commit for x86_64
> `LLVM=1` with the latest stable and minimum supported Rust compiler
> versions. I also ran my usual stable kernel tests on the end result;
> that is, boot-tested in QEMU for several architectures etc. In v6.12.18
> for loongarch there is an unrelated error that was not there in v6.12.17
> when I did a previous test run -- reported separately.
> 
> Things could still break, so extra tests on the next -rc from users in
> Cc here would be welcome -- thanks!

All queued up now, thanks!

greg k-h
