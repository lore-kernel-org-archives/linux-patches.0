Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CA651B16B;
	Wed, 30 Sep 2026 18:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793519; cv=none; b=Gj5tEtfbdbzNEerjEA73NTWZ25vqtgTvSAKDrDnNByHae0HiEPy6acRd/JNflhxHppuRkUjVQT0M/4Natp9lxClJDdtVgEppozDAcN08hyvZhV1JY8KRiyJ21VWQkDy4w5pqxxa+Lryktw2AuYe4bGkt5AIBZHgJ70Ewj2r1Ob4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793519; c=relaxed/simple;
	bh=OypERW3G55lDD8Yu164hbYgOxYn1kGumTdtywSRK2Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS5S8hrdKXhCaJU568s6rVG97wqJYH9Ul+P3KDgue4LOdoaIvw07gMKWgbplILm1oRFVKYfC9U31zUiaO+hiiMkgDoA9VRPztauhPkLAHpYlgTFWRq0fOMaMueWkASiMK9O1Dh48PR5bLX7TYinmrlGjK2ml++gvDWWnVg2EW8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rvp9kFrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rvp9kFrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14591F00898;
	Wed, 30 Sep 2026 18:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793517;
	bh=+r4/j43hFiMK4GBZagBRL9YlgteoHCcKh5C1sfWCVTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rvp9kFrKr8EFS1sdh7Crl99sJm88KomZ3NaEs/EpF4jlG52/GQr5EC/Z6O9mmGQPN
	 oLKv4tRGBvQTvIdo01T28/igr4fT6LIvGtaPePeVEvDxm87wWgHAQLXmq00KW68g2o
	 ayE5gAPuC+o9cBJl6GzUtm5gu3J1YZqctFMMiaHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 284/395] net: ena: fix PHC cleanup on probe failure
Date: Wed, 30 Sep 2026 17:29:06 +0200
Message-ID: <20260930152346.821094900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 0958ea4355e2e9220ad4e13da3b7d94f365ed34f upstream.

ena_probe() initializes the PHC as part of ena_device_init(), but the
probe failure path does not destroy it before freeing the PHC private
data.

The normal removal path calls ena_phc_destroy() through
ena_destroy_device() before ena_phc_free(). However, if probe fails
after ena_device_init() succeeds, the error path reaches ena_phc_free()
without unregistering the PTP clock or destroying the device PHC
resources.

Call ena_phc_destroy() in the probe error path before freeing the PHC
private data.

This issue was found by manual code inspection.

Cc: stable@vger.kernel.org tags and describe this as a consistency cleanup
Fixes: e0ea34158ee8 ("net: ena: Add PHC support in the ENA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: stable
Link: https://patch.msgid.link/20260921154202.471662-2-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4126,6 +4126,7 @@ err_worker_destroy:
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+	ena_phc_destroy(adapter);
 ena_devlink_destroy:
 	ena_devlink_free(devlink);
 err_metrics_destroy:


