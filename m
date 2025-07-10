Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90302221290;
	Thu, 10 Jul 2025 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752153423; cv=none; b=rpMmG1LOsBAya+RD5nIJnosxJf5GlIhaZJIAJ2TGW5epkCyTn6bZXCfKf1u1KnpY4LgCJ4/ZTREUqyvL401PZmPHnHzCtPip1wq4FyqyVrr59qy742UMP9f1+cbG0iVFNqLFVq9m2qgx1wlxWh991k6zxo9FOhIWCFn8dln5ltE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752153423; c=relaxed/simple;
	bh=90azQJZSwo2IVdYQNYBd2nthNRaHFxNtog/QVsJkiHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knOyShGW1mE/sfaN/ufp4wCD5L3Cr4lHBMeOgUlz7q9ivjp7+w7t+ed6dfe5xzdYSdukhaTM8vDJ7I23DHrK4z9aKcjAbP77B5Cl4xwT3o0RAC8qB+fiMcev4QtMirf4eDKDoY4Xv3dsMJOIEzW2NXjpZyE/HPd3GyLn/BCopjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chC32Xdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chC32Xdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC58C4CEE3;
	Thu, 10 Jul 2025 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752153423;
	bh=90azQJZSwo2IVdYQNYBd2nthNRaHFxNtog/QVsJkiHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=chC32Xdtoi+pWSToPQUF2SPLPOZJsa9M0Cijz1A4jTFbAs8EnhU9rnxND0DTAzMYF
	 tjKZDUVlKsTu2h11LaQnFPgOrXQOo9vQStP6fH1fKmhPbcr60/GEW5XzqMdWdz2b+d
	 LeXZgBpcv8ZfdrHDjp/RVW9YwAc8wktOXKaaBHqo=
Date: Thu, 10 Jul 2025 15:16:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Julian Ruess <julianr@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>, Farhan Ali <alifm@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 60/81] s390/pci: Fix stale function handles in error
 handling
Message-ID: <2025071041-liable-postal-77b7@gregkh>
References: <20250708162224.795155912@linuxfoundation.org>
 <20250708162226.893789793@linuxfoundation.org>
 <6bca64221f8954adcdcfe6b5639e29c7fee4b03a.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bca64221f8954adcdcfe6b5639e29c7fee4b03a.camel@linux.ibm.com>

On Thu, Jul 10, 2025 at 10:14:17AM +0200, Niklas Schnelle wrote:
> On Tue, 2025-07-08 at 18:23 +0200, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> > 
> > [ Upstream commit 45537926dd2aaa9190ac0fac5a0fbeefcadfea95 ]
> > 
> > The error event information for PCI error events contains a function
> > handle for the respective function. This handle is generally captured at
> > the time the error event was recorded. Due to delays in processing or
> > cascading issues, it may happen that during firmware recovery multiple
> > events are generated. When processing these events in order Linux may
> > already have recovered an affected function making the event information
> > stale. Fix this by doing an unconditional CLP List PCI function
> > retrieving the current function handle with the zdev->state_lock held
> > and ignoring the event if its function handle is stale.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
> > Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
> > Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/s390/pci/pci_event.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
> > index d969f36bf186f..dc512c8f82324 100644
> > --- a/arch/s390/pci/pci_event.c
> > +++ b/arch/s390/pci/pci_event.c
> > @@ -257,6 +257,8 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
> >  	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
> >  	struct pci_dev *pdev = NULL;
> >  	pci_ers_result_t ers_res;
> > +	u32 fh = 0;
> > +	int rc;
> >  
> >  	zpci_dbg(3, "err fid:%x, fh:%x, pec:%x\n",
> >  		 ccdf->fid, ccdf->fh, ccdf->pec);
> > @@ -264,9 +266,23 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
> >  	zpci_err_hex(ccdf, sizeof(*ccdf));
> >  
> >  	if (zdev) {
> > +		mutex_lock(&zdev->state_lock);
> > +		rc = clp_refresh_fh(zdev->fid, &fh);
> > +		if (rc) {
> > +			mutex_unlock(&zdev->state_lock);
> > +			goto no_pdev;
> > +		}
> > +		if (!fh || ccdf->fh != fh) {
> > +			/* Ignore events with stale handles */
> > +			zpci_dbg(3, "err fid:%x, fh:%x (stale %x)\n",
> > +				 ccdf->fid, fh, ccdf->fh);
> > +			mutex_unlock(&zdev->state_lock);
> > +			goto no_pdev;
> > +		}
> >  		zpci_update_fh(zdev, ccdf->fh);
> >  		if (zdev->zbus->bus)
> >  			pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
> > +		mutex_unlock(&zdev->state_lock);
> >  	}
> >  
> >  	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
> 
> Sorry I only noticed this due to a build error report but this backport
> is NOT CORRECT. The mutex_lock(&zdev->state_lock) line that was context
> in the original commit was part of commit bcb5d6c76903 ("s390/pci:
> introduce lock to synchronize state of zpci_dev's") which also added
> the mutex and isn't in this tree. So without pulling that in as a
> prerequisite this won't compile. 
> 
> Also and kind of worse the above puts the mutex_unlock() in the wrong
> place! Please drop/revert this patch. 
> 
> The original commit here should work for its specific problem even
> without the backport of the mutex though I think it would be best to
> get that into stable as well. Sorry for not marking it as a dependency.
> That said, shouldn't there be a note that this backport deviates
> significantly from the upstream commit?

Already dropped, as something went wrong here.

thanks for the review.

greg k-h
