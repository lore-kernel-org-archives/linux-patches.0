Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F348F852;
	Mon, 31 Aug 2026 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185078; cv=none; b=WhKzndtc0XpMIDjhTTH2QfTVuU8Cf+EZKSBBeljm24JdpgU0RYbsHYeAXJu4e2RcOI1EBNeT/x9K5xJ0NDhZ++1ebbpYBz2L/cy+PYjzawTW//xqWtY/sqZrSD+q9qKQ/DA7Byp+scoWx8+L34Xh5vvsWxPnYKJgwChpXxapqSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185078; c=relaxed/simple;
	bh=U/vXqGv/wyoVbkKHqYm53KMO/7C2BwNQ4044fEmTNjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBXVjFkZq45xhtI744N5DPVbVobLYMoc4treQMzQXI2WxojjLvn3F1PcDzovanc9S0ZsPAFf+N6/UbyAmkkvntlmN4ofBC2kkT4OQazyWRttbdro6ikmV8lyn2aD1/DXtWmebDdz+q1QUPrIJvfwLUX88+NtiZ/iqwSliZMprTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2NfnpnN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2NfnpnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B721F000E9;
	Mon, 31 Aug 2026 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185076;
	bh=957ypWMYxa7iJkkq93Aeg3NhasKm6+/4kcpKBJFt9iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2NfnpnNI1nbDGM8aoehdQbf1fxHWtlsZ9Y4i9frD/x9BTack8oxIUOOAXh+2BD6W
	 kn8q/MnRfTidqmx5sgAYvcbkGgtHF4J74QEyDaXgH0WHpAc8p0KghD8gRA+eINp5Sd
	 uc8aHz2O/O4zpKCGjx/jPUBd/RIAu/AP9cofOzdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Lucas De Marchi <ldemarchi@nvidia.com>
Subject: [PATCH 5.15 45/69] xhci: dbgtty: Fix unregister on tty_alloc_driver() failure
Date: Mon, 31 Aug 2026 15:35:18 +0200
Message-ID: <20260831133400.839889290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -576,8 +576,8 @@ static int dbc_tty_init(void)
 	dbc_tty_driver = tty_alloc_driver(64, TTY_DRIVER_REAL_RAW |
 					  TTY_DRIVER_DYNAMIC_DEV);
 	if (IS_ERR(dbc_tty_driver)) {
-		idr_destroy(&dbc_tty_minors);
-		return PTR_ERR(dbc_tty_driver);
+		ret = PTR_ERR(dbc_tty_driver);
+		goto fail;
 	}
 
 	dbc_tty_driver->driver_name = "dbc_serial";
@@ -597,12 +597,18 @@ static int dbc_tty_init(void)
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
 
 static void dbc_tty_exit(void)


