Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5224078C1;
	Wed, 30 Sep 2026 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797052; cv=none; b=D4L2wpcFPBxaiOXSzVrgxqILAds9NOailjzhQcWWW9B0Ijco4ZFYDf7lldkvRorrM3WvW1TqvqbluaCiA/mLUmukb+9fq+nbsWSsmRj+wDlwZnv/3sWPmaQ951u9nI/K/F97UNFRw8/V4dE0tror2FmMH98Wkkxc5T+BknYZImQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797052; c=relaxed/simple;
	bh=AMJdMjxqnFmGF3qvk1XFy/Om6DNpvme9CiwyJ1jTPtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRBORvQGRVwCL1+Sm7kYTwjigSTkGEfRMpKy7W3yHIQgISLHZTnMMG84wl0o9iPyO0hC6pq6eaQ62jwCAA+cDxEMawcdMqEHsxoKR6XMQ0dngcNSratoNH0F3nBBhaf91EGlSpyx8lsABOhsdY6jZl1BOaujzYVwTUlvBHVH6b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzpIEmVi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzpIEmVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211E91F000FF;
	Wed, 30 Sep 2026 19:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797051;
	bh=3eELjWHPZmu+b6FV+PLgGZFEfFy3qvi/Wa2YtpPPKAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzpIEmVi1L7Tqp0Vt+XVo2sfBoEtVRGR42mv7UVnmeiTyaen33MvCDGJ6k5s/evKq
	 TjaONxb3WSTB3qOHncJLYO/jsaO8rtzSUVCMmhSr6MCfRZOgR24rjT2eipMtU4t0j3
	 T7kb4roUclmRiowMNz2rpIMxGtVeFi17P6QZAQF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1129/1193] net: hisilicon: hns_dsaf_mac: fix mdio device leak in hns_mac_register_phy()
Date: Wed, 30 Sep 2026 17:30:13 +0200
Message-ID: <20260930152459.321979087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 999e8295bc41d6ce45b8e54f88150efa96f3f01e upstream.

hns_dsaf_find_platform_device() returns the mdio platform device with its
reference count incremented. hns_mac_register_phy() never drops that
reference, so the mdio device can not be released.

Release the reference on both the deferred probe and the normal path.

Fixes: 1d1afa2ebf82 ("net: hns: register phy device in each mac initial sequence")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260917110828.2148390-1-vulab@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -793,6 +793,7 @@ static int hns_mac_register_phy(struct h
 		dev_err(mac_cb->dev,
 			"mac%d mdio is NULL, dsaf will probe again later\n",
 			mac_cb->mac_id);
+		put_device(&pdev->dev);
 		return -EPROBE_DEFER;
 	}
 
@@ -801,6 +802,8 @@ static int hns_mac_register_phy(struct h
 		dev_dbg(mac_cb->dev, "mac%d register phy addr:%d\n",
 			mac_cb->mac_id, addr);
 
+	put_device(&pdev->dev);
+
 	return rc;
 }
 


