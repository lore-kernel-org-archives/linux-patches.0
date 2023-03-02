Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5EE10FA
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 19:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454DFC433EF;
	Thu,  2 Mar 2023 19:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677786279;
	bh=Gg0MB69jq45zUDzbufKVzCb4e8QnQUlughxd29kp6D4=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=UF/A3cNrIHCjYUH8VfY/NK6UpVZIokCbrtWmA0U5IV3wIHe5pk73luJg1oh0zsOQd
	 7JxdJ445auFN5T/F/vj1J5gd7cAsbz9Mq2s4jsmwzIMgimBw+VGjfWpbRESZAyDWvL
	 j9GmxFoc+U3+M0qAgS43FDQDbe3PJ3A2lx0JR+Y/qroSv2U41EAit3wbqxG8fyD6cE
	 mspGkwIZQy786bHnEiMq7JDm3/vyzhB+39wDVQPiqFcSfsXd/+FV4HCZHJxZMiuC0z
	 mlISEufoYhbF200VNRCve2zyJhpeTmz/mVL17+PsdEUHsBreG7BEBMiTsl4sqZ/lCv
	 wJbE8//XBcK4A==
Message-ID: <093867df6137ad9e964b7dd90fb58f1a.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAL_JsqLVQVZhYTSZgrvA-V-xOUbiBdyDxqPOZk=89YS33EahBQ@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <CAL_JsqLVQVZhYTSZgrvA-V-xOUbiBdyDxqPOZk=89YS33EahBQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: Rob Herring <robh+dt@kernel.org>
Date: Thu, 02 Mar 2023 11:44:37 -0800
User-Agent: alot/0.10

Quoting Rob Herring (2023-03-02 09:13:59)
> On Wed, Mar 1, 2023 at 7:38=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
> >
> > This patch series adds unit tests for the clk fixed rate basic type and
> > the clk registration functions that use struct clk_parent_data. To get
> > there, we add support for loading a DTB into the UML kernel that's
> > running the unit tests along with probing platform drivers to bind to
> > device nodes specified in DT.
> >
> > With this series, we're able to exercise some of the code in the common
> > clk framework that uses devicetree lookups to find parents and the fixed
> > rate clk code that scans devicetree directly and creates clks. Please
> > review.
> >
> > I Cced everyone to all the patches so they get the full context. I'm
> > hoping I can take the whole pile through the clk tree as they almost all
> > depend on each other. In the future I imagine it will be easy to add
> > more test nodes to the clk.dtsi file and not need to go across various
> > maintainer trees like this series does.
> >
> > Stephen Boyd (8):
> >   dt-bindings: Add linux,kunit binding
> >   of: Enable DTB loading on UML for KUnit tests
> >   kunit: Add test managed platform_device/driver APIs
> >   clk: Add test managed clk provider/consumer APIs
> >   dt-bindings: kunit: Add fixed rate clk consumer test
> >   clk: Add KUnit tests for clk fixed rate basic type
> >   dt-bindings: clk: Add KUnit clk_parent_data test
> >   clk: Add KUnit tests for clks registered with struct clk_parent_data
>=20
> Good to see bindings for this. I've been meaning to do something about
> the DT unittest ones being undocumented, but I hadn't really decided
> whether it was worth writing schemas for them. The compatibles at
> least show up with 'make dt_compatible_check'. Perhaps we want to just
> define some vendor (not 'linux') that's an exception rather than
> requiring schemas (actually, that already works for 'foo').

Sure. Maybe "kunit" should be the vendor prefix? Or "dtbunit"?

> It's
> likely that we want test DTs that fail normal checks and schemas get
> in the way of that as we don't have a way to turn off checks.

Having the schemas is nice to make sure tests that are expecting some
binding are actually getting that. But supporting broken bindings is
also important to test any error paths in functions that parse
properties. Maybe we keep the schema and have it enforce that incorrect
properties are being set?

Do we really need to test incorrect bindings? Doesn't the
dt_bindings_check catch these problems so we don't have to write DTB
verifiers in the kernel?

>=20
> We already have GPIO tests in the DT unittests, so why is clocks
> different? Or should the GPIO tests be moved out (yes, please!)?

Ah I didn't notice the GPIO tests in there. There are i2c tests too,
right? All I can say is clks are using kunit, that's the difference ;-)

>=20
> What happens when/if the DT unittest is converted to kunit? I think
> that would look confusing from the naming. My initial thought is
> 'kunit' should be dropped from the naming of a lot of this. Note that
> the original kunit submission converted the DT unittests. I would
> still like to see that happen. Frank disagreed over what's a unit test
> or not, then agreed, then didn't... I don't really care. If there's a
> framework to use, then we should use it IMO.

Honestly I don't want to get involved in migrating the existing DT
unittest code to kunit. I'm aware that it was attempted years ago when
kunit was introduced. Maybe if the overlay route works well enough I can
completely sidestep introducing any code in drivers/of/ besides some
kunit wrappers for this. I'll cross my fingers!

>=20
> >
> >  .../clock/linux,clk-kunit-parent-data.yaml    |  47 ++
> >  .../kunit/linux,clk-kunit-fixed-rate.yaml     |  35 ++
> >  .../bindings/kunit/linux,kunit.yaml           |  24 +
> >  arch/um/kernel/dtb.c                          |  29 +-
> >  drivers/clk/.kunitconfig                      |   3 +
> >  drivers/clk/Kconfig                           |   7 +
> >  drivers/clk/Makefile                          |   6 +
> >  drivers/clk/clk-fixed-rate_test.c             | 296 ++++++++++++
> >  drivers/clk/clk-kunit.c                       | 204 ++++++++
> >  drivers/clk/clk-kunit.h                       |  28 ++
> >  drivers/clk/clk_test.c                        | 456 +++++++++++++++++-
> >  drivers/of/Kconfig                            |  26 +
> >  drivers/of/Makefile                           |   1 +
> >  drivers/of/kunit/.kunitconfig                 |   4 +
> >  drivers/of/kunit/Makefile                     |   4 +
> >  drivers/of/kunit/clk.dtsi                     |  30 ++
> >  drivers/of/kunit/kunit.dtsi                   |   9 +
> >  drivers/of/kunit/kunit.dtso                   |   4 +
> >  drivers/of/kunit/uml_dtb_test.c               |  55 +++
> >  include/kunit/platform_driver.h               |  15 +
> >  lib/kunit/Makefile                            |   6 +
> >  lib/kunit/platform_driver-test.c              | 107 ++++
> >  lib/kunit/platform_driver.c                   | 207 ++++++++
>=20
> Humm, we have DT platform driver unittests too. What's the difference?

Yes, I added unit tests for the kunit platform device/driver wrappers
added in this series.

>=20
> Anyways, that's all just my initial reaction from only halfway looking
> at this. :)

Thanks for taking the time to review even halfway.
