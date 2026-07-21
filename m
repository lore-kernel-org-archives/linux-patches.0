Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62160415F23;
	Tue, 21 Jul 2026 22:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671375; cv=none; b=mOEUXgiRq+Std259fdF/VEKOQSAXVzgbMjTMJWZ4OZHfhmdKcEYzsBHwbV6PmuwQGhBYORycg/rbH/5XSmyFKwooYZrwAsTl5Q9baU9AQMc1QmiCQJvZGVI4fycMoJH4FPTmZQYoHqk0FL8NI27KfP33zk/zSjvqJIqk4d3g5Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671375; c=relaxed/simple;
	bh=ICOREwVQj8mez3uwOp0vlVWbuWN5Pg81gC+2r0Y76jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDReGT52LLCyhz8wmgUmtSvyp0F9iwzC+ilDsJCYvsX/WmY6qHp5BWt5mouCRSrOy/iyVosclFjamEUA0roeKoUzLiTVWyfoLAkao7FNNHAE1LycVFdOcgCKg9QSLkgOCiNnqRFSNKiRxK6BdWahwK8WwfSqEtaOouMbjwv3nH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsvioNpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsvioNpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D321F000E9;
	Tue, 21 Jul 2026 22:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671374;
	bh=bH3lZBMnuaSJ6GaxMZRUtJn2mYlZ6+ZD3sAhUIL45YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsvioNpKXqu0DDhQfhwFyiXgI2OzM7kIehynBoCgbfft/iCCjJ8AgNvWhkP60vVi7
	 tjoRks9lV3UZ1BNlQp9SVMBPHEtv4GevDmdjv57K2VGIZJZ9WIGAnemtvGGX/CWMwF
	 VcVcdmg4GjYTiyjhgMK9tvisZg4GxOI9VlkSDTjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <khali@linux-fr.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 5.15 179/843] i2c: core: fix adapter deregistration race
Date: Tue, 21 Jul 2026 17:16:54 +0200
Message-ID: <20260721152410.041192133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit b1a58ed9eab146b36f41a55db8f5d7ce9fdedf3f upstream.

Adapters can be looked up by their id using i2c_get_adapter() which
takes a reference to the embedded struct device.

Remove the adapter from the IDR before tearing it down during
deregistration (and on registration failure) to make sure its resources
are not accessed after having been freed (e.g. the device name).

Fixes: 35fc37f81881 ("i2c: Limit core locking to the necessary sections")
Cc: stable@vger.kernel.org	# 2.6.31
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1566,7 +1566,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto err_remove_debugfs;
+		goto err_replace_id;
 	}
 
 	res = i2c_setup_smbus_alert(adap);
@@ -1609,7 +1609,10 @@ static int i2c_register_adapter(struct i
 out_reg:
 	i2c_deregister_clients(adap);
 	device_del(&adap->dev);
-err_remove_debugfs:
+err_replace_id:
+	mutex_lock(&core_lock);
+	idr_replace(&i2c_adapter_idr, NULL, adap->nr);
+	mutex_unlock(&core_lock);
 	debugfs_remove_recursive(adap->debugfs);
 	init_completion(&adap->dev_released);
 	put_device(&adap->dev);
@@ -1799,6 +1802,8 @@ void i2c_del_adapter(struct i2c_adapter
 	/* First make sure that this adapter was ever added */
 	mutex_lock(&core_lock);
 	found = idr_find(&i2c_adapter_idr, adap->nr);
+	if (found == adap)
+		idr_replace(&i2c_adapter_idr, NULL, adap->nr);
 	mutex_unlock(&core_lock);
 	if (found != adap) {
 		pr_debug("attempting to delete unregistered adapter [%s]\n", adap->name);


