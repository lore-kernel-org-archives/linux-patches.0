Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACD52236EB;
	Tue, 30 Sep 2025 15:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244915; cv=none; b=m9qZLcaAn1OaBbNe9TdtlHGgUjoQTR/KKlhMeJAW85Wu3rvo5PHcOE0VpV5Gi8rZqEacCX+3Cv3W1Snc3NImg/wiriy4ydDdbwu2PkjfOVIzsYFEmiY8BbkzPzBkxSNLzAPvjD7XQ0fidl4GIwccaMd4FHo0Zi1NbibyNuag/lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244915; c=relaxed/simple;
	bh=9ccPQt89yuacaV6ZKtLxmx0vUwun2hCz5cCZ20F8PSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcYTDFT0HxlLk0DymVfe9WzQ5FZYfmFeuNT8ZLEFrxEeOaNeb9k7+NYyhVypnhJqyclcfS+D5xT904K3/FhxTVGiCVPMsIPr+vrfIo8GSFAs4YdXFACt4sS0d5CTuQa2tiRHdLbioy3ouxrUKGcW/UGI0MEvH/M9gOJQ/PvEDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fv8S8dBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fv8S8dBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34648C4CEF0;
	Tue, 30 Sep 2025 15:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244915;
	bh=9ccPQt89yuacaV6ZKtLxmx0vUwun2hCz5cCZ20F8PSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fv8S8dBot18T/lYmijwcm3lBtDBa6nZGzMsdg+ANqUS4uWYprykk3lTRubK7EmBY4
	 RTHS5G5gaX0rm87qE4SHwZiFa+R/+hZEyF1sC21NWi2+vVtqbBWsrUWU99wTbaz8zf
	 PVWIi2vUCRD2LOcRMoChA80g4RxqB5O5fKSkj6jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett A C Sheffield <bacs@librecast.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/151] Revert "fbdev: Disable sysfb device registration when removing conflicting FBs"
Date: Tue, 30 Sep 2025 16:45:31 +0200
Message-ID: <20250930143827.647977268@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett A C Sheffield <bacs@librecast.net>

This reverts commit 13d28e0c79cbf69fc6f145767af66905586c1249.

Commit ee7a69aa38d8 ("fbdev: Disable sysfb device registration when
removing conflicting FBs") was backported to 5.15.y LTS. This causes a
regression where all virtual consoles stop responding during boot at:

"Populating /dev with existing devices through uevents ..."

Reverting the commit fixes the regression.

Signed-off-by: Brett A C Sheffield <bacs@librecast.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index d938c31e8f90a..3b52ddfe03506 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
-#include <linux/sysfb.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/vt.h>
@@ -1795,17 +1794,6 @@ int remove_conflicting_framebuffers(struct apertures_struct *a,
 		do_free = true;
 	}
 
-	/*
-	 * If a driver asked to unregister a platform device registered by
-	 * sysfb, then can be assumed that this is a driver for a display
-	 * that is set up by the system firmware and has a generic driver.
-	 *
-	 * Drivers for devices that don't have a generic driver will never
-	 * ask for this, so let's assume that a real driver for the display
-	 * was already probed and prevent sysfb to register devices later.
-	 */
-	sysfb_disable();
-
 	mutex_lock(&registration_lock);
 	do_remove_conflicting_framebuffers(a, name, primary);
 	mutex_unlock(&registration_lock);
-- 
2.51.0



