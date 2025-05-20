Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE6124FBFF;
	Tue, 20 May 2025 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750820; cv=none; b=bZc8r1zwIRFMeU8MnLtry/wb5et6dMBssq1MxwgAbEu+RuRO2B1uNoLC+QwvmSlEE5JnSUtIJnlKsmQ8XKLlBUuNLK9rdOxknzJETRD+B6hQWp/4946Or10d6A6AuX0m/yWZNgbwKqlwcdCNlL5/0zZCl8ZQsFwK2s55uyj0ZDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750820; c=relaxed/simple;
	bh=IfRvgKKlH4buwnSF2/y9mxNWFdTG0284r4stMXYxILs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akKW5LGuYZhQlaWANNUBB78NSjZwJj5W4saUPUevH5G8XhBy9uf7etO9ORfG3tAeUDhte6OCkpq9HRDrJFqiqhXWZ54mFqwVRQNzhTQeCmArn+wMUT1HyPMJnkddOv+ryg0QcLYjaEJ4ECSN1LTdhqpr34dVbGNIiyjPNMPi1HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwZ00/Rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwZ00/Rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D4BC4CEEA;
	Tue, 20 May 2025 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750820;
	bh=IfRvgKKlH4buwnSF2/y9mxNWFdTG0284r4stMXYxILs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwZ00/RfgM3y1j6k6NS8hvNVUdP8kcgXL3FGhD4Dgw+smQVVQQHafqhodtwdE8JMm
	 Mn85WAMTXcDQC8FV7M9vaBB2736mfHiqNMfcEsDBw106Pmn/nwuGkh/RAvUVGOrUGZ
	 6kl/mFEuNZzwhjYL6aaBbRbN9JCYivY1TbVv0Zco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 131/145] dmaengine: idxd: Add missing cleanups in cleanup internals
Date: Tue, 20 May 2025 15:51:41 +0200
Message-ID: <20250520125815.674151369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 61d651572b6c4fe50c7b39a390760f3a910c7ccf upstream.

The idxd_cleanup_internals() function only decreases the reference count
of groups, engines, and wqs but is missing the step to release memory
resources.

To fix this, use the cleanup helper to properly release the memory
resources.

Fixes: ddf742d4f3f1 ("dmaengine: idxd: Add missing cleanup for early error out in probe call")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250404120217.48772-6-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -407,14 +407,9 @@ static int idxd_setup_groups(struct idxd
 
 static void idxd_cleanup_internals(struct idxd_device *idxd)
 {
-	int i;
-
-	for (i = 0; i < idxd->max_groups; i++)
-		put_device(group_confdev(idxd->groups[i]));
-	for (i = 0; i < idxd->max_engines; i++)
-		put_device(engine_confdev(idxd->engines[i]));
-	for (i = 0; i < idxd->max_wqs; i++)
-		put_device(wq_confdev(idxd->wqs[i]));
+	idxd_clean_groups(idxd);
+	idxd_clean_engines(idxd);
+	idxd_clean_wqs(idxd);
 	destroy_workqueue(idxd->wq);
 }
 


