Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5435A8954;
	Mon, 31 Aug 2026 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184353; cv=none; b=FvMwqMN1wPwuAPEMUQ6VZHbYMH2Evj9zfOT7GbjMRSyCjKpk3ANKOsRF8pVRn5RPU5mSOKWOOqHxxw/maHTW+ptVwy2tBlc+pdNhastV6QO3BB42oYYomFPgMYAjNKydXcMhB2ASPj71UQOOWEnnk+wUcHP5X1YFyJZrSD/VsfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184353; c=relaxed/simple;
	bh=GCGVMff+TcOJ+x+JOALB+zxZnrvJ3CMd2CUeZpMweRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/GkMl/DFFLJ3vRnzqOymHyVicEb58duNyCwc8iAd4WjVb23+F8oXK4vUoY9l0EIExmnnoHnoSKKY3CoJMk+XQlP4ttbHJ+HtR8JlKHWMgmMZyVcwRa1YO1VhMQty5EfDbeozHY9150ICw6wPUTj6PMZzpz8qC/m7332KHIsFbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2d0M5+MW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2d0M5+MW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BB91F00A3F;
	Mon, 31 Aug 2026 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184351;
	bh=KaR4DYJ68/sY1dQLgTBw2cgQ7UFrUiWu9wLvsWhuZRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2d0M5+MW6dyFq0z6wNohRldu9Fn+fUKEIpFLePhceyFEGNUqZJOPpdBul33Jbqs/a
	 EWkmejYzFT0xI+DKqQ94d/jZLHzChoQxWDtVSS7+CEhchl0wZ4gTId2PE4LTQmX9LR
	 YpdPchCodRX8tpZDfoYClK3JFk1fhwSDe0dtY34w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Lucas De Marchi <ldemarchi@nvidia.com>
Subject: [PATCH 6.12 60/99] xhci: dbgtty: Fix unregister on tty_alloc_driver() failure
Date: Mon, 31 Aug 2026 15:34:29 +0200
Message-ID: <20260831133403.002136942@linuxfoundation.org>
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

commit 25b8dfc13495a6c1cf4abacc8ef20196c7f20e5c upstream.

Make sure to set dbc_tty_driver to NULL to match the check in
dbc_tty_exit(). For that, make detached error handling path common to the
other branch in the same function.

Fixes: 4521f1613940 ("xhci: dbctty: split dbc tty driver registration and unregistration functions.")
Cc: stable@vger.kernel.org # v5.10
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lucas De Marchi <ldemarchi@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-9-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -596,8 +596,8 @@ int dbc_tty_init(void)
 	dbc_tty_driver = tty_alloc_driver(64, TTY_DRIVER_REAL_RAW |
 					  TTY_DRIVER_DYNAMIC_DEV);
 	if (IS_ERR(dbc_tty_driver)) {
-		idr_destroy(&dbc_tty_minors);
-		return PTR_ERR(dbc_tty_driver);
+		ret = PTR_ERR(dbc_tty_driver);
+		goto fail;
 	}
 
 	dbc_tty_driver->driver_name = "dbc_serial";
@@ -617,12 +617,18 @@ int dbc_tty_init(void)
 	ret = tty_register_driver(dbc_tty_driver);
 	if (ret) {
 		pr_err("Can't register dbc tty driver\n");
-		tty_driver_kref_put(dbc_tty_driver);
-		idr_destroy(&dbc_tty_minors);
-		dbc_tty_driver = NULL;
+		goto fail_put;
 	}
 
 	return ret;
+
+fail_put:
+	tty_driver_kref_put(dbc_tty_driver);
+fail:
+	idr_destroy(&dbc_tty_minors);
+	dbc_tty_driver = NULL;
+
+	return ret;
 }
 
 void dbc_tty_exit(void)


