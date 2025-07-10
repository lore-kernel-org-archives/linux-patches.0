Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BF917993;
	Thu, 10 Jul 2025 13:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752153483; cv=none; b=LVItZFItE9v3GnklY/7VFiMN2ae0ll0yzdsQwf5XWONQU6e4qbKYZ7dZPBUF/qjzdBkSbCSLV/N+yyaeZBx4Hp921/6zGyjRwd2wqM2oHLz2ozwZOTfezTZLtaRJOy3ffzpBerS/bGjhaiZy/AZlSm7r7EEZQMGRYk+/f+5Crjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752153483; c=relaxed/simple;
	bh=1rtiOKlL0gjZt0JsCJ4IP4OtVn/TjSI4IPpsxl+t7Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKkP0GPgA/+CNTUXgNdvaX7H8j9n5EFNkQ7vVaj/8U5Wcqmtkn8S46vl8xEmdJ7wPlH7NX8kjcPNEKI7dIVyCJ4FFqqkQJGthbxZttnYfTW7bj/nKrHQO00NsKTXfNVeqLf4yaMyyjxhJM56SjptmvmQzNOBRbrm0jflqhATqfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFtdLgt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFtdLgt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD52CC4CEED;
	Thu, 10 Jul 2025 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752153483;
	bh=1rtiOKlL0gjZt0JsCJ4IP4OtVn/TjSI4IPpsxl+t7Qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GFtdLgt4W82WAVOdQTSekyXcJPYEsnenZxIzh2gNcwm8tfmYlugWKfoLT1HBMMkIL
	 Ia6rHN3we7qcZsrKInElBLHSzpJMDNR96XKR5urwiFbk3pypsEJ8XYBaJgPjnEd78D
	 LZtlKBSSXCaM/CZo8w4PHyzJsZIP2ke4QAxf/NTE=
Date: Thu, 10 Jul 2025 15:18:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Julian Ruess <julianr@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>, Farhan Ali <alifm@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 108/132] s390/pci: Fix stale function handles in
 error handling
Message-ID: <2025071037-bulgur-frostily-3a6b@gregkh>
References: <20250708162230.765762963@linuxfoundation.org>
 <20250708162233.754242912@linuxfoundation.org>
 <23b7e8e20d7f660513dce9c70958af81057f0f46.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b7e8e20d7f660513dce9c70958af81057f0f46.camel@linux.ibm.com>

On Thu, Jul 10, 2025 at 10:36:06AM +0200, Niklas Schnelle wrote:
> On Tue, 2025-07-08 at 18:23 +0200, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
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
> >  arch/s390/pci/pci_event.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
> > index d969f36bf186f..fd83588f3c11d 100644
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
> > @@ -264,6 +266,16 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
> >  	zpci_err_hex(ccdf, sizeof(*ccdf));
> >  
> >  	if (zdev) {
> > +		mutex_lock(&zdev->state_lock);
> 
> This won't compile this tree misses commit bcb5d6c76903 ("s390/pci:
> introduce lock to synchronize state of zpci_dev's").
> 
> > +		rc = clp_refresh_fh(zdev->fid, &fh);
> > +		if (rc)
> > +			goto no_pdev;
> > +		if (!fh || ccdf->fh != fh) {
> > +			/* Ignore events with stale handles */
> > +			zpci_dbg(3, "err fid:%x, fh:%x (stale %x)\n",
> > +				 ccdf->fid, fh, ccdf->fh);
> > +			goto no_pdev;
> > +		}
> >  		zpci_update_fh(zdev, ccdf->fh);
> >  		if (zdev->zbus->bus)
> >  			pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
> > @@ -292,6 +304,8 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
> >  	}
> >  	pci_dev_put(pdev);
> >  no_pdev:
> > +	if (zdev)
> > +		mutex_unlock(&zdev->state_lock);
> 
> Curiously this patch was adjusted differently here vs for 6.1.y, this
> one at least places the unlock in the same place as upstream.
> 
> >  	zpci_zdev_put(zdev);
> >  }
> >  
> 
> Please drop this patch! Ten can we pull in commit bcb5d6c76903
> ("s390/pci: introduce lock to synchronize state of zpci_dev's")
> as a prerequiste? This fix would still work for its specific issue
> without the mutex i.e. just adjusting context but I'd prefer to have
> both in stable.
> 
> Also, I wonder if it would be possible to have the subject of these
> kind of mails indicate if the backport patch was adjusted more than
> just line offsets or context? I think that would make it much easier to
> spot where extra attention is required.

Already dropped.  And yes, it should have contained some
meta-information about this, normally that goes in the signed-off-by
area.

thanks,

greg k-h
