Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B712944AB73;
	Tue, 21 Jul 2026 21:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668592; cv=none; b=pkmgXSQq8x1OQcVvVX2mLXVYKWtlAjgsZ2mTGHQCInUWtqYCU4XK7XlhXqsO00GTADZmdUvfYC/z+kTjVMlj4VHB2Aj4nFo6A69xwbcKeYZWSItN3MxEhIC+v2mQMIjgrivjYveQED5NYa8VKXj5463+U9ZnOy6lUZqfud/wqao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668592; c=relaxed/simple;
	bh=KdB3VcesrNnpxYCOmflTU0GLnOBoNJtJdhTVtjpr+38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHPFXp+28/Jf8j0nAftf0uSLR/S8Xo57BYXMiLQBVEaEjCLm1XtBpLYz4ZjK2Ik3j9iPVckPmsImyFwFoqkmZJHZZOQ9P29Mj0KRW/+CyuvSVzx7sWpI6VfnWaic6/sxA1BE66t9pY7J9WPlTcOZjl7vOQIsKHbn0nC7Z0dx6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+/Poeru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+/Poeru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278DB1F000E9;
	Tue, 21 Jul 2026 21:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668591;
	bh=1U3QTFDvToMVfz++rsz+0cvoQ/gF2BqfuYhwl/MuHlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+/PoeruoGbNUVreEC8hA/gB/Kb7/XQ20zpH2Fv66BHnDFahK7q3yaAyeR1Eq/Add
	 ukjqd4lOlOGrNvUzLJDXuv9KsFCR81R/T/UqW9Y0au0R8ognfpFVmaGGenpOolMZG8
	 VXzFEfLWHVRiYXA6sschxo1w4qfpgBgWFTs15kSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <khali@linux-fr.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.1 0232/1067] i2c: core: fix adapter deregistration race
Date: Tue, 21 Jul 2026 17:13:53 +0200
Message-ID: <20260721152429.791216275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1568,7 +1568,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto err_remove_debugfs;
+		goto err_replace_id;
 	}
 
 	res = i2c_setup_smbus_alert(adap);
@@ -1612,7 +1612,10 @@ static int i2c_register_adapter(struct i
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
@@ -1802,6 +1805,8 @@ void i2c_del_adapter(struct i2c_adapter
 	/* First make sure that this adapter was ever added */
 	mutex_lock(&core_lock);
 	found = idr_find(&i2c_adapter_idr, adap->nr);
+	if (found == adap)
+		idr_replace(&i2c_adapter_idr, NULL, adap->nr);
 	mutex_unlock(&core_lock);
 	if (found != adap) {
 		pr_debug("attempting to delete unregistered adapter [%s]\n", adap->name);


