Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F65161;
	Tue, 30 Apr 2024 00:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714435480; cv=none; b=ChJZAvbkOpymTlqBxHAQQ7yk97os2GAEngTVhdmUft3zFWc7DLU7m7/kXMCDGnWWxPNEMCBljDYm7p+GCGyB1cQKHpBfQW1wS8E3XYW2ASAMuFo+NXhRG3Hn3ylCUe49Rf8PIGw1vF29UVpsfZ6V3duBnwbg2t69bnxNK7iRFXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714435480; c=relaxed/simple;
	bh=GjF585A07WLRSmFByqx2QGzcXnlbaXpuxWaDW/GAdTk=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=RsGNq4owXDIQT5CAsK6UsPMib19w36mpUCiMtHJMIbzQPvb72rHYLBZumgNPsbupH1ebDCv3E17XNe3yYpq+HnkWAfmcrTw0zQ+Td76MFevb2cCzl9DF3CHUy5wHMqC0R5HLdBpB2ZzPk8dsoe4OYS7nuMp3PHRuVXqM2fg6tbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECnO2WuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECnO2WuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBB5C113CD;
	Tue, 30 Apr 2024 00:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714435480;
	bh=GjF585A07WLRSmFByqx2QGzcXnlbaXpuxWaDW/GAdTk=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=ECnO2WuGKFYNALJk4sMtwyo0AqDmnYReBr4XRCtpP+iJJVutqsk+7cR3IiaYPi4i5
	 f0BFqtfTR2MgBmSxBhsuCnI1u4IIam2OrSP81cO9Aey7bGKmwnYzINimmH+k2EAZ/A
	 MKndRoZv/zxZhgPMnlkialUVwKTjUJSYfnuvC9Kd1MytqlYUVilqPoQL0rvcvLkYgl
	 oo41ZcfPBZ21G0YplGjlXtJlQVbjlxXRTwlA8kFuigG2dsebutbkj2w7JQMVDWuZL/
	 8vQ5XBk62p/4VMCsF4fqv0GWDiWu2giTbRKJvarwGbv81ncJ9A1jwzxgQtLP/xr69t
	 JXdqugmLV5ovQ==
Message-ID: <38cfd1c4b7297515539bd2c91b3bf541.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-1-e2db3b82d5ef@kernel.org>
References: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org> <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-1-e2db3b82d5ef@kernel.org>
Subject: Re: [PATCH 1/2] clk: bcm: dvp: Assign ->num before accessing ->hws
From: Stephen Boyd <sboyd@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Gustavo A. R. Silva <gustavoars@kernel.org>, bcm-kernel-feedback-list@broadcom.com, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org, patches@lists.linux.dev, llvm@lists.linux.dev, stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>, Michael Turquette <mturquette@baylibre.com>, Nathan Chancellor <nathan@kernel.org>
Date: Mon, 29 Apr 2024 17:04:37 -0700
User-Agent: alot/0.10

Quoting Nathan Chancellor (2024-04-25 09:55:51)
> Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
> __counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
> with __counted_by, which informs the bounds sanitizer about the number
> of elements in hws, so that it can warn when hws is accessed out of
> bounds. As noted in that change, the __counted_by member must be
> initialized with the number of elements before the first array access
> happens, otherwise there will be a warning from each access prior to the
> initialization because the number of elements is zero. This occurs in
> clk_dvp_probe() due to ->num being assigned after ->hws has been
> accessed:
>=20
>   UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-bcm2711-dvp.c:5=
9:2
>   index 0 is out of range for type 'struct clk_hw *[] __counted_by(num)' =
(aka 'struct clk_hw *[]')
>=20
> Move the ->num initialization to before the first access of ->hws, which
> clears up the warning.
>=20
> Cc: stable@vger.kernel.org
> Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __cou=
nted_by")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Applied to clk-next
