Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6976C3F482E;
	Thu, 16 Jul 2026 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211457; cv=none; b=pgEgzMljgdno4qfJnOEVJ6bk95ppwZmSb3tqrsZP0HlnGQJH4Xr7cupM8FlBYGg9nrICJ37sP3OBFl2S339FQGa2pvIK9GF4rdHwRmY/xyuHdezzjP+MKkK3nPc4vlZ1qNnsGRg7ysly/H79gZrM24GHru2K+QjoptQiye36Qqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211457; c=relaxed/simple;
	bh=0bIAckS2jy+UJkeQitbjafcmt0XhHrm8nWP1cPsPM9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoJgALEQLB9DJoAIurMMRgx09tMHuf59LBf7C8ounCq1YWFtTPFNwvOL/FRTXUN/NzAi2a9/nNp0UgspfUAPSdYZwBCHBJWFTt6Ja1v8mdF+ACzxUWbvd4asJfvfmaM86zV59pDaVGMltXrSBHafUSDgnx1UZF1h8RIob9KrHUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlO9f1uW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlO9f1uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE86B1F000E9;
	Thu, 16 Jul 2026 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211456;
	bh=K1OipKxMNS82a+tigLyPgF07c1HdHukRWcK1UvziAbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlO9f1uWgUR7DC27HnWL8bSZxNEWeafKlyQc6catzUc+vyRv5+SrRGZl4wQLOL/Ti
	 C2o+z0vgDgXpZ22HMo73KQMLR46hMkIONTogeUbAx2o3iCTlv9eEmG3j4kNRg4w1t3
	 AFxYn8O09JTTNdvKCA4wMDKIQWolM4Cwhu6F28sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.18 435/480] i2c: core: fix NULL-deref on adapter registration failure
Date: Thu, 16 Jul 2026 15:33:02 +0200
Message-ID: <20260716133054.226302206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 2295d2bb101faa663fbc45fadbb3fec45f107441 upstream.

If adapter registration ever fails the release callback would trigger a
NULL-pointer dereference as the completion struct has not been
initialised.

Note that before the offending commit this would instead have resulted
in a minor memory leak of the adapter name.

Fixes: 3f8c4f5e9a57 ("i2c: core: fix reference leak in i2c_register_adapter()")
Cc: stable@vger.kernel.org
Cc: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1582,8 +1582,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		put_device(&adap->dev);
-		goto err_remove_irq_domain;
+		goto err_put_adap;
 	}
 
 	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
@@ -1612,10 +1611,12 @@ static int i2c_register_adapter(struct i
 out_reg:
 	i2c_deregister_clients(adap);
 	debugfs_remove_recursive(adap->debugfs);
+	device_del(&adap->dev);
+err_put_adap:
 	init_completion(&adap->dev_released);
-	device_unregister(&adap->dev);
+	put_device(&adap->dev);
 	wait_for_completion(&adap->dev_released);
-err_remove_irq_domain:
+
 	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);


