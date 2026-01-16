Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1517F281341;
	Fri, 16 Jan 2026 05:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768540216; cv=none; b=vBJF8TtRLgFpZTMv5jAb1ty/OpGpV21yx+8HcFaS+/7iSThPSIwBqkA8tA9+1wXapHLE4FjlRIMc/wLcm9xgUwwyIk39iM4sWxNx2LwXE7Vw/3Gr21Elhx+hsI+FGkxVPGtjme8mGRI+x89tDzwCYoCbv3qQy+e5gtXs04kVNuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768540216; c=relaxed/simple;
	bh=HZzHW7YHZPFUQKO1dKDsA0Pg/kpBIfBQhMpeukAM8II=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxoUXfJKKKZn9jNadoDL6r+ifC1cKIW7RAp+YtgWCOgSJpID8uQfS5Xj2ErPeKOLplNtK5l1uCnHj2mdPu2dUzbB8UqVR2sS4MvBi605IJkHF9hFPC8X2S9b+XI/jR5khJm+N32OUxdLMJOM1Xg9fU9lisbgdSHCq1tdbJddD5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Het7nqji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Het7nqji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EFDC116C6;
	Fri, 16 Jan 2026 05:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768540215;
	bh=HZzHW7YHZPFUQKO1dKDsA0Pg/kpBIfBQhMpeukAM8II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Het7nqjiBCR4dN8g3EHFcpM9lAzrF60K0/j1XIY6YjUPMhPtRmD6t5xGxbngzHAV2
	 /RMwlWIc2Y6ZymJ73u4Lv3IaFocowX+CRqTyOkx8+Q52QoK1AN1tKprDXos4BXBH5S
	 rEmmXD5qf3HeTNQfgCn3o6gioZzNbEGkcJk4PsqlB53DAzVe1eB3Q25dEVDFqUX7bc
	 dfHhhuuqzXSxjvegYtSkfxiY5g2ZC11GXt4YimMK3vJiuOVlCYteH41RevpMgWvvba
	 m1DXZ5QT52HlbQX3zkfjbSwuczYwQ8wCRRzDPTJrb+BQEXiPSnI1airiKQbzelXmEc
	 14Cef03trdThA==
Date: Thu, 15 Jan 2026 22:10:11 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Paul Walmsley <pjw@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Palmer Dabbelt <palmer@dabbelt.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Craig Topper <craig.topper@sifive.com>,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH RFC v2] riscv: Use 64-bit variable for output in
 __get_user_asm
Message-ID: <20260116051011.GB1452322@ax162>
References: <20260113-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v2-1-e04aba2e1f9f@kernel.org>
 <7bc39d4d-6e2d-f0af-9787-5fd2c92bfd4e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc39d4d-6e2d-f0af-9787-5fd2c92bfd4e@kernel.org>

On Wed, Jan 14, 2026 at 06:02:46PM -0700, Paul Walmsley wrote:
> I'm assuming this would be a temporary patch, and that we might be able to 
> remove it at some point (years, I guess?)

Yes, ideally this would be short lived but unfortunately, I am not
really sure what the plan to fix this on the LLVM side is :/ Maybe Craig
or Bill can comment on that.

> Might be worth adding a comment in the code to explain why a temporary 
> variable is needed.

I will insert:

/*
 * Use a temporary variable for the output of the asm goto to avoid a
 * triggering an LLVM assertion due to sign extending the output when
 * it is used in function calls:
 * https://github.com/llvm/llvm-project/issues/143795
 */

I will send v3 either tomorrow or Monday.

Cheers,
Nathan
