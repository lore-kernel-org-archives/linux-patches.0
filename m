Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADF33B19DE;
	Fri,  9 Oct 2026 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556957; cv=none; b=F9JEepbiA8Yc7r63bVitk1acdDm8LrK9K0RnO6cI4cSPXP3fsAPOtQOKYOK2d7FEfaOHjyNb5K88y27nd7LBzZp7yxa+sQy6wD4qX5wepnuzk+5NePD12LKVM4r0EOqoe+7RXS4fUPGGt5xIxvW25avl7igMm/DXRvKB/g8IuoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556957; c=relaxed/simple;
	bh=mCAonnpxZW6tEafWYg07KevZTOd1FReu7WEN3WN6wJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aacdHMY+hZtdGTwbiwZ5Qlnp6s4PljL2EJwxoOHTtgpK+X/hpbqVb5rQ3IoyonhHEyDGUIa+G0xMdzdPWN+r5jwH/h96CcGD0orOWY3Z6SgN0ttUmROkRJb8N+LbpJwBFHtt3lELC3rP9+yduHo3G4pQCjEz6S8w98n8KUzwBPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANZv/oJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANZv/oJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBF11F000FF;
	Fri,  9 Oct 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556956;
	bh=5EYezBQ6hpizFXQAINDrS4/j45QSmVMVC+SopEUWPXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANZv/oJ/scyS/2Y2lG3hLrvdryVGr1Zq1vnAMUxquJ4in5nZe0ow4bGbDCUEu06CB
	 F0SwlzmG6UIYg7HmXKxKikKVLR+a+9km8vLNL9izk/bHAN21YXGAWGOlgLOciOBF4L
	 SLFYmV1EQeJM71p6Y5uvWF11gVqJywaeiUfn+lBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 7.2 273/428] EDAC/versalnet: Drop remote processor handle refcount on driver removal
Date: Fri,  9 Oct 2026 16:10:10 +0200
Message-ID: <20261009140952.088944674@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 5f43a2d35d5e748c09a50a98fc766dc95bb3a6bd upstream.

mc_probe() acquires a reference to the remote processor with
rproc_get_by_phandle(), but mc_remove() does not release the reference.

rproc_shutdown() only balances the power reference acquired by rproc_boot();
it does not drop the device reference acquired by rproc_get_by_phandle(). As
a result, successful driver removal leaves the remoteproc reference
unbalanced.

Call rproc_put() during removal to release the reference acquired in
mc_probe().

  [ bp: Massage commit message. ]

Fixes: d5fe2fec6c40d ("EDAC: Add a driver for the AMD Versal NET DDR controller")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260913053532.1324671-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/versalnet_edac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/edac/versalnet_edac.c
+++ b/drivers/edac/versalnet_edac.c
@@ -953,6 +953,7 @@ static void mc_remove(struct platform_de
 	remove_versalnet(priv);
 	rproc_shutdown(priv->mcdi->r5_rproc);
 	cdx_mcdi_finish(priv->mcdi);
+	rproc_put(priv->mcdi->r5_rproc);
 	kfree(priv->mcdi);
 }
 


