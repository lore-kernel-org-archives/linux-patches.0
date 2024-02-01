Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1A35D499;
	Thu,  1 Feb 2024 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706797530; cv=none; b=eFVJ8p2pMuEOMJnV6KZCboBPEqVIDXeGZhtkMIzEWAI4CG+eo/xlxzSsQlrdV/Glrk8AJgbd5/jiPZcb7Npen/6qJiLpPRZJlqWiXQNRZEThQzwFogb7mNQgdWMLrRAOhowK8OYq934+/hZ6yBskaevlLthCpVhaQ1RqbOpBjsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706797530; c=relaxed/simple;
	bh=Tc1q8mjPtCgOSh78OFaiCgOqBeN67OIG9tH1WHRKm4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVhUz4rWPxnbJgKVrRbjGBCZveAgZjBwCOrZDx02Ec9vaPm3ZrD0K2sWePHh+yHKrdYMEcgAHn3Qh4lzVX/pwbtqb1BP8KyvrWL7HzL0bJxwcCDs/qKulBOybjkpid6aGfkEDD9q+aB0IRZ7OnDphdHDuxwx8iAWXffo7WxREn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9U4L6Fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9U4L6Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95E2C433C7;
	Thu,  1 Feb 2024 14:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706797530;
	bh=Tc1q8mjPtCgOSh78OFaiCgOqBeN67OIG9tH1WHRKm4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o9U4L6Fko7zdTZUOWhSC6Dujducx5fzwDJUVwEh20p0ehXwrhj4+owPy+cFFv/LiZ
	 k0MJ5vC7AmmSfSYH4xk/sBGpt4ar7YCLz1z0ET2lYtNTmFcuyvVyWXtQK4YXAm9nbV
	 h9SFMlTq4ZY/Giy0uyOcUWZAY+KTDZ+aP1TFOmuA=
Date: Thu, 1 Feb 2024 06:25:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Justin Forbes <jforbes@fedoraproject.org>
Cc: Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command
 injection
Message-ID: <2024020151-purchase-swerve-a3b3@gregkh>
References: <20240129170014.969142961@linuxfoundation.org>
 <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org>
 <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>

On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
> On Tue, Jan 30, 2024 at 10:21 AM Jonathan Corbet <corbet@lwn.net> wrote:
> >
> > Justin Forbes <jforbes@fedoraproject.org> writes:
> >
> > > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrote:
> > >> 6.6-stable review patch.  If anyone has any objections, please let me know.
> > >>
> > >> ------------------
> > >>
> > >> From: Vegard Nossum <vegard.nossum@oracle.com>
> > >>
> > >> [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
> > >>
> > >> The kernel-feat directive passes its argument straight to the shell.
> > >> This is unfortunate and unnecessary.
> > >>
> > >> Let's always use paths relative to $srctree/Documentation/ and use
> > >> subprocess.check_call() instead of subprocess.Popen(shell=True).
> > >>
> > >> This also makes the code shorter.
> > >>
> > >> This is analogous to commit 3231dd586277 ("docs: kernel_abi.py: fix
> > >> command injection") where we did exactly the same thing for
> > >> kernel_abi.py, somehow I completely missed this one.
> > >>
> > >> Link: https://fosstodon.org/@jani/111676532203641247
> > >> Reported-by: Jani Nikula <jani.nikula@intel.com>
> > >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> > >> Cc: stable@vger.kernel.org
> > >> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > >> Link: https://lore.kernel.org/r/20240110174758.3680506-1-vegard.nossum@oracle.com
> > >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> > >
> > > This patch seems to be missing something. In 6.6.15-rc1 I get a doc
> > > build failure with:
> > >
> > > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.15-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133: SyntaxWarning: invalid escape sequence '\.'
> > >   line_regex = re.compile("^\.\. LINENO ([0-9]+)$")
> >
> > Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Python
> > string escapes).  That is not a problem with this patch, though; I would
> > expect you to get the same error (with Python 3.12) without.
> 
> Well, it appears that 6.6.15 shipped anyway, with this patch included,
> but not with 86a0adc029d3.  If anyone else builds docs, this thread
> should at least show them the fix.  Perhaps we can get the missing
> patch into 6.6.16?

Sure, but again, that should be independent of this change, right?

thanks,

greg k-h


> 
> Jusitn
> 
> > Thanks,
> >
> > jon
> >
> 
