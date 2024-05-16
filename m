Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4108D4EB30;
	Thu, 16 May 2024 12:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715861462; cv=none; b=NJEgN3JvheBC3K+NqluY0aFrCLhiDMo9ckUrn6APmkK1C0GVKytgDHR4zqPthx5CIlZEzpFKgz4Ll0VDk3divwA4bWbmVohre0MqA6d7+0TvYYHs2Mrt8UG9Z4qSoODufC51QQx5fldU9M7QdJIohWjMVg6VY2bCb13MhfXZqME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715861462; c=relaxed/simple;
	bh=HKeG/Np/80+fRhUwiQBfGjpcGP9XvDW4eQ8HduuifDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4m3bM+9w62yd5nUnNAWvxeUZLF4kLsdGqhtZgil0av80FqnyrADwkVET9RZj5uuweGli8jz8aSsxIZ30NyOaKVP0OtNIArIomd0/HIXHFumaY9xkUl/W3Mx27F6cGKAf6+Sc7EfuXUlCVihyn3HN+HuAIe+/bGhXBn6+qc2qdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6s/wSdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6s/wSdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DE3C113CC;
	Thu, 16 May 2024 12:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715861461;
	bh=HKeG/Np/80+fRhUwiQBfGjpcGP9XvDW4eQ8HduuifDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p6s/wSdxvGXM713EnVGN/SKxKdsqajqEstVHjfe/EkqcR4OKwNWJ6Q3oB/jcxjJ1y
	 I1tH66EVMZVfmLsyx5uhq9esrNRiDg7qJDpUaPH2L67OQDaCtQtH8MY0GzJFxV4ezh
	 KJpZMjY1qqWvfuYmIouO3V0wkVLZVBbHmRjx9Exk=
Date: Thu, 16 May 2024 14:10:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
Message-ID: <2024051628-direness-grazing-d4ee@gregkh>
References: <20240515082517.910544858@linuxfoundation.org>
 <8221e12b-4def-4faf-84c6-f2fe208a4bf3@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8221e12b-4def-4faf-84c6-f2fe208a4bf3@sirena.org.uk>

On Wed, May 15, 2024 at 05:37:15PM +0100, Mark Brown wrote:
> On Wed, May 15, 2024 at 10:27:21AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.8.10 release.
> > There are 340 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I'm seeing issues with the ftrace "Test file and directory owership
> changes for eventfs" test on several platforms, including both 32 Arm
> and whatever random x86_64 box Linaro have in their lab.  The logs
> aren't terribly helpful since they just log a "not ok", example here:
> 
>   https://lava.sirena.org.uk/scheduler/job/265221#L3252
> 
> Bisects land on "eventfs: Do not differentiate the toplevel events
> directory" as having introduced the issue.  Other stables don't seem to
> be affected.
> 
> Bisect log (this one from a Raspberry Pi 3 in 32 bit mode):
> 
> # bad: [cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9] Linux 6.8.10-rc2
> # good: [f3d61438b613b87afb63118bea6fb18c50ba7a6b] Linux 6.8.9
> # good: [428b806127e00d1c39ed72cbae36dbb4598e58dd] usb: dwc3: core: Prevent phy suspend during init
> # good: [a336529a6498c3e7208415b1c2710872aebf04aa] drm/vmwgfx: Fix invalid reads in fence signaled events
> # good: [dcca5ac4f5de7cca371138049a4a5877a6a3af97] hv_netvsc: Don't free decrypted memory
> git bisect start 'cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9' 'f3d61438b613b87afb63118bea6fb18c50ba7a6b' '428b806127e00d1c39ed72cbae36dbb4598e58dd' 'a336529a6498c3e7208415b1c2710872aebf04aa' 'dcca5ac4f5de7cca371138049a4a5877a6a3af97'
> # bad: [cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9] Linux 6.8.10-rc2
> git bisect bad cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9
> # good: [00dfda4fc19df6f2235723e9529efa94cbc122a2] nvme-pci: Add quirk for broken MSIs
> git bisect good 00dfda4fc19df6f2235723e9529efa94cbc122a2
> # bad: [1239a1c5dc96166a0010de49e4769e08bc6d75b3] Bluetooth: qca: fix wcn3991 device address check
> git bisect bad 1239a1c5dc96166a0010de49e4769e08bc6d75b3
> # good: [a2ede3c7da39a8ab359cd23ebba04603e119ac59] ksmbd: do not grant v2 lease if parent lease key and epoch are not set
> git bisect good a2ede3c7da39a8ab359cd23ebba04603e119ac59
> # bad: [21b410a9ae24348d143dbfe3062eae67d52d5a76] eventfs: Do not differentiate the toplevel events directory
> git bisect bad 21b410a9ae24348d143dbfe3062eae67d52d5a76
> # good: [801cdc1467e661f2b151eeb8a25042593a487c78] tracefs: Still use mount point as default permissions for instances
> git bisect good 801cdc1467e661f2b151eeb8a25042593a487c78
> # first bad commit: [21b410a9ae24348d143dbfe3062eae67d52d5a76] eventfs: Do not differentiate the toplevel events directory

Thanks for the bisection, I'll go drop this from 6.8 and 6.6 queues.

Hopefully 6.9 doesn't also have this issue.

greg k-h
