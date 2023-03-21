Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE69210780
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E44AC43442;
	Tue, 21 Mar 2023 21:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679434800;
	bh=uOHbaqkHp18NjYzxD7288r4cACwXmG739ePMDopL+a8=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=W3doXz+C38Q7qylKKFZjQm0YjelEmcx2dV8x2q6g4xWbCsif21ywTqHBFzbEmRDOb
	 5RUsdp1jE7kWEBOF/IU/4VZALkqPUjXQ4244+MQ0q3S68KYFxaH9pZ2/Y108Fq517o
	 w+sJ61WsRBJgOP2S1mbP35pTousHZ7FRVT5/RAfHbBuh9xgF9/0Wp15S0jxT1HHI8M
	 KQ0KmbJLx/L3oDxrtp1e5OT8tCoxSJCthXIMmbQ9L30q2TiCN8cuVm0fRfh2jDqrVq
	 jIhEAgdzgwHVqqbe3SEKdhOjII6kFNIDmXSJ0B7Z+LE79lGp6hNCwTBpnPf+yilDz4
	 cCygueOSogM9g==
Message-ID: <915cd777043f8c240aac6f7e5588f060.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABVgOS=g6yvNg6xscZqa5fQdyWMEGJ0K9_86R3K7_Fa0wCM_VQ@mail.gmail.com>
References: <20230315183729.2376178-1-sboyd@kernel.org> <CABVgOS=g6yvNg6xscZqa5fQdyWMEGJ0K9_86R3K7_Fa0wCM_VQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] clk: Add kunit tests for fixed rate and parent data
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
To: David Gow <davidgow@google.com>
Date: Tue, 21 Mar 2023 14:39:58 -0700
User-Agent: alot/0.10

Quoting David Gow (2023-03-17 01:22:30)
> On Thu, 16 Mar 2023 at 02:37, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > This patch series adds unit tests for the clk fixed rate basic type and
> > the clk registration functions that use struct clk_parent_data. To get
> > there, we add support for loading device tree overlays onto the live DTB
> > along with probing platform drivers to bind to device nodes in the
> > overlays. With this series, we're able to exercise some of the code in
> > the common clk framework that uses devicetree lookups to find parents
> > and the fixed rate clk code that scans device tree directly and creates
> > clks. Please review.
> >
> > I Cced everyone to all the patches so they get the full context. I'm
> > hoping I can take the whole pile through the clk tree as they almost all
> > depend on each other.
> >
> > Changes from v1 (https://lore.kernel.org/r/20230302013822.1808711-1-sbo=
yd@kernel.org):
> >  * Don't depend on UML, use unittest data approach to attach nodes
> >  * Introduce overlay loading API for KUnit
> >  * Move platform_device KUnit code to drivers/base/test
> >  * Use #define macros for constants shared between unit tests and
> >    overlays
> >  * Settle on "test" as a vendor prefix
> >  * Make KUnit wrappers have "_kunit" postfix
> >
>=20
>=20
> Thanks! I like this much better, and it is working fine here under UML
> and x86_64.
>=20
> There are some issues with other architectures (mostly endianness
> problems, but I got a refcount underflow in kunit_remove_resource
> after platform_device_alloc_kunit_test on sparc64 as well), but
> otherwise it's working on most of the things I've tried.

I see the undercount as well. I believe the problem is that we need to
not call platform_device_put() after the platform device is added to the
bus with platform_device_add(). I think I need to make the
platform_device_add_kunit() function find the resource allocated in
platform_device_alloc_kunit() and remove it. The
kunit_destroy_resource() API still calls the free function though? So I
need a kunit_nuke_resource() API that unlinks and doesn't call the free
function. Or I can modify the resource free function to call the
platform_device_unregister() function once it is added. Or I can call
get_device() one more time to balance in the platform_device_add_kunit()
wrapper.

Either way, calling platform_device_put() is really only supposed to be
done in error cases, so calling it from the kunit resource wrapper is
sorta wrong.
