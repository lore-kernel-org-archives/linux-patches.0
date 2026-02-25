Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F49A1EA7CB;
	Wed, 25 Feb 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772031062; cv=none; b=hoBS9kj4XxaZ7f3GkRc6DrJDZ026Wm5MgrOFAdkv29qhQe3eWKpo9GH9QYAcLECjofxvigm3d2A7uP4PTOmM39GBY4NjL/7QOd/HA4adNPD35WTq/MMyHoTnRS1A/M3pf7pJVchzlDsgWb3ehFVQONBFiRsQS+ug46IgahzU4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772031062; c=relaxed/simple;
	bh=J6QMbiY4SNwOYRDX65ZiPX7WLszOBPYX6J+ex82C6Qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVdcjpP1uDfRuxudhLt1QlAcPXqW+W1e/QCrv8TGXmVIFnEnMynC4IMC8sBmkN00nGN+NqJ4RCJST4EIW172rOT0zuO+1SPqoaxkwf0dYB7R7fLuTnhurb99yuiKVm2Pnu2iWJmENh5ySJpASivvTv2y8/Qgear42qsmuEYn/cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubWX7e4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubWX7e4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A992FC116D0;
	Wed, 25 Feb 2026 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772031061;
	bh=J6QMbiY4SNwOYRDX65ZiPX7WLszOBPYX6J+ex82C6Qw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ubWX7e4Fxzr2+S0Ozuo5kxhBCcLxBYfyKEd+cb3UqFymivoD08mJHFeEJmcr/ybhb
	 UWa9e5vFogxTxC+PJoCjlxLEtF8UL0qIRsjMOq/DXpKYniMn1lB8zV1QearKcrNYkz
	 +bnoivw3sR0c6WgxyV+LAZ5iNBB2zAsza7vsnOPE=
Date: Wed, 25 Feb 2026 06:50:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Vacek <neelx@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 026/641] btrfs: add orig_logical to btrfs_bio for
 encryption
Message-ID: <2026022525-bok-amusing-aa38@gregkh>
References: <20260225012348.915798704@linuxfoundation.org>
 <20260225012349.617596661@linuxfoundation.org>
 <CAPjX3Fe8XOkja2L8dv30s4pnzSQDsAExXY5Nh8MFQoPreQUeAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPjX3Fe8XOkja2L8dv30s4pnzSQDsAExXY5Nh8MFQoPreQUeAQ@mail.gmail.com>

On Wed, Feb 25, 2026 at 07:15:16AM +0100, Daniel Vacek wrote:
> On Wed, 25 Feb 2026 at 02:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi Greg,
> 
> This one is a preparation for new feature development, it's not really
> worth the stable branch. Backporting it makes no sense.
> 
> Have a nice day,
> Daniel
> 
> > ------------------
> >
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > [ Upstream commit bd45e9e3f6232f76fa9bd0e40c1e3409e4449f5e ]
> >
> > When checksumming the encrypted bio on writes we need to know which
> > logical address this checksum is for.  At the point where we get the
> > encrypted bio the bi_sector is the physical location on the target disk,
> > so we need to save the original logical offset in the btrfs_bio.  Then
> > we can use this when checksumming the bio instead of the
> > bio->iter.bi_sector.
> >
> > Note: The patch was taken from v5 of fscrypt patchset
> > (https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/)
> > which was handled over time by various people: Omar Sandoval, Sweet Tea
> > Dorminy, Josef Bacik.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > [ add note ]
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > Stable-dep-of: b39b26e017c7 ("btrfs: zoned: don't zone append to conventional zone")

It was added because of the requirement for this backport.  Let me see
if that can't be done without this change first...

yup, that still worked, just a bit of fuzz, now dropped, thanks!

greg k-h
