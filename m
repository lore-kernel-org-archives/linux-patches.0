Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD52FB612;
	Mon, 25 Aug 2025 14:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756132338; cv=none; b=H3VsLOiphIZytEgDa7GbF2uO1Vh4WQd1HwnW3jopU3TAl9OVepDGf7isg18iAmGKR39/xQ8lUEx6t3ozBfM4q9rTqg56o3qS19b9ZtgSAVhyiAaXN9kDEuN365JaIP40p3gIYvi65XtlFhvaRoO8OGOtKUElQc+X8yQdoaBb4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756132338; c=relaxed/simple;
	bh=CejHFcCg/LceUsBinXTS0yUNDRyULV0yXMik1KYc3wI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Gj5pFw5ivUo2seNKB5VeTQ3A6PmtzHqWokC4pdbp6JPkKNJmrJQxdQ/XBwI3LSp93R8euol6HA24XyJjf2WPyeSDhu9S1GvkSDS/xwsz4fi5gkj+ZIzsauyCKYS1li6/q7RXObudzWxfm9ll9U5kx5sjeBvNZVl7ZWj+WFHHykY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mi1ZBg76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mi1ZBg76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AFEC4CEED;
	Mon, 25 Aug 2025 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756132337;
	bh=CejHFcCg/LceUsBinXTS0yUNDRyULV0yXMik1KYc3wI=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=Mi1ZBg76BnCpTIJKzcwRhlWqHfGjH8eO/CxJSUTZQgVuTvHx6vc4kmZn+p7yyC52d
	 iaRBRnmceMHsJvk9QwxZA9rL5bsRuGpq9T3MClPIhynv0Y/nY52E4N4PcES3wKvIVg
	 ErI9xuDteuK810aB6fODg8LCxtV44fBJ0FSHJmQ5O2K+jxvtAjd8yBTEw/TNkW7Q83
	 o1+FxQcEJ13fHbZoD5nUna85KSy9C9RqVD2C90qaRHGc1JXNHlyXEbisv5shWGGcFR
	 oU+GaVtxfcuTpahV9X48X6hh0OejyVbASPCKRuSDfRSgPVmCLwZlr9FwX+Gvwq3XWo
	 xV5PUisYjMwGQ==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 Aug 2025 16:32:12 +0200
Message-Id: <DCBKYG65XMBV.1E287MARVTUP2@kernel.org>
Subject: Re: [PATCH] rust: alloc: remove `allocator_test`
Cc: "Alex Gaynor" <alex.gaynor@gmail.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R .
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <rust-for-linux@vger.kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250816211900.2731720-1-ojeda@kernel.org>
In-Reply-To: <20250816211900.2731720-1-ojeda@kernel.org>

On Sat Aug 16, 2025 at 11:19 PM CEST, Miguel Ojeda wrote:
> Given we do not have tests that rely on it anymore, remove
> `allocator_test`, which simplifies the complexity of the build.
>
> In particular, it avoids potential issues with `rusttest`, such as the
> one fixed at [1], where a public function was added to `Kmalloc` and
> used elsewhere, but it was not added to `Cmalloc`; or trivial issues
> like a missing import [2] due to not many people testing that target.
>
> The only downside is that we cannot use it in the `macros`' crate
> examples anymore, but we did not feel a need for that so far, and anyway
> we could support that by running those within the kernel too, which we
> may do regardless.
>
> Link: https://lore.kernel.org/rust-for-linux/20250816204215.2719559-1-oje=
da@kernel.org/ [1]
> Link: https://lore.kernel.org/rust-for-linux/20250816210214.2729269-1-oje=
da@kernel.org/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to alloc-next, thanks!
