Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1D924B2C;
	Thu, 18 Jan 2024 11:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575668; cv=none; b=fcoUfB7d6WohmkHgU0W/lkVe5f1grmWEgfR+mGjaFf+kFrLqdKeJU9DHu+U33c7qvg+mB2V3QYRwhRyVG4a9Yw0F6kZT7tqCMC4p8R6LH+ayPNYM2hSlmcc11RwAr9zxzgEgnyMoQVTTOplRC1Hs/yASEPK9VAJ+jJr425Ts52Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575668; c=relaxed/simple;
	bh=UD+HBMbZtZ3g1yjxFIwtdYBTcOOMsJdX7QTpI17iMZ8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=E8v1Cj/ja335KDBvCcNhIABqEJ6sPFhZ2GWI3YINnbej8kQH9cPcepw74I6f2Ln0zizPk/tpNLueuTi+vNWwFJI4MaqVpV0nUKYIBr+/g5fvdzX0QqLajeUhiWl8VpAgGTupxcaRmXACFIzTo2ike2TLduVBDtmcr83f/uEau14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs69F+Vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs69F+Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2214C433C7;
	Thu, 18 Jan 2024 11:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575668;
	bh=UD+HBMbZtZ3g1yjxFIwtdYBTcOOMsJdX7QTpI17iMZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs69F+VtR46TK3JIU6ngsfAey6bvjE85E4Q9kWvl5wlB2+c1/OkQDuiDK9rtiAcJB
	 Q+TW0rx6fdMyYgies3E5akBfAtTgVUWi6STel7kSBez3x3QJU/oxIaPGZqEIsQrOHg
	 hokXzlo6mIp2FJZqXpT+RsnBbGNhtV0vhiNpFpd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/100] nvme: prevent potential spectre v1 gadget
Date: Thu, 18 Jan 2024 11:48:42 +0100
Message-ID: <20240118104312.409877389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6a2816f3b4e8..73ae16059a1c 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -16,6 +16,7 @@
 #endif
 #include <crypto/hash.h>
 #include <crypto/kpp.h>
+#include <linux/nospec.h>
 
 #include "nvmet.h"
 
@@ -508,6 +509,7 @@ static ssize_t nvmet_ns_ana_grpid_store(struct config_item *item,
 
 	down_write(&nvmet_ana_sem);
 	oldgrpid = ns->anagrpid;
+	newgrpid = array_index_nospec(newgrpid, NVMET_MAX_ANAGRPS);
 	nvmet_ana_group_enabled[newgrpid]++;
 	ns->anagrpid = newgrpid;
 	nvmet_ana_group_enabled[oldgrpid]--;
@@ -1580,6 +1582,7 @@ static struct config_group *nvmet_ana_groups_make_group(
 	grp->grpid = grpid;
 
 	down_write(&nvmet_ana_sem);
+	grpid = array_index_nospec(grpid, NVMET_MAX_ANAGRPS);
 	nvmet_ana_group_enabled[grpid]++;
 	up_write(&nvmet_ana_sem);
 
-- 
2.43.0



