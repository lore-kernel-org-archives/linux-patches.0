Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF83655CE;
	Tue, 12 May 2026 20:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778619191; cv=none; b=eRjnzGxm9N8VVw7uK85XOoNf9KGHdSEHHsHJaFYF1CGZZf0zNQgA2Xku9H96BI+0yyp6E86pPO0mgSy8pFjnJ1Co83oCTJP+x0vYuofqNYsoL+oBRS2k45dqyrluCfQz+FjKg4j+EeuirR8Jy3O5Ks/h8No1TQY5h4Rj5Mko5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778619191; c=relaxed/simple;
	bh=eKZnOJPC5HlN+wwGap3r99knl65QeE5KI0dZYEYrjF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJFuDcVGf+ARND0z+eOM1VlMGwFn4N9lxAYX+sZfe35hV+ie0J4wHicGqcrxB8KVdSifv1Q5Hk/GAL7efuFous0xghJj6b3/Pat1UpWEojkycX65LK4VT4tzRlvCNLMqh/BTSGnKKaJfi0NNYaso+q+u2qICOHCDm14BmTZyQr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnG1blq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnG1blq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA78C2BCB0;
	Tue, 12 May 2026 20:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778619191;
	bh=eKZnOJPC5HlN+wwGap3r99knl65QeE5KI0dZYEYrjF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnG1blq9ybJDVcDxjyOyzZjsYQJG/rOcELBKgDDsCgbMP2mt4Q4uuzdWZe0zR4IGq
	 outGioQjV9Ayvy/XfrNROoqC9c8FJRmgYtFn8TMTeL+KeF5NVje7QwXP7GO9SBCkIp
	 ldr+fDY+oya7fV444rGJX0T5msUCGcXNFTq3ie/Uz/MgF/vLU0sAnHIQFFHRL7RahS
	 fTBDnA27E9vhF3XPe2UJhcg99XZvZX14WgwWTk5ioEUGqSPd6mev2a7yLZ+I8KrP36
	 1uqXcV4sStz+OKydmF9MciaLcJVUMG7uBRl8ZnqIJzyL1jNhs4Z15O/YHlApwQ3TUJ
	 YWSBp2XWCcupg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	chenhuacai@loongson.cn,
	lixianglai@loongson.cn,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.18 091/270] LoongArch: KVM: Compile switch.S directly into the kernel
Date: Tue, 12 May 2026 22:52:50 +0200
Message-ID: <20260512205250.313933-1-ojeda@kernel.org>
In-Reply-To: <20260512173940.376401154@linuxfoundation.org>
References: <20260512173940.376401154@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 12 May 2026 19:38:12 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Xianglai Li <lixianglai@loongson.cn>
>
> commit 5203012fa6045aac4b69d4e7c212e16dcf38ef10 upstream.
>
> If we directly compile the switch.S file into the kernel, the address of
> the kvm_exc_entry function will definitely be within the DMW memory area.
> Therefore, we will no longer need to perform a copy relocation of the
> kvm_exc_entry.
>
> So this patch compiles switch.S directly into the kernel, and then remove
> the copy relocation execution logic for the kvm_exc_entry function.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For loongarch64, I am seeing a bunch of errors like:

    arch/loongarch/kvm/switch.S:201:1: error: unrecognized instruction mnemonic
    EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
    ^

`EXPORT_SYMBOL_FOR_KVM` does not exist in 6.18. Does this need a subset
of commit 6276c67f2bc4 ("x86: Restrict KVM-induced symbol exports to KVM
modules where obvious/possible")?

Cc'ing a few folks...

Thanks!

Cheers,
Miguel
