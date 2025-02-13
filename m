Received: from r-passerv.ralfj.de (r-passerv.ralfj.de [109.230.236.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F521AAA29
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.230.236.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461593; cv=none; b=j0JSfnvGljvmB26vestNqT4FEzqzdAxPNHjN+UyXzQal73dlBM1reqn9fMV4D3b5MUPA33KxiLS5qbvyt+WZ+bcbh2MdREbvX0OdsY70FMbonUI45PCxyxwrnqbELrcnz5FEYZXMVpx9zjL4yzMLtY+oxCfFc+bjyI3+mqZolTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461593; c=relaxed/simple;
	bh=eQ5hKL8Do7QTUquhfPYnl9WT+Oj8r0LEBJJf4Dgm8XE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gNitZnTZpGeULxzEzWVs6eB1kILpcibGJan1c15vWjn7dEqtobiD+MwlPkcctVpQficSc0k+pmdm2LWwqpEsRL/Gwv9Mi5cgUAQ6ERhgyMr1YuNoludkblEMKX5/9vwwciL2mM+ua/weDm1iO+vuYhmSQZbucFBxwj0+ZWP8dLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ralfj.de; spf=pass smtp.mailfrom=ralfj.de; dkim=pass (1024-bit key) header.d=ralfj.de header.i=@ralfj.de header.b=0kwRNqV6; arc=none smtp.client-ip=109.230.236.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ralfj.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ralfj.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ralfj.de header.i=@ralfj.de header.b="0kwRNqV6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ralfj.de; s=mail;
	t=1739461584; bh=eQ5hKL8Do7QTUquhfPYnl9WT+Oj8r0LEBJJf4Dgm8XE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=0kwRNqV6/VTFUT91g8IVWD+PE8xZ3DtpuOWqmBqqx6r467v1iZBtf1ABglQ7QUI0b
	 NFTt9gWq/HEYAE83AvSePXmbph3ufFjUqooOv3/+jTDqa3wkBf86JWYHx4uVB+MKuQ
	 uHsGyclvb41/uqXepDW74cr8FITn4VcIiEdFK9DY=
Received: from [10.21.49.97] (unknown [195.176.44.46])
	by r-passerv.ralfj.de (Postfix) with ESMTPSA id 013482052A91;
	Thu, 13 Feb 2025 16:46:23 +0100 (CET)
Message-ID: <9430b26a-8b2b-4ad8-b6b0-402871f2a977@ralfj.de>
Date: Thu, 13 Feb 2025 16:46:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat
 target
To: Ard Biesheuvel <ardb@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 stable@vger.kernel.org, Matthew Maurer <mmaurer@google.com>,
 Jubilee Young <workingjubilee@gmail.com>
References: <20250210163732.281786-1-ojeda@kernel.org>
 <CAMj1kXHgjwHkLsJkM3H2pjEPXDvD80V+XhH_Gsjv8N4Cf6Bvkw@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralf Jung <post@ralfj.de>
In-Reply-To: <CAMj1kXHgjwHkLsJkM3H2pjEPXDvD80V+XhH_Gsjv8N4Cf6Bvkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

> We have to carefully make the distinction here between codegen and ABI.
> 
> The arm64 C code in the kernel is built with -mgeneral-regs-only
> because FP/SIMD registers are not preserved/restored like GPRs, and so
> they must be used only in carefully controlled circumstances, i.e., in
> assembler code called under kernel_neon_begin()/kernel_neon_end()
> [modulo some exceptions related to NEON intrinsics]
> 
> This does not impact the ABI, which remains hard-float [this was the
> only arm64 calling convention that existed until about a year ago].
> Any function that takes or returns floats or doubles (or NEON
> intrinsic types) is simply rejected by the compiler.

That's how C works. It is not how Rust works. Rust does not reject using floats 
ever. Instead, Rust offers softfloat targets where you can still use floats, but 
it won't use float registers. Obviously, that needs to use a different ABI.
As you said, aarch64 does not have an official softfloat ABI, but LLVM 
implements a de-facto softfloat ABI if you ask it to generate functions that 
take/return float types while disabling the relevant target features. (Maybe 
LLVM should just refuse to generate such code, and then Rust may have ended up 
with a different design. But now this would all be quite tricky to change.)

> Changing this to softfloat for Rust modifies this calling convention,
> i.e., it will result in floats and doubles being accepted as function
> parameters and return values, but there is no code in the kernel that
> actually supports/implements that.

As explained above, f32/f64 were already accepted as function parameters and 
return values in Rust code before this change. So this patch does not change 
anything here. (In fact, the ABI used for these functions should be exactly the 
same before and after this patch.)

> Also, it should be clarified
> whether using a softfloat ABI permits the compiler to use FP/SIMD
> registers in codegen. We might still need -Ctarget-feature="-neon"
> here afaict.

Rust's softfloat targets do not use FP/SIMD registers by default. Ideally these 
targets allow selectively using FP/SIMD registers within certain functions; for 
aarch64, this is not properly supported by LLVM and therefore Rust.

> Ideally, we'd have a target/target-feature combo that makes this more
> explicit: no FP/SIMD codegen at all, without affecting the ABI,
> therefore making float/double types in function prototypes illegal.
> AIUI, this change does something different.

Having targets without float support would be a significant departure from past 
language decisions in Rust -- that doesn't mean it's impossible, but it would 
require a non-trivial effort (starting with an RFC to lay down the motivation 
and design).

Kind regards,
Ralf


