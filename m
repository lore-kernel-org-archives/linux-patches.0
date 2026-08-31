Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC5448986E;
	Mon, 31 Aug 2026 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184957; cv=none; b=f5TBVBK399W7vTzAiNcMOChPPu0C9i0EnwHxQGoKgd45Jz/iPBbKlQ6AeTxUiPnkJUCsXlsGBay4fB91+GY2MPgjYNLhSAuONiq9dlE7ObnjFA049jaHjdYWU98Rz2+PLp4PhEZgtJOifRlblvXVipOaCfShx+YTXztuqaEE9RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184957; c=relaxed/simple;
	bh=HT1A7hsabq8688BAdQUFXNau3cPLl88UatbkA6+Hy28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psvIJzVTuguNlZyhmSJygsdXD/fVvPLJzTJSVxJKdUofD0xbuVWd7xQE6QZxFyVsxEEt9PYNL/c9ClQDdLRGBwhGePNjMwM6wLl4xsPKvY4lCWWw2R8GkQlyLWZq5XQfVmMQcExjS1An5dViU8Lmtj/SWeZNrJuFK5Uupa+Nhj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAR5mSM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAR5mSM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00EE1F00A3D;
	Mon, 31 Aug 2026 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184956;
	bh=AVNOs6m8cGLSZMi2QxvVlX8fM/AWMPwSyIcQgpu+J1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iAR5mSM6Ay3euvywga7CkB/sQc1qFNgMMAr4E209/tFLMYQzp1wi7wqmcRZ2MdlvT
	 hbelbt7yjACDvUr9xv9FQI6C8ps4dPJXgkZrtaE6d2qDcAqB6umV3JjLjIn6CqF0ZZ
	 8z5NCS53YJOpoHsw2eXYK5tkosAERl54kOw3IdsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Lucas De Marchi <ldemarchi@nvidia.com>
Subject: [PATCH 6.1 66/92] xhci: dbgtty: Fix unregister on tty_alloc_driver() failure
Date: Mon, 31 Aug 2026 15:35:04 +0200
Message-ID: <20260831133403.091956328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -597,8 +597,8 @@ int dbc_tty_init(void)
 	dbc_tty_driver = tty_alloc_driver(64, TTY_DRIVER_REAL_RAW |
 					  TTY_DRIVER_DYNAMIC_DEV);
 	if (IS_ERR(dbc_tty_driver)) {
-		idr_destroy(&dbc_tty_minors);
-		return PTR_ERR(dbc_tty_driver);
+		ret = PTR_ERR(dbc_tty_driver);
+		goto fail;
 	}
 
 	dbc_tty_driver->driver_name = "dbc_serial";
@@ -618,12 +618,18 @@ int dbc_tty_init(void)
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


