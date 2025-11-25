Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D310D2264A9;
	Tue, 25 Nov 2025 21:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764105921; cv=none; b=Vm/iaQyZpjmf8MEC8MrJ5bFltya8dMbmurdmXpGQTJ1KyASl9CzTdAVDijH7Bc93k2z12WBBad8rXqob6gPTzdOOI7keMKlsU8fbVnfXja14THRNZktmFDWVj5l7jcdlcXRMizI0D79K3+iGtvNFzgjJTZYJu24cAsfcc63GHPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764105921; c=relaxed/simple;
	bh=/5/8CnucXexqxcmHU/UtJRHL8WYNxyE9z/az71jfwjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYqXJFPdQmSxHFcKG29Z/gKOq+dZFvVaOSn03Thr2DihexzPGHCn6/ME+sTF3VoZ9i4wLPV49p5HVDJILqrMqYY+QK6ODSG5Zb/mwmToV3WBjCYDzwXXC+NBf+D4w8QdMCTmf9+dPengGONSXvY/mAJVnTZ4uJWaP2GpZ7fwebY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pVvzVe4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pVvzVe4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392A0C4CEF1;
	Tue, 25 Nov 2025 21:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764105921;
	bh=/5/8CnucXexqxcmHU/UtJRHL8WYNxyE9z/az71jfwjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pVvzVe4HPqXuvwssOnpPmVG0irI/Jdi1mn5r2geRo5gtQEjRqzhW3TLBTQfOH6paK
	 oZ+qjn2P84b03j1GMfiFz4EOqVcxA/zGHIA06BBPnMm72ZX1pmiDbjDn5HV8IHmsbx
	 kAW5nInjZZFQfcGCA2o1ZiAvZpKT0F1lVj/MBVO3MSTi2rBnAv8mGnKWe9XFfvmKxx
	 ybHh0EE3f2zM1/r4GXCnGbzt2LkbRnHch1Z1JS7zR+9+lALudMAUOAUX7XGiSJ8dEp
	 zQpnB562Lj3o1muXZd/v3SRxOBToVjmC6oUAsqnmvc9+Jt9ldX67/kl7rR8vbuWB5O
	 mrWviyyOjZwjw==
Date: Tue, 25 Nov 2025 13:25:19 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Add break to default case in
 kvm_pgtable_stage2_pte_prot()
Message-ID: <aSYev0IqSATKAEau@kernel.org>
References: <20251125-arm64-kvm-hyp-pgtable-fix-c23-ext-warn-v1-1-98b506ddefbf@kernel.org>
 <87ecplgapz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecplgapz.wl-maz@kernel.org>

On Tue, Nov 25, 2025 at 07:42:48PM +0000, Marc Zyngier wrote:
> On Tue, 25 Nov 2025 17:59:15 +0000,
> Nathan Chancellor <nathan@kernel.org> wrote:
> > 
> > Clang warns (or errors with CONFIG_WERROR=y / W=e):
> > 
> >   arch/arm64/kvm/hyp/pgtable.c:757:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
> >     757 |         }
> >         |         ^
> > 
> > With older versions of clang (15 and older) and GCC (at least the minimum
> > supported, 8.1), this is an unconditional hard error:
> > 
> >   arch/arm64/kvm/hyp/pgtable.c: In function 'kvm_pgtable_stage2_pte_prot':
> >   arch/arm64/kvm/hyp/pgtable.c:756:2: error: label at end of compound statement
> >     default:
> >     ^~~~~~~
> > 
> >   arch/arm64/kvm/hyp/pgtable.c:756:10: error: label at end of compound statement: expected statement
> >           default:
> >                   ^
> >                    ;
> > 
> > Add a break statement to this default case to clear up the error/warning.
> > 
> > Fixes: 2608563b466b ("KVM: arm64: Add support for FEAT_XNX stage-2 permissions")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Thank you both for addressing the pile-up of issues I managed to
introduce :) Online now, will apply in just a moment.

Thanks,
Oliver
