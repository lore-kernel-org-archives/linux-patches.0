Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEDC23A9A0;
	Tue, 26 Aug 2025 13:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215626; cv=none; b=LOCqUjaDtlgshJmOfQpRMiTLsG0GuAwONLO/pAb8u6OZm0c/hI2F0EKJfbtcaYBSXG0DMT1QcHWP6YBc7XzQ0GPtAzUxjLMJlvBCieXd7XFAWhkqpGboS1r8fBhgOSr82Q7gu21kcHkrnedAxLIYaXdZiSP6M+Tlo5A1sm8ZkM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215626; c=relaxed/simple;
	bh=F4aOIFXu1xCfDC1y74KctrKQb/usKP8I+gv6I8Galps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmkyz9orOYIcJMLgmRpJ5Zf7kJc8keeNQ/PKeR6qsduWoVbzZouLSBycLtq2xIOp9jLoif3R32fdHb/pDTLvc5J7/rOiY0JCNrv0SOPWEshPE7tCVHFzA6gUC8v0o4+xHy2JgrlFoFAlda5683sh87oOVSZ+DrFuV9ohsu4sR6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjdNhIkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjdNhIkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C44CC4CEF1;
	Tue, 26 Aug 2025 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215626;
	bh=F4aOIFXu1xCfDC1y74KctrKQb/usKP8I+gv6I8Galps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjdNhIkwXX/GhyfWLdw3m42hkTWnXRHE+pwvnEU+JZjOWjoOdX2yxscbc5AAetD46
	 Zm2mWgWg+3amCRCKM6+wXgLheEVGMAamfAO7sjGIm5OHkRJMlWrhJnmUa9fP3QTtlL
	 D1+47aul6tRfCY4tSbkmiG7AW4uKXiZfjalugWuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/644] comedi: comedi_test: Fix possible deletion of uninitialized timers
Date: Tue, 26 Aug 2025 13:03:16 +0200
Message-ID: <20250826110949.116540402@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ changed timer_delete_sync() to del_timer_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/comedi_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/drivers/comedi_test.c
+++ b/drivers/comedi/drivers/comedi_test.c
@@ -790,7 +790,7 @@ static void waveform_detach(struct comed
 {
 	struct waveform_private *devpriv = dev->private;
 
-	if (devpriv) {
+	if (devpriv && dev->n_subdevices) {
 		del_timer_sync(&devpriv->ai_timer);
 		del_timer_sync(&devpriv->ao_timer);
 	}


