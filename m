Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E22B635;
	Tue, 30 Apr 2024 00:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714435495; cv=none; b=JeveGRqrht/2A+w9yT+ykIf9Fxy09O0KkAnNH7V9zCbAhGf3yJ/xcqny3JcYV4uyw+ZtVtq6SKjYWU8sZP7xIgislc7B0E1wbGF9kSahIJCsJbwh1PHGIMzhnOgS2jMerWMq9o3JS62bBpHocwUO4viDvZAcWOMain9MHBBoibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714435495; c=relaxed/simple;
	bh=DumFO5WXPtmjUDTFNgIZT/Yv6qbcW3CwCTQCCDpM3rU=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=TrBLgiWfhPZhiaXBJKncJFdJBMnSXEdb0snyjU+W9HVX1sx/BhbnOmq1udQS1GdsN7P2eWLlYA0YDiKVo0ZvJ4nczcTvKe2hGohm9uMtoUms0GqmvX3aN4DUiwEyIH0CR8xQpTBwnTh70mNA4xLnH7VYC0qCkfIbFgHSqr8+15w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXUpDCsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXUpDCsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55CBC116B1;
	Tue, 30 Apr 2024 00:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714435494;
	bh=DumFO5WXPtmjUDTFNgIZT/Yv6qbcW3CwCTQCCDpM3rU=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=VXUpDCsltm4bgnvWT94Gurvd8gNGKGVQOBcde1+KLzieU+7jT4LmJkIHMkTz39R8l
	 gkJdnWSJ/f4JR0pWssFE0134TCUMKkGdPaS3gb3yxYc2qiwU2JmUUEVqeree8DSkWg
	 DhV0E/PFtEubGpdGbsjb/TALuq0uFyROhcS9hhiITojyN+7nOm/Cwj/5ucx8YPx49s
	 +Tku+UisUJHa3vG7OW8p/WsdKoB8cGiU0/EmKhzL7A1YeDpbsB04GN9bmSLcbT4fE/
	 q/Y/5SbOEOQxp3/Xw5Tab/KsjKGCUp9V48/KVqulXfA0lslJ1lZhVBzKozhjD23Rg+
	 rj/3YT6LMvGwg==
Message-ID: <aa54224be3d2567fdb657e304c46c5b9.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-2-e2db3b82d5ef@kernel.org>
References: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org> <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-2-e2db3b82d5ef@kernel.org>
Subject: Re: [PATCH 2/2] clk: bcm: rpi: Assign ->num before accessing ->hws
From: Stephen Boyd <sboyd@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Gustavo A. R. Silva <gustavoars@kernel.org>, bcm-kernel-feedback-list@broadcom.com, linux-clk@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org, patches@lists.linux.dev, llvm@lists.linux.dev, stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>, Michael Turquette <mturquette@baylibre.com>, Nathan Chancellor <nathan@kernel.org>
Date: Mon, 29 Apr 2024 17:04:52 -0700
User-Agent: alot/0.10

Quoting Nathan Chancellor (2024-04-25 09:55:52)
> Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
> __counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
> with __counted_by, which informs the bounds sanitizer about the number
> of elements in hws, so that it can warn when hws is accessed out of
> bounds. As noted in that change, the __counted_by member must be
> initialized with the number of elements before the first array access
> happens, otherwise there will be a warning from each access prior to the
> initialization because the number of elements is zero. This occurs in
> raspberrypi_discover_clocks() due to ->num being assigned after ->hws
> has been accessed:
>=20
>   UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-raspberrypi.c:3=
74:4
>   index 3 is out of range for type 'struct clk_hw *[] __counted_by(num)' =
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
