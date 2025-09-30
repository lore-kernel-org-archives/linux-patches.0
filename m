Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0511F1302;
	Tue, 30 Sep 2025 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245100; cv=none; b=EgxU/6TRUSVtb2j/0cQebdwQCrDQiui2T8qjsHlKkASKat3vnGad6bwzA1LSabqKscNaoBiFGn20e8Flu8uhBu+4/5Fqpp826MQOQ0KK3yU2ohm8GpuTWT8jHsFK86QIcDAGcNoXmLCMTBdbo4SrvI3H8wFwkFmnCdbWht+uaEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245100; c=relaxed/simple;
	bh=xbi1RPjKFnHvErpnjW+fpHx6aT6e3dnELsd71S9wy9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYWQ6oEgVOqzu9AJgnUkvkZN/53RiGaGXvaPh5+7M/lUHbS5liiDH6kEMEMXzTYz4tamCRSRHT8U6+SauVzbmVPuK6vn/NJzJi9SXcCTebZ21W9cZIroMLGnVY+sVm0MpxFsoybUnSCBPAImrcUXhWAym6tbv/Bnrl5FujpEAM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOs/3TM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOs/3TM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3C9C4CEF0;
	Tue, 30 Sep 2025 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245100;
	bh=xbi1RPjKFnHvErpnjW+fpHx6aT6e3dnELsd71S9wy9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOs/3TM5vSXACNxu++wQDjzTJ3//XwKgJi90c61juCbAcOfCU2FI8iqcYQwuy/d2M
	 l45Z/9dpYeB2ZY+Fx7XvjNMAV96BAs0JEP7YGX2X321pwCZMRA2BuCZ6xerwmk6/0g
	 cZ/zyLcfwLYgC0YFdcw/lN+U77ZJx2OaKreqy8Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/151] um: virtio_uml: Fix use-after-free after put_device in probe
Date: Tue, 30 Sep 2025 16:46:39 +0200
Message-ID: <20250930143830.346376897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7ebf70cf181651fe3f2e44e95e7e5073d594c9c0 ]

When register_virtio_device() fails in virtio_uml_probe(),
the code sets vu_dev->registered = 1 even though
the device was not successfully registered.
This can lead to use-after-free or other issues.

Fixes: 04e5b1fb0183 ("um: virtio: Remove device on disconnect")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 204e9dfbff1a0..8edc218ce21fd 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1225,10 +1225,12 @@ static int virtio_uml_probe(struct platform_device *pdev)
 	device_set_wakeup_capable(&vu_dev->vdev.dev, true);
 
 	rc = register_virtio_device(&vu_dev->vdev);
-	if (rc)
+	if (rc) {
 		put_device(&vu_dev->vdev.dev);
+		return rc;
+	}
 	vu_dev->registered = 1;
-	return rc;
+	return 0;
 
 error_init:
 	os_close_file(vu_dev->sock);
-- 
2.51.0



