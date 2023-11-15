Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB5B3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoulNXqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3F1C433CA;
	Wed, 15 Nov 2023 19:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077367;
	bh=8K/Dhpb5JBIXpa7MXT5yZY9rz/JrSL2PfJxSEt++L84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoulNXqnlDgpXzFFz+OVOuy/fq597HiWuSLbohN574KgAdMNIcWkymTh3j2K2vDlv
	 S0A+haXUZwddSqSFVkME526/6gEYmA94UkaFPqJ5KvvTN++9rk0H6rcHG/4YCvIOzQ
	 XKa6nbgR4KqPsGxhpJi05j4cMhbZKmxI0OyE/FZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johnny Liu <johnliu@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/603] gpu: host1x: Correct allocated size for contexts
Date: Wed, 15 Nov 2023 14:13:23 -0500
Message-ID: <20231115191631.156917911@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johnny Liu <johnliu@nvidia.com>

[ Upstream commit e889a311f74f4ae8bd40755a2c58d02e1c684fef ]

Original implementation over allocates the memory size for the
contexts list. The size of memory for the contexts list is based
on the number of iommu groups specified in the device tree.

Fixes: 8aa5bcb61612 ("gpu: host1x: Add context device management code")
Signed-off-by: Johnny Liu <johnliu@nvidia.com>
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230901115910.701518-1-cyndis@kapsi.fi
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/context.c b/drivers/gpu/host1x/context.c
index a3f336edd991b..955c971c528d4 100644
--- a/drivers/gpu/host1x/context.c
+++ b/drivers/gpu/host1x/context.c
@@ -34,10 +34,10 @@ int host1x_memory_context_list_init(struct host1x *host1x)
 	if (err < 0)
 		return 0;
 
-	cdl->devs = kcalloc(err, sizeof(*cdl->devs), GFP_KERNEL);
+	cdl->len = err / 4;
+	cdl->devs = kcalloc(cdl->len, sizeof(*cdl->devs), GFP_KERNEL);
 	if (!cdl->devs)
 		return -ENOMEM;
-	cdl->len = err / 4;
 
 	for (i = 0; i < cdl->len; i++) {
 		ctx = &cdl->devs[i];
-- 
2.42.0



