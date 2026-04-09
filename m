Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AD93859C8;
	Thu,  9 Apr 2026 08:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775724922; cv=none; b=Ssw5K+90P+f4QH1Iu7Ie3Ui0B2vK+ITKqOB8N6oglLQ87J0gZghUaxINGT0to1lcNQ2GI54zVA7/rFbMdOTzbrClNnc+PueRl4d9PNs8QuOMudTphrY+kISJeAVv7S1JIQoemdIlGTvh6h39T5bTUdCT7uDzxOTNJ+5vSPXZr+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775724922; c=relaxed/simple;
	bh=K8IqSUpS8Qo9h4Tenec5xQrEnrM2Ob8riRLZEAiZKCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2YqvkV3N/pgNK3Ji2++W45Iek2FogF4EMQYz6HTnp9uej34UnMOlhCAIKoGhZJuGC7NoHrKLFEwfMvQicJe1KTfJBGEseXLNXKQNWvE6f+LF7A+veRpliVb7pzAFDDHRgZ+FETvT9pdkrVnuDD208/5mp8UehBrn5tHyJxzDA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uAgn5A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uAgn5A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E653DC4CEF7;
	Thu,  9 Apr 2026 08:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775724922;
	bh=K8IqSUpS8Qo9h4Tenec5xQrEnrM2Ob8riRLZEAiZKCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1uAgn5A1QrQSGMYJHRwmfTRwChpZLjVpm550nLNRfzDimegJ+g4uue5X6E5OFa2oi
	 5iYwtu/CFR+rdC4j60zHfkNJv7KnyBLzG/o/49AvI5y5ftnrE2Ew+4BTrpUkhJbJsP
	 rhYGT0bDxlE4p0qmm7hGqspFOKquR9gKi8dKrX4k=
Date: Thu, 9 Apr 2026 10:55:19 +0200
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
Message-ID: <2026040908-aflutter-apache-dc1c@gregkh>
References: <20260408175939.393281918@linuxfoundation.org>
 <20260408175948.651696885@linuxfoundation.org>
 <bfda5183-df4b-4f7a-b867-031f046aa2ee@kernel.org>
 <2026040926-pregnancy-altitude-5d24@gregkh>
 <2026040941-surviving-surgery-189a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026040941-surviving-surgery-189a@gregkh>

On Thu, Apr 09, 2026 at 10:43:58AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 09, 2026 at 10:26:55AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Apr 09, 2026 at 10:09:59AM +0200, Jiri Slaby wrote:
> > > Hi,
> > > 
> > > On 08. 04. 26, 20:04, Greg Kroah-Hartman wrote:
> > > > 6.19-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > > 
> > > > commit b981e9e94c687b7b19ae8820963f005b842cb2f2 upstream.
> > > ...
> > > > --- a/arch/x86/platform/geode/geode-common.c
> > > > +++ b/arch/x86/platform/geode/geode-common.c
> > > ...
> > > > @@ -127,6 +129,12 @@ int __init geode_create_leds(const char
> > > >   		goto err_free_swnodes;
> > > >   	}
> > > > +	gpio_refs = kzalloc_objs(*gpio_refs, n_leds);
> > > 
> > > On x86_32, this fails to build:
> > > arch/x86/platform/geode/geode-common.c:132:21: error: implicit declaration
> > > of function ‘kzalloc_objs’; did you mean ‘kzalloc_node’?
> > > [-Wimplicit-function-declaration]
> > > arch/x86/platform/geode/geode-common.c:132:19: error: assignment to ‘struct
> > > software_node_ref_args *’ from ‘int’ makes pointer from integer without a
> > > cast [-Wint-conversion]
> > >   132 |         gpio_refs = kzalloc_objs(*gpio_refs, n_leds);
> > > 
> > > 
> > > 6.19 does not have kzalloc_objs() yet.
> > 
> > Ugh, yeah, Sasha caught this too, let me go fix this up, my fault.  I
> > guess I never build x32 kernels anymore :(
> 
> Ok, now fixed up, I'll go push out new -rc2 releases with this fix in it
> to make sure I didn't get it wrong.

Ah, Sasha just dropped the commit, that was easier to do :)
