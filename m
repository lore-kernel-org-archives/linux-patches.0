Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEA552CCC3;
	Thu, 17 Sep 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664454; cv=none; b=kl2OynlaPFAo6OcURsCqUyzgiDe0hYMVlcHwNw/ct87nzSYgDCaiA9ivrG9vG1ElhiNPe/5ecYMKCsuw+N2SoDHfvg76Y4ApwBZHg1WO0s9VHHPLvfqzvURBs9kUg4/2YjfoceSH4Tmt7tkGsvlLIiW1r4/Bo4VwIbfJzr3L1Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664454; c=relaxed/simple;
	bh=FK0tfAaKGc3g2irxLqYAAXLTaoCjU3uciE4qIMqOd78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYvFKIKwGUxPH8/BWWc9pn77dlJU1qqTE0OxevkiFaDE/ZDUQ01oYynfqxvsb9e1+Wr72M2oZZDOdUzGkNQu7tju/6SOeDYXefmurBNo4RrmUP0xWhWD7lxlRULCUFTZORZShUE2PO/CJHfCDpNsH9zGty/iTCVsxfjzH7KWgCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcSP5fov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcSP5fov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF1A1F000FF;
	Thu, 17 Sep 2026 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664452;
	bh=LiDWu1CtL8gHlqWwCDVvGn4A+J+DDJaqYzqPLWLtCrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcSP5fov4d7p1+1tKnuhJ4ikW/np1UO3ZIk7QDrhkDvXeOVz93JQpqXamJYLVIWUo
	 XF6MvPsDbZioQjighhso/g8vprjvpvR0iXuYWt16F8zApv6+LdfPswfjzzZBLsoYY0
	 hoKdPss6H6iktYRHdHchj3rSSyQTQnCFRvAcYxKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0377/1250] vdpa/ifcvf: handle dev_set_name() failure in ifcvf_vdpa_dev_add()
Date: Thu, 17 Sep 2026 16:02:52 +0100
Message-ID: <20260917151602.268973439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 6658dc74d9150..56ed03dc918db 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -734,15 +734,22 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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



