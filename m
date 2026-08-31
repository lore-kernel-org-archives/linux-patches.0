Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F2559CB1;
	Mon, 31 Aug 2026 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184040; cv=none; b=GdY1nDy3hVaAZoUMY3dtT+KeDCPv5ngoAGPusfuRBVt39t+hzhr3noxFweWZ/7f2VLWIi8PdiR7WSeRheAGyz7ix8Hu/BuABNzalY4aG4jOfklDT1V8JIAb9zr/4IKD9+zQOICPAVSXJheyDvCC6+iKMU2HU2cAos2DHh9hrDBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184040; c=relaxed/simple;
	bh=kH69iWh0feqmj+H1R0EAK1lw/P8oqi7VDnJjCNhEFzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1koaRJIMUWi7dp3P/AmpDNWYrL4rUPg+Zed92t8oM2EHRQco3Xxfxp4k16afkzGo3P3xlsF5BUmg+LjSRtEfxQtxLl/G4i8uG4f7q08rTJeTyi3oh2CbO9YJJkSa+tw/uOVy2qjy6MYwWU+n9LuvWBzzpCj8qRAUbcd/MTRncY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4xgkruc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4xgkruc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB1E1F00ACA;
	Mon, 31 Aug 2026 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184036;
	bh=4lOq/NooncOV/CWfdrl92DytmwyQ+D8dfEVMI0s5Ajc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4xgkruch9U8CZGZ6yj3tmf0okIaN3AIUy5lEM+bOCZad29U34H0a+TqC5FA4sLmr
	 OUjf60y1Y1B5dpUooW0Z4qBtFG1HIoWjNAgMQu1vP3zzd/2njViDDkHFiDDO9Cyigc
	 VlSpzMrzdid0y9vrWCe0o0bCfrMo9rBbRj39YFnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Lucas De Marchi <ldemarchi@nvidia.com>
Subject: [PATCH 6.18 34/83] xhci: dbgtty: Fix unregister on tty_register_driver() failure
Date: Mon, 31 Aug 2026 15:34:10 +0200
Message-ID: <20260831133401.184866968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Lucas De Marchi <ldemarchi@nvidia.com>

commit a916fa66a43e10f63198b6ce978badffc678821a upstream.

If tty_register_driver() fails, it drops the reference, but fails to set
the global dbc_tty_driver to NULL, causing the unregister to be called
again when module exits.

On module unload dbc_tty_exit() only gates its cleanup on the driver
pointer being non-NULL, so it operates on the already-freed driver:

    module_init(xhci_hcd_init)
      xhci_hcd_init()
        xhci_dbc_init()                       [return value ignored]
          dbc_tty_init()
            tty_register_driver() fails
              tty_driver_kref_put()           -> driver freed
              (dbc_tty_driver left dangling)
    ...
    module_exit(xhci_hcd_fini)
      xhci_hcd_fini()
        xhci_dbc_exit()
          dbc_tty_exit()
            if (dbc_tty_driver)               -> true (dangling)
              tty_unregister_driver()         -> use-after-free

Fixes: 4521f1613940 ("xhci: dbctty: split dbc tty driver registration and unregistration functions.")
Cc: stable@vger.kernel.org # v5.10
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lucas De Marchi <ldemarchi@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -651,6 +651,7 @@ int dbc_tty_init(void)
 		pr_err("Can't register dbc tty driver\n");
 		tty_driver_kref_put(dbc_tty_driver);
 		idr_destroy(&dbc_tty_minors);
+		dbc_tty_driver = NULL;
 	}
 
 	return ret;


