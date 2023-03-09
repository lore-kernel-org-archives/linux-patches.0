Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113842F50
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 23:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C63C433EF;
	Thu,  9 Mar 2023 23:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678403971;
	bh=0e1IQuJM6EOb5pF3dOal+TY0fflstRFeaSOPVjTl6rk=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=WTw9lhTBdv/hpDwi8v6P1+xgoHMQ7K073snH/DjLyODMeuVcXMzZGRpayl1GqnXoJ
	 TZYGx8IxRtunqcCzWkBB6vQJL3Q5wLiw/8x3Wu0p3Z2mVv91oHLmZs5/LCvu1hckJ5
	 Y86jbRH1E4b0eJdKv69OKTZRAINlbhkeJZpDSnCnDEmjqKqHqSQcRFj7LAfkQbVnSu
	 /otSYFe7xyEcx56wLYqqQOARY2LAu0Q8Z8eytpjalU4xjE1a3795SxKFvJkFZ/ikxg
	 9sNl5bhX7Noy1mCyAkdVnKi30/W6I6REzK1i6YmEDpzYZWqYfkTGlRhU6Zl4smKtiL
	 6lAp7OvgRe6mQ==
Message-ID: <a97c9bb3a5addfb34af8ccabaa513026.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABVgOSkomwwgKZ9N0_0YMDL--QaZiTV7ONgSRABU2Ph1Z0CG-g@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-3-sboyd@kernel.org> <CABVgOSkomwwgKZ9N0_0YMDL--QaZiTV7ONgSRABU2Ph1Z0CG-g@mail.gmail.com>
Subject: Re: [PATCH 2/8] of: Enable DTB loading on UML for KUnit tests
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>
Date: Thu, 09 Mar 2023 15:19:29 -0800
User-Agent: alot/0.10

Quoting David Gow (2023-03-02 23:15:04)
> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > To fully exercise common clk framework code in KUnit we need to
> > associate 'struct device' pointers with 'struct device_node' pointers so
> > that things like clk_get() can parse DT nodes for 'clocks' and so that
> > clk providers can use DT to provide clks; the most common mode of
> > operation for clk providers.
> >
> > Adding support to KUnit so that it loads a DTB is fairly simple after
> > commit b31297f04e86 ("um: Add devicetree support"). We can simply pass a
> > pre-compiled deviectree blob (DTB) on the kunit.py commandline and UML
> > will load it. The problem is that tests won't know that the commandline
> > has been modified, nor that a DTB has been loaded. Take a different
> > approach so that tests can skip if a DTB hasn't been loaded.
> >
> > Reuse the Makefile logic from the OF unittests to build a DTB into the
> > kernel. This DTB will be for the mythical machine "linux,kunit", i.e.
> > the devicetree for the KUnit "board". In practice, it is a dtsi file
> > that will gather includes for kunit tests that rely in part on a
> > devicetree being loaded. The devicetree should only be loaded if
> > CONFIG_OF_KUNIT=3Dy. Make that a choice config parallel to the existing
> > CONFIG_OF_UNITTEST so that only one devicetree can be loaded in the
> > system at a time. Similarly, the kernel commandline option to load a
> > DTB is ignored if CONFIG_OF_KUNIT is enabled so that only one DTB is
> > loaded at a time.
>=20
> This feels a little bit like it's just papering over the real problem,
> which is that there's no way tests can skip themselves if no DTB is
> loaded.

Hmm. I think you're suggesting that the unit test data be loaded
whenever CONFIG_OF=3Dy and CONFIG_KUNIT=3Dy. Then tests can check for
CONFIG_OF and skip if it isn't enabled?

>=20
> That being said, I do think that there's probably some sense in
> supporting the compiled-in DTB as well (it's definitely simpler than
> patching kunit.py to always pass the extra command-line option in, for
> example).
> But maybe it'd be nice to have the command-line option override the
> built-in one if present.

Got it. I need to test loading another DTB on the commandline still, but
I think this won't be a problem. We'll load the unittest-data DTB even
with KUnit on UML, so assuming that works on UML right now it should be
unchanged by this series once I resend.
