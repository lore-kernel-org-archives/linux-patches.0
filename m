Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2882AD306
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 17:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD162C433D2;
	Tue, 21 Mar 2023 17:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679421364;
	bh=fme8VBP3GP2rSp6dAa9xEtOtI+WLEGichp4lNPYbnm0=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=jK2ejocISTEYkgYev33TJtcxiFDvya9Tk/W9hzd0eBYbua//PnOrijpZDBrDdsHrh
	 8Bfq9+hSy9Db0a11bLDIujYvfCfPC7FjsKXpHM8iRafQJipXAWKZWoTEYxKzp8fmdC
	 dHuURY/bNFtUFHho/K34Ry6UBBj817eTk3CFV9Ev45gzi683Lc1qu7z0xUk00mSZa6
	 T1D2r++s4e+KBKtWfowKFMcd1JQ5vTcpwj/ycfISiw/bEANWYobp9eYRgenCYAE24c
	 7P0UiPR+5Cmsz/veeRco0j8omkma9Ju1KEO+St1DTYktcs/a0dVv+gPD4PCQloqDLF
	 WL8potBGnxASg==
Message-ID: <d339c3b0e92e11fb9c98671c1e36cd14.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230321173303.GA950598-robh@kernel.org>
References: <20230315183729.2376178-1-sboyd@kernel.org> <20230315183729.2376178-2-sboyd@kernel.org> <20230321173303.GA950598-robh@kernel.org>
Subject: Re: [PATCH v2 01/11] of: Load KUnit DTB from of_core_init()
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
To: Rob Herring <robh@kernel.org>
Date: Tue, 21 Mar 2023 10:56:02 -0700
User-Agent: alot/0.10

Quoting Rob Herring (2023-03-21 10:33:03)
> On Wed, Mar 15, 2023 at 11:37:18AM -0700, Stephen Boyd wrote:
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index ac6fde53342f..090c5d7925e4 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -16,13 +16,16 @@
> > =20
> >  #define pr_fmt(fmt)  "OF: " fmt
> > =20
> > +#include <linux/align.h>
> >  #include <linux/console.h>
> >  #include <linux/ctype.h>
> >  #include <linux/cpu.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> > +#include <linux/of_fdt.h>
>=20
> base.c deals with unflattened trees. There shouldn't be anything FDT=20
> related in it.

Ok.

