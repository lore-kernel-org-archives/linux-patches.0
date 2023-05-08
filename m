Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A4F8BF9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE560C433D2;
	Mon,  8 May 2023 10:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541853;
	bh=CbCnVWiw97CkQCa1siral+G1i6x/Z7lFJ0TtoRZVEfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTVpsM/B558NXz7ImpmIlackBXsIu7C34yAjti8CbW1c2WFPoSd5ghoXRKqNji3Ab
	 thEv84VindNBPC9cvKgdGXqowQtq6dA1CCAWDbZRs29sFczJm7oyOljsyGH6KzpKUS
	 LBGffTYTFcsu6eZ446T/WQDze3UGuNPmOrlbaInU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 213/663] gpu: host1x: Fix potential double free if IOMMU is disabled
Date: Mon,  8 May 2023 11:40:39 +0200
Message-Id: <20230508094435.263860991@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8466ff24a37a9a18fb935e90dda64f049131ae28 ]

If context device has no IOMMU, the 'cdl->devs' is freed in
error path, but host1x_memory_context_list_init() doesn't
return an error code, so the module can be loaded successfully,
when it's unloading, the host1x_memory_context_list_free() is
called in host1x_remove(), it will cause double free. Set the
'cdl->devs' to NULL after freeing it to avoid double free.

Fixes: 8aa5bcb61612 ("gpu: host1x: Add context device management code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/host1x/context.c b/drivers/gpu/host1x/context.c
index c8e7994c2c9cd..3be0d6d02f1a4 100644
--- a/drivers/gpu/host1x/context.c
+++ b/drivers/gpu/host1x/context.c
@@ -87,6 +87,7 @@ int host1x_memory_context_list_init(struct host1x *host1x)
 		device_del(&cdl->devs[i].dev);
 
 	kfree(cdl->devs);
+	cdl->devs = NULL;
 	cdl->len = 0;
 
 	return err;
-- 
2.39.2



