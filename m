Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1D83A8DC;
	Fri, 24 Nov 2023 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpAz8MXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78498C433C9;
	Fri, 24 Nov 2023 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849725;
	bh=I5VGw38+z4AxB8TnOosDRJYxBmuLZ/oG7NsfdYXFnOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpAz8MXyGJzMxtfKcrixxU+WxHpHPW3M8+fYXUET8I2jzDCKt/fDz+Cup6bRfHW2i
	 Tv0P4gJfZ9KOPtos8bLgPMcLSK6Wl8AEPu5AFgPjmUVn71Ix7zqkTZsKnGrZBz02tU
	 ivwCBg2lBOc7WLfQTXRyBDjNMxYWEp8ZZJfeNp30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 271/530] hvc/xen: fix event channel handling for secondary consoles
Date: Fri, 24 Nov 2023 17:47:17 +0000
Message-ID: <20231124172036.290800174@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


