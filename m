Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0843F23754;
	Thu, 18 Jan 2024 10:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575227; cv=none; b=cxfN0mfHxaqt0ZWctYvuAHpjzoZneM3kHE1FJBhfKWvqVzv4tNAPBf9TE46Jad6ZTTU2MLlxYL8Qj8/i0uBLey46hAEN4pDZ3H5CJildgf0TV/Q7pbob7CxdmMZMGF342hWzGuD+VoRxIY88K0xATVCUmdKE1QR45/e55E18MXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575227; c=relaxed/simple;
	bh=0d/YvBoaZXLNqHIL2V9JLk5M54xo1eyFkqeLl692mOc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=t4rlTJ3IgqKUWs69ZkfdH5Gi5VdWcY6eyC/3VhS441Yhoxe7eLeJzuBmjP5xOPbyij8+LFzAyk+S9hgHH/4gEryNqQE4tSPKEpDwP4KLu+JkrMnB+c9Jfm0PFZK9ivIYGcYtuk9ER6fYcCSLZNsLLorOnTiCNh+/xAkgv70o68g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXt0jdyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXt0jdyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818AAC433C7;
	Thu, 18 Jan 2024 10:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575226;
	bh=0d/YvBoaZXLNqHIL2V9JLk5M54xo1eyFkqeLl692mOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXt0jdyFp1zs4vgkav1rNVoPQfyo0vtoV8X9OrMKwbnDiylr8/w1P5WHxGqrAeZiS
	 e+KJ3CR2EC2iHg7skNOc9vpjYywLWRurtZwyGk9oMTn8HM+mCY6zxp5F6Yote1vHcu
	 CU20YPjwJOhKIWsK2BqfgRz8lZXRlPGvwgZFe+4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/150] nvme: prevent potential spectre v1 gadget
Date: Thu, 18 Jan 2024 11:47:58 +0100
Message-ID: <20240118104322.576364270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Nitesh Shetty <nj.shetty@samsung.com>

[ Upstream commit 20dc66f2d76b4a410df14e4675e373b718babc34 ]

This patch fixes the smatch warning, "nvmet_ns_ana_grpid_store() warn:
potential spectre issue 'nvmet_ana_group_enabled' [w] (local cap)"
Prevent the contents of kernel memory from being leaked to  user space
via speculative execution by using array_index_nospec.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 907143870da5..01b2a3d1a5e6 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -17,6 +17,7 @@
 #endif
 #include <crypto/hash.h>
 #include <crypto/kpp.h>
+#include <linux/nospec.h>
 
 #include "nvmet.h"
 
@@ -509,6 +510,7 @@ static ssize_t nvmet_ns_ana_grpid_store(struct config_item *item,
 
 	down_write(&nvmet_ana_sem);
 	oldgrpid = ns->anagrpid;
+	newgrpid = array_index_nospec(newgrpid, NVMET_MAX_ANAGRPS);
 	nvmet_ana_group_enabled[newgrpid]++;
 	ns->anagrpid = newgrpid;
 	nvmet_ana_group_enabled[oldgrpid]--;
@@ -1700,6 +1702,7 @@ static struct config_group *nvmet_ana_groups_make_group(
 	grp->grpid = grpid;
 
 	down_write(&nvmet_ana_sem);
+	grpid = array_index_nospec(grpid, NVMET_MAX_ANAGRPS);
 	nvmet_ana_group_enabled[grpid]++;
 	up_write(&nvmet_ana_sem);
 
-- 
2.43.0



