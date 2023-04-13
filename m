Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBC07E
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 00:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072BEC433EF;
	Thu, 13 Apr 2023 00:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681345566;
	bh=tQYSWNm02Rfoi3cW6r6HFWTCjEAasxZQGZXCvVRhjHo=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=RcqgakYq+dcD1F/KD6eHSmn/VuynpviBakPDOvGdPOiiMNusf0wtDni7ahcJvjDbD
	 964hFnKfvfV8zMuiuQSi9ziYZ2rPnU5wG2+UZVOTeYq27aTls+lLd41k7Mk08CG4vu
	 XtuiVOn4GBkblKM75Eg01Q4IFfDKl+DapbSQ8RP0/9UFj57xUfo0eiD4ASLw8ZZi9O
	 elFCmO7fjlqhIh8M6zHakT+MndZWHVWcqkCw+/rOEBKu6Uj1HzRR7y2vmgMZKeSh2n
	 JTO/SrSxf4ApeyzjKRb5pE23rCrzpeN3tIrsGQ1xUwi0K7pbyffV26H4AhPfeTO7Ic
	 kRraecxfw91WA==
Message-ID: <eaf237baf3a0bfd5bf4c7e97e32f9261.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAGS_qxryWVOT9cBtKk28=NupbLP6_AiCj0P3np2GpMVKkyQOLg@mail.gmail.com>
References: <20230327222159.3509818-1-sboyd@kernel.org> <20230327222159.3509818-6-sboyd@kernel.org> <CAGS_qxryWVOT9cBtKk28=NupbLP6_AiCj0P3np2GpMVKkyQOLg@mail.gmail.com>
Subject: Re: [PATCH v3 05/11] of: Add a KUnit test for overlays and test managed APIs
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
To: Daniel Latypov <dlatypov@google.com>
Date: Wed, 12 Apr 2023 17:26:02 -0700
User-Agent: alot/0.10

Quoting Daniel Latypov (2023-04-12 17:04:26)
> On Mon, Mar 27, 2023 at 3:22=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> w=
rote:
> > +/* Test that of_overlay_apply_kunit() cleans up after the test is fini=
shed */
> > +static void of_overlay_apply_kunit_cleanup(struct kunit *test)
> > +{
> > +       struct device *dev;
> > +       struct device_node *np;
> > +
> > +       KUNIT_ASSERT_EQ(test, 0,
> > +                       of_overlay_apply_kunit(test, kunit_overlay_test=
));
> > +
> > +       np =3D of_find_node_by_name(NULL, kunit_node_name);
> > +       of_node_put(np); /* Not derefing 'np' after this */
> > +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> > +
> > +       dev =3D bus_find_device(&platform_bus_type, NULL, np, bus_match=
_np);
> > +       put_device(dev); /* Not derefing 'device' after this */
> > +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
> > +
> > +       /* Remove overlay */
> > +       kunit_cleanup(test);
>=20
> Note: this cleans up *all* resources associated with `test`.
> Right now, it's probably fine, but this probably isn't the safest approac=
h.
>=20
> Notably, two of the new/upcoming API changes rely on resource,
> kunit/static_stub.h and kunit_add_action() [1].
> Calling kunit_cleanup() undoes all the stubs and immediately triggers
> all the actions.
>=20
> Perhaps you can create your own local `struct kunit` like in [2]
> E.g.
>=20
> struct kunit subtest; // not sure what to call this...
>=20
> kunit_init_test(&subtest, "fake test", NULL);
> /* use subtest */
> kunit_cleanup(&subtest);

Thanks for the pointers. I can change this to be a fake sub-test as
that's the intention here. I was mostly following what
kunit_resource_test_static() was doing, which was calling
kunit_cleanup() on the existing test that's passed in.
