Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A7247010D;
	Tue, 21 Jul 2026 20:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665444; cv=none; b=abpeeBQcaxkAPgJMB3rAHVHcnamL6ACvMeurldrEmnLtwavzmcvInC8FVLdABj0jq020ZmATyWK6fHKTb/H+dwyWgsO662ZQxxXG6iDaMUYp10RZJGh0F9Qliv6srA8mEwCUbXzVXbZcSPAKJ1gBu/LSJmklxNm1kAdzeLbTw4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665444; c=relaxed/simple;
	bh=srtOLYwa3YrRDquAmQ2DCc+z0Lv0Q+ZX1Bg66qbOevg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQh9wnv5utXaEgxd1DbNYIZwaQdlTEZgCYTyWOWuRSq+My5aPXYr3UwlxjOfUC1OwT+v1RDupK6A72/ntvoPZlmItDTvK5U2RnvAg1BEJ4GIvV0Y+Jk7QgO8GfZ6+VB89pmI3dLjX+cvBDI16S+BKH9yUGJfNR9PhCn9rVdCrmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg0AfnzR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg0AfnzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B621F000E9;
	Tue, 21 Jul 2026 20:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665443;
	bh=StDPIKZoolK8Rmx2SwLTz/LBSRHOIF9hfxylim0STek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zg0AfnzRYufhk5uCYnFyATLKh/N0yb2R6M1XB7tHt4zAXfD1XLMDkB6OSEFqGT5vZ
	 NRz+SDprSmKgpMDsDwCDIr55pCge8VtarnS/ruyCPAjfhIB5X6dIlyjC0Hmys2Sw2Y
	 XbN5CsWvw3mkaSAFoOhdKGjyvjEC6BhAuN6RtUTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0305/1266] Input: synaptics-rmi4 - unregister function handlers on physical driver registration failure
Date: Tue, 21 Jul 2026 17:12:22 +0200
Message-ID: <20260721152448.655349513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 6251f7d3472c0409e30f8d6a24f10d33d12e3f9a upstream.

If rmi_register_physical_driver() fails, the current error path
unregisters only the RMI bus. The function handlers registered
earlier remain registered with the driver core.

Add a separate error path to unregister the function handlers
before unregistering the bus in this failure case.

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260610064633.2837084-1-haoxiang_li2024@163.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_bus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_bus.c
+++ b/drivers/input/rmi4/rmi_bus.c
@@ -448,11 +448,13 @@ static int __init rmi_bus_init(void)
 	if (error) {
 		pr_err("%s: error registering the RMI physical driver: %d\n",
 			__func__, error);
-		goto err_unregister_bus;
+		goto err_unregister_function_handlers;
 	}
 
 	return 0;
 
+err_unregister_function_handlers:
+	rmi_unregister_function_handlers();
 err_unregister_bus:
 	bus_unregister(&rmi_bus_type);
 	return error;


