Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC89393DEA;
	Fri,  6 Feb 2026 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770376967; cv=none; b=V7LXdIaLl7YSX1Psd96HEdNwJirEFSjEhtOrqblfYjoO509q56K2HJjI0AuSAgHxUTzXIMZwPg60QWldboluuN1+07HVzUtiqlPCeuPdmm6gwnX4q48wdGiMXCwiZVMArKrhMJ105WTGCuZkEGDrD5FI/hd49N7Fe7j3o/iITeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770376967; c=relaxed/simple;
	bh=tipjZIAm+it3Cad0XHp1wNZYWgsdThdoedCXDuCJoeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IvozneCSvV2sWgxyUAKDxhzSZCIHnzXmi1hrx79ErBvYUp/CgnwtvZQF2zK8cc0XtXn2g/GgUgWIsElBAH1RhN0oKvZfFxxbtx7Nna2Q5u29Fllh73GKgiXfW/ys5p5YhAjA4/g6kT8TgbeImsfM0tH5TBEimOQua6oOcWtVmoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUP71Pqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUP71Pqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D18EC116C6;
	Fri,  6 Feb 2026 11:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770376967;
	bh=tipjZIAm+it3Cad0XHp1wNZYWgsdThdoedCXDuCJoeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUP71PqmjYMqOIT6aVR6NhHUb9yE0NLLUYqJz3VrL7UkmNG9F1iA6JMHf5n/u3Vd4
	 LbpCUBRmzObzvFMsOEDTH9z4hD/f6xabQ92DrY562VqdYOHEVRvY7FHT6bWtuTbu0i
	 3f8I+jlK1hCX/LQhzt25kL6XJXlKPJr54lfP0Mzo=
Date: Fri, 6 Feb 2026 12:22:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Lavra <flavra@baylibre.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 5.10 070/161] iio: imu: st_lsm6dsx: fix iio_chan_spec for
 sensors without event detection
Message-ID: <2026020630-theater-transform-c228@gregkh>
References: <20260204143851.755002596@linuxfoundation.org>
 <20260204143854.274769162@linuxfoundation.org>
 <eb892614c9cd28aa03922567f8a6d75ed2f594bc.camel@decadent.org.uk>
 <b5f8757ebd48c3a11591a68e8b97017f7b9d7e31.camel@baylibre.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5f8757ebd48c3a11591a68e8b97017f7b9d7e31.camel@baylibre.com>

On Fri, Feb 06, 2026 at 09:17:38AM +0100, Francesco Lavra wrote:
> On Thu, 2026-02-05 at 23:44 +0100, Ben Hutchings wrote:
> > On Wed, 2026-02-04 at 15:38 +0100, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let me
> > > know.
> > > 
> > > ------------------
> > > 
> > > From: Francesco Lavra <flavra@baylibre.com>
> > > 
> > > commit c34e2e2d67b3bb8d5a6d09b0d6dac845cdd13fb3 upstream.
> > > 
> > > The st_lsm6dsx_acc_channels array of struct iio_chan_spec has a non-
> > > NULL
> > > event_spec field, indicating support for IIO events. However, event
> > > detection is not supported for all sensors, and if userspace tries to
> > > configure accelerometer wakeup events on a sensor device that does not
> > > support them (e.g. LSM6DS0), st_lsm6dsx_write_event() dereferences a
> > > NULL
> > > pointer when trying to write to the wakeup register.
> > > Define an additional struct iio_chan_spec array whose members have a
> > > NULL
> > > event_spec field, and use this array instead of st_lsm6dsx_acc_channels
> > > for
> > > sensors without event detection capability.
> > [...]
> > > @@ -1170,8 +1177,8 @@ static const struct st_lsm6dsx_settings
> > >                 },
> > >                 .channels = {
> > >                         [ST_LSM6DSX_ID_ACC] = {
> > > -                               .chan = st_lsm6dsx_acc_channels,
> > > -                               .len =
> > > ARRAY_SIZE(st_lsm6dsx_acc_channels),
> > > +                               .chan = st_lsm6ds0_acc_channels,
> > > +                               .len =
> > > ARRAY_SIZE(st_lsm6ds0_acc_channels),
> > >                         },
> > >                         [ST_LSM6DSX_ID_GYRO] = {
> > >                                 .chan = st_lsm6dsx_gyro_channels,
> > 
> > In the upstream commit the 3rd hunk changed the entry for hardware IDs
> > ST_LSM6DSO16IS_ID and ST_ISM330IS_ID.
> > 
> > That entry was added by commit f35e1ee9cb5d "iio: imu: st_lsm6dsx: add
> > support to LSM6DSO16IS" in 6.2.  So in this backport the 3rd hunk is
> > changing configuration for other devices.
> > 
> > I think the right thing to do for the 5.10-6.1 branches is to only apply
> > the first 2 hunks.
> 
> Good catch. In the 5.10 branch, the third hunk is changing configuration
> for ST_LSM6DSR_ID, ST_ISM330DHCX_ID, and ST_LSM6DSRX_ID, none of which
> should have their configuration changed; so only the first two hunks should
> be applied.

Oh that's crazy.  I stared at this for a long time as the patches really
look "identical" when it comes to the original one.  You have no context
for what entry is associated with what "configuration" as these
structures are huge!

I'll just drop this patch entirely from all of these queues and wait for
someone to send me a version that they "know" is correct.

thanks,

greg k-h
