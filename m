Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A93F4C33E6;
	Wed, 30 Sep 2026 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793499; cv=none; b=LNJ1ny/xqIOGJ8OnOPBu+5bf4UEkrCr2ZAzrY9hJcqH3RZy6OFTVFGViV+JVek+O13X6NaHdkDx3JWxjY40R6UcF+Ysuu1A8S1ILASqYXs+IUpIhkjsJHDvrOxGXVrZA4yymvaV2svIiZAC2GLmPBU3Oupx3dVCZcvOIlxLq8QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793499; c=relaxed/simple;
	bh=RWzTzcNUKpMG5kSWnaT8dvsfIYggkrT8Q00TGA7kNGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOUF89AQzUbN03WI8/Us0V0b1kTW+tr8dcCfUzGieKLWRbQe/9oIhvU6VXECjuDaDSGtMF5NrM4QyRaghOF0Lu3xhYMsNJX6PqJSzM+ZY+t2ENbqbLbeJAQyHxIvPtuUNZnE26OEm4p9kAg3ieU4UetmDiE0lsm99mw+ynjGurE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRkhV0Yy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRkhV0Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B28B1F000FF;
	Wed, 30 Sep 2026 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793497;
	bh=w+5uHwzJ2++obbz8kSqN029kgc5NzsodCHruCYioegw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRkhV0YylzfIV7XSSa3geuA8I1RZq2nJX8LczyxmIHDNGC0NNKX+00Cep+m7ZEJRg
	 dbtxrcLPN8pQ7UipA+DS4+r8B/yQ/PwxL3IltCmSC2c/DHHk0bsot+1THZJPA9KNWi
	 5hv4ZtICGHFwtzUi7EvUCVM5HJVAZHxGnbIPYNJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 277/395] net: hisilicon: hns_dsaf_mac: fix mdio device leak in hns_mac_register_phy()
Date: Wed, 30 Sep 2026 17:28:59 +0200
Message-ID: <20260930152346.669734517@linuxfoundation.org>
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
 


