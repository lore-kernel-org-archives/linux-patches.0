Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED1B1872
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 17:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF62EC3411E;
	Sun, 10 Jul 2022 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657472400;
	bh=WVQuFo8zHmVlpglag2kHdgvVIfeY7YJ/1E69jk34LHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f4bfUNINCx2KcEv9CW5jU59H+sRpmJ9q1Ea/UQIjslQpNbWUqJRss/KQzsyp1p+n4
	 a7HvUp4NRlqM/7Ux8XvMScu9TbNAc7AtJ3l3eYbWGFX3gEFaM1QiTkA5kB0VED5XUC
	 cenB/cxGt66Qbl5vXb11jt+nyVscc94t54gT4G4A=
Date: Sun, 10 Jul 2022 18:59:57 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, ashok.raj@intel.com,
	tony.luck@intel.com, ravi.v.shankar@intel.com,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2] platform/x86/intel/ifs: Allow non-default names for
 IFS image
Message-ID: <YssFjbveghDLNn4N@kroah.com>
References: <20220710160011.995800-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220710160011.995800-1-jithu.joseph@intel.com>

On Sun, Jul 10, 2022 at 09:00:11AM -0700, Jithu Joseph wrote:
> Existing implementation limits IFS images to be loaded only from
> a default file-name /lib/firmware/intel/ifs/ff-mm-ss.scan.

That was by design, why is this suddenly not acceptable?

> But there are situations where there may be multiple scan files
> that can be run on a particular system stored in /lib/firmware/intel/ifs

Again, this was by design.

> E.g.
> 1. Because test contents are larger than the memory reserved for IFS by BIOS

What does the BIOS have to do with this?

> 2. To provide increased test coverage

Test coverage of what?

> 3. Custom test files to debug certain specific issues in the field

Why can't you rename the existing file?

> Renaming each of these to ff-mm-ss.scan and then loading might be
> possible in some environments. But on systems where /lib is read-only
> this is not a practical solution.

What system puts /lib/ as read-only that you want to have loading
hardware firmware?  That kind of defeats the security implications of
having a read-only /lib/, right?

> Modify the semantics of the driver file
> /sys/devices/virtual/misc/intel_ifs_0/reload such that,
> it interprets the input as the filename to be loaded.

So you are now going to allow any file to be read from the system, in an
unknown filesystem namespace, by this driver?  How wise is that?  How
much has this been fuzzed and tested to ensure that it can not now be
instantly abused by anyone with access to this sysfs file?

Be aware that most systems have now locked down the ability for
userspace to pick filenames for stuff like this for good reason.  This
feels like a step backwards from those protections.  Are you _SURE_ you
want to do this?

> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index 73c8e91cf144..577cee7db86a 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -34,12 +34,13 @@
>   * socket in a two step process using writes to MSRs to first load the
>   * SHA hashes for the test. Then the tests themselves. Status MSRs provide
>   * feedback on the success/failure of these steps. When a new test file
> - * is installed it can be loaded by writing to the driver reload file::
> + * is installed it can be loaded by writing the filename to the driver reload file::
>   *
> - *   # echo 1 > /sys/devices/virtual/misc/intel_ifs_0/reload
> + *   # echo mytest > /sys/devices/virtual/misc/intel_ifs_0/reload
>   *
> - * Similar to microcode, the current version of the scan tests is stored
> - * in a fixed location: /lib/firmware/intel/ifs.0/family-model-stepping.scan
> + * The file will be loaded from /lib/firmware/intel/ifs/mytest
> + * The default file /lib/firmware/intel/ifs/family-model-stepping.scan
> + * will be loaded during module insertion.

So you have a default directory, what happened to your read-only /lib/ ?

This also does not properly document what the kernel code does.

{sigh}

Please do not rush this, it's not acceptable as-is at all.

> --- a/Documentation/ABI/testing/sysfs-platform-intel-ifs
> +++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
> @@ -35,5 +35,4 @@ What:		/sys/devices/virtual/misc/intel_ifs_<N>/reload
>  Date:		April 21 2022
>  KernelVersion:	5.19
>  Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
> -Description:	Write "1" (or "y" or "Y") to reload the IFS image from
> -		/lib/firmware/intel/ifs/ff-mm-ss.scan.
> +Description:	Write <file_name> to reload the IFS image from /lib/firmware/intel/<file_name>.

"reload" should not be for specifying the filename, please use a sane
interface instead of this overloading logic.

greg k-h
