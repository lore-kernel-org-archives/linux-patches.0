Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C502C49DB9B;
	Wed, 30 Sep 2026 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783944; cv=none; b=OnJ5QCKiNV7OVa0KqGhKqoniKHU1o6wH7d0glo8qxUB1YXP0GDSNem+Am4K8/A4x1iOsFXbSxbXPRKzoGAfbsvD9NSBxrwZSsC/j16j6YiyPEGJvnP0CX96ukShbgKaZrHa9BljtmDjIS50ADQ4l7uw0uTzWV1JvDP0/ghEVfvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783944; c=relaxed/simple;
	bh=wpxXoKaQHiP5yzHvKzhC3kXtTjbYDJEdc1i2eRgvxXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PphwlYOZ9oTtHf1awFhqiWYi0t7q2CaN5i9qX+bDBOJwd6YxpgYsB1t3is3DuqyQWt64qLnX2HnDkUFOs84PUhigL9XVsJSrk+wOC0sI0INlZ6qgs4DXz/Xw/KdCckhNA8spoTpcTE5gdMfb1xB1GFkv8OYDGMekn9C8sRx1V88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNiStJ3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNiStJ3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061AD1F00898;
	Wed, 30 Sep 2026 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783940;
	bh=8epL2J3a1XMdStKUaEK2ZoPLstn4l0XbeegkYnNByZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNiStJ3R7u6Rn+5PDZ0xQcG3KPn4DzrqCz6iOrWRO/u4ls9ud3OfqGmd1sndeXl8m
	 iPZh46Ru6AYR85z3GxkG60C0QtDMr/oCYW7kJCt9cwSDzBbUagD4nzuA38kUzzq+cL
	 PmDb4+Qv6PlBU9rb+BE5TmKk1sBfjLhQT8kKOynE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 575/595] net: hisilicon: hns_dsaf_mac: fix mdio device leak in hns_mac_register_phy()
Date: Wed, 30 Sep 2026 17:27:48 +0200
Message-ID: <20260930152400.098100915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
 


