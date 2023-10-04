Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4131D55D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/CXqOaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F7CC433C7;
	Wed,  4 Oct 2023 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443384;
	bh=E1896sxHEX81T/q/k4uNu7KH+SiGCgenBaz/kTpNs4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/CXqOaRw4xTIe4X8Lii0W2qQ5MR14tRfPInHR+KBnydPzbNP7Vz40kSFl3kAUnln
	 gRCvTlPcQ9spSMR565xi6CX1RF/IQGVbEX9x/UZHDsOoxdQ783bjci4C0YcS5aA6Ur
	 ZhaNtRXu8j4c606Tfb3bpnrUW1nm8w9EgtxtTUwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Alves <joao.alves@arm.com>,
	Olivier Deprez <olivier.deprez@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/259] firmware: arm_ffa: Dont set the memory region attributes for MEM_LEND
Date: Wed,  4 Oct 2023 19:55:11 +0200
Message-ID: <20231004175223.662012009@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9dda1178479aa0a73fe0eaabfe2d9a1c603cfeed ]

As per the FF-A specification: section "Usage of other memory region
attributes", in a transaction to donate memory or lend memory to a single
borrower, if the receiver is a PE or Proxy endpoint, the owner must not
specify the attributes and the relayer will return INVALID_PARAMETERS
if the attributes are set.

Let us not set the memory region attributes for MEM_LEND.

Fixes: 82a8daaecfd9 ("firmware: arm_ffa: Add support for MEM_LEND")
Reported-by: Joao Alves <joao.alves@arm.com>
Reported-by: Olivier Deprez <olivier.deprez@arm.com>
Link: https://lore.kernel.org/r/20230919-ffa_v1-1_notif-v2-13-6f3a3ca3923c@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index c37e823590055..21481fc05800f 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -478,6 +478,19 @@ static u32 ffa_get_num_pages_sg(struct scatterlist *sg)
 	return num_pages;
 }
 
+static u8 ffa_memory_attributes_get(u32 func_id)
+{
+	/*
+	 * For the memory lend or donate operation, if the receiver is a PE or
+	 * a proxy endpoint, the owner/sender must not specify the attributes
+	 */
+	if (func_id == FFA_FN_NATIVE(MEM_LEND) ||
+	    func_id == FFA_MEM_LEND)
+		return 0;
+
+	return FFA_MEM_NORMAL | FFA_MEM_WRITE_BACK | FFA_MEM_INNER_SHAREABLE;
+}
+
 static int
 ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		       struct ffa_mem_ops_args *args)
@@ -494,8 +507,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	mem_region->tag = args->tag;
 	mem_region->flags = args->flags;
 	mem_region->sender_id = drv_info->vm_id;
-	mem_region->attributes = FFA_MEM_NORMAL | FFA_MEM_WRITE_BACK |
-				 FFA_MEM_INNER_SHAREABLE;
+	mem_region->attributes = ffa_memory_attributes_get(func_id);
 	ep_mem_access = &mem_region->ep_mem_access[0];
 
 	for (idx = 0; idx < args->nattrs; idx++, ep_mem_access++) {
-- 
2.40.1



