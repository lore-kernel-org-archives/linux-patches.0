Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B6322A1F;
	Thu, 16 Jul 2026 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210199; cv=none; b=FgqdaAnfPYChEmK8C3rKz5BoFSaRg98qxDfbzoLArINU3BVxy9gSC/JEWFE1JQcSiG4X8n8lE+8oxuaSf6J9LibCNKFdbEMMFDyQ5FcbTfwJWfEp6r3l83fK0pCt8INu6b2QWI12tTakvgq77uyIzEY5sgyxW3Ymgoa29VFTL+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210199; c=relaxed/simple;
	bh=vVnfzqfRA83k58VrUJJjywyabXEyrQ/FFxgH81RG4qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT5iOGcnA/PvSnOZy5OnEL6RShVRxL0hZUHsi3XQUEnbAiC+iE1HNlgHWilDhdV9j80cOMueZz4U9vz5e0yE6SvRkQ4Y2+bR6UqZs+zCuE0aj3PGwqmgIn4R8jrmnRBgAvKnnDNPYZ6qq+8VgfXgMk3J4of4j5nI44PkoSEQLxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrCn1snw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrCn1snw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7381F000E9;
	Thu, 16 Jul 2026 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210198;
	bh=xabEY3fByJIYVHgdGp4FA6EJCXIfYYF7+PhKUqfTuig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrCn1snwFwnwSVNSOu6SVDYVfXltQuDrnQGqhVQQRfsF6FHpsVlckTf5U0xEB1KmT
	 IMQnQ2l5jabGO0RccmNFKrJDmpu8lSX8WG9GNIdVXAEU7u2vUzTPdqw5pT9XRlKOwc
	 zCioRy5yGtP8czN9+DID0EJ3eQHw83HWu8+rt7vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <khali@linux-fr.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 7.1 474/518] i2c: core: fix adapter deregistration race
Date: Thu, 16 Jul 2026 15:32:22 +0200
Message-ID: <20260716133058.216700231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1586,7 +1586,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto err_remove_debugfs;
+		goto err_replace_id;
 	}
 
 	res = i2c_setup_smbus_alert(adap);
@@ -1613,7 +1613,10 @@ static int i2c_register_adapter(struct i
 out_reg:
 	i2c_deregister_clients(adap);
 	device_del(&adap->dev);
-err_remove_debugfs:
+err_replace_id:
+	mutex_lock(&core_lock);
+	idr_replace(&i2c_adapter_idr, NULL, adap->nr);
+	mutex_unlock(&core_lock);
 	debugfs_remove_recursive(adap->debugfs);
 err_put_adap:
 	init_completion(&adap->dev_released);
@@ -1802,6 +1805,8 @@ void i2c_del_adapter(struct i2c_adapter
 	/* First make sure that this adapter was ever added */
 	mutex_lock(&core_lock);
 	found = idr_find(&i2c_adapter_idr, adap->nr);
+	if (found == adap)
+		idr_replace(&i2c_adapter_idr, NULL, adap->nr);
 	mutex_unlock(&core_lock);
 	if (found != adap) {
 		pr_debug("attempting to delete unregistered adapter [%s]\n", adap->name);


