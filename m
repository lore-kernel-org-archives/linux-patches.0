Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C937E258CD3;
	Tue, 24 Jun 2025 08:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750752464; cv=none; b=fpVbLgvi0w1pd3w03zRB3DHCWNN7hsr9JBhNV9wvcCslLgl6hbMausRXszVU+PHtCmEg5/0obCukex/ev7SzChBn8h645JcMpb0ZQIdWtt2wEZbfskHhKZGttz4ZiDqCT79i6Q/NBnG1Yx5xLPfElClat99P4msVX1Z02Fu9NYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750752464; c=relaxed/simple;
	bh=6pYHXVLAPGO4KYtYwQybK8pmthGSu74JcYRTxp+J5uI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Yjbic3yyeS4k5mhqrl755Ufw3HA/DY6iQreDtNMYsxyIIGZCB4alJ0tiBBjcjZA/mglfWdteS5rEF5lKj+YsLVvSJzjwVCJe0p5D9rGmE0VjB/WabGr3ntnVDUD8IVewPjU054PonDyFDAFr9auLGQ++AGyR8MPCm3psJys5q/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfeIK8js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfeIK8js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED230C4CEEF;
	Tue, 24 Jun 2025 08:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750752464;
	bh=6pYHXVLAPGO4KYtYwQybK8pmthGSu74JcYRTxp+J5uI=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=DfeIK8jsKuHTHYRq3TsjaggHEyPQOMo/uLmMrlxUetUUr4MBG8K1WGVU8lAloldW3
	 ez+a71RCEVyRTyBVbmG40eU9sdjDvME50u1mLKTTXhlxscFi5v63+AXbpdqaY4ho1+
	 TTbILob38ZK/yP9B/2ELMyTXGWbdyC2ERLqyHKz9wx9H8l990xseAnA/JteJQeCapK
	 Cdsr+ZdNuoLmMC3Bnzq/LviLtyKbbcD+3IggV7GfyxIvpOHcbtJBsyx3nHf2m5En6k
	 j/2AE7iY3J4mBKoVBv3IwSBnKstqepKJkjSRLa+ZoB10bY1cFWRA4tQt0p4cY9GHdd
	 79mV6m1MI2A4g==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Jun 2025 10:07:41 +0200
Message-Id: <DAULY9E26AKQ.3DCD5IW7CWUI7@kernel.org>
Cc: <patches@lists.linux.dev>, "Alice Ryhl" <aliceryhl@google.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Sasha Levin" <sashal@kernel.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Christian Heusel" <christian@heusel.eu>
Subject: Re: [PATCH 6.15 515/592] rust: devres: fix race in Devres::drop()
From: "Benno Lossin" <lossin@kernel.org>
To: "Thorsten Leemhuis" <linux@leemhuis.info>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250623130700.210182694@linuxfoundation.org>
 <20250623130712.686988131@linuxfoundation.org>
 <DAUALX71J38F.2E1VBF0YH27KQ@kernel.org>
 <eYjMg1ry65KlJgUKnqEjkoG6RkGBk1xtTYP1Af8fRBlrZyO8jOIrnAPs209lnvPqLwwwI0uQimzOx-EjmuhPEQ==@protonmail.internalid> <025d9611-2a7f-40fd-9124-7b62fe6c5e84@leemhuis.info>
In-Reply-To: <025d9611-2a7f-40fd-9124-7b62fe6c5e84@leemhuis.info>

On Tue Jun 24, 2025 at 9:24 AM CEST, Thorsten Leemhuis wrote:
> [CCing Miguel (JFYI) as well as Christian, who reported the build
> error[1] with 6.15.4-rc1 (which I'm seeing as well[2]) caused by the
> patch this mail is about according to Benno.]

Thanks!

> [1]=C2=A0https://lore.kernel.org/all/a0ebb389-f088-417b-9fd4-ac8c100d206f=
@heusel.eu/
>
> [2]=C2=A0https://download.copr.fedorainfracloud.org/results/@kernel-vanil=
la/fedora-rc/fedora-42-x86_64/09200694-stablerc-fedorarc-releases/builder-l=
ive.log.gz
>
> On 24.06.25 01:14, Benno Lossin wrote:
>> On Mon Jun 23, 2025 at 3:07 PM CEST, Greg Kroah-Hartman wrote:
>>> 6.15-stable review patch.  If anyone has any objections, please let me =
know.
>>>
>>> ------------------
>>>
>>> From: Danilo Krummrich <dakr@kernel.org>
>>>
>>> [ Upstream commit f744201c6159fc7323c40936fd079525f7063598 ]
>>>
>>> In Devres::drop() we first remove the devres action and then drop the
>>> wrapped device resource.
>>>
>>> The design goal is to give the owner of a Devres object control over wh=
en
>>> the device resource is dropped, but limit the overall scope to the
>>> corresponding device being bound to a driver.
>> [...]
>> This is missing the prerequisite patch #1 from
>>
>>     https://lore.kernel.org/all/20250612121817.1621-1-dakr@kernel.org
>
> You afaics mean 1b56e765bf8990 ("rust: completion: implement initial
> abstraction") [v6.16-rc3]=20

Yes that is the prerequisite.

> =E2=80=93 which did not cleanly apply to 6.15.4-rc1 in

In which repository is that tag? I didn't find it in the stable tree.

I tried applying it on top of v6.15.3 and that also results in a
conflict, but only in `bindgen_helpers.h` and `helpers.c`, so we can
simply provide a fixed patch.

@Danilo, I think this should be backported, how do you want to proceed?

---
Cheers,
Benno

> a quick test; it was also not possible to revert this patch ("rust:
> devres: fix race in Devres::drop()") cleanly; reverting worked after
> reverting "rust: devres: do not dereference to the internal Revocable"
> First, but that lead to another build error:
> https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora=
-rc/fedora-42-x86_64/09202837-stablerc-fedorarc-releases/builder-live.log.g=
z
>
> Ciao, Thorsten

