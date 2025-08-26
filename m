Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF191F4C90;
	Tue, 26 Aug 2025 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217329; cv=none; b=hy6PXbZbzj1MfDQszJb17wCqunuD682cdxYnD/HbQ48zU/To9G2Nq+YuyNHG1Zyf0NmvKPEZxPO7VTww5iztzDLL++0yN+7wheZPq3aDNwsyCsQHiimvpOjZROPifDijep56LPDoOu7qxuGMZhAdK0Gx4IMN17mDsUrjwCtpO8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217329; c=relaxed/simple;
	bh=02bVVHb9yldcs4ui3d59Fpcr5XqEF0q6C/uCFzOhX6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+2IC8/7RmYKRTpoJQlBjLQJkjH0kOGl2+YwL+tyKTh0TJTeJbb2GmrawsxkGDcSjOToVbYsrWDP0BGOjFvT+QdaAJjToBLjrJpxn7VE3GSEMaCN+wxPxUUmNd0ii34Q5t8O77LeItCKg5myYOBIo9vbwM5vy8GNW3cYv8V0o7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YL+wTWTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YL+wTWTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40588C4CEF1;
	Tue, 26 Aug 2025 14:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217329;
	bh=02bVVHb9yldcs4ui3d59Fpcr5XqEF0q6C/uCFzOhX6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YL+wTWTPS3QmdZkg9xNq185XCnM6fN68FK6xkzrURu8i5/w0NsMEJzA7A3CXf/epN
	 oDXB6Jv2Csbu4SFEfA7v1sbwmuhHaRup1gzULyydi2rEZpt2/4Gn2LhuO2F9zPmsyi
	 FLeDwZ68Old9+RnqBdQ4n84z0kj+hZbeUHdb2HOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/523] comedi: comedi_test: Fix possible deletion of uninitialized timers
Date: Tue, 26 Aug 2025 13:04:41 +0200
Message-ID: <20250826110926.324791948@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 1b98304c09a0192598d0767f1eb8c83d7e793091 upstream.

In `waveform_common_attach()`, the two timers `&devpriv->ai_timer` and
`&devpriv->ao_timer` are initialized after the allocation of the device
private data by `comedi_alloc_devpriv()` and the subdevices by
`comedi_alloc_subdevices()`.  The function may return with an error
between those function calls.  In that case, `waveform_detach()` will be
called by the Comedi core to clean up.  The check that
`waveform_detach()` uses to decide whether to delete the timers is
incorrect.  It only checks that the device private data was allocated,
but that does not guarantee that the timers were initialized.  It also
needs to check that the subdevices were allocated.  Fix it.

Fixes: 73e0e4dfed4c ("staging: comedi: comedi_test: fix timer lock-up")
Cc: stable@vger.kernel.org # 6.15+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250708130627.21743-1-abbotti@mev.co.uk
[ file location from drivers/comedi to drivers/staging/comedi and timer_delete_sync() to del_timer_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -790,7 +790,7 @@ static void waveform_detach(struct comed
 {
 	struct waveform_private *devpriv = dev->private;
 
-	if (devpriv) {
+	if (devpriv && dev->n_subdevices) {
 		del_timer_sync(&devpriv->ai_timer);
 		del_timer_sync(&devpriv->ao_timer);
 	}


