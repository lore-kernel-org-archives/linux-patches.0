Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EB22560
	for <patches@lists.linux.dev>; Fri, 17 Feb 2023 09:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBF1C433EF;
	Fri, 17 Feb 2023 09:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676625912;
	bh=NThfZIOw43ISCQBxVEa8Vm7Fa2T1LWxfMFodAp2xP6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HDYaknk9HFjP3bNtqcHsOTXQ9xvzUyKXs2kseGF5aInAaDJGSUu6Oh2ZDLHZmSbIA
	 8XUqaYBGXbg34VQ5SPTT8HXqej0aQ4+/gHnUKa7lJlJCUoL4ARt0FT1zSsGqmgheqC
	 50k3tHKHv0DX43dyPoEO7ec5V574FUon609smc7w=
Date: Fri, 17 Feb 2023 10:25:10 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rostedt@goodmis.org,
	ashok.raj@intel.com, tony.luck@intel.com,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev, ravi.v.shankar@intel.com,
	thiago.macieira@intel.com, athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: Re: [PATCH v2 2/7] platform/x86/intel/ifs: Introduce Array Scan test
 to IFS
Message-ID: <Y+9H9otxLYPqMkUh@kroah.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230214234426.344960-3-jithu.joseph@intel.com>
 <Y+4kQOtrHt5pdsSO@kroah.com>
 <4e5cebd0-815e-e3ca-7068-4d665d337bf2@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5cebd0-815e-e3ca-7068-4d665d337bf2@intel.com>

On Thu, Feb 16, 2023 at 02:57:13PM -0800, Joseph, Jithu wrote:
> On 2/16/2023 4:40 AM, Greg KH wrote:
> >> +		ifs_devices[i].data.pkg_auth = kmalloc_array(topology_max_packages(),
> >> +							     sizeof(bool), GFP_KERNEL);
> >> +		if (!ifs_devices[i].data.pkg_auth)
> >> +			continue;
> > 
> > You have a static array of a structure that contains both things that
> > describe the devices being used, as well as dynamic data with no real
> > lifespan rules.  Please don't perputate this common design pattern
> > mistake.
> > 
> > Always try to make static data constant and make dynamic data dynamic
> > with proper reference counted lifetime rules.  People converting this
> > code into rust in the future will thank you :)
> 
> I may not have fully understood your comment. So pardon me if the following description
> on the lifecycle of the dynamic allocated memory is not to the point.
> 
> The lifetime of this allocation matches the load time of the driver (allocated on init, freed on exit).
> There are no further / allocations or freeing anywhere within the driver.
> There is only a single place where this memory is used, whose access is serialized via a semaphore.

But the memory is associated with "something" that has a lifetime,
right?  This is either a misc device, or a cpu, or a platform device, or
something that you have to determine that you need to allocate it.

So use that as the thing you hang your dynamic data off of, don't use a
static array.  Allow that static array to be put into read-only memory
(i.e. it is const and can not be changed by your code accidentally or on
purpose.)

Does that help explain things better?

thanks,

greg k-h
