Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC1E279792;
	Wed, 30 Jul 2025 09:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868698; cv=none; b=m7V1h7AZyOFs76oyqTLmuR6Cuzf9j8a7D+INwSfRivBH3vtGlEINRyAKqLJ5OAqZjdOr6vR2KTSrKmnY3RhP7mr5xkYnEkWshwzwsfbGwFddXOJzsDDYJXa3+7t6VCxnKMi3JVvs5Ylzb1QwcvA5ppM+ezl7Cgi1jxmINt63ztM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868698; c=relaxed/simple;
	bh=bRfKeoIyn2I784gTJOxOMBEPWb9xQOh5Bzq0fp1CoU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRLPcmnYc8vRfn/lL1DFMNGm5MKvPvvT2jj7sf7HKC10ckz33NatPLIn1NN2Nji6vtBxLen7sHfr99Xh7i4RBDb6H3fD+/JX3LzhI/ncL2HYkzrUW/TtYOuv/ENrSS3Z+3rlAh/dygbh4tvaPsfC4dPj3ipBDHPKQGaDT/nxKCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHXaUwPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHXaUwPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A90C4CEF5;
	Wed, 30 Jul 2025 09:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868698;
	bh=bRfKeoIyn2I784gTJOxOMBEPWb9xQOh5Bzq0fp1CoU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHXaUwPkuxJ4967j48JouEvcElx3xgv2yBjbt6T9SuG9Q0MveqyMI7Cy5L+JJF3tH
	 UbkGaqW1DplAa8jhNtGrqT3g3zEUuDB/Qw7twsARanFnITQFQ6SCeUgkLIPkv1z9e1
	 //ezbsSjqJQQB8fXjXWAG0BHrBCu01vRmvvTUFZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 054/117] dpaa2-eth: Fix device reference count leak in MAC endpoint handling
Date: Wed, 30 Jul 2025 11:35:23 +0200
Message-ID: <20250730093235.663621453@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ma Ke <make24@iscas.ac.cn>

commit ee9f3a81ab08dfe0538dbd1746f81fd4d5147fdc upstream.

The fsl_mc_get_endpoint() function uses device_find_child() for
localization, which implicitly calls get_device() to increment the
device's reference count before returning the pointer. However, the
caller dpaa2_eth_connect_mac() fails to properly release this
reference in multiple scenarios. We should call put_device() to
decrement reference count properly.

As comment of device_find_child() says, 'NOTE: you will need to drop
the reference with put_device() after use'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250717022309.3339976-2-make24@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4655,12 +4655,19 @@ static int dpaa2_eth_connect_mac(struct
 		return PTR_ERR(dpmac_dev);
 	}
 
-	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+	if (IS_ERR(dpmac_dev))
 		return 0;
 
+	if (dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type) {
+		err = 0;
+		goto out_put_device;
+	}
+
 	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
-	if (!mac)
-		return -ENOMEM;
+	if (!mac) {
+		err = -ENOMEM;
+		goto out_put_device;
+	}
 
 	mac->mc_dev = dpmac_dev;
 	mac->mc_io = priv->mc_io;
@@ -4694,6 +4701,8 @@ err_close_mac:
 	dpaa2_mac_close(mac);
 err_free_mac:
 	kfree(mac);
+out_put_device:
+	put_device(&dpmac_dev->dev);
 	return err;
 }
 


