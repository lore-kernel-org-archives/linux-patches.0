Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C247D5A1768;
	Mon, 31 Aug 2026 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184322; cv=none; b=Mu3OANFZxfRK70sq9aEB0gij86tidR2zV7VuIsE2v/nbXv59y6LpcFqBmHzFSHAWlddABgonD5eEcRI17URJk2vgrBSbd5B1YNGAso4jn+r2DW0HD6auF/L79T6WN5kOk8o/VYTPG8laBMBP+NFrYyY4xhMzE5aPoLKZ8GlUp0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184322; c=relaxed/simple;
	bh=EQgcoKpL/bY6JQHBpPL5c52l899CsBWgndsTO4vdhNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFx6fnGP75bdpCcRE4RYyliys1nhtwFUWlARx7oeLu1LvOL51M/zc4S+CMd8z5EuX5+Jj3+RZvYkE77kDMswHvLfQUZTyeiAJ2dLbCDCuHQvoknoKPWnH+2OdnC8abAPWw3ppImjBKLCNeXDJOI/9K5LiMSYT38G9x8csO5YcpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVyPKDgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVyPKDgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2C71F000E9;
	Mon, 31 Aug 2026 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184320;
	bh=ATnoOXxt5HboDf2KbWZ+5dfmXBsUppDAwjKOlujsvWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVyPKDgKz8cVGSD6la44xSOLymRWat+mZ9Tohtap4ou2h4eHICUw1G1zgU0cb5tzc
	 a8wZsUbXIiZPO3lYGFE+r/ge20/sPBGTiTTCSyJ7of4a9z/1h6gEFjlwamN6fzsAI7
	 kMLlRlw28UN6Ke61snG+lzYGJaNEyPJTTDtxur0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Lucas De Marchi <ldemarchi@nvidia.com>
Subject: [PATCH 6.12 59/99] xhci: dbgtty: Fix unregister on tty_register_driver() failure
Date: Mon, 31 Aug 2026 15:34:28 +0200
Message-ID: <20260831133402.960548133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -619,6 +619,7 @@ int dbc_tty_init(void)
 		pr_err("Can't register dbc tty driver\n");
 		tty_driver_kref_put(dbc_tty_driver);
 		idr_destroy(&dbc_tty_minors);
+		dbc_tty_driver = NULL;
 	}
 
 	return ret;


