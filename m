Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF2124C06A;
	Tue,  8 Sep 2026 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788828845; cv=none; b=MkPMmBwJ9onctaVGZkUb3R3WUKRIUbLS+9C5zObOXltTnoBhDNBHRL/Uzl0a/ScOpS+gz6JPkhZkKJdOZ0cA0M42MZcNTf5vzRq45jlmIuxzPnrLjYAFJZ5eAb8I9uoj7moEFFdaL7hlPdixKrVPkWXA+2EEUC9tXW+GXEXkaNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788828845; c=relaxed/simple;
	bh=1Iu7DoHowKn9ALC/s694UHvSFpc8T9MqsZcApt6IuAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9341xzdZtLlLIH3+hjHWFyp3wTkGBFLXud9JNIKtlWCWZ5uvE+5W+X9D89BrBHxKDbz21u4kfuWT9chjH4ExUOQxLEYEqYhlRRz+vatKsWLC850fMSlV3sFgtnF9Vqwx0ZbamaNgEEnvxkjxWhRnLdA0zeD/awtcgb/ZXrOobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dk4/qUlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dk4/qUlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8A41F00A3D;
	Tue,  8 Sep 2026 00:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788828844;
	bh=hcmWYPENjv1Hni0riM35IOF3+58h8qJ6sMT/ksOUAs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dk4/qUlvpRSKY6m8/U4LQ8wxcGiKWBAo1+sGJyNVvPPoDTWBMNJnWO9iWovk3nIy+
	 JZo3mo6GXXO8ifMumvl2NV/A9xcwp/rOSsIyY38YbSMg1tKUenqc9EMDUq5e+kRDsM
	 yCNDhI5rkt6VR/tLFk9bfn66JLz8cEO71WB5fdO4Rv3TmPlxtG+PBJySxusFqypi/w
	 O+sbwixQsqF9B0UkBkMoO2bDcAprp6hU/HYU1jzTc6839/RFf84tLgz4T/SGIk901f
	 ODZ0EW9lRjfgDVTbQcSehkkJA+15ew42DVxmRZx911yRgqXV1uci1LDbVCnABW17Vx
	 XVl7NQuQGOS7w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	patches@lists.linux.dev,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 381/403] i3c: master: Fix potential UAF in i3c_device_uevent()
Date: Mon,  7 Sep 2026 20:53:40 -0400
Message-ID: <2026-09-07-daily-reply-0001-i3c-uaf-prereq@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c6a90e1e-371a-4905-9ecc-1784ad00aa03@intel.com>
References: <c6a90e1e-371a-4905-9ecc-1784ad00aa03@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> AFAICT it was queued normally and is in Linus' tree:
>
> 	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=456f832e5fc26fbfd3b8200fd4553eee520cc377

Right, it's upstream, but that's not the same as being queued in any
of our stable trees. I checked all seven active branches (7.2, 6.18,
6.12, 6.6, 6.1, 5.15, 5.10) and none of them carry it.

It's the first of a six commit i3c hardening series:

  456f832e5fc2 ("i3c: master: Fix recursive locking during device registration")
  8bed7f4fa710 ("i3c: Fix unlocked dereference of dev->desc in i3c_device_get_supported_xfer_mode()")
  4dc1b3eeba79 (...)
  feb0ed76601f (...)
  e5e8dd2e959f ("i3c: master: Fix potential UAF in i3c_device_uevent()")  <- the patch in question
  f44d3b15326c (...)

Of those, only 8bed7f4fa710 has landed anywhere (7.2 alone). Applying
e5e8dd2e959f on its own trades the UAF it fixes for an easily-triggered
recursive-rwsem deadlock on ordinary device bind/unbind, so I've
dropped it from all seven queues again.

Could you (or whoever's carrying the i3c tree) send a properly ordered
backport of the whole series instead of the single commit?

-- 
Thanks,
Sasha
