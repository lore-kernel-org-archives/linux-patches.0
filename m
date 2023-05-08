Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69245168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF23FC433EF;
	Mon,  8 May 2023 11:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543980;
	bh=x1pjOODMCUuiKQWmap/VWXnW8YJAWpinnYjZV3yR8vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDFaW84yupnMN9YkMjE3vly2DF5d+c42bPakS73YOB0Y117lJs49hmHL7g8TMCvqj
	 lKKSJUhX3TOtLbqEVc3XqsEgrnmB+P65+XbCx0Jdzwv71DdeqaRcRVYCCMTbsqQmNU
	 4YBgQARlxaOmfHkQfUPqqpErnOGbsCIUNlEQ2+Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 246/694] gpu: host1x: Fix potential double free if IOMMU is disabled
Date: Mon,  8 May 2023 11:41:21 +0200
Message-Id: <20230508094440.294859110@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
index 8beedcf080abd..5ec18315ff9fe 100644
--- a/drivers/gpu/host1x/context.c
+++ b/drivers/gpu/host1x/context.c
@@ -83,6 +83,7 @@ int host1x_memory_context_list_init(struct host1x *host1x)
 		device_del(&cdl->devs[i].dev);
 
 	kfree(cdl->devs);
+	cdl->devs = NULL;
 	cdl->len = 0;
 
 	return err;
-- 
2.39.2



