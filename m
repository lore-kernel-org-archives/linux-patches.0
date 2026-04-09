Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D004E3A3819;
	Thu,  9 Apr 2026 08:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775723217; cv=none; b=O9MnEZ1iNmbXwo4hFGQ13zYDMql6e1lQ2vvmZ78bMnnt3WsyV5gVRtRGUI+oKdwfNTe2wKAl/yWjUy+Xa6R/AaiZdxt9Nu5Ed6W+nr6bwwzIRio4TfKKgCNG3YXytmP8hYUd/1Xt2nyFthmspPxLCXRcPNhi0Zv7AeyyAfg8dyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775723217; c=relaxed/simple;
	bh=9K7zVcBKbmK8zs2sb28tSLclXGZNip32Ovu4hatjcBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCeJx/UendXIBxPnJ0LGKELIX8oNVc4pqCUJ4k8vYoxYAf1AN0Tv/YV6W5bK863y8d+3FMzQoT/j75jt8p/Myut1YLajd8TZ3rZSsSboT2y7PWBlbLgC/psA39YTaJpBp7PRLojBH2/+XWvCNdj2AU9YQ5BdANbLRspH5fJANBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nALTtJNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nALTtJNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2C5C4CEF7;
	Thu,  9 Apr 2026 08:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775723217;
	bh=9K7zVcBKbmK8zs2sb28tSLclXGZNip32Ovu4hatjcBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nALTtJNCZh54B3ij776Vrt/YLuRFgrlCwfQCGzZpBHzuvfF6ZH+omrlQDtf7IExkD
	 UZh1ZVqb7lnD4SPW2rn0/7S7BnAOtPLdB1q+RUiM7XpINc7LYcO2ovKEs15XCeKTlH
	 RxWtRbU+SIWsn7XJIbOwr5ex8DOQmm2sKQCK8uB4=
Date: Thu, 9 Apr 2026 10:26:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 6.19 248/311] x86/platform/geode: Fix on-stack property
 data use-after-return bug
Message-ID: <2026040926-pregnancy-altitude-5d24@gregkh>
References: <20260408175939.393281918@linuxfoundation.org>
 <20260408175948.651696885@linuxfoundation.org>
 <bfda5183-df4b-4f7a-b867-031f046aa2ee@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfda5183-df4b-4f7a-b867-031f046aa2ee@kernel.org>

On Thu, Apr 09, 2026 at 10:09:59AM +0200, Jiri Slaby wrote:
> Hi,
> 
> On 08. 04. 26, 20:04, Greg Kroah-Hartman wrote:
> > 6.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > commit b981e9e94c687b7b19ae8820963f005b842cb2f2 upstream.
> ...
> > --- a/arch/x86/platform/geode/geode-common.c
> > +++ b/arch/x86/platform/geode/geode-common.c
> ...
> > @@ -127,6 +129,12 @@ int __init geode_create_leds(const char
> >   		goto err_free_swnodes;
> >   	}
> > +	gpio_refs = kzalloc_objs(*gpio_refs, n_leds);
> 
> On x86_32, this fails to build:
> arch/x86/platform/geode/geode-common.c:132:21: error: implicit declaration
> of function ‘kzalloc_objs’; did you mean ‘kzalloc_node’?
> [-Wimplicit-function-declaration]
> arch/x86/platform/geode/geode-common.c:132:19: error: assignment to ‘struct
> software_node_ref_args *’ from ‘int’ makes pointer from integer without a
> cast [-Wint-conversion]
>   132 |         gpio_refs = kzalloc_objs(*gpio_refs, n_leds);
> 
> 
> 6.19 does not have kzalloc_objs() yet.

Ugh, yeah, Sasha caught this too, let me go fix this up, my fault.  I
guess I never build x32 kernels anymore :(
