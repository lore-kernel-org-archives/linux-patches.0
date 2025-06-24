Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05D018C00;
	Tue, 24 Jun 2025 09:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750755826; cv=none; b=UgY2b8cC8ZAtqga3+q4y2mte3Ag8CZ0qZKbue1mZUvZXrlx4RFZ6LTbODxHfss+OScHNvapEICQrnqzgZovUJEm4n8iO8gbyZ3sqNEVr/WJI7izey+N3PM++WzggZ/ARTDNw/pYZf8dYxejbZUUOGADOEd0/1z71m6kivHT9WMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750755826; c=relaxed/simple;
	bh=v154ws9H9DmOUPwB45+yhb7pNSKwUUEUO0Rtbvnx/r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOtOeb5OVCytcYQcaC8Lvj1gWQnEb6byQrCj4463xWSwC3R3C2DXF0CJcJTOhfjCK6lHCWK85ahBoXvsAzZ1wQdmHGzXuG7msBjTjVnGtXvCXG63MWxf2HEvhUf6caCR7iGSrhUE/foBQRCyxMNtRW7vI4+zbq8ceXXiElOsgKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhPqG5sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhPqG5sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A585CC4CEE3;
	Tue, 24 Jun 2025 09:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750755826;
	bh=v154ws9H9DmOUPwB45+yhb7pNSKwUUEUO0Rtbvnx/r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zhPqG5sIRp6RoL0fE6rmcW15gi6cpdMiSjqdu1MHPeqKpGQcg4jHPCEDYs2o4nOK+
	 GMYsCeL9wR+aby5QsdiKgR3Z2XCGeLVUIFeHjTF89fW/ICP4KpCTx/uUbd6+D6QO8Y
	 W0Vn5oGYbh1sZitMHOk3tImjqXCU+5oRnP+TqfqE=
Date: Tue, 24 Jun 2025 10:03:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Benno Lossin <lossin@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Christian Heusel <christian@heusel.eu>
Subject: Re: [PATCH 6.15 515/592] rust: devres: fix race in Devres::drop()
Message-ID: <2025062439-scheming-scale-7ab0@gregkh>
References: <20250623130700.210182694@linuxfoundation.org>
 <20250623130712.686988131@linuxfoundation.org>
 <DAUALX71J38F.2E1VBF0YH27KQ@kernel.org>
 <eYjMg1ry65KlJgUKnqEjkoG6RkGBk1xtTYP1Af8fRBlrZyO8jOIrnAPs209lnvPqLwwwI0uQimzOx-EjmuhPEQ==@protonmail.internalid>
 <025d9611-2a7f-40fd-9124-7b62fe6c5e84@leemhuis.info>
 <DAULY9E26AKQ.3DCD5IW7CWUI7@kernel.org>
 <ae03cf82-dfda-46fc-914d-2e329cd8d3da@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae03cf82-dfda-46fc-914d-2e329cd8d3da@leemhuis.info>

On Tue, Jun 24, 2025 at 10:24:46AM +0200, Thorsten Leemhuis wrote:
> On 24.06.25 10:07, Benno Lossin wrote:
> > On Tue Jun 24, 2025 at 9:24 AM CEST, Thorsten Leemhuis wrote:
> >> [CCing Miguel (JFYI) as well as Christian, who reported the build
> >> error[1] with 6.15.4-rc1 (which I'm seeing as well[2]) caused by the
> >> patch this mail is about according to Benno.]
> > Thanks!
> > 
> >> On 24.06.25 01:14, Benno Lossin wrote:
> >>> On Mon Jun 23, 2025 at 3:07 PM CEST, Greg Kroah-Hartman wrote:
> >>>> 6.15-stable review patch.  If anyone has any objections, please let me know.
> >>>>
> >>>> ------------------
> >>>>
> >>>> From: Danilo Krummrich <dakr@kernel.org>
> >>>>
> >>>> [ Upstream commit f744201c6159fc7323c40936fd079525f7063598 ]
> >>>>
> >>>> In Devres::drop() we first remove the devres action and then drop the
> >>>> wrapped device resource.
> >>>>
> >>>> The design goal is to give the owner of a Devres object control over when
> >>>> the device resource is dropped, but limit the overall scope to the
> >>>> corresponding device being bound to a driver.
> >>> [...]
> >>> This is missing the prerequisite patch #1 from
> >>>
> >>>     https://lore.kernel.org/all/20250612121817.1621-1-dakr@kernel.org
> >>
> >> You afaics mean 1b56e765bf8990 ("rust: completion: implement initial
> >> abstraction") [v6.16-rc3] 
> > 
> > Yes that is the prerequisite.
> > 
> >> – which did not cleanly apply to 6.15.4-rc1 in
> > 
> > In which repository is that tag? I didn't find it in the stable tree.
> 
> Use this tree and branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/log/?h=linux-6.15.y
> 
> There sadly is no tag ("send a patch to Greg's rc-release scripts to
> make them tag -rc releases" is somewhere near the end of my todo list
> for a while already...).
> 
> > I tried applying it on top of v6.15.3 and that also results in a
> > conflict, but only in `bindgen_helpers.h` and `helpers.c`, so we can
> > simply provide a fixed patch.
> 
> Yeah, that likely is needed to make Greg happy here.

For now I'll just go drop this commit and wait for it to be submitted in
a series that actually builds.

And I need to go fix my test-server to actually build the rust code, I
didn't realize that wasn't happening and is a huge gap in my test
builds...

thanks,

greg k-h
