Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C4D14AD2B;
	Tue, 25 Jun 2024 12:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319944; cv=none; b=TvPL9YRLuflMiVj/FA7qhZHt44ZxPjlpTczcY8TX5NTJQxlm0k7kzuqHFfywHug/DzJXzZGxzpWaV3Zhib97XBL/mZ1A5UW/RU1jF2BsGep1MuPqJub6UjiaDmv/uu7Smg9pR70afAVR5l0ipH6UeQD2cHHYnTzU6R/u7LUsjog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319944; c=relaxed/simple;
	bh=DqQkhxxkF1ywIPNKmbIKr6300vxrVQAt7ItYkuvNEAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRmfUNAGMUvXYQbQL3RoqsyBnW3I6BziWjzlu+6vHWtIOBGSVwewaYcxwHgBpkE3X8TKsAbIQ3X4qdjn4k/LV1AUcQQn8ZAKxWX3VPVBPAn/W4O+s9GroWMwVMoTf9t9i9W/I44vKsj9h+Ah3jyK1EEsxvX41iy2ryXlis6JnXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRERz4i2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRERz4i2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E74C32786;
	Tue, 25 Jun 2024 12:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719319944;
	bh=DqQkhxxkF1ywIPNKmbIKr6300vxrVQAt7ItYkuvNEAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MRERz4i2elIBflylaPuoLgJWScA/nqp4di5FDIxkpNx29rVftPVpGXEPZnq6d8eho
	 wqgdPWNiKfxhsdC5aa5+7qIl0eOLjI2vHiRolQmXwdNGo/N3j/4bVWU/7b3XZDlCVK
	 UDn7LneZqBGKIXTY2yeYhog+4+x9NerBI4ExbCew=
Date: Tue, 25 Jun 2024 14:52:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>, Dave Airlie <airlied@gmail.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	tursulin@ursulin.net, Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Message-ID: <2024062537-panorama-sled-3025@gregkh>
References: <20240619125609.836313103@linuxfoundation.org>
 <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk>
 <2024061946-salvaging-tying-a320@gregkh>
 <ZnqyFRf9zPa4kfwL@intel.com>
 <2024062502-corporate-manned-1201@gregkh>
 <87ed8ldwjv.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ed8ldwjv.fsf@intel.com>

On Tue, Jun 25, 2024 at 03:41:24PM +0300, Jani Nikula wrote:
> On Tue, 25 Jun 2024, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jun 25, 2024 at 08:03:33AM -0400, Rodrigo Vivi wrote:
> >> On Wed, Jun 19, 2024 at 04:16:56PM +0200, Greg Kroah-Hartman wrote:
> >> > On Wed, Jun 19, 2024 at 04:03:29PM +0200, Francois Dugast wrote:
> >> > > On Wed, Jun 19, 2024 at 02:53:52PM +0200, Greg Kroah-Hartman wrote:
> >> > > > 6.9-stable review patch.  If anyone has any objections, please let me know.
> >> > > 
> >> > > Hi Greg,
> >> > > 
> >> > > This patch seems to be a duplicate and should be dropped.
> >> 
> >> Please also drop the 6.9.7-rc1:
> >> 
> >> https://lore.kernel.org/stable/20240625085557.190548833@linuxfoundation.org/T/#u
> >
> > Done.
> >
> >> > How are we supposed to be able to determine this?
> >> > 
> >> > When you all check in commits into multiple branches, and tag them for
> >> > stable: and then they hit Linus's tree, and all hell breaks loose on our
> >> > scripts.  "Normally" this tag:
> >> > 
> >> > > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> >> > 
> >> > Would help out here, but it doesn't.  
> >> 
> >> I wonder if there would be a way of automate this on stable scripts
> >> to avoid attempting a cherry pick that is already there.
> >
> > Please tell me how to do so.
> >
> >> But I do understand that any change like this would cause a 'latency'
> >> on the scripts and slow down everything.
> >
> > Depends, I already put a huge latency on drm stable patches because of
> > this mess.  And I see few, if any, actual backports for when I report
> > FAILED stable patches, so what is going to get slower than it currently
> > is?
> >
> >> > Why not, what went wrong?
> >> 
> >> worst thing in this case is that git applied this cleanly, although
> >> the change was already there.
> >
> > Yup.
> >
> >> But also a timing thing. The faulty patch was already in the master.
> >> At the moment we applied the fix in our drm-xe-next, we had already
> >> sent the latest changes to the upcoming merge-window, so it propagated
> >> there as a cherry-pick, but we had to also send to the current -rc
> >> cycle and then the second cherry-pick also goes there.
> >> 
> >> This fast propagation to the current active development branch in general
> >> shouldn't be a problem, but a good thing so it is ensured that the fix
> >> gets quickly there. But clearly this configure a problem to the later
> >> propagation to the stable trees.
> >
> > Normally you all tag these cherry-picks as such.  You didn't do that
> > here or either place, so there was no way for anyone to know.  Please
> > fix that.
> >
> >> > I'll go drop this, but ugh, what a mess. It makes me dread every drm
> >> > patch that gets tagged for stable, and so I postpone taking them until I
> >> > am done with everything else and can't ignore them anymore.
> >> > 
> >> > Please fix your broken process.
> >> 
> >> When you say drm, do you have same problem with patches coming from
> >> other drm drivers, drm-misc, or is it really only Intel trees?
> >> (only drm-intel (i915) and drm-xe)?
> >
> > Intel trees have traditionally been the worst, but normally you all give
> > me some cherry-pick clue on the commits so I can weed them out.  That
> > didn't happen here.
> >
> > But, I will note that the AMD drm tree is now starting to do this, in
> > much worse ways than the Intel tree because there is NO cherry-pick
> > information anywhere, so again, I have no idea what to do and massive
> > conflicts happen.
> >
> > So AMD is copying your bad behavior, please, both of you stop and fix
> > this so that it isn't so broken.
> >
> > Again, I understand the need/want to have multiple versions of the same
> > patch in different branches to get fixes merged quicker, but when you do
> > that, please give me a way to determine this, otherwise we have no
> > chance.
> 
> To be fair, this one seems to have been an accident. The same commit was
> cherry-picked to *two* different branches by two different people
> [1][2], and this is something we try not to do. Any cherry-picks should
> go to one tree only, it's checked by our scripts, but it's not race free
> when two people are doing this roughly at the same time.

any cherry-pick SHOULD have the git id referenced when they are
cherry-picked, that's what the id is there for.  Please always do that.

greg k-h
