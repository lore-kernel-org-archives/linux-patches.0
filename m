Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC30737A84C;
	Thu,  2 Jul 2026 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010635; cv=none; b=lEdkISWi2o1lK0lwGoCm/z7BNvMTMhsVeW9GKGCCyk723b4RArFEbshBJ2o0NFOlfu+U8y5T/l825c9Aui10a6HrE1pPWXEordteTYvjdz4WoD9/wHUhMKRHxIp/0hIhjShcpWXmxRkdbtYsFej2EA5gGIs4ktp2H1yhF8Ao+3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010635; c=relaxed/simple;
	bh=Hm8HMLFN4f9ex38RnXueiBD/kMc4arW7QUc9Vlk3NMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcoX5204glCR7Ar5h1WRhHJnvTNBl5Xhme1Wq/S4uyY/075b9d5oI5di+0Gy42XhD16wbJDV1ESQDkPATFbXnU7Eg79DIz1HP/wy8xL12+yPeWKDExEA/iQuypNpMyQTF0barQIKjvIExesu6LOYMKbiE87V+nETQBeg5ZcHBXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lpjfy9gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lpjfy9gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8871F000E9;
	Thu,  2 Jul 2026 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010634;
	bh=bEdwa8++Nr2givTB3LT2pYPFXj7GoJNuNWVKMsCpHwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lpjfy9ghWR2j+7pK/Gp/qnLA++EnJyyCPu2muzeyJW7p70AVCogB7PiJ4cAJ2iqhO
	 WO9h71xM/oyBG+tod+/Yt6F4gbBM6sE3Pd4f1U7k63IgsowcW0n4XV5fcbCAzrIKLX
	 HrEwaA9wXycLDLnd2wa7E9JXdtBAg+r1JPnP4gB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.12 184/204] i2c: core: fix adapter registration race
Date: Thu,  2 Jul 2026 18:20:41 +0200
Message-ID: <20260702155122.514271101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit ba14d7cf2fe7284610a29854bdff22b2537d3ce6 upstream.

Adapters can be looked up based on their id using i2c_get_adapter()
which takes a reference to the embedded struct device.

Make sure that the adapter (including its struct device) has been
initialised before adding it to the IDR to avoid accessing uninitialised
data which could, for example, lead to NULL-pointer dereferences or
use-after-free.

Note that the i2c-dev chardev, which is registered from a bus notifier,
currently uses i2c_get_adapter() so the adapter needs to be added to the
IDR before registration.

Fixes: 6e13e6418418 ("i2c: Add i2c_add_numbered_adapter()")
Cc: stable@vger.kernel.org	# 2.6.22
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1559,6 +1559,10 @@ static int i2c_register_adapter(struct i
 	pm_suspend_ignore_children(&adap->dev, true);
 	pm_runtime_enable(&adap->dev);
 
+	mutex_lock(&core_lock);
+	idr_replace(&i2c_adapter_idr, adap, adap->nr);
+	mutex_unlock(&core_lock);
+
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
@@ -1617,7 +1621,7 @@ static int __i2c_add_numbered_adapter(st
 	int id;
 
 	mutex_lock(&core_lock);
-	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1, GFP_KERNEL);
+	id = idr_alloc(&i2c_adapter_idr, NULL, adap->nr, adap->nr + 1, GFP_KERNEL);
 	mutex_unlock(&core_lock);
 	if (WARN(id < 0, "couldn't get idr"))
 		return id == -ENOSPC ? -EBUSY : id;
@@ -1653,7 +1657,7 @@ int i2c_add_adapter(struct i2c_adapter *
 	}
 
 	mutex_lock(&core_lock);
-	id = idr_alloc(&i2c_adapter_idr, adapter,
+	id = idr_alloc(&i2c_adapter_idr, NULL,
 		       __i2c_first_dynamic_bus_num, 0, GFP_KERNEL);
 	mutex_unlock(&core_lock);
 	if (WARN(id < 0, "couldn't get idr"))


