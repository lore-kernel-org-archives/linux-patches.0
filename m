Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113342F32
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CB6C433D2;
	Fri, 10 Mar 2023 23:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678490489;
	bh=Npny9ESbzIr4YnzQ03Gj3yQ775wdrfEdkosmTVaC0Uw=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=EIVro1bu+N3OK/q5OEERqChLs25DFQCNhj78gEv8fI8l0BIBByNN1mFCkamda+yhK
	 dLzFUW1UtR1ojJGlSZ4KsUPueDd1wbdRhqx985fisdjBgM8vr3X/eZg4XtNEcPa7/G
	 gZ4Pfo28UVWrqvEoYmaZ8Yey6Ov1Yf97tR29NPBKMjvs4sXT+Ejjny2BSX70iqYPDC
	 RsYZHJnXfbcHlRJu+KoxkLjBDTSkBh/LwZAFdnefQiBHdrp0DSgA4FlJ9G9yNnnNAS
	 N2fq1RI9yFhA4SV8nIuKaaIAKfCy06anbGm3vWJi/WmQrzdwblSGslTTdLBkdgoZ5I
	 0WzTNMHlXfhWA==
Message-ID: <77b315f6b89eb256c516ee08b1c17312.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABVgOSkahumU6T+rCVx+k7Y9=iMszveseVYE0wfKjXwkNJpFxQ@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-5-sboyd@kernel.org> <CABVgOSkahumU6T+rCVx+k7Y9=iMszveseVYE0wfKjXwkNJpFxQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] clk: Add test managed clk provider/consumer APIs
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>
Date: Fri, 10 Mar 2023 15:21:27 -0800
User-Agent: alot/0.10

Quoting David Gow (2023-03-02 23:15:35)
> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > Unit tests are more ergonomic and simpler to understand if they don't
> > have to hoist a bunch of code into the test harness init and exit
> > functions. Add some test managed wrappers for the clk APIs so that clk
> > unit tests can write more code in the actual test and less code in the
> > harness.
> >
> > Only add APIs that are used for now. More wrappers can be added in the
> > future as necessary.
> >
> > Cc: Brendan Higgins <brendan.higgins@linux.dev>
> > Cc: David Gow <davidgow@google.com>
> > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > ---
>=20
> Looks good, modulo bikeshedding below.

Cool!

> >
> > diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> > index e3ca0d058a25..7efce649b0d3 100644
> > --- a/drivers/clk/Makefile
> > +++ b/drivers/clk/Makefile
> > @@ -17,6 +17,11 @@ ifeq ($(CONFIG_OF), y)
> >  obj-$(CONFIG_COMMON_CLK)       +=3D clk-conf.o
> >  endif
> >
> > +# KUnit specific helpers
> > +ifeq ($(CONFIG_COMMON_CLK), y)
> > +obj-$(CONFIG_KUNIT)            +=3D clk-kunit.o
>=20
> Do we want to compile these in whenever KUnit is enabled, or only when
> we're building clk tests specifically? I suspect this would be served
> better by being under a CLK_KUNIT config option, which all of the
> tests then depend on. (Whether that's the existing
> CONFIG_CLK_KUNIT_TEST, and all of the clk tests live under the same
> config option, or a separate parent option would be up to you).

I was thinking of building it in with whatever mode CONFIG_KUNIT is
built as. If this is a module because CONFIG_KUNIT=3Dm, then unit tests
would depend on that, and this would be a module as well. modprobe would
know that some unit test module depends on symbols provided by
clk-kunit.ko and thus load clk-kunit.ko first.

>=20
> Equally, this could be a bit interesting if CONFIG_KUNIT=3Dm. Given
> CONFIG_COMMON_CLK=3Dy, this would end up as a clk-kunit module, no?

Yes, that is the intent.

>=20
> > +endif
> > +
> >  # hardware specific clock types
> >  # please keep this section sorted lexicographically by file path name
> >  obj-$(CONFIG_COMMON_CLK_APPLE_NCO)     +=3D clk-apple-nco.o
> > diff --git a/drivers/clk/clk-kunit.c b/drivers/clk/clk-kunit.c
> > new file mode 100644
> > index 000000000000..78d85b3a7a4a
> > --- /dev/null
> > +++ b/drivers/clk/clk-kunit.c
> > @@ -0,0 +1,204 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * KUnit helpers for clk tests
> > + */
> > +#include <linux/clk.h>
> > +#include <linux/clk-provider.h>
> > +#include <linux/err.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +
> > +#include <kunit/resource.h>
> > +
> > +#include "clk-kunit.h"
> > +
> > +static void kunit_clk_disable_unprepare(struct kunit_resource *res)
>=20
> We need to decide on the naming scheme of these, and in particular if
> they should be kunit_clk or clk_kunit (or something else).
>=20
> I'd lean to clk_kunit, if only to match DRM's KUnit helpers being
> drm_kunit_helper better, and so that these are more tightly bound to
> the subsystem being tested.
> (i.e., so I don't have to scroll through every subsystem's helpers
> when autocompleting kunit_).

Ok, got it. I was trying to match kunit_kzalloc() style. It makes it
easy to slap the 'kunit_' prefix on existing auto-completed function
names like kzalloc() or clk_prepare_enable().

I wasn't aware of drm_kunit_helper. That's a mouthful! We don't call it
slab_kunit_helper_kzalloc(). Maybe to satisfy all conditions it should
be:

	clk_prepare_enable_kunit()

so that kunit_ autocomplete doesn't have a big scroll list, and clk
subsystem autocompletes, and we know it is kunit specific.
