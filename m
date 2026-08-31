Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6631D480356;
	Mon, 31 Aug 2026 13:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183469; cv=none; b=OJE5ic+By6IEI5/Kxf/mp2rjtGCk25hmy3ECAWc45UxSW6tbgO/jJl+bufvXDTfGZA2J1Kefufn01xsn+0+scA4wCuR/v6ysZM91Jztwwcsyg2aQgfrWzHONzbbDpOx2lLKXHBpmqxQ+9+JYrcu4SRpxMDqjJDd6feHHx0gFlYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183469; c=relaxed/simple;
	bh=5L6hQO0MhHBPrBoj8zPkZ+1p1f/8nuO5OX/8ohXBXjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDR1vvHoxccBwtOAcK6CbU6lKu53+X+E/+PnSGuUFcxCmynap31sZ0oIy0cMFOa/hwQapnHOXNKH5+sPmtx4LxGz4hDPgOKI1iSVTQc1P7eJ3EKBiY552b57ZOZtIHruhY1j3xjgfgexn8kCCgqhAMONRNrIXzUAQTwwJay7W14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1JQldx+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1JQldx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF591F00A3D;
	Mon, 31 Aug 2026 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183468;
	bh=MbOKC1b9W982L5R+roiS+14/u5FG7GQOBheDH6a4CSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1JQldx+sko707LScNqrm6E2RFk5KqShhpiju/EQExjfYUt5gMJYe7bZiq0O07gYr
	 R8lv3IyqrUmQ9oSPaeNwwTuF/LV4nPlTWQD/6f/OA4j79LNC5UQTbN1DU676GcmtF0
	 T8cYPOtDQQ4l0Z5Kji9KcuLBqK3JBEYnsn4o8TMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Lucas De Marchi <ldemarchi@nvidia.com>
Subject: [PATCH 7.2 10/71] xhci: dbgtty: Fix unregister on tty_register_driver() failure
Date: Mon, 31 Aug 2026 15:33:35 +0200
Message-ID: <20260831133359.513409535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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


