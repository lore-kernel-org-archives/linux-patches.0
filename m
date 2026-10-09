Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E26F459AD2;
	Fri,  9 Oct 2026 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556981; cv=none; b=Ictb0WBUvdqCmAw4YwEW30jHHjChozJxkClIqewrqVSuWwuyK/s9occ8IK732MRAZw8ZQcceiVadvTb5nd9NH2n8GyAq7BKjN+Az0yWF3cJTWAJHcPu7pM/PmZyt2hWEmN0ErKLloE6ASf8C2o7jYGgZIU0o3OK4HaYPIrF+NP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556981; c=relaxed/simple;
	bh=9FLIQ9Xi+b/yQ0TpafDISQQ8SJ5oQ0Z/D44Rb/+KeIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDGGW9zoMPKEdMRNzmm+XKjR7ILNajT7iXVOLklEV+bfAUBoiITyIiXtTS9EqO1bcd7dqth8NBjsnfSd2W53NKt8TaGFR7D8RnXjDEJZaHXi1D7OOo+4zhsP67Z9CfXANRV9/sdsJBY7QR7s/H2cUNrE+xzKdbCkrsXCAjVemVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kquRK4AM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kquRK4AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D891F000FF;
	Fri,  9 Oct 2026 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556979;
	bh=v4+swGPXsnGYGKrY5GdCkzgn2HxyUj/wluIo/rftQdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kquRK4AM6U0hEqmDH59zD4qUPyBFK0b3KtlUdy1d08GnJCC2KepQ4ZcEpRgbF2wvx
	 obKMkfuRD3CAOuuen9U838HnSV7m2Z4pe0Po9mYQBalga7ROVbCO1He7LOuNM7IkYF
	 3B0pjh08B9/3SKUvLUfOHXoicW9D3/1JGxNajj/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 7.2 277/428] EDAC/altera: Fix use-after-free in error paths
Date: Fri,  9 Oct 2026 16:10:14 +0200
Message-ID: <20261009140952.179371566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1594,8 +1594,13 @@ static int altr_portb_setup(struct altr_
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
@@ -1998,9 +2003,17 @@ static int altr_edac_a10_device_add(stru
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
 


