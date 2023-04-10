Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81D05250
	for <patches@lists.linux.dev>; Mon, 10 Apr 2023 20:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A3EC433D2;
	Mon, 10 Apr 2023 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681157553;
	bh=5U7q5FFfyESST3OGukgX6MQSaldfDcBHIY+o9mSh3P8=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=YySPYjpqrwiHID23tH5fwQjEhH0nap4jt74c37bUm9nT9e2Q178bMoE8Hg/IzN6xE
	 1Hzc9yZcuPSwjP6itSfcFXZgqwkHeWP6PAqFq2a+J9d6eJshFP0uczTFRtg9eoVnDR
	 7uxE9OsQXUnHtwhiT7ubyzog/TqS2lGvXoKowYAorxpd5NTPuLMEaQ1cNQ5M/tcLVW
	 8jWQVntvlcw8PvxnHgTASTEZ8yBmkRqWZi9sQzTjD8uWLqpfZpWJ5RaYDpoB9voXIu
	 Qv/mLUwDFN4GLf77twSmTncye2PCYt8//ygCPf04lFRjyD6SrPW7xor8LyDfpKjGo9
	 Tfwd39GsEBQmA==
Message-ID: <1ae778ee8d91819ffdebf613e435d040.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230406145916.GB3036886-robh@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org> <20230327222159.3509818-6-sboyd@kernel.org> <20230406145916.GB3036886-robh@kernel.org>
Subject: Re: [PATCH v3 05/11] of: Add a KUnit test for overlays and test managed APIs
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
To: Rob Herring <robh@kernel.org>
Date: Mon, 10 Apr 2023 13:12:29 -0700
User-Agent: alot/0.10

Quoting Rob Herring (2023-04-06 07:59:16)
> On Mon, Mar 27, 2023 at 03:21:53PM -0700, Stephen Boyd wrote:
> > diff --git a/drivers/of/overlay_test.c b/drivers/of/overlay_test.c
> > new file mode 100644
> > index 000000000000..66b1dceea568
> > --- /dev/null
> > +++ b/drivers/of/overlay_test.c
> > @@ -0,0 +1,110 @@
> > +// SPDX-License-Identifier: GPL-2.0
[...]
> > +/*
> > + * Test that of_overlay_apply_kunit() creates platform devices with the
> > + * expected device_node
> > + */
> > +static void of_overlay_apply_kunit_platform_device(struct kunit *test)
> > +{
> > +     struct device *dev;
> > +     struct device_node *np;
> > +
> > +     KUNIT_ASSERT_EQ(test, 0,
> > +                     of_overlay_apply_kunit(test, kunit_overlay_test));
> > +
> > +     np =3D of_find_node_by_name(NULL, kunit_node_name);
> > +     of_node_put_kunit(test, np);
> > +     KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> > +
> > +     dev =3D bus_find_device(&platform_bus_type, NULL, np, bus_match_n=
p);
>=20
> of_find_device_by_node()

Done.

>=20
> > +     put_device(dev); /* Not derefing 'device' after this */
> > +     KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
> > +
> > +     /* Remove overlay */
> > +     kunit_cleanup(test);
>=20
> I guess this is testing the cleanup. It's not that obvious given the=20
> overlay is removed by kunit_cleanup(). Not sure if anything can be done=20
> though...

Don't think so? The test name is "of_overlay_apply_kunit_cleanup", so we
need to use the kunit_cleanup() API to simulate that the "test is done".
Otherwise we're testing some other API like of_overlay_remove(), which
could be added as another test case. I specifically wanted to test that
the kunit cleanup path does what we're expecting here.