>=20
> >  #include <linux/of_graph.h>
> > +#include <linux/printk.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/slab.h>
> >  #include <linux/string.h>
> > @@ -163,10 +166,90 @@ void __of_phandle_cache_inv_entry(phandle handle)
> >               phandle_cache[handle_hash] =3D NULL;
> >  }
> > =20
> > +#ifdef CONFIG_OF_KUNIT
>=20
> base.c is already quite big. This should probably be its own file.=20
> Perhaps in kunit code because that's what we do for everything else=20
> (e.g. DT clock code goes in drivers/clk/). (My goal is to eliminate=20
> drivers/of/. That's easier than finding maintainers. ;) )

Heh, sure.

>=20
> > +static int __init of_kunit_add_data(void)
> > +{
> > +     void *kunit_fdt;
> > +     void *kunit_fdt_align;
> > +     struct device_node *kunit_node =3D NULL, *np;
> > +     /*
> > +      * __dtbo_kunit_begin[] and __dtbo_kunit_end[] are magically
> > +      * created by cmd_dt_S_dtbo in scripts/Makefile.lib
> > +      */
> > +     extern uint8_t __dtbo_kunit_begin[];
> > +     extern uint8_t __dtbo_kunit_end[];
> > +     const int size =3D __dtbo_kunit_end - __dtbo_kunit_begin;
> > +     int rc;
> > +     void *ret;
> > +
> > +     if (!size) {
> > +             pr_warn("kunit.dtbo is empty\n");
> > +             return -ENODATA;
> > +     }
> > +
> > +     kunit_fdt =3D kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
> > +     if (!kunit_fdt)
> > +             return -ENOMEM;
> > +
> > +     kunit_fdt_align =3D PTR_ALIGN(kunit_fdt, FDT_ALIGN_SIZE);
> > +     memcpy(kunit_fdt_align, __dtbo_kunit_begin, size);
> > +
> > +     ret =3D of_fdt_unflatten_tree(kunit_fdt_align, NULL, &kunit_node);
>=20
> I don't understand why this doesn't use of_overlay_fdt_apply(). Your=20
> test(s) shouldn't be any different than any other overlay user (granted, =

> there aren't many). You apply the overlay, run your test, then remove=20
> the overlay.

This isn't a test. This is loading the kunit.dtso blob, and potentially
the root DTB. Maybe of_overlay_fdt_apply() will work if there is a root
node already?

>=20
> > +     if (!ret) {
> > +             pr_warn("unflatten KUnit tree failed\n");
> > +             kfree(kunit_fdt);
> > +             return -ENODATA;
> > +     }
> > +     if (!kunit_node) {
> > +             pr_warn("KUnit tree is empty\n");
> > +             kfree(kunit_fdt);
> > +             return -ENODATA;
> > +     }
> > +
> > +     of_overlay_mutex_lock();
> > +     rc =3D of_resolve_phandles(kunit_node);
> > +     if (rc) {
> > +             pr_err("Failed to resolve KUnit phandles (rc=3D%i)\n", rc=
);
> > +             of_overlay_mutex_unlock();
> > +             return -EINVAL;
> > +     }
> > +
> > +     if (!of_root) {
>=20
> There's patches from Frank and others under review which will always=20
> create and empty DT if the bootloader/arch didn't provide one. This=20
> series should rely on that. (Or just assume that when that happens, your =

> tests will run in more environments)

Ok. I'll base v3 on the series here[1] unless told otherwise.

> > @@ -1879,6 +1962,105 @@ int of_update_property(struct device_node *np, =
struct property *newprop)
> >       return rc;
> >  }
> > =20
> > +#if defined(CONFIG_OF_UNITTEST) || defined (CONFIG_KUNIT)
> > +/**
> > + * update_node_properties - adds the properties of np into dup node (p=
resent in
> > + * live tree) and updates parent of children of np to dup.
> > + *
> > + * @np: node whose properties are being added to the live tree
> > + * @dup: node present in live tree to be updated
> > + */
> > +static void __init update_node_properties(struct device_node *np,
> > +                                     struct device_node *dup)
>=20
> Please split any moving of code to separate patches.

Sure.

>=20
> I'm not remembering why we need these test functions vs. just applying=20
> overlays. Frank? Perhaps because it's trying to test the overlay code=20
> itself. But you should just be a user of the overlay API and not need to =

> do anything special.

Got it.

> > diff --git a/drivers/of/kunit.dtso b/drivers/of/kunit.dtso
> > new file mode 100644
> > index 000000000000..d512057df98d
> > --- /dev/null
> > +++ b/drivers/of/kunit.dtso
> > @@ -0,0 +1,10 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/dts-v1/;
> > +/plugin/;
> > +
> > +/ {
> > +     /* Container node where KUnit tests can load overlays */
> > +     kunit_bus: kunit-bus {
> > +             compatible =3D "simple-bus";
> > +     };
> > +};
>=20
> Why do we need an overlay to apply overlays to?=20

I'm applying overlays based on the phandle kunit_bus. Should we allow
overlays to modify the root node? I haven't tried that, but I can give
it a shot and see if it works.

>=20
>=20
> > diff --git a/drivers/of/of_test.c b/drivers/of/of_test.c
> > new file mode 100644
> > index 000000000000..a4d70ac344ad
> > --- /dev/null
> > +++ b/drivers/of/of_test.c
> > @@ -0,0 +1,43 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * KUnit tests for OF APIs
> > + */
> > +#include <linux/kconfig.h>
> > +#include <linux/of.h>
> > +
> > +#include <kunit/test.h>
> > +
> > +/*
> > + * Test that the root node / exists.
> > + */
> > +static void dtb_root_node_exists(struct kunit *test)
> > +{
> > +     KUNIT_EXPECT_NOT_ERR_OR_NULL(test, of_find_node_by_path("/"));
> > +}
> > +
> > +/*
> > + * Test that the /__symbols__ node exists.
> > + */
> > +static void dtb_symbols_node_exists(struct kunit *test)
> > +{
> > +     KUNIT_EXPECT_NOT_ERR_OR_NULL(test, of_find_node_by_path("/__symbo=
ls__"));
> > +}
>=20
> Many base DTs will not have this. And the kunit tests themselves=20
> shouldn't need it because they should be independent of the base tree.
>=20

Alright. Let me see how modifying the root node works, in which case
maybe none of this patch is necessary besides confirming there is a root
node.

[1] https://lore.kernel.org/all/20230317053415.2254616-1-frowand.list@gmail=
.com/
