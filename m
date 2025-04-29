Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EF721883E;
	Tue, 29 Apr 2025 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947936; cv=none; b=t7cPufFWjFIf5mMrsa41Bqu+Ty641sdvc1AHKn1SakyaZoz//ZN8y3qHkvPvILwBsw3MgT8CH06BbDKYYG3AHEV8wokXy6CNWPwJnui3I7kD3USr/eoLrxpxHdwN8hF1fniXMIWlkJyHRc+Jq/bpX5jKKO2mhQ/vD1Zh7Tho+pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947936; c=relaxed/simple;
	bh=V7FiyFT/Dr/wun2mEORKoN6eHYKlMAk73TOPMSSxbMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO2AVvJ1YweeHss8kqwPHf9kEN8dshUIlguHbvN9jlQHiRnkQlpayxC7gBl31MOuMvpAQxCrmnjBj7YYpAnQ/gSaTbZF7XQREXLclR3cbSA0PbW8vIVfKK8MuVcqYZTK9SGc93DLgf1H2oEVOXBWE/mG7ShjXnv6X5oxld5wx4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy3e2UOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy3e2UOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0CEC4CEEA;
	Tue, 29 Apr 2025 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947936;
	bh=V7FiyFT/Dr/wun2mEORKoN6eHYKlMAk73TOPMSSxbMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vy3e2UOAbgwJX3N00bV2/nG+OgZXTuZ1hDYP1LI9meO2UwAB+swNvb1kTU2iGx/mx
	 zkaaZ1NucZUcmOn0sOdEiICZnXmAnPxxTY94hDp/qfi0urW6BWc1hmuGF0vYliBakB
	 sd8RoR7t9G1rqj+3FHvhk6utC57B4Xjj9KHEj+ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 149/280] USB: wdm: close race between wdm_open and wdm_wwan_port_stop
Date: Tue, 29 Apr 2025 18:41:30 +0200
Message-ID: <20250429161121.219647019@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit c1846ed4eb527bdfe6b3b7dd2c78e2af4bf98f4f upstream.

Clearing WDM_WWAN_IN_USE must be the last action or
we can open a chardev whose URBs are still poisoned

Fixes: cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250401084749.175246-3-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -726,7 +726,7 @@ static int wdm_open(struct inode *inode,
 		rv = -EBUSY;
 		goto out;
 	}
-
+	smp_rmb(); /* ordered against wdm_wwan_port_stop() */
 	rv = usb_autopm_get_interface(desc->intf);
 	if (rv < 0) {
 		dev_err(&desc->intf->dev, "Error autopm - %d\n", rv);
@@ -868,8 +868,10 @@ static void wdm_wwan_port_stop(struct ww
 	poison_urbs(desc);
 	desc->manage_power(desc->intf, 0);
 	clear_bit(WDM_READ, &desc->flags);
-	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
 	unpoison_urbs(desc);
+	smp_wmb(); /* ordered against wdm_open() */
+	/* this must be last lest we open a poisoned device */
+	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
 }
 
 static void wdm_wwan_port_tx_complete(struct urb *urb)


