Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5424B43D51D;
	Tue, 21 Jul 2026 22:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673083; cv=none; b=Fiaj5r78L//b416xJ6bE2z3I5myPXtHipnsJba5E527oHeEErmDuWCw+9qWic7bWBA8MQa7WdTesmxPDjlp0yjORPHM2wfiVOw3XDEnrpqKcMzIABcC6OVzCqKhXKw0dPDQ9orjokcc+Vu8WQl2bld/05t8bPgNBlVdkKpUqgfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673083; c=relaxed/simple;
	bh=6wCd/J89NpIqknJWTzYd+wAljx1o78BSPB6w/sIHKeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzrSoPDqQyfIaNj5V8e7HCums9BfxPTc/o6fSa3VMSRUQ/GusHTRvAktAekZDqeZl1dm8EI2HfKjEl7g0H4pvVMDxA22Y7mQXbzxvZTKrHiqJOjsua9L1dJyJ7NpJiMAD1y1pcd/NHJsd0uUOI89D2Zz4UzUXtvJ0Iy0pOlozvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiLFN/ax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiLFN/ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7941F00A3A;
	Tue, 21 Jul 2026 22:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673082;
	bh=gQY8dJaUJ83qtlnJV2iBD+rSo/Wi5CXWWpXz3WwhNLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiLFN/axogdfWqBVLdnEtq/dERgvVMWxB+V3qQNxHLTOeoG6Zy+y2DRFoVnlh6Q22
	 p4jiaVePflFyyPx3nYd1e6WFvsacKhaGRQCSUSJO6tr+6rz9M+RiZ5xqWc1Qy86i4t
	 MFLyjX41venWYwTTbu0LpEOdvg12i044Gub5h6k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/699] i2c: core: fix NULL-deref on adapter registration failure
Date: Tue, 21 Jul 2026 17:16:27 +0200
Message-ID: <20260721152356.337581126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 2295d2bb101faa663fbc45fadbb3fec45f107441 ]

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
Stable-dep-of: ba14d7cf2fe7 ("i2c: core: fix adapter registration race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1462,7 +1462,7 @@ static int i2c_register_adapter(struct i
 	res = device_register(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto err_remove_irq_domain;
+		goto err_put_adap;
 	}
 
 	res = of_i2c_setup_smbus_alert(adap);
@@ -1504,10 +1504,12 @@ static int i2c_register_adapter(struct i
 
 out_reg:
 	i2c_deregister_clients(adap);
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


