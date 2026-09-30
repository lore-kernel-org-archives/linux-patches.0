Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681BD51617E;
	Wed, 30 Sep 2026 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784596; cv=none; b=OlTUALVVn6x16/WrrPa/9miKGj2I3pteBwmDd50BQIFTLBPMPXndpBQUhknYJsuFmNzWBKxzOj4ehHmiA+tauXr/RbZtE3ooTXXUA42WnE7WTraPNGUdxMxa6z7T/yr2iPOTj3CnLl37LhKXTQS4IbHZfih49oS7bqnxucM5jMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784596; c=relaxed/simple;
	bh=fV82pyCZkk6FxjUlcqVxlwtqv6+cnNO+OTWWEbzT4D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3UFoh9YxEscAc90jEICzlnuYOqWxjalll3BrUr1rd6+qqztqw7cZ03ADVNNTtRmQ5F08hsf8W0VCqT5/jMiV5CA44b8RvTc6yixIgRBTJxoiswc65Lf9WcoB2FzdEUCmHPi9Wzwclx3uhzti9N7MRKHy9uFCDDE5Km85Vd+yNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVrFmnMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVrFmnMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E0C1F000FF;
	Wed, 30 Sep 2026 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784589;
	bh=dJNRECwlNhxRelHtc+BzxLCPpLTnuIshEzgJsHfrkKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVrFmnMaz8RmgrkImErAGirGxC/PgVfyF4nrIS1oud3Z4ucL4CekfH/TeXZvVxukY
	 7E6E32EWzLt4xzKxP38aygvnRLu4EVnxuFZaEgwBjdIGb0gy0ftQLQ8LIp92m5asZk
	 W5u4o9CUvSJIKktE/wukclrY9y4GhcvIzzISSPFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/982] vdpa/ifcvf: handle dev_set_name() failure in ifcvf_vdpa_dev_add()
Date: Wed, 30 Sep 2026 17:15:09 +0200
Message-ID: <20260930152420.531834270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index d5036f49f161a..b1711b2e30ceb 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -766,15 +766,22 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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



