Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E297E390
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 03:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZnNubWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D650C433C7;
	Tue, 10 Oct 2023 03:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696908187;
	bh=kap+Rfsrx6FI8QCBde20mkzghb54YqCctHduIHD6tBA=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=WZnNubWqWby0EvPD3BI/yOe2UpEo+G71xkcZ67sx58OCB+4btLfI3QoEawakyIXub
	 SjCBRp5MFhLnWyEFIPSl9dWOi2pVR6QyWgnhLnIn3CEnXmsAT8bv8JPITN67sjRHCn
	 MdrjFWJLnJVq3XsDKIhAez3uhCs6DDAQXVNifNQgMSAGu+qJ68rTHavejRDeHfsWQw
	 ouGGWiJETOgLSJuk7bGKhgXSkuIg58TIiXZK3h4qWICFo+fy/5jiJh3/8JhanzUQ5T
	 NQtOafxcBM06RC9j457WEJ1Aomp2dTMuAK4nZpmF2Z/zhVp16XWQiZAh5tKOJodoeZ
	 MqclLrUNfKMkA==
Message-ID: <127bb741b6787c64e822bf7bc407926c.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230912175534.2427862-2-sboyd@kernel.org>
References: <20230912175534.2427862-1-sboyd@kernel.org> <20230912175534.2427862-2-sboyd@kernel.org>
Subject: Re: [PATCH 1/2] clk: Drive clk_leaf_mux_set_rate_parent test from clk_ops
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>, kernel test robot <yujie.liu@intel.com>, Maxime Ripard <mripard@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Mon, 09 Oct 2023 20:23:04 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-09-12 10:55:30)
> Running this kunit test with lockdep enabled leads to warning splats
> about calling clk provider APIs without the clk_prepare lock held.  I
> proposed adding a wrapper around these APIs to grab the prepare lock so
> we can call them from anywhere, and Maxime implemented that approach[1],
> but it didn't look great. That's because we had to make more kunit
> testing APIs just to call code from a place that isn't a clk provider
> when the prepare lock isn't held.
>=20
> Instead of doing that, let's implement a determine_rate clk_op for a new
> leaf clk that is the child of the existing leaf clk. We can call
> __clk_determine_rate() on the existing leaf clk from there, and stash
> away the clk_rate_request struct to check once the clk_op returns. Drive
> that clk_op by calling clk_round_rate() to keep things similar to how it
> was before (i.e. nothing actually changes rate, just the new rate is
> determined). This silences the warning by driving the test from a
> clk_op where we know the prepare lock is held.
>=20
> While looking at this in more detail, it was determined that the code we
> intended to test in commit 262ca38f4b6e ("clk: Stop forwarding
> clk_rate_requests to the parent") wasn't actually tested. The call to
> __clk_determine_rate() wasn't actually getting to the newly introduced
> code under the CLK_SET_RATE_PARENT if condition in
> clk_core_round_rate_nolock() because the parent clk (the mux) could
> round rates. We introduce a new leaf and make sure the parent of that
> clk has no clk_ops so that we can be certain that the
> CLK_SET_RATE_PARENT condition in clk_core_round_rate_nolock() is
> evaluated.
>=20
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/linux-clk/2b594e50-2bbf-4a2d-88e6-49fc39f=
3957a@roeck-us.net/
> Reported-by: kernel test robot <yujie.liu@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202301310919.b9d56ee3-yujie.liu@in=
tel.com
> Cc: Maxime Ripard <mripard@kernel.org>
> Link: https://lore.kernel.org/r/20230721-clk-fix-kunit-lockdep-v1-0-32cdb=
a4c8fc1@kernel.org [1]
> Fixes: 262ca38f4b6e ("clk: Stop forwarding clk_rate_requests to the paren=
t")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
