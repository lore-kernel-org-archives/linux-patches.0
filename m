Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD9412B94;
	Mon, 22 Jun 2026 01:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782091563; cv=none; b=ds7hBUkyox8BktkWGlwyyCyiynPUnVzT6tZ7jwCZDtHwqxoQ2rUaXWy2xTvC372jqO4NdDxs9Ryf/H+tn66vslFyc6XOoGXRrTS57aZ9UBsVyqQYsuGVaKM/KCisEerF78ZdT3LAKy9h4lp7TBW8UTkxUaj/TN7VxZYUtjprAtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782091563; c=relaxed/simple;
	bh=FYXFG0/TfrGv4Al8kmRQ7eXUqLItVkQl0lZqAhBTFm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwuXh0xiz6/Q4vIQzxkf/Jlhg+TmkagnAXJJVS/ByUOoMnYzEBfJZFAl82ytLwT/yZM7lDhhtJwW03JweYZTpOHZ2Z/frnhN+my3WYZQ4pQkhaOoQPWKLxS/Tr0wuHxfsB/dGZD0dTuVHeXgq9rakShaUv0Ef0rhY0Jo/+qo03Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFOwmDBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFOwmDBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278651F000E9;
	Mon, 22 Jun 2026 01:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782091561;
	bh=vBFFAv4vJY9m1MG+5W9luTeAXHDARWP5cNSg2vooz3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFOwmDBjjR11fKsVXuVmgdhFZnKk7RG5CjEKiNFukgYAkoBi2WBKHMMFHKttLyVRg
	 lBUVHP5I+5cJ2SoqWA+nFwfJSbcgIW2aDqylGEKMK6Y/R6sKc37T7g5fBJLuOG1//h
	 YjIqw5IujmMTnv6wyoBuqBu5aEEmjPiST3jWnw9nODD8H/BAllPj49XRupC05KKy+7
	 8h/AgwseMLDul5xdphUH689dFKka4bUa43vPqq/s3ZXsEEJnA6Gox3BpAabgwYU882
	 roTFeFsUa0sBL2zF7ZAZjSSYrcrGzJ+1bny8h3H/CZSeoR+fRx7xlBIz0BVMX2wLJw
	 JNgsBbIALVETw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 6.1 342/522] thermal: core: Fix thermal zone governor cleanup issues
Date: Sun, 21 Jun 2026 21:25:58 -0400
Message-ID: <20260621212034.0001.sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <42c2abbdfdd4ea8e234fbcfc4b37095ebd2c7b36.camel@decadent.org.uk>
References: <42c2abbdfdd4ea8e234fbcfc4b37095ebd2c7b36.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-06-21 at 17:29 +0200, Ben Hutchings wrote:
> > 	result = thermal_zone_create_device_groups(tz, mask);
> > -	if (result)
> > +	if (result) {
> > +		thermal_set_governor(tz, NULL);
> >  		goto remove_id;
> > +	}
>
> The order of initialisation in thermal_zone_device_register_with_trips()
> is quite different between 6.1 and mainline.  Clearing the governor here
> doesn't make sense as the governor has not been set yet.
>
> The proper place for this in 6.1 seems to be in the failure path after
> calling thermal_add_hwmon_sysfs().

Right... looks like it's just a noop.

Although it seems that  the leak it's meant to plug is still covered on the
affected path. When registration fails after thermal_add_hwmon_sysfs() (the
path where the governor *has* been set), the unwind goes through
device_unregister() -> put_device() -> thermal_release(), and the
thermal_release() hunk in this same backport adds thermal_set_governor(tz,
NULL) there:

> > 		tz = to_thermal_zone(dev);
> > 		thermal_zone_destroy_device_groups(tz);
> > +		thermal_set_governor(tz, NULL);
> > 		kfree(tz);

That is the same put_device->release mechanism mainline relies on, so
the governor is unbound before the thermal zone is freed and the leak
does not occur.

--
Thanks,
Sasha
