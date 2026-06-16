Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E5035DA6A;
	Tue, 16 Jun 2026 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628479; cv=none; b=FvXF/VmnBFkRS9Cj7lu6f7JoofmsYlTjpqtXG41cnAkivPKID4O5AZpt/aO6RckAEzktq6ORLLUsBQz9h69DvUtKo4Om00PTgeCO6T5Jc0G26g3EJwYKKkBMHeoGbeh2hqGuV1cmwi4Kp28B5eBcAtsHeue1sro7TqowhcPGMIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628479; c=relaxed/simple;
	bh=M7Ut87/cbnzQagUsHbaDd/JdATTClmtX07B8xHN3oZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuPQoduM+t7CuI9irti28VmDWP/AnuBfzYpYf2KlSDS7LktZ0MC55Xn2DgCGLSX0cnJLd6sC0OJwlbRZNWWS1uOpngZqfcQn0avfVd7ATHt4ANfRV+gDdCdgLrBuce0WZLAJ2V43ykl1Fm/KcK2hlx0LT2o4a3i+4QqoGsK/VFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AitZx0i3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AitZx0i3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39461F000E9;
	Tue, 16 Jun 2026 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628478;
	bh=iG3pY954g0GE8ZMSZUbEnx28JqXD8HDZzf+2Aqvg74E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AitZx0i3bYgNTRTds1tBWGoQDEsXVQ24tnzbaFolck0SZ0sDai87Vjzt9Bz3n2MGP
	 phIR9dWHyoGO5EcrzZmNCEoE0KLtAN8BZ1hJeXrFcyErCywwGnccOP2WzwbNgnAJH3
	 W5qmjVUTUsow4DH843KIenZ0QYXIkfMAAqFapi5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ben Hutchings <benh@debian.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 6.6 103/452] parport: Fix race between port and client registration
Date: Tue, 16 Jun 2026 20:25:30 +0530
Message-ID: <20260616145123.203808569@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

commit ef15ccbb3e8640a723c42ad90eaf81d66ae02017 upstream.

The parport subsystem registers port devices before they are fully
initialised, resulting in a race condition where client drivers such
as lp can attach to ports that are not completely initialised or even
being torn down.

When the port and client drivers are built as modules and loaded
around the same time during boot, this occasionally results in a
crash.  I was able to make this happen reliably in a VM with a
PC-style parallel port by patching parport_pc to fail probing:

> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -2069,7 +2069,7 @@ static struct parport *__parport_pc_probe_port(unsigned long int base,
>  	if (!p)
>  		goto out3;
>
> -	base_res = request_region(base, 3, p->name);
> +	base_res = NULL;
>  	if (!base_res)
>  		goto out4;
>

and then running:

    while true; do
        modprobe lp & modprobe parport_pc
	wait
	rmmod lp parport_pc
    done

for a few seconds.

In the long term I think port registration should be changed to put
the call to device_add() inside parport_announce_port(), but since the
latter currently cannot fail this will require changing all port
drivers.

For now, add a flag to indicate whether a port has been "announced"
and only try to attach client drivers to ports when the flag is set.

Fixes: 6fa45a226897 ("parport: add device-model to parport subsystem")
Closes: https://bugs.debian.org/1130365
Closes: https://lore.kernel.org/all/6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de/
Cc: stable <stable@kernel.org>
Signed-off-by: Ben Hutchings <benh@debian.org>
Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://patch.msgid.link/afo6uBv68GDevbMD@decadent.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/share.c |   11 +++++++++--
 include/linux/parport.h |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -223,10 +223,14 @@ static void get_lowlevel_driver(void)
 static int port_check(struct device *dev, void *dev_drv)
 {
 	struct parport_driver *drv = dev_drv;
+	struct parport *port;
 
 	/* only send ports, do not send other devices connected to bus */
-	if (is_parport(dev))
-		drv->match_port(to_parport_dev(dev));
+	if (is_parport(dev)) {
+		port = to_parport_dev(dev);
+		if (test_bit(PARPORT_ANNOUNCED, &port->devflags))
+			drv->match_port(port);
+	}
 	return 0;
 }
 
@@ -553,6 +557,7 @@ void parport_announce_port(struct parpor
 		if (slave)
 			attach_driver_chain(slave);
 	}
+	set_bit(PARPORT_ANNOUNCED, &port->devflags);
 	mutex_unlock(&registration_lock);
 }
 EXPORT_SYMBOL(parport_announce_port);
@@ -582,6 +587,8 @@ void parport_remove_port(struct parport
 
 	mutex_lock(&registration_lock);
 
+	clear_bit(PARPORT_ANNOUNCED, &port->devflags);
+
 	/* Spread the word. */
 	detach_driver_chain(port);
 
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -242,6 +242,7 @@ struct parport {
 
 	unsigned long devflags;
 #define PARPORT_DEVPROC_REGISTERED	0
+#define PARPORT_ANNOUNCED		1
 	struct pardevice *proc_device;	/* Currently register proc device */
 
 	struct list_head full_list;


