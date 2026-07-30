Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A16143F0A2;
	Thu, 30 Jul 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422851; cv=none; b=T9Woiygs8DJ4T9t9gQH1Cl6V0ECZOEpj/Z5cGMaQN/FsMqNR12i3HylJrxZSE4xSoDKPucXjEhf/Qq9zFgkNPVXUoBUm/TX7o5yygXNxYG8asO9nLim7KnKkQby9RK8EN/pqa0+OzsvIkTkjkzYkX2uTPu9dCZGfyZbCRZ0sAJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422851; c=relaxed/simple;
	bh=iCojVxUTfYpr7xiznyDcDgtkNmGWnb+OVY0rBOAoAoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhgFzgrJA3QRunNEsNFSTfOOgZqTd3DY1eerxdxcjdqV5NSUm1M8t67QIGSn7hLet81FvOh4iEYJVtAumQWaUN8oSRWRZHvWy9GAKXECP786kypezuRTggC6PkM1eW6xERz3cyxPbMleemzm/792JRBE0v4Mcufhl7r68L7Tbjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9mWPjsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9mWPjsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A901F000E9;
	Thu, 30 Jul 2026 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422850;
	bh=ruKD4uF9HBvSsw8o7+Hb0LMVuWkexdK43fmSrt4tP0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9mWPjsHXy3Uo7VHauTKS2raV3H1A16d7ldAVxvC4fJnwn0VnC3yfOC9sVQM1Dzc1
	 AYXrtE5lsALj8Ii4ysow9892mNZVa/okQfUka2kv+f0B2nxGzZtUgKuT87c3BYFBic
	 M9NFWM5nyWbNsQLQB8hyAY25kIt0Z/l2qw1Woynk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.1 578/744] firmware: stratix10-svc: fix teardown order in remove to prevent race
Date: Thu, 30 Jul 2026 16:14:11 +0200
Message-ID: <20260730141456.571088117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>

commit bba85375f8751d6c949036269b529cdcb2a2ed8f upstream.

In stratix10_svc_drv_remove(), stratix10_svc_async_exit() was called
before client devices were unregistered. This created a race window
where child devices could still be issuing service requests through
the async channels after the async infrastructure had already been
torn down.

Unregister client devices before tearing down the async threads and
channels to ensure all in-flight service calls drain before the
underlying infrastructure is destroyed.

Fixes: bcb9f4f07061 ("firmware: stratix10-svc: Add support for async communication")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -2044,12 +2044,12 @@ static void stratix10_svc_drv_remove(str
 	struct stratix10_svc_controller *ctrl = platform_get_drvdata(pdev);
 	struct stratix10_svc *svc = ctrl->svc;
 
+	platform_device_unregister(svc->stratix10_svc_rsu);
+
 	stratix10_svc_async_exit(ctrl);
 
 	of_platform_depopulate(ctrl->dev);
 
-	platform_device_unregister(svc->stratix10_svc_rsu);
-
 	for (i = 0; i < SVC_NUM_CHANNEL; i++) {
 		if (ctrl->chans[i].task) {
 			kthread_stop(ctrl->chans[i].task);


