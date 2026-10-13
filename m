Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483E14FECF5;
	Tue, 13 Oct 2026 13:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896764; cv=none; b=kXlX88T3N6rnB1SRAaPfATE/CA+zPOwzE9xLSPY4RZV86N8JiZGivtfyVPkoT7+Qp6gDXugRRkOPnlk3KGmsnnoWqT0PxPUdcdndopsFLU+bKgw/HSXVLPyQW5b+K64mDzfd+PnuK5nbhpeRt46hPEd9f3Qn4SeQX2QN38TY10k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896764; c=relaxed/simple;
	bh=RgeY3SIYk0SFWnc72FC7m6TtI/Swc5PiyC3oxjpf3oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3m9os1VIMPCtQ+7RKO5jK52OFjrnbmqC+xjNJFVPBe60WF8+IbF7QaIVxOgOhmh5JIBZgZEq0TqzYyFStX7IqxCokmkjWQvFTE6ti+wAZ7xjnfOdpakrenQlaqA/nVSeoEUQredrIs9Log3Jj9UgXbLcsu1cTsr9hKTGFedQSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtVuTxt5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtVuTxt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F8E1F00898;
	Tue, 13 Oct 2026 13:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791896762;
	bh=PBDIE7GzvCgmpzvw/ZsA/sK1+J/NGCAntQXTexS8NNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtVuTxt5ErtMpkbGfGL1xLIGCDowIsKArOzts/S2GWDBpLTkyRokZua5XIMXtIyN8
	 joW/wMnxEDjwJ9Ql8CjM5dQ1hmqJCVRZdPrXeXIw8UAGd4Q/Ac5VnzFG0KRbzT6K0j
	 wBimQdDybAaZET/8ngiJ2W8MPVOlk4tL2F/GP6h3BY0+8KcwLLB9+2DPmnXtcNnf+0
	 wCEebhHPs6C/E6DwycpWYFa+I43PekwuhQadbpbXjHQS2GRO51zrwf3eJ7ikY7sEDc
	 gewbugUHTN2eT1YpuzoMfNMkytyFiUezZY4cS3IOWATp7/5XPTK7Pv2ZjnH6L5bQlQ
	 s0FnovQZYsipA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev,
	pjw@kernel.org,
	samuel.holland@sifive.com,
	stable@vger.kernel.org,
	yongxuan.wang@sifive.com,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH 7.2 046/281] RISC-V: Clear HSTATUS.HU on CPU initialization
Date: Tue, 13 Oct 2026 15:05:51 +0200
Message-ID: <20261013130551.12527-1-ojeda@kernel.org>
In-Reply-To: <20261013112856.169944981@linuxfoundation.org>
References: <20261013112856.169944981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 13:36:02 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> 7.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
>
> commit 6694612317e5225086e39ca1ba97ada2b1942e48 upstream.
>
> The RISC-V privileged specification does not mandate HSTATUS reset
> values, leaving the HU bit potentially set after hardware reset.
> When HU=1, hypervisor instructions (HLV/HLVX/HSV) can execute in
> U-mode to access guest memory, which may cause unintended behavior
> if not explicitly controlled.
>
> Clear HSTATUS.HU during CPU initialization to ensure hypervisor
> instructions are only available in HS-mode, preventing unexpected
> guest memory access from U-mode code.
>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> Link: https://patch.msgid.link/20260924-hstatus_hu-v2-1-7e970f5f1d8d@sifive.com
> Cc: stable@vger.kernel.org
> [pjw@kernel.org: capitalized RISCV_ISA_EXT_h to fix build; added stable cc]
> Signed-off-by: Paul Walmsley <pjw@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For riscv64, I am seeing:

    arch/riscv/kernel/cpufeature.c:1189:36: error: use of undeclared identifier 'RISCV_ISA_EXT_H'
    1189 |         if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_H))
         |                                           ^

It seems it is missing commit

  0c5a9ab5192b ("riscv: Standardize extension capitalization")

Either that or manually tweak the identifier to match 7.2.y.

6.18.y also breaks for the same reason.

I hope this helps!

Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-riscv@lists.infradead.org

Cheers,
Miguel
