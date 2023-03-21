Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D89D311
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 18:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA39C433EF;
	Tue, 21 Mar 2023 18:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679423088;
	bh=Ih24D6DL2Z+45IV1xj0EMMfRxt3EZLsNuWJ/2RCaeQA=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=jF03Bmn4KZ2dlxkLkltkNkV1byIn+l+M/FbWIrz+LS9ntaxbIl7vmIVjCr6Zd61HN
	 +tjXacBWwpZVdi1E07D8liCNR7fMHO9AJGfzwfooM1/9Ccf0TV6X7o27VGfXj/BCds
	 NH+++eRfZmoql8Wl1BUmINFK6Ut/XTlirb2ITXCXvHB2LLQm0uHps8hQ0l+pqq2I1f
	 CsllvazDFFBuO37X3x1wolIXxbfL5a3F8UznE6Yy0qbd+J2PoFnWiX3s27kGw6b9Id
	 Sjn67WlFCU7g3CnRWmHo77lEHiRquM5nA1qMjPAD+/DjRQb+Q3z+1VAcxuhR8lCl/0
	 H8NOH6EEqqX0A==
Message-ID: <d4ca881f69306a25b020432446a84c90.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <12903a61f64206be837c1f0744632f29.sboyd@kernel.org>
References: <20230315183729.2376178-1-sboyd@kernel.org> <20230315183729.2376178-2-sboyd@kernel.org> <20230321173303.GA950598-robh@kernel.org> <12903a61f64206be837c1f0744632f29.sboyd@kernel.org>
Subject: Re: [PATCH v2 01/11] of: Load KUnit DTB from of_core_init()
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
To: Rob Herring <robh@kernel.org>
Date: Tue, 21 Mar 2023 11:24:45 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-03-21 11:15:19)
> Quoting Rob Herring (2023-03-21 10:33:03)
> > On Wed, Mar 15, 2023 at 11:37:18AM -0700, Stephen Boyd wrote:
> > > diff --git a/drivers/of/of_test.c b/drivers/of/of_test.c
> > > new file mode 100644
> > > index 000000000000..a4d70ac344ad
> > > --- /dev/null
> > > +++ b/drivers/of/of_test.c
> > > @@ -0,0 +1,43 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * KUnit tests for OF APIs
> > > + */
> > > +#include <linux/kconfig.h>
> > > +#include <linux/of.h>
> > > +
> > > +#include <kunit/test.h>
> > > +
> > > +/*
> > > + * Test that the root node / exists.
> > > + */
> > > +static void dtb_root_node_exists(struct kunit *test)
> > > +{
> > > +     KUNIT_EXPECT_NOT_ERR_OR_NULL(test, of_find_node_by_path("/"));
> > > +}
> > > +
> > > +/*
> > > + * Test that the /__symbols__ node exists.
> > > + */
> > > +static void dtb_symbols_node_exists(struct kunit *test)
> > > +{
> > > +     KUNIT_EXPECT_NOT_ERR_OR_NULL(test, of_find_node_by_path("/__sym=
bols__"));
> > > +}
> >=20
> > Many base DTs will not have this. And the kunit tests themselves=20
> > shouldn't need it because they should be independent of the base tree.
> >=20
>=20
> When I try to apply an overlay it fails=20
>=20
>  OF: overlay: no fragments or symbols in overlay
>  OF: overlay: init_overlay_changeset() failed, ret =3D -22
>      # of_overlay_apply_kunit_apply: ASSERTION FAILED at drivers/of/overl=
ay_test.c:18
>      Expected 0 =3D=3D ({ extern uint8_t __dtbo_kunit_overlay_test_begin[=
]; extern uint8_t __dtbo_kunit_overlay_test_end[]; __of_overlay_apply_kunit=
((test), __dtbo_kunit_overlay_test_begin, __dtbo_kunit_overlay_test_end); }=
), but
>          ({ extern uint8_t __dtbo_kunit_overlay_test_begin[]; extern uint=
8_t __dtbo_kunit_overlay_test_end[]; __of_overlay_apply_kunit((test), __dtb=
o_kunit_overlay_test_begin, __dtbo_kunit_overlay_test_end); }) =3D=3D -12 (=
0xfffffffffffffff4)
>  [FAILED] of_overlay_apply_kunit_apply
>=20
> Now I'm trying to hack on the fake root node to see if I can make it work.
>=20

Aha I figured it out. Needed to read more documentation.

---8<---
diff --git a/drivers/of/kunit_overlay_test.dtso b/drivers/of/kunit_overlay_=
test.dtso
index e3ced1467dd9..7688f9ef1b6b 100644
--- a/drivers/of/kunit_overlay_test.dtso
+++ b/drivers/of/kunit_overlay_test.dtso
@@ -2,7 +2,7 @@
 /dts-v1/;
 /plugin/;
=20
-/ {
+&{/} {
 	test-kunit {
 		compatible =3D "test,kunit-empty";
 	};
