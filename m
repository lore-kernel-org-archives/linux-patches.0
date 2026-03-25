Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E124A35;
	Wed, 25 Mar 2026 00:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774397430; cv=none; b=l1S4Z6QRpKZ0ryqW5v0tk3hqPpuOnvqy1e7urZuOLnkqDvsZQgTN/Pjiyoy6C3WGnXYNeVzfPcHVpbZboqgjyEeoX/8GZZWTRU5yjo17PDSFj45bj9H7Bmp5jGo6jHt2BlY6+fGWdxP5morvQ67IyhsoSOhwsngqsAXugwcDGhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774397430; c=relaxed/simple;
	bh=2MH0l+RGRfozqdvfagheEQvFMGcGic8A0BgdV4t99B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7IM+43AviR2v4qfOUec5z6QWS7NS0F/AwvCYkvLec4V9b2kCFG821lkG+Ue7j6sypze+WTL4rMPJzkyE+9vK8U+v4LgCC8t2UzkEKxPSDTm/a6AQFjU4i2NGRSA0m3HnfoKvnlRaNnBlX+HXmBoSe4Gs4Hwb5/vXszrPBMy6Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSGfo3vQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSGfo3vQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72D4C19424;
	Wed, 25 Mar 2026 00:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774397429;
	bh=2MH0l+RGRfozqdvfagheEQvFMGcGic8A0BgdV4t99B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSGfo3vQpT0WJioRbmF3awAqgT1Lgmu3ECe3FnMS6oXkr0mSKN4mujpSbt2bB4mVW
	 V7Rna/rWmf/LEDXYn7H9onbU3q7Z0yUeF5diTUs9dPQttj7GbviOZt3CE7G59unqp2
	 4HeJSfkRLJ9XE/YglgbOl4IPELiHEdv0mhBqYsl1yf6IMxqJByPfaYVPw4tN4aGwSJ
	 O84X2VR12q9b05C2pqlexH6h+/6NO7Cqv16aeDnqdpHc/Qq0DMGIEEHDKyzuIrdLJD
	 Y0lqkcj4cyeKbUDn10xZIf6STYu+y/FYRY2BHt7F/q//4cbfpULwUrEWNSb5lo89EY
	 ksmL6zepJ52dQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: farbere@amazon.com,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org,
	tglx@linutronix.de,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: Re: [PATCH 6.12 017/460] kexec: Consolidate machine_kexec_mask_interrupts() implementation
Date: Wed, 25 Mar 2026 01:10:22 +0100
Message-ID: <20260325001022.57697-1-ojeda@kernel.org>
In-Reply-To: <20260323134527.084575420@linuxfoundation.org>
References: <20260323134527.084575420@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 14:40:13 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> 6.12-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Eliav Farber <farbere@amazon.com>
>
> [ Upstream commit bad6722e478f5b17a5ceb039dfb4c680cf2c0b48 ]
>
> Consolidate the machine_kexec_mask_interrupts implementation into a common
> function located in a new file: kernel/irq/kexec.c. This removes duplicate
> implementations from architecture-specific files in arch/arm, arch/arm64,
> arch/powerpc, and arch/riscv, reducing code duplication and improving
> maintainability.
>
> The new implementation retains architecture-specific behavior for
> CONFIG_GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD, which was previously implemented
> for ARM64. When enabled (currently for ARM64), it clears the active state
> of interrupts forwarded to virtual machines (VMs) before handling other
> interrupt masking operations.
>
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/all/20241204142003.32859-2-farbere@amazon.com
> Stable-dep-of: 20197b967a6a ("powerpc/kexec/core: use big-endian types for crash variables")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please see my note at:

  https://lore.kernel.org/stable/20260325000600.57287-1-ojeda@kernel.org/

I hope that helps!

Cc: Huacai Chen <chenhuacai@loongson.cn>,
Cc: Tianyang Zhang <zhangtianyang@loongson.cn>

Cheers,
Miguel
