Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256EF4D17A5;
	Thu, 17 Sep 2026 17:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667974; cv=none; b=lLcvvIVIPFhabAwcYBA4fyc4AQdXHdgs2IimDbwD2liX41MFEIUvUgbuh1eM1Vb2/Ugi1tm2x7gLGo+3U5YISZwdw886C8eEDByFLOjrI6yLtPYrD/EjUAuVksvFTKCSiPOoj892YgkSzyr1RJBxh3TyyBGEUvcVOsMdsI1RmGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667974; c=relaxed/simple;
	bh=3QbY4ZaR4TUGvJjE1UyGbnUpNyarz4z+cfhH0ymgH/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qb5oIrutRqKIoxwpr1qAfTlNXXhZjpzRWyYDc4tldlyy9VJB5utD3azasHoewTcJ5qWC26pOQYYA95b35CSPZgRCswjvzJyss+gd2cRzaqEDMu/1Nt2A327HgBOnqWanl3eJ3bwSVdH02xiigAnOgtYk3QgbsG08aLRQs7UZvz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2PJiNdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2PJiNdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705E31F000FF;
	Thu, 17 Sep 2026 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667973;
	bh=xwz64owi/8xY2IwVDMpIkbC1SeRhf3ln8fqBwjN7vb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2PJiNdxVadCRdtVDoO/LwWKdGQLonzINu/UaWfTMmgnJErYlSg+vWgFBGo6YHDJ7
	 LogQwcZCupoHEuI/fnUMKn2cG5eFFcL3VNPWDxaH5fvuvOt/yzhWKxv/7hOIDaSoac
	 dz5/+PSFtr0QZeiP1lQr68E94ZL2pyiwSgx3J6YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0271/1102] vdpa/ifcvf: handle dev_set_name() failure in ifcvf_vdpa_dev_add()
Date: Thu, 17 Sep 2026 16:03:34 +0100
Message-ID: <20260917151546.411258235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evgenii Burenchev <evg28bur@yandex.ru>

[ Upstream commit 4c653e85857b41a7148917f2628fae1d04a9c251 ]

dev_set_name() may fail and return an error, but its return value
is currently ignored and overwritten by _vdpa_register_device().

Abort device creation if dev_set_name() fails and release the
device reference to avoid continuing with an improperly initialized
struct device.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Zhu Lingshan <lingshan.zhu@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260226152924.38790-1-evg28bur@yandex.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ccf64d7bbfaa2..f7e8bc99626d6 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -733,15 +733,22 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 		ret = dev_set_name(&vdpa_dev->dev, "%s", name);
 	else
 		ret = dev_set_name(&vdpa_dev->dev, "vdpa%u", vdpa_dev->index);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to set device name");
+		goto err;
+	}
 
 	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
 	if (ret) {
-		put_device(&adapter->vdpa.dev);
 		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
-		return ret;
+		goto err;
 	}
 
 	return 0;
+
+err:
+	put_device(&adapter->vdpa.dev);
+	return ret;
 }
 
 static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
-- 
2.53.0



