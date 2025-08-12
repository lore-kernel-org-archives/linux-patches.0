Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBF72FDC51;
	Tue, 12 Aug 2025 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020333; cv=none; b=dzYp2pCXyvMCr87C6kW0TbMkJKuCZI2S67grwUl6pqn4FrYSsl16sH9Ia7CBTsUraD2xMMEhashS5iDD8CyA+Pe13yvB/uyB976zU5yWOafjAswX4JqTh1bqjzV5qfYuisBE88wkXKvAGG5QuT0SW1KVaMXLldQdbUZmfnMAmyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020333; c=relaxed/simple;
	bh=//iBkvNwi3TgTrySUrbqQhbUwVcZddPoZXeYyRTUxE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tA6QnmHPc75oxz1n6ygypa/znEjCgSsXhOLFxKmNSHrUp+4BWe/03ms6SG6KRrHD2DNDcmFoIwfMg41kqspeem+RgLLvnULhOk0pPnBl460e0/18VZmG1NNuE3H8GwXyq3vsa21gZsmiC2oTwOXxdIMXaIRNU1tLCNqygDv0Tq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb7DuFK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb7DuFK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F173CC4CEF0;
	Tue, 12 Aug 2025 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020333;
	bh=//iBkvNwi3TgTrySUrbqQhbUwVcZddPoZXeYyRTUxE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb7DuFK1qXhiHX0Qd9MuPAwY9NlgOodfANz2eD6WDTwVJMYfILphJPCxagFvke5oq
	 wjtYrgDJx/Ij81G9emcQn4wXcX8vOll7fDxSLbnZGEgF5uzVklZsVJybFZtKfTXR90
	 liSmLOB9Lmnj3cj1wfhmtQH6p9VJpSBuAAHEJHVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/253] comedi: comedi_test: Fix possible deletion of uninitialized timers
Date: Tue, 12 Aug 2025 19:27:17 +0200
Message-ID: <20250812172950.821049864@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -788,7 +788,7 @@ static void waveform_detach(struct comed
 {
 	struct waveform_private *devpriv = dev->private;
 
-	if (devpriv) {
+	if (devpriv && dev->n_subdevices) {
 		del_timer_sync(&devpriv->ai_timer);
 		del_timer_sync(&devpriv->ao_timer);
 	}


