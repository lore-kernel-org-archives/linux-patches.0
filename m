Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294874F3EB0;
	Tue, 13 Oct 2026 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897017; cv=none; b=trYtaovmpLjJqZVkCD4YVvS2aXBO3ucQ5+skSncw2O3++WXeiGHSs5Nqs6xO+9PMT2bpajckVA+kMB1RMrRPVVYbViFLO4SasmqCx4Wc2GcxUASfkulNAi5GKkKka4hRWbchvTmliZkUsvKh6kUomQlhOOFunWlHsRs0/KGrYzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897017; c=relaxed/simple;
	bh=Gf641kOh0WXFymgy7KLoHMVvyyYWiYaF6+rtY5sLqLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru9t0/FjSkcj0LL5oSDANCD57shGli05zWf8jF5y57G7mIbGO6UycKW6x2jwbm5i6kW77DH5s9RBBt8zY74ewA4FPilO8a4l7rka8Zi94UwnM/srcUqUTBp0C5ka7w13GHhtV3XXFlkxZax2BfLvEyxsbHFvs5nFSAx52ju4JbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZbvNQOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZbvNQOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BD91F000FF;
	Tue, 13 Oct 2026 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791897015;
	bh=xafSNgNlPCR1jAlRze1jmczKR8dGeYr0eqPlPJNXft0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZbvNQOqtHBWUA4zJnMPG71mTaw0yoRXXbnCTiFyDxkGyJXtzxTfEdr3Ri4YNZrwi
	 hIcBvyOdvopQV1uT6FwGje1zmtpKNBTDM7e0CO7wadiQWH+3ayuTnAgUmv1kSZ5Hcw
	 mfyqbrX8ANdbnq/k7142jPn/RhJPG7DgirgpxT3+jPhsGEW0xBYjPTQDl2Fdm4pvsN
	 DZHd1Gq7BDYtQDXO7LM9AjcoLg8dZmeEdBhT3xPtO2Naajxb2zZYeL/c6HhDfykI4E
	 HH91aLzRpYI8DljormINEsnAURtJ30/nYv6SHfIGt3omRqRGn6/SzMKiJhnaB7PO0B
	 wucOAcCcPzFzg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev,
	pjw@kernel.org,
	samuel.holland@sifive.com,
	stable@vger.kernel.org,
	yongxuan.wang@sifive.com
Subject: Re: [PATCH 6.18 050/621] RISC-V: Clear HSTATUS.HU on CPU initialization
Date: Tue, 13 Oct 2026 15:10:08 +0200
Message-ID: <20261013131008.12815-1-ojeda@kernel.org>
In-Reply-To: <20261013112922.051225508@linuxfoundation.org>
References: <20261013112922.051225508@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 13:30:45 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me know.
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

Please see:

  https://lore.kernel.org/stable/20261013130551.12527-1-ojeda@kernel.org/

Cheers,
Miguel
