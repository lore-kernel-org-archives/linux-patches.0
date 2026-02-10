Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE902DC782;
	Tue, 10 Feb 2026 11:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770722370; cv=none; b=gVzCeG1WF+SvQntt2m2GdOpFvOE6PU/p/3fVJa8CEaEp5GkWNri8yPloJIOpf8lD7TIwU5J4lO0x+TUx7xQd30PmUtOGkBDSGlrVtLQ3gn5MwtYrJGBh5dEPDXOYATOg+FVzGQx1kas6H3FXtxI1Sw2eSSOvzwPKYL/c1/VUuyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770722370; c=relaxed/simple;
	bh=iN7Zpx9HA0TLyuHI4vyYnN/jAq81qcroUDuqIKBurao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZijZz2aVgb97CxDiQ8Oj6K3mnJQX9rQbdJfFCDW55oT9nZweQtDtJL/kKH8+WRP7TbCyw1CCejIv2v8EFR5ynORiM0kihylaQeReKpbuRrePEAb/GhDFGdSd8p2QcojQisbrhKSXFZOeqcLTSkjbhoQepIW88CsfQhIiJwvHYkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScjOb1p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScjOb1p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41419C116C6;
	Tue, 10 Feb 2026 11:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770722369;
	bh=iN7Zpx9HA0TLyuHI4vyYnN/jAq81qcroUDuqIKBurao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ScjOb1p+eYNh6kGa6EyNbL4jPaoIw93pN3CrrI6kVcyEYFjA7hrJFDlrUWJadjNSt
	 7brHSwMZ6w96gdIZxKgoCM82HEOc7hIxQv2gtwnzHHrODKV1E6f2aPewQpZr6YhTqE
	 tYr/0CNP1GFtZyK7be84NR9eBWB9Pw8wzqw8i8pg=
Date: Tue, 10 Feb 2026 12:19:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Guenter Roeck <linux@roeck-us.net>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 134/175] hwmon: (acpi_power_meter) Fix deadlocks
 related to acpi_power_meter_notify()
Message-ID: <2026021009-cavalry-spearman-1950@gregkh>
References: <20260209142320.474120190@linuxfoundation.org>
 <20260209142325.330634333@linuxfoundation.org>
 <CAK8fFZ5n-og8dxFrh4J7pWW9h+iTp+AbdGUF1cd_7jDZpKEj8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8fFZ5n-og8dxFrh4J7pWW9h+iTp+AbdGUF1cd_7jDZpKEj8w@mail.gmail.com>

On Tue, Feb 10, 2026 at 11:19:12AM +0100, Jaroslav Pulchart wrote:
> >
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > [ Upstream commit 615901b57b7ef8eb655f71358f7e956e42bcd16b ]
> >
> > The acpi_power_meter driver's .notify() callback function,
> > acpi_power_meter_notify(), calls hwmon_device_unregister() under a lock
> > that is also acquired by callbacks in sysfs attributes of the device
> > being unregistered which is prone to deadlocks between sysfs access and
> > device removal.
> >
> > Address this by moving the hwmon device removal in
> > acpi_power_meter_notify() outside the lock in question, but notice
> > that doing it alone is not sufficient because two concurrent
> > METER_NOTIFY_CONFIG notifications may be attempting to remove the
> > same device at the same time.  To prevent that from happening, add a
> > new lock serializing the execution of the switch () statement in
> > acpi_power_meter_notify().  For simplicity, it is a static mutex
> > which should not be a problem from the performance perspective.
> >
> > The new lock also allows the hwmon_device_register_with_info()
> > in acpi_power_meter_notify() to be called outside the inner lock
> > because it prevents the other notifications handled by that function
> > from manipulating the "resource" object while the hwmon device based
> > on it is being registered.  The sending of ACPI netlink messages from
> > acpi_power_meter_notify() is serialized by the new lock too which
> > generally helps to ensure that the order of handling firmware
> > notifications is the same as the order of sending netlink messages
> > related to them.
> >
> > In addition, notice that hwmon_device_register_with_info() may fail
> > in which case resource->hwmon_dev will become an error pointer,
> > so add checks to avoid attempting to unregister the hwmon device
> > pointer to by it in that case to acpi_power_meter_notify() and
> > acpi_power_meter_remove().
> >
> > Fixes: 16746ce8adfe ("hwmon: (acpi_power_meter) Replace the deprecated hwmon_device_register")
> > Closes: https://lore.kernel.org/linux-hwmon/CAK8fFZ58fidGUCHi5WFX0uoTPzveUUDzT=k=AAm4yWo3bAuCFg@mail.gmail.com/
> > Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/hwmon/acpi_power_meter.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
> > index 29ccdc2fb7ff8..de408df0c4d78 100644
> > --- a/drivers/hwmon/acpi_power_meter.c
> > +++ b/drivers/hwmon/acpi_power_meter.c
> > @@ -47,6 +47,8 @@
> >  static int cap_in_hardware;
> >  static bool force_cap_on;
> >
> > +static DEFINE_MUTEX(acpi_notify_lock);
> > +
> >  static int can_cap_in_hardware(void)
> >  {
> >         return force_cap_on || cap_in_hardware;
> > @@ -823,18 +825,26 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
> >
> >         resource = acpi_driver_data(device);
> >
> > +       guard(mutex)(&acpi_notify_lock);
> > +
> >         switch (event) {
> >         case METER_NOTIFY_CONFIG:
> > +               if (!IS_ERR(resource->hwmon_dev))
> > +                       hwmon_device_unregister(resource->hwmon_dev);
> > +
> >                 mutex_lock(&resource->lock);
> > +
> >                 free_capabilities(resource);
> >                 remove_domain_devices(resource);
> > -               hwmon_device_unregister(resource->hwmon_dev);
> >                 res = read_capabilities(resource);
> >                 if (res)
> >                         dev_err_once(&device->dev, "read capabilities failed.\n");
> >                 res = read_domain_devices(resource);
> >                 if (res && res != -ENODEV)
> >                         dev_err_once(&device->dev, "read domain devices failed.\n");
> > +
> > +               mutex_unlock(&resource->lock);
> > +
> >                 resource->hwmon_dev =
> >                         hwmon_device_register_with_info(&device->dev,
> >                                                         ACPI_POWER_METER_NAME,
> > @@ -843,7 +853,7 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
> >                                                         power_extra_groups);
> >                 if (IS_ERR(resource->hwmon_dev))
> >                         dev_err_once(&device->dev, "register hwmon device failed.\n");
> > -               mutex_unlock(&resource->lock);
> > +
> >                 break;
> >         case METER_NOTIFY_TRIP:
> >                 sysfs_notify(&device->dev.kobj, NULL, POWER_AVERAGE_NAME);
> > @@ -953,7 +963,8 @@ static void acpi_power_meter_remove(struct acpi_device *device)
> >                 return;
> >
> >         resource = acpi_driver_data(device);
> > -       hwmon_device_unregister(resource->hwmon_dev);
> > +       if (!IS_ERR(resource->hwmon_dev))
> > +               hwmon_device_unregister(resource->hwmon_dev);
> >
> >         remove_domain_devices(resource);
> >         free_capabilities(resource);
> > --
> > 2.51.0
> >
> >
> >
> 
> Hello, I tested this patch, but unfortunately it does not resolve the
> reported issue on our systems the deadlock is still reproducible with
> the same iDRAC reset reproducer.

Is 6.19 also a problem here, or does it work properly on that release?

thanks,

greg k-h
