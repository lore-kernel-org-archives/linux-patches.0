Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DB52F0C74;
	Fri, 21 Aug 2026 04:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787286820; cv=none; b=OZCAw3np1CCnKuyn7zr8w0KiS+NYp6ffcmcfnYFTXcoqZFr2MqBCB6Rpqu62bwJexc5xl8Tvx3XBrd81ei+5wMR3GlbuOe+XdQZjtIkUyiD/DDYlsYQ2OyYb4N0MyNWMMZibjgT/2F9cTtyumDIO7NijZqEnJBdpHtc72vKqDos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787286820; c=relaxed/simple;
	bh=Gr3ZX2BA5WpdSO9+jnMVJZgf5Qw5eTXU5pz5oE6TpWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isjCEk91MmDYorviPVNWn5WIhFY7ri52cegqtt+yn5jeB2PDtgenwHEJ/EAqwlI5U06xBNpalL7UnHJxMxsvKQ6b62ijSySwHj8tbMYBh8NDJsTNqYPYTHr56KeZ08GSw4Cm7p9Py/tE5/KAYS/rxzvL8seQBoxmUruF8eBsbgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baNruVKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baNruVKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32EB1F000E9;
	Fri, 21 Aug 2026 04:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787286818;
	bh=oy1yCFjQ9RYkoArPZBcTtRBXm8YsvFi0SIMdimDtM/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=baNruVKHHtyXslcuyfnCzi4kupWXocmqMCJL/AOD31pG7SVdKxpaYgbvyP6lG0Lsi
	 zIbcqPxcuslge8twR9BTKIwgg6kDavBykE6/8hOjziocI00d73AiZDcna1YQUdxtc7
	 u0dShI8Q1jW2TA5AJi/nsUrzLnFdTKtxn4yu/tcLbxyp65tcQmZ2XBR30W94HJ2Duu
	 IuzsZmZUeN6ANsuBjlBOeokSLrKLP3hOJJMZu+QJJ6eCvOGBrs48x9HUVx27oNeFNS
	 yoma14VKBl1bNMTd3HyfsYIj9DZ9jY5Cm5X1B8BxbIu2/0Gyz8F0ZnNh7JCb/sBdEq
	 Wg8t9j+hny+Ng==
From: Sasha Levin <sashal@kernel.org>
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	liam.merwick@oracle.com,
	vegard.nossum@oracle.com,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 6.12 111/181] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Fri, 21 Aug 2026 00:33:32 -0400
Message-ID: <20260821-stable-item001-snp-builtin-kvm@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoXZohqTkyXQmteX@google.com>
References: <aoXZohqTkyXQmteX@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> > > 435b344a7042 ("crypto: ccp: Add external API interface for PSP module
> > > initialization")
> > > 44e70718df4f ("KVM: SVM: Ensure PSP module is initialized if KVM module
> > > is built-in")
> > > 409f45387c93 ("x86/sev: Fix broken SNP support with KVM module built-in")
>
> Yes, we should also backport the above fixes to 6.12.y.

The first two are queued for 6.12.

409f45387c93 ("x86/sev: Fix broken SNP support with KVM module built-in") does
not apply there. 6.12 predates the segmented-RMP rework, so snp_rmptable_init()
still uses probed_rmp_base/memremap() and the commit needs seven prerequisites,
six of them the v6.14-rc1 segmented-RMP/RMPREAD series. That is hardware
enablement, not stable material, so I don't want to pull it in as a dependency.

Could someone send a tested 6.12.y-specific backport of 409f45387c93? I'll hold
6.12 until it shows up.

-- 
Thanks,
Sasha
