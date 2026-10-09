Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725E33BD64D;
	Fri,  9 Oct 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556358; cv=none; b=Fr598umCHR1KGFznYlZ0AxyUSO1k2+0ajH57FH0SJkXu7TWIhuw6EJP99mqYmvg0uCjKXdbl429DjFKqQqnK95BsSUKR3dE8kwtUG6byNvzyvzJCER8WJipLkKg3AeSvzRqqletKJKYKrbtdF9htC/99PmCjRsxbhNsbU7t4QrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556358; c=relaxed/simple;
	bh=VQofDcEh7RNcQqMF7drTZtOxJLp86QEI1/w1ysEw1ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEV877ha9YmuADnR92BjCyCmPAr9J1Mv5mzNVp9S+PFE//DFnWxzpviorqSWdt73MLxHiwoWIyL5hH9Icz0ZvF7mpL/fwmi+mIV4TNgP/lbmlr/7EXnA2ZaFL+yFk8uiioDyZZgKQWLp2QKY/5AhR5Q42q8Oip+Bda5xkf40psY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVNkQzj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVNkQzj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A52F1F000FF;
	Fri,  9 Oct 2026 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556357;
	bh=M2m1p+49NTVuqcMQHlJMUi3hAOjWQ6kXck2k2BaggsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVNkQzj8Q3x4g897kCYfB/PNz5KAtp2PxKIhd02XJHe+MqDPVonhDX9+Iizjc2F2R
	 gkaDt7+xQweKUP7w7uGrVv6hD0hjQr9bRDznOkYy068XCb1QJWkzzxT9UvYDxg5vkC
	 KLMi7Sl/J4Upi89LzINVq0JX+2wdtdtQ7QWsNLPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 221/403] EDAC/altera: Fix use-after-free in error paths
Date: Fri,  9 Oct 2026 16:09:42 +0200
Message-ID: <20261009140957.315067222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

commit eef3b67f9c6782127163b631c9043011a68016e2 upstream.

In both altr_edac_a10_device_add() and altr_portb_setup(), the error path
freed the dci structure before releasing the devres group. Since the managed
single and double bit IRQ handlers use altdev(dci->pvt_info) as their data, an
IRQ firing between freeing dci and unregistering the IRQs could dereference
the freed memory.

Release the devres group first so the managed IRQs are unregistered
before the dci structure is freed.

Fixes: 911049845d70 ("EDAC, altera: Add Arria10 SD-MMC EDAC support")
Fixes: 588cb03ea208 ("EDAC, altera: Add Arria10 L2 Cache ECC handling")
Closes: https://sashiko.dev/#/patchset/20260719211238.589402-1-rosenp%40gmail.com
Assisted-by: LLM
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org ## 6.18+
Link: https://patch.msgid.link/20260911120627.2634225-5-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1593,8 +1593,13 @@ static int altr_portb_setup(struct altr_
 	return 0;
 
 err_release_group_1:
-	edac_device_free_ctl_info(dci);
+	/*
+	 * Release the devres group first so the managed IRQs are
+	 * unregistered before dci (which contains the IRQ handler's
+	 * data via dci->pvt_info) is freed, avoiding a use-after-free.
+	 */
 	devres_release_group(device->edac->dev, altr_portb_setup);
+	edac_device_free_ctl_info(dci);
 	edac_printk(KERN_ERR, EDAC_DEVICE,
 		    "%s:Error setting up EDAC device: %d\n", ecc_name, rc);
 	return rc;
@@ -1997,9 +2002,17 @@ static int altr_edac_a10_device_add(stru
 	return 0;
 
 err_release_group1:
+	/*
+	 * Release the devres group first so the managed IRQs are
+	 * unregistered before dci (which contains the IRQ handler's
+	 * data via dci->pvt_info) is freed, avoiding a use-after-free.
+	 */
+	devres_release_group(edac->dev, NULL);
 	edac_device_free_ctl_info(dci);
+	goto err_print;
 err_release_group:
 	devres_release_group(edac->dev, NULL);
+err_print:
 	edac_printk(KERN_ERR, EDAC_DEVICE,
 		    "%s:Error setting up EDAC device: %d\n", ecc_name, rc);
 


