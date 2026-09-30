Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4556C521231;
	Wed, 30 Sep 2026 18:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792620; cv=none; b=lrrup1RoQj74+wWIcxBCKBFKYYO4RzQfV+Fe/RozdRakUuOk5COYJgKcEh+MajuqG14BiYrk7ImK8ejiu420wxwr+gpmd9ew/g1XJiv5yYDkGGmGbRm05/yFMYOt0Pe7Tz0YY1zYKN7bST6u+LbQ1pTar9yu7ffI/7juG/oIX/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792620; c=relaxed/simple;
	bh=68IjXHox8xyXw/CVM69g9HVdkQLx+yWGq8qhwV0yVQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AirLkZ+30KczjzOn8ItFAP7WGjNcf2nU63CSiCsvMYkhDWHriZsKJUz93hEhf7A9Rt4EWcI6R4DXpW0FtypyVMrhvvzfBQyqag+SBtToLtbhWINhEQSGWWzyD6eg3yJfTZx6EVXesSvSNqR7P8T7Pq0ZZpGcidAJYdMsiqs1h6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMfzVPl2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMfzVPl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531111F000FF;
	Wed, 30 Sep 2026 18:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792618;
	bh=Zbm9HeVo2wF17anQRqD3qh8wyaxHOWOKJOn09QmChbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMfzVPl2P9Z//GeFuYZbTyVyaTMb28DuEE3GXFL+qaGF+QDnont5MbbJfLlcuEbNX
	 zaJnM3a5qKz6fZcKBAU2oybku6R34eQc+jNZ91csSH/yS5vO8d7urri3VpCPFcSqSR
	 LeP4tXQ7mwnEfVuf0Cc3ay/pepqlkF8EhiLz/dUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 720/752] net: hisilicon: hns_dsaf_mac: fix mdio device leak in hns_mac_register_phy()
Date: Wed, 30 Sep 2026 17:29:50 +0200
Message-ID: <20260930152413.804175145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
 


