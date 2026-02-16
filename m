Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C12A3148D3;
	Mon, 16 Feb 2026 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771256149; cv=none; b=g+r6i7480CTHUzvuWLudKm3g8Dwuzbp/OvDTNKYEzlssG7ihmsDowmgAoSb6apPV1A5O19p7ctfx0ramezMZ2pQowDInqYfdE2HxYDM2OI+sGRx2db5z9xaQiBJfvbW2DGwlqKhpjaKrhA6/9/U7FE1+J3mJZWpZ0B7uwdeujE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771256149; c=relaxed/simple;
	bh=iV+VYj0VTk7PkJDImMNGk258HrLM/fVa+DmkjNXGyno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sm2kWOhdf7l3xJj5gRrT1BmZm9KhSRtXAU4NEVajXcNwDZmK6pNMDpb5qQ0y8+dD4+F5KTrElFF3w+a4w78i6aX6tPgZQ8ZznDbUJqvjsYDHYQkziQLJ89l+EUzQ0yuHl+SW/RLKH926NnaO9MHrUO4YJkDJ8kQMMFJYCurDe+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhEe/lLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhEe/lLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4ADC19424;
	Mon, 16 Feb 2026 15:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771256148;
	bh=iV+VYj0VTk7PkJDImMNGk258HrLM/fVa+DmkjNXGyno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yhEe/lLe2PXJHS2e2naAiIPT9ruit1Sxyxyb2OFocyJrOTMkV1Rvzcv1x2gqKj/rS
	 qJLesYqPTMuXfspAi4CoTiGe0v8DnwyrijiNDAclBnZW98LlJ7HxZOje/3QNOFzTw4
	 Eki0k44uWdcK5tzl7P8wYhD1fNC6YnMIKRJuG9h8=
Date: Mon, 16 Feb 2026 16:35:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
Message-ID: <2026021613-manila-neuter-32c7@gregkh>
References: <20260213134704.728003077@linuxfoundation.org>
 <bde6d2f9-f554-49f1-9af8-084c4cdea035@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bde6d2f9-f554-49f1-9af8-084c4cdea035@sirena.org.uk>

On Mon, Feb 16, 2026 at 02:27:54PM +0000, Mark Brown wrote:
> On Fri, Feb 13, 2026 at 02:48:19PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.72 release.
> > There are 24 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> As I've mentioned before putting -rcs out on a Friday afternoon isn't
> ideal for getting results...
> 
> > Gui-Dong Han <hanguidong02@gmail.com>
> >     driver core: enforce device_lock for driver_match_device()
> 
> This breaks boot on at least the Arm Juno platform, upstream it
> introduced regressions on quite a few systems due to drivers registering
> in the probe of other devices.  That's obviously not a great pattern but
> a regreession is a regression.
> 
> bisect:
> 
> # bad: [4b487d46d595999554fb81524f66ed3d1a73b615] Linux 6.12.72-rc1
> # good: [ae591174b1f2e6b81ffe182fb621bba910bfb44e] Linux 6.12.71
> git bisect start '4b487d46d595999554fb81524f66ed3d1a73b615' 'ae591174b1f2e6b81ffe182fb621bba910bfb44e'
> # test job: [4b487d46d595999554fb81524f66ed3d1a73b615] https://lava.sirena.org.uk/scheduler/job/2455882
> # bad: [4b487d46d595999554fb81524f66ed3d1a73b615] Linux 6.12.72-rc1
> git bisect bad 4b487d46d595999554fb81524f66ed3d1a73b615
> # test job: [b3b78ed0290627689bb76932b290f649d7a55ea7] https://lava.sirena.org.uk/scheduler/job/2456102
> # bad: [b3b78ed0290627689bb76932b290f649d7a55ea7] wifi: rtw88: Fix alignment fault in rtw_core_enable_beacon()
> git bisect bad b3b78ed0290627689bb76932b290f649d7a55ea7
> # test job: [5be98c74259c3e953c4eb9989166b5b5225196a6] https://lava.sirena.org.uk/scheduler/job/2456393
> # bad: [5be98c74259c3e953c4eb9989166b5b5225196a6] crypto: iaa - Fix out-of-bounds index in find_empty_iaa_compression_mode
> git bisect bad 5be98c74259c3e953c4eb9989166b5b5225196a6
> # test job: [c9e18834e4b2f69c0b1798440b9d531109cc16f2] https://lava.sirena.org.uk/scheduler/job/2456585
> # good: [c9e18834e4b2f69c0b1798440b9d531109cc16f2] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
> git bisect good c9e18834e4b2f69c0b1798440b9d531109cc16f2
> # test job: [c34376e5a52a35ade9960d259ca1e8910db72013] https://lava.sirena.org.uk/scheduler/job/2456855
> # bad: [c34376e5a52a35ade9960d259ca1e8910db72013] Bluetooth: btusb: Add USB ID 7392:e611 for Edimax EW-7611UXB
> git bisect bad c34376e5a52a35ade9960d259ca1e8910db72013
> # test job: [3454ada4952bf8ac7c9a7b6aec0e18aa87226170] https://lava.sirena.org.uk/scheduler/job/2457085
> # bad: [3454ada4952bf8ac7c9a7b6aec0e18aa87226170] driver core: enforce device_lock for driver_match_device()
> git bisect bad 3454ada4952bf8ac7c9a7b6aec0e18aa87226170
> # first bad commit: [3454ada4952bf8ac7c9a7b6aec0e18aa87226170] driver core: enforce device_lock for driver_match_device()


Argh, I forgot about that "issue".

Ok, let me go push out new releases with this reverted, and drop it from
the older stable kernels, as this isn't a good idea at the moment.

thanks,

greg k-h
