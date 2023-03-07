Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2382610792
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 21:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB433C433EF;
	Tue,  7 Mar 2023 21:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678226016;
	bh=bXpDeJ+bKqyuyw9K1wlhaLEENKYmniVFEPD3+zmo9AE=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=cEPL0PxrcCqhhfdpdMP7T5do0b0u55fgRXA6AcSKDTG4rmjAqKHUVagowIbRwdMNq
	 sjKhcK17x1oo/PIKeTLhHF8JQWXmZSdA0PQslle7OaCrGH8d/4dctj9hnhnCndVw//
	 flpnsEOOTge3smiTgjaXXwCzzL4QIoVRR0JvQVBW7cGXUId8Y0pEzl3mmnmXqVi+g4
	 YHJNuNfYEi7H0352Txc/VaRpjDzKNbDFyvkie34CBWIrXVnT9E4NkTM3i8o/pOa9dx
	 lqTd3WCct8W/Cu43Z3HyoIHfgppFM9A/7RJDQEF4CBe0iVWLNtV8YZDnO4zf/168SX
	 o6uh9K7Puc4Yw==
Message-ID: <509072932692550449632f714c6ccb29.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5e26a786-400a-cd6c-8771-d94a8020839d@gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <CABVgOSnpMNCtEEsJV28OzUoxdDuiT4a2T0avP0AYf9xFW1jxrw@mail.gmail.com> <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com> <3759b28cca7ab751296d4dd83f2dcc51.sboyd@kernel.org> <5e26a786-400a-cd6c-8771-d94a8020839d@gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J.Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>, Frank Rowand <frowand.list@gmail.com>, Rob Herring <robh+dt@kernel.org>
Date: Tue, 07 Mar 2023 13:53:34 -0800
User-Agent: alot/0.10

Quoting Frank Rowand (2023-03-04 07:04:48)
> On 3/2/23 13:27, Stephen Boyd wrote:
> >=20
> > But perhaps this design is too much of an end-to-end test and not a unit
> > test? In the spirit of unit testing we shouldn't care about how the node
> > is added to the live devicetree, just that there is a devicetree at all.
> >=20
> > Supporting overlays to more easily test combinations sounds like a good
> > idea. Probably some kunit_*() prefixed functions could be used to
>=20
> In an imaginary world where overlay support was completed, then _maybe_.
>=20
> To me, the most important  environment to test is where the devictree
> data is populated in early boot from an FDT.  This is the environment
> that drivers currently exist in.
>=20
> Populating devicetree data via an overlay adds in the functioning of the
> overlay apply code (and how the rules behind that functioning may differ
> from devicetree data populated in early boot from an FDT).

For the purposes of clk unit tests I don't care where the devicetree
nodes come from. All I care about is that they're rooted in the live
devicetree for the system and that they have platform devices attached
to them. The clk unit tests will assert that the overlay has been
applied and that should be sufficient to make sure the tests has
satisfied pre-conditions.

If these were end-to-end tests then I would agree that making the nodes
be loaded during early boot from an FDT would be the right approach.
That would test the integration of early DTB loading and code that runs
on the FDT. These aren't integration tests though, so when the nodes are
created and unflattened doesn't matter.

I'll introduce various unit tests around the kunit specific overlay
application API so that I know it makes platform devices and they have
device nodes attached to them. And those same tests should be able to
confirm that devices are destroyed when the overlay is removed.
