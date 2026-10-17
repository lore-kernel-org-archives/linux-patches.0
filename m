Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5D83AF66D;
	Sat, 17 Oct 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256626; cv=none; b=aWW+iFvvdZPaUK+yr/m5DDsUb6rYJOKMAsk/s2DmNdqtBZOVkAi0NHqx4ZyHvpwVhVCVFZNKN3lG4gsFdCihv8NebkJtprDNl8kR22a2o0+dnBVtZB7G5qjNzK75G+RJTQTOJ+2fiuGJ9z3ferwM5aUJfrudOOs2c4Yr5L0LFms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256626; c=relaxed/simple;
	bh=gm7mg+9Ou2h2krrU9vzXtYB7Awn4Msk2lYRj8m/uZCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMI1ag5M7rt80ilKsDSsWqqnLjb8JYs7uxZzuAcPH6BnQWf51UkKXt3csiCXadxrPAIrodPbFEicJqFJTry36z6tM4g+uV4leY7yTls8uJw+eNfVLt0V4vDFYCx63c4n1GZFn7OAZyvQpBIiEtV9+LLcXW2KYweh6sfvx4kKwDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdBITgIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdBITgIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B559D1F000C4;
	Sat, 17 Oct 2026 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256625;
	bh=Ep0aErvAdi+s6/3Hfxbkx9YlWMSAvKVnmCL5APi4Jds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdBITgImd+unM105VNwsv3NWJcxFXNRiEjOUNDTy24qjwWFzEJvgd9oIiQjHlM7nv
	 wFV7ytJSEXGZZyzCoxH8s52Y7KB/GTP25AaMasXtIyRMezjcVRo8KtfPqq3usuLXC+
	 w1uEuaLza+wfrcV8GkLuo2h11EdUCf1VmdgUUXfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH 6.6 0256/1674] USB: cdc-acm: skip URB restart in port_shutdown if disconnected
Date: Sat, 17 Oct 2026 17:42:08 +0200
Message-ID: <20261017160437.695296052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Yuchao Zhang <ndaugoing@gmail.com>

commit dc614d6bc991740d41d5a99ac7765c4b675dda88 upstream.

acm_port_shutdown() is called from the tty-port machinery whenever the
last user closes the port.  acm_disconnect() sets acm->disconnected and
calls tty_port_tty_vhangup(), which eventually triggers port_shutdown().
At that point acm_disconnect() has already called acm_poison_urbs() and
is about to free the control and read URBs.

However, acm_port_shutdown() unconditionally calls acm_unpoison_urbs()
and, when the ALWAYS_POLL_CTRL quirk is set, immediately re-submits the
ctrlurb and all read URBs.  If the concurrent acm_disconnect() then
frees those URBs and their DMA buffers while they are in-flight, the
result is a use-after-free in acm_ctrl_irq() or acm_read_bulk_callback()
accessing the freed DMA memory.

Fix by checking acm->disconnected after draining the delayed anchor and
returning early: if we are in a disconnect path the URBs must remain
poisoned and must not be resubmitted.

The early return is placed after the delayed-anchor drain loop because
that loop only cancels write-side accounting (wb->use = false and
autopm counter) and does not touch the hardware path.

Fixes: f58752ebcb35 ("USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10 INGENIC touchscreen")
Cc: stable <stable@kernel.org>
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Link: https://patch.msgid.link/20260918114309.3659635-2-ndaugoing@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -787,6 +787,9 @@ static void acm_port_shutdown(struct tty
 		usb_autopm_put_interface_async(acm->control);
 	}
 
+	if (acm->disconnected)
+		return;
+
 	acm_unpoison_urbs(acm);
 
 	if (acm->quirks & ALWAYS_POLL_CTRL) {


