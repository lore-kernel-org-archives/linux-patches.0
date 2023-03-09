Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42ACC963
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 23:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FA6C433D2;
	Thu,  9 Mar 2023 23:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678404305;
	bh=0+xvIX/l5HfhoI3d48C3MS9defLdrI9hBfw1DQOEHsU=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=pfJgPn04fLoJ83bmxLG/rpgHobSV6DWXPzzXm37HY7VDdZdyViNeT4OyfObONxBUU
	 6SsTyBLL60s3XJ0/0SBzWcHJQdoOanCmNi4cdbzst7OXZAH9fETbCN7fXaJ4afORqI
	 6yObyqm+RC5tlfdDl467IifHaYBK++rMgVLGKLvA2ZT65xrHpRmrWJyoAvQ76fB8C8
	 vcGgvwvuoQZ+7u6fI6ahUDJyzdjkReRNMramhznHpy/TEAd0pTGYrXEy8UOYqGOuyn
	 6VrjfSW9SsLJoTzuMqk8DjDqgK+ConBj+Kr3IoaSaP+0blbw2zYcp4TAxfT5Fi2Bk9
	 em91zLxWRXm1g==
Message-ID: <b0d4d450a7ad9b39336771b74b48f086.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABVgOSmR0_u8Tw0E8C1mRFxSiGKwdKG5ka_+X_36Hj4VNLdg2g@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-4-sboyd@kernel.org> <CABVgOSmR0_u8Tw0E8C1mRFxSiGKwdKG5ka_+X_36Hj4VNLdg2g@mail.gmail.com>
Subject: Re: [PATCH 3/8] kunit: Add test managed platform_device/driver APIs
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>
Date: Thu, 09 Mar 2023 15:25:03 -0800
User-Agent: alot/0.10

Quoting David Gow (2023-03-02 23:15:31)
> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > Introduce KUnit resource wrappers around platform_driver_register(),
> > platform_device_alloc(), and platform_device_add() so that test authors
> > can register platform drivers/devices from their tests and have the
> > drivers/devices automatically be unregistered when the test is done.
> >
> > This makes test setup code simpler when a platform driver or platform
> > device is needed. Add a few test cases at the same time to make sure the
> > APIs work as intended.
> >
> > Cc: Brendan Higgins <brendan.higgins@linux.dev>
> > Cc: David Gow <davidgow@google.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > ---
> >
> > Should this be moved to drivers/base/ and called platform_kunit.c?
> > The include/kunit/platform_driver.h could also be
> > kunit/platform_device.h to match linux/platform_device.h if that is more
> > familiar.
>=20
> DRM has a similar thing already (albeit with a root_device, which is
> more common with KUnit tests generally):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/i=
nclude/drm/drm_kunit_helpers.h
>=20
> But that's reasonably drm-specific, so it makes sense that it lives
> with DRM stuff. platform_device is a bit more generic.
>=20
> I'd probably personally err on the side of having these in
> drivers/base/, as I think we'll ultimately need similar things for a
> lot of different devices, and I'd rather not end up with things like
> USB device helpers living in the lib/kunit directory alongside the
> "core" KUnit code. But I could be persuaded otherwise.

Ok no problem. I'll move it.

>=20
> >
> > And I'm not super certain about allocating a driver structure and
> > embedding it in a wrapper struct. Maybe the code should just use
> > kunit_get_current_test() instead?
>=20
> I think there are enough cases througout the kernel where
> device/driver structs are needed that having this makes sense.
> Combined with the fact that, while kunit_get_current_test() can be
> used even when KUnit is not loaded, actually doing anything with the
> resulting struct kunit pointer will probably require (at least for the
> moment) KUnit functions to be reachable, so would break if
> CONFIG_KUNIT=3Dm.

Wouldn't it still work in that case? The unit tests would be modular as
well because they depend on CONFIG_KUNIT.

>=20
> So, unless you actually find kunit_get_current_test() and friends to
> be easier to work with, I'd probably stick with this.
>=20

Alright thanks.

> > diff --git a/lib/kunit/platform_driver.c b/lib/kunit/platform_driver.c
> > new file mode 100644
> > index 000000000000..11d155114936
> > --- /dev/null
> > +++ b/lib/kunit/platform_driver.c
> > @@ -0,0 +1,207 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Test managed platform driver
> > + */
> > +
> > +#include <linux/device/driver.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <kunit/resource.h>
> > +
> > +struct kunit_platform_device_alloc_params {
> > +       const char *name;
> > +       int id;
> > +};
>=20
> FYI: It's my plan to eventually get rid of (or at least de-emphasize)
> the whole 'init' function aspect of KUnit resources so we don't need
> all of these extra structs and the like. It probably won't make it in
> for 6.4, but we'll see...

Will we be able to get the error values out of the init function? It's
annoying that the error values can't be returned as error pointers to
kunit_alloc_resource(). I end up skipping init, and doing it directly
before or after calling the kunit_alloc_resource() function. I'll try to
avoid init functions in the allocations.
