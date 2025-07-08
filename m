Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47981714B7;
	Tue,  8 Jul 2025 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992975; cv=none; b=PgE8gHsQ8jsdwVTdaQpbkoQWdkk9SCS2iyUi42GZibUvFwTLHC+AE6lAIR8/04yEj8mwklCmDQP3FBFr5Vv/nZT3SCgGIM7BhhsRrTxb9Jbr7VfDzIeHJzIgtrjw5/vhJ/yI3K8qm0b6zs6+o7jz9j6u6JM+zgzow/2ZlwqlUs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992975; c=relaxed/simple;
	bh=u2GEhuN8RVXemPkfiTNi3JGJRQKas1YFukd6fw2TgPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tyew+C4QY3CFQz+G2+98NhkAZTFYjj/IFKaJGTAXhoKHi1rEv1QpVe+04yckdpPd5bemaT+PEXKjWfMfzJZwbf1RGSvNO2qzDOs8nRIVbIr8uoQ+4YUKka2LQg3tf2INzvsh79nJArel6GgmJ6elgiaJ+xNKVBXE6k8wdBv8sj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifKplZTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifKplZTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E03C4CEED;
	Tue,  8 Jul 2025 16:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992975;
	bh=u2GEhuN8RVXemPkfiTNi3JGJRQKas1YFukd6fw2TgPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifKplZTc8v42KqCvy3+qHzT+RbGrse6A7Xfbo98CnTBQrK4WJAWN1+QHx2P+YopkU
	 q7gf16yrMaSztVnhdTYx67BZPCfoZQrBOU/eA6MHb1zjScTlQNQXEoqFtb+nrdw7IK
	 ZXAfxiWreelD0YYR9SgCvbBJgr/4ZUU4CqpsvEDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/232] remoteproc: k3-r5: Add devm action to release reserved memory
Date: Tue,  8 Jul 2025 18:22:22 +0200
Message-ID: <20250708162245.260926679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit 972361e397797320a624d1a5b457520c10ab4a28 ]

Use a device lifecycle managed action to release reserved memory. This
helps prevent mistakes like releasing out of order in cleanup functions
and forgetting to release on error paths.

Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20241219110545.1898883-2-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 701177511abd ("remoteproc: k3-r5: Refactor sequential core power up/down operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index 6cbe74486ebd4..a9ec65c12fb93 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -947,6 +947,13 @@ static int k3_r5_rproc_configure(struct k3_r5_rproc *kproc)
 	return ret;
 }
 
+static void k3_r5_mem_release(void *data)
+{
+	struct device *dev = data;
+
+	of_reserved_mem_device_release(dev);
+}
+
 static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 {
 	struct device *dev = kproc->dev;
@@ -977,12 +984,14 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 		return ret;
 	}
 
+	ret = devm_add_action_or_reset(dev, k3_r5_mem_release, dev);
+	if (ret)
+		return ret;
+
 	num_rmems--;
 	kproc->rmem = kcalloc(num_rmems, sizeof(*kproc->rmem), GFP_KERNEL);
-	if (!kproc->rmem) {
-		ret = -ENOMEM;
-		goto release_rmem;
-	}
+	if (!kproc->rmem)
+		return -ENOMEM;
 
 	/* use remaining reserved memory regions for static carveouts */
 	for (i = 0; i < num_rmems; i++) {
@@ -1033,8 +1042,6 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 	for (i--; i >= 0; i--)
 		iounmap(kproc->rmem[i].cpu_addr);
 	kfree(kproc->rmem);
-release_rmem:
-	of_reserved_mem_device_release(dev);
 	return ret;
 }
 
@@ -1045,8 +1052,6 @@ static void k3_r5_reserved_mem_exit(struct k3_r5_rproc *kproc)
 	for (i = 0; i < kproc->num_rmems; i++)
 		iounmap(kproc->rmem[i].cpu_addr);
 	kfree(kproc->rmem);
-
-	of_reserved_mem_device_release(kproc->dev);
 }
 
 /*
-- 
2.39.5



