Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F791482F9;
	Tue, 23 Apr 2024 21:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908742; cv=none; b=eULQissOsj85Q+iwL8LgAYb93GlC7hAyUUn5nu3R8ct8SLerWp/TIigmN5UJyIiIQvvl1j2UM6UcGc7Dnhq3pxenVSDpwplOIM1VGivry43JEo2mCmBtLlvKF1yVOhzqwx/BBlMG0wt2wGCiWklJE5hetq1PtRT4zdVmouBnBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908742; c=relaxed/simple;
	bh=N2c7L7FvTiEskAbBi2XT/uo/BtOvdwJ4mntyIxWuFls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kEszkmXCtJAu8Io5XdSoCdzCjPMiTitvn2mTpqraGOT+Q9+XwDDQ3bLgy+8DAOCF0EOIXqaKiJsj54lee/LgqOO8CZI4Uaw9avsHGq1fCPnHijjUPrOARqlqHI+PNHxWadcEkZENiUrw0yya2hASB1MEcw4vu7PRpVRC5M91IPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TClcCy4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TClcCy4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556ECC3277B;
	Tue, 23 Apr 2024 21:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908742;
	bh=N2c7L7FvTiEskAbBi2XT/uo/BtOvdwJ4mntyIxWuFls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TClcCy4AtqH+cyuWTo3xOW/uQ/AVWwfjmQkOoV6F5M33QWX6nt4/oX/OEiHG3XJZR
	 oH0NuOKEvokdrFC6PTkoaaoOBkXSVwNeLGLrv+3vHzoLaK/dSElxOUl7/RrDVdDu2S
	 kQ1/+u/tMA3t6WOkzgFqIWkFh8XpW93cU6QnfbSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	": Aleksander Morgado" <aleksandermj@chromium.org>,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 6.1 114/141] Revert "usb: cdc-wdm: close race between read and workqueue"
Date: Tue, 23 Apr 2024 14:39:42 -0700
Message-ID: <20240423213856.906960201@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1607830dadeefc407e4956336d9fcd9e9defd810 upstream.

This reverts commit 339f83612f3a569b194680768b22bf113c26a29d.

It has been found to cause problems in a number of Chromebook devices,
so revert the change until it can be brought back in a safe way.

Link: https://lore.kernel.org/r/385a3519-b45d-48c5-a6fd-a3fdb6bec92f@chromium.org
Reported-by:: Aleksander Morgado <aleksandermj@chromium.org>
Fixes: 339f83612f3a ("usb: cdc-wdm: close race between read and workqueue")
Cc: stable <stable@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -485,7 +485,6 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
-	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -500,10 +499,7 @@ static int service_outstanding_interrupt
 		goto out;
 	}
 
-	used = test_and_set_bit(WDM_RESPONDING, &desc->flags);
-	if (used)
-		goto out;
-
+	set_bit(WDM_RESPONDING, &desc->flags);
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);


