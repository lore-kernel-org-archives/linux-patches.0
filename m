Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215262;
	b=SyDbOyHS/hqYyT14FTMwW93UgDRRAL78iwPX71+Fo0Ng6Zi4vfEyy2H2tFTmuryTYK9s
	 g3I6QO1dZmOQfk0v/TpyAhnNpoKVOjk4cmcgD7XIuoBrqdpcYbEE44twzLXl5IdA58oE0
	 yYJ4LqrdQ1DvSkpdMg7ZLOqEND25WOoYMMpF2felRq5svECGiDMu/SrE1Y+E8DYZcKpRl
	 9haOTC1P9N7DVjRK7c9wIWy1SbQNnUE+lCMmZwJcJtML0VsC3PLn/TIq17En+xggMyyN2
	 4GV9yG8W7UVY6GQ/fmH/x2ycT9jSUVj8jLHO7fGzUNBWRiCmBpJSWj5yE9kutPqHTLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABjXMYpneuY5xJNPJK++SZvRZvvdE28mjv1kki56WZw=;
	b=ivzBD42svK2nR3aRqOsfRBXXLguDOKV638didVGo7E38bQp3R3ni8kUU4DgdOyaoAw7u
	 nrR7A+y4nBwVkWBplNuOSjbCU99eF7xuwCTkNY/UhEJz3W2mt54Frl6edbS5bI0hvZ6ue
	 VBL1KRIictxBRrRwagVP9aUGQLdc6ZVS0hvbgA5UFJBePuHF/WW9K2QZ0adSfIJdT0yuv
	 1sFM9CnbG0wjyUGkwOfOmkOpNjX2qN4/Y73aDkNqKTKzYVW9lurODnZjL7h1udLKMUelh
	 4KgRLSAelRdp5KYRGcJYadXg5DXK+h3ZmO7cXhhN3ZxAppMYjata40tDE+QxNM6f4VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0QbxbcN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3DD606A31D;
	Wed, 28 Oct 2026 19:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0QbxbcN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDCB1F01825;
	Wed, 28 Oct 2026 19:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215261;
	bh=ABjXMYpneuY5xJNPJK++SZvRZvvdE28mjv1kki56WZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0QbxbcNUa29MCkVrLXrYY6+EFFJGeaI1uRr2B7ITlyyNSckYa3oVZUoQMVImY0Qt
	 QbOc5jFFsK5pi37xsF+zwpohG42/7QZLCWFLOgtnnYE5HkRgSPgB36w7FQ735oCOaZ
	 J9j9dAFE4OBfCT7l9Yw2a8TeLVQn5K/ZkE2jvGrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1150/1887] usb: free iso schedules on failed submit
Date: Wed, 28 Oct 2026 17:54:06 +0100
Message-ID: <20261028170525.576544901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit b9399d25fbb34a05bbe76eeedd730f62ff2670e9 ]

EHCI and FOTG210 isochronous submits build an ehci_iso_sched before
linking the URB to the endpoint queue, and keep the staged schedule in
urb->hcpriv until iso_stream_schedule() and the link helpers consume it.
If the controller is no longer accessible, or usb_hcd_link_urb_to_ep()
fails, submit jumps to done_not_linked before that handoff happens and
leaks the staged schedule still attached to urb->hcpriv.

Free the staged schedule from done_not_linked when submit fails before
the URB is linked and clear urb->hcpriv after the free.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. As we do not have an
EHCI host controller with a USB isochronous device to test with, no
runtime testing was able to be performed.

Fixes: 8de98402652c ("[PATCH] USB: Fix USB suspend/resume crasher (#2)")
Fixes: e9df41c5c589 ("USB: make HCDs responsible for managing endpoint queues")
Fixes: 7d50195f6c50 ("usb: host: Faraday fotg210-hcd driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260630071419.349161-1-dawei.feng@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-sched.c  | 11 +++++++++--
 drivers/usb/host/fotg210-hcd.c |  6 ++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index bd542b6fc46bd..d002e70171f6c 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1623,6 +1623,7 @@ iso_stream_schedule(
 			status = 1;	/* and give it back immediately */
 			iso_sched_free(stream, sched);
 			sched = NULL;
+			urb->hcpriv = NULL;
 		}
 	}
 	urb->error_count = skip / period;
@@ -1653,8 +1654,6 @@ iso_stream_schedule(
 	return status;
 
  fail:
-	iso_sched_free(stream, sched);
-	urb->hcpriv = NULL;
 	return status;
 }
 
@@ -1966,6 +1965,10 @@ static int itd_submit(struct ehci_hcd *ehci, struct urb *urb,
 		usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
 	}
  done_not_linked:
+	if (status < 0) {
+		iso_sched_free(stream, urb->hcpriv);
+		urb->hcpriv = NULL;
+	}
 	spin_unlock_irqrestore(&ehci->lock, flags);
  done:
 	return status;
@@ -2343,6 +2346,10 @@ static int sitd_submit(struct ehci_hcd *ehci, struct urb *urb,
 		usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
 	}
  done_not_linked:
+	if (status < 0) {
+		iso_sched_free(stream, urb->hcpriv);
+		urb->hcpriv = NULL;
+	}
 	spin_unlock_irqrestore(&ehci->lock, flags);
  done:
 	return status;
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index dc968960769e1..5cdae91211ece 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -4272,8 +4272,6 @@ static int iso_stream_schedule(struct fotg210_hcd *fotg210, struct urb *urb,
 	return 0;
 
 fail:
-	iso_sched_free(stream, sched);
-	urb->hcpriv = NULL;
 	return status;
 }
 
@@ -4567,6 +4565,10 @@ static int itd_submit(struct fotg210_hcd *fotg210, struct urb *urb,
 	else
 		usb_hcd_unlink_urb_from_ep(fotg210_to_hcd(fotg210), urb);
 done_not_linked:
+	if (status < 0) {
+		iso_sched_free(stream, urb->hcpriv);
+		urb->hcpriv = NULL;
+	}
 	spin_unlock_irqrestore(&fotg210->lock, flags);
 done:
 	return status;
-- 
2.53.0



