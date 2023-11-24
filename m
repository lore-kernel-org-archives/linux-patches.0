Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108CA2FC4E;
	Fri, 24 Nov 2023 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lT4Ub5Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E6FC433C7;
	Fri, 24 Nov 2023 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850953;
	bh=uzLdT24Y5Jvuso0PxaW2EvwBele96AzdyitfG6gHIIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lT4Ub5Xmmj/huTcyBR8lXKJFqsdFs3xkZtliRfDWunULz8ftCqQ1FwbRYZd2nX3G9
	 CuT9GkMc0mzV+iSGBJlCUVImiQCXzir9STmHvhgoS+EkPUd85nL1lo/T97ocec504I
	 PqgiBMH2EdsaFIae4M7PI33P7IxTUVFdaltk5TAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.5 255/491] hvc/xen: fix event channel handling for secondary consoles
Date: Fri, 24 Nov 2023 17:48:11 +0000
Message-ID: <20231124172032.233227352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit ef5dd8ec88ac11e8e353164407d55b73c988b369 upstream.

The xencons_connect_backend() function allocates a local interdomain
event channel with xenbus_alloc_evtchn(), then calls
bind_interdomain_evtchn_to_irq_lateeoi() to bind to that port# on the
*remote* domain.

That doesn't work very well:

(qemu) device_add xen-console,id=con1,chardev=pty0
[   44.323872] xenconsole console-1: 2 xenbus_dev_probe on device/console/1
[   44.323995] xenconsole: probe of console-1 failed with error -2

Fix it to use bind_evtchn_to_irq_lateeoi(), which does the right thing
by just binding that *local* event channel to an irq. The backend will
do the interdomain binding.

This didn't affect the primary console because the setup for that is
special — the toolstack allocates the guest event channel and the guest
discovers it with HVMOP_get_param.

Fixes: fe415186b43d ("xen/console: harden hvc_xen against event channel storms")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231020161529.355083-2-dwmw2@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -436,7 +436,7 @@ static int xencons_connect_backend(struc
 	if (ret)
 		return ret;
 	info->evtchn = evtchn;
-	irq = bind_interdomain_evtchn_to_irq_lateeoi(dev, evtchn);
+	irq = bind_evtchn_to_irq_lateeoi(evtchn);
 	if (irq < 0)
 		return irq;
 	info->irq = irq;


