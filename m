Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FD0255F5C;
	Wed, 30 Jul 2025 09:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868787; cv=none; b=Ntom9lWgHTGSSkhCvo40iFo41rIvDzI5v828mLD60loFMzbWlvBVc4/d4bIO2NwcWCdVp5lsYMWvVT/d3jAF2pZN8y3KlYKqz8m/PqLlqDXgMQVOKCf1XfmHvlpUM981Eb3EpGzfyjcEM7hphUUhp365pEN/hrE75z+luc7C9hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868787; c=relaxed/simple;
	bh=rdPPsjro/aX6TyP7Zpr6P9XyRuhQOP/82KahRQM3fC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5C+lDhBX/LP45o1sIbkGCujiG5ypNrh4oKAt4k+Xz2OOYBnpyjEL0Rvq9lEAB4DmMLgTfvYxXWmxvbt33hmmXCGJJeikgyl5piGwRnEZNkZRujY+KKfAlWHHAG5/ZEedizINF0D2uKuGHTQa6/VOC52VTwpPIXUPwV6gfdsHIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaYMPrN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaYMPrN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADA3C4CEF6;
	Wed, 30 Jul 2025 09:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868787;
	bh=rdPPsjro/aX6TyP7Zpr6P9XyRuhQOP/82KahRQM3fC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaYMPrN5CZ7pJDwaUqq49mlOrEl7jFqvtdkF/b3Omm8wniEp7FAEUlK8cjCtxUQCY
	 AfzT5yAG6SIf3OLmpBBpjPbx0S8ya8O+mgyRmXRPaVhh1336oFTmAGZX3azUOscQLI
	 hoigPupUUOoj1kw2qqxe9+IDOTRqNoPpxYWBdmJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/117] comedi: comedi_test: Fix possible deletion of uninitialized timers
Date: Wed, 30 Jul 2025 11:35:44 +0200
Message-ID: <20250730093236.458326766@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


