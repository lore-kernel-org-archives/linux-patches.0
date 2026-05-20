Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879AC40F8DB;
	Wed, 20 May 2026 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302699; cv=none; b=RxI+VOcuZd7MPuIQQYe6SedqDLs7AkDyRr4IlBiPUlGOdPelX6Vp/R3X88l1y4fiTV/AXydPYoWqcYYzqSFskHozLmKQgFnUp6OF11aAsHh6KPNtcW+wTfMy2f5u/hLRQbZmzn8mvgW+c5162NpTaEkDlQrk3dUtmtUPLs9Rg7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302699; c=relaxed/simple;
	bh=Kvk5Tsw9aq/DvxI+ceuD5GfNCR5XQYr5AQ528iIz3iY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YwN5lOeOaHAvkNTCFsWmDsJbS4OLHwWH8AhMFXwLH7VLTBtvlD22WdAgi2y9xGbcMqW5xQILDJc2Od9z6ytu2OKQ+3xRJVOVb4eoC/4cZZdKghn4hVzIsLbJmNDNoY8FTqoZ00D78Az9mCZWZfJUIf6d8J1w1iNMOt9kBBIVYFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMc77ZwC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMc77ZwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028471F000E9;
	Wed, 20 May 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779302698;
	bh=DuTdQIf1HxEP9jH9qaBl6izKmoJUOH3+Y7EuBikIT3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IMc77ZwCPTzs0dqQe93654HZXQ3gh9seDC+pw3OSxK+PNsEovPXlaF0Uxz/hPlb1+
	 8CiXoUB8EbhZFIbJgBK8H/AlFAtN3zn19NW2fGqpSq7l+DNH31bbz5gd6R95r/xUi6
	 /Ln98Eol06XwgP+Govzf0IsiN90dszY9zEuWIUuE8tUGZm1YgBjNgngmF2SEoGkcn1
	 N7MTncjuRakdASHOtc6v+fILYkjaE6UIi9sq5Stu/+Gv4sCDT6XnunhRY3482QeY8h
	 eIlE7qOOVZ+ZiqKsvTIa1QyXyF0pgeqspMjWjyOafUR+gLfGWrGqI2X3cDuUKjyGpI
	 Br1LRKPeK/L+A==
Date: Wed, 20 May 2026 18:44:56 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>, stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Vijayendra Suman <vijayendra.suman@oracle.com>
Subject: Re: [PATCH 6.12 046/206] usb: typec: tcpm: reset internal port
 states on soft reset AMS
Message-ID: <20260520184456.GA3424023@google.com>
References: <20260512173932.810559588@linuxfoundation.org>
 <20260512173933.811124271@linuxfoundation.org>
 <95aa6c6a-6ebe-4ae0-9376-63aa9fb8872c@oracle.com>
 <2026051351-creme-primary-89ae@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026051351-creme-primary-89ae@gregkh>

On Wed, May 13, 2026 at 02:00:06PM +0200, Greg Kroah-Hartman wrote:
> > downstream backport adds the reset in other case:
> > 
> > 
> >         case VCONN_SWAP_ACCEPT:
> >                 tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> > +               port->vdm_sm_running = false;
> > +               port->explicit_contract = false;
> >                 tcpm_ams_finish(port);
> >                 tcpm_set_state(port, VCONN_SWAP_START, 0);
> >                 break;
> > 
> > I think we need to rework on this backport, so I think for the time being we
> > should drop this backport.
> 
> Wow, patch fuzz got it wrong, good catch!
> 
> I'll drop this from all queues now.

Right, it seems commits are being cherry-picked to the stable kernel
branches through a convoluted process where they are first formatted as
patch files, then applied with 'patch' using the default fuzz of 2.

This is error-prone and is resulting in lots of incorrect backports
where changes are applied to the wrong place in the file, as well as
missing backports.

'git cherry-pick' should be used instead.  It has much better results.
It handles this commit correctly, for example.

- Eric
