Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3550A41B8CD;
	Sat, 12 Sep 2026 10:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207221; cv=none; b=GXN/h8xDb0SRx9P5mxCCj6nKqgcaw1ZeTkbCavLvHpvBD4y2xZcXrmGljZe6PisCFIqPIOqAQUnSQ7/56XDuajDOOqkr/NNb1zhXhP8+e+XnoYIpk+H04H544cKkDFzzrYNN3QIAaHxYPwZVOaKWPb7Qfmk27eRVTSEMR9QLVQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207221; c=relaxed/simple;
	bh=hCogOOxu6phsjJbRndtSL5gAAy/ex5r4pr4IDbO9CaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elFehym0lvx6iWVX13uizD4MeAIDbwfVGjNG5EFSmSgr9i6h1BRzXhTGdyhhFwZAw1hZBFD3b4BYT3LvqeM/4s5/HcjAJ0G4Jgaw9o1d7HsuqdFp5iEwgn95cViRmieOY6uqiiJX2Qd0RWA9eovhfhA62ZFARtAdzz6oMz8izMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCREpy9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCREpy9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73631F000FF;
	Sat, 12 Sep 2026 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207219;
	bh=GuUe4kBbphweYxgiSQVSzb4Tw9wEdJK9X2PYv3/g4wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCREpy9RiTj+KOzra3PviChaAgT/A9RtucA4QW3gln3zrK+uxGQ/hILvaL5mBgk/B
	 JNwRjeTg3a2IsVswQ3zy06a1TdOzCItvAYFOHbrsrymaNH/CcW5oCGsPDgt8GcecJ5
	 DVZInfplPfGnxwIQmVhEhYzUsV8nNCBAN4kUZ9g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0325/1518] usb: typec: ucsi: gaokun: unwind notifier on UCSI register failure
Date: Sat, 12 Sep 2026 08:41:34 +0200
Message-ID: <20260912065630.826113998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 2c5659a7064e7c4c0c51eb9356bcf6726a85773b ]

gaokun_ucsi_register_worker() registers the EC notifier before calling
ucsi_register(). If ucsi_register() fails, the worker currently only logs
the error and leaves the notifier registered. Later EC events can then
call into an unpublished UCSI instance.

The remove path also unconditionally unregisters both the EC notifier and
the UCSI device even if the delayed worker failed before both publication
steps completed.

Unregister the notifier immediately when ucsi_register() fails, and track
only the fully published state. The remove path then tears down the pair
only if both publication steps completed.

Fixes: 00327d7f2c8c ("usb: typec: ucsi: add Huawei Matebook E Go ucsi driver")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Pengyu Luo <mitltlatltl@gmail.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260709123239.62930-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
index 95b7b77b726d7..b40718f402370 100644
--- a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
+++ b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
@@ -103,6 +103,7 @@ struct gaokun_ucsi {
 	struct notifier_block nb;
 	u16 version;
 	u8 num_ports;
+	bool registered;
 };
 
 /* -------------------------------------------------------------------------- */
@@ -482,8 +483,13 @@ static void gaokun_ucsi_register_worker(struct work_struct *work)
 	}
 
 	ret = ucsi_register(ucsi);
-	if (ret)
+	if (ret) {
 		dev_err_probe(ucsi->dev, ret, "ucsi register failed\n");
+		gaokun_ec_unregister_notify(uec->ec, &uec->nb);
+		return;
+	}
+
+	uec->registered = true;
 }
 
 static int gaokun_ucsi_probe(struct auxiliary_device *adev,
@@ -528,8 +534,11 @@ static void gaokun_ucsi_remove(struct auxiliary_device *adev)
 	int i;
 
 	disable_delayed_work_sync(&uec->work);
-	gaokun_ec_unregister_notify(uec->ec, &uec->nb);
-	ucsi_unregister(uec->ucsi);
+	if (uec->registered) {
+		gaokun_ec_unregister_notify(uec->ec, &uec->nb);
+		ucsi_unregister(uec->ucsi);
+	}
+
 	for (i = 0; i < uec->num_ports; ++i)
 		typec_mux_put(uec->ports[i].typec_mux);
 
-- 
2.53.0



