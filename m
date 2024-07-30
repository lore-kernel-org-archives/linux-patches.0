Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A13418A6AE;
	Tue, 30 Jul 2024 17:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359391; cv=none; b=X7TxuAb6CV7MSkDPnpIQ1Pd6suvtCbIVD3zDkkGITak2a8/dgXhaOEAkxUhYGPlHw/BMpxGtu7MqPIm5ubY3h9o57+DxKkrFKlhD2/HyidG18rf7BcAtRIeGxDgXwdvwxut4BEHsmCbCUotrcXk+2x96Z1AvkWiFAiOliy3hkLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359391; c=relaxed/simple;
	bh=fmKGNzIYfCWHvR9P96xZR4JDSnD66DxGZzbbRW9l91A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ/4zBu/09k0M37aG3kjBw28mxuBMRJAIk8XTQPTEf0aeCKnsfL1POwA6dSPuprrPvDoL3/D2Uzk2JRGVf2LZMP+2C/2re8zS5mbebK4Mz9v3Cfoft+1VByG7TJNl+hqREXqqK3jgp0kHtU6LjoeseOmYhwnPBWvxMGLLlfYGnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VLKxMpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VLKxMpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C81C32782;
	Tue, 30 Jul 2024 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359391;
	bh=fmKGNzIYfCWHvR9P96xZR4JDSnD66DxGZzbbRW9l91A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VLKxMpD+pHcdPWFEL8jTEfGzsNS7GpG4unu9TazIr8OcXFgPy/EmSCB/UgMzVXsC
	 pLcCuGZ0VakrolvVaZub4BX6qFBnGxDRsF6u+7T1qTV9zxsre2SHEPgQLFuN07qjOV
	 bFAa/ARVUlnjdkRvj/HAE0RqPlA4Kx3YAt3QG1nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 464/809] RDMA/hns: Fix shift-out-bounds when max_inline_data is 0
Date: Tue, 30 Jul 2024 17:45:40 +0200
Message-ID: <20240730151743.057272103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 24c6291346d98c7ece4f4bfeb5733bec1d6c7b4f ]

A shift-out-bounds may occur, if the max_inline_data has not been set.

The related log:
UBSAN: shift-out-of-bounds in kernel/include/linux/log2.h:57:13
shift exponent 64 is too large for 64-bit type 'long unsigned int'
Call trace:
 dump_backtrace+0xb0/0x118
 show_stack+0x20/0x38
 dump_stack_lvl+0xbc/0x120
 dump_stack+0x1c/0x28
 __ubsan_handle_shift_out_of_bounds+0x104/0x240
 set_ext_sge_param+0x40c/0x420 [hns_roce_hw_v2]
 hns_roce_create_qp+0xf48/0x1c40 [hns_roce_hw_v2]
 create_qp.part.0+0x294/0x3c0
 ib_create_qp_kernel+0x7c/0x150
 create_mad_qp+0x11c/0x1e0
 ib_mad_init_device+0x834/0xc88
 add_client_context+0x248/0x318
 enable_device_and_get+0x158/0x280
 ib_register_device+0x4ac/0x610
 hns_roce_init+0x890/0xf98 [hns_roce_hw_v2]
 __hns_roce_hw_v2_init_instance+0x398/0x720 [hns_roce_hw_v2]
 hns_roce_hw_v2_init_instance+0x108/0x1e0 [hns_roce_hw_v2]
 hclge_init_roce_client_instance+0x1a0/0x358 [hclge]
 hclge_init_client_instance+0xa0/0x508 [hclge]
 hnae3_register_client+0x18c/0x210 [hnae3]
 hns_roce_hw_v2_init+0x28/0xff8 [hns_roce_hw_v2]
 do_one_initcall+0xe0/0x510
 do_init_module+0x110/0x370
 load_module+0x2c6c/0x2f20
 init_module_from_file+0xe0/0x140
 idempotent_init_module+0x24c/0x350
 __arm64_sys_finit_module+0x88/0xf8
 invoke_syscall+0x68/0x1a0
 el0_svc_common.constprop.0+0x11c/0x150
 do_el0_svc+0x38/0x50
 el0_svc+0x50/0xa0
 el0t_64_sync_handler+0xc0/0xc8
 el0t_64_sync+0x1a4/0x1a8

Fixes: 0c5e259b06a8 ("RDMA/hns: Fix incorrect sge nums calculation")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index db34665d1dfbf..1de384ce4d0e1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -532,13 +532,15 @@ static unsigned int get_sge_num_from_max_inl_data(bool is_ud_or_gsi,
 {
 	unsigned int inline_sge;
 
-	inline_sge = roundup_pow_of_two(max_inline_data) / HNS_ROCE_SGE_SIZE;
+	if (!max_inline_data)
+		return 0;
 
 	/*
 	 * if max_inline_data less than
 	 * HNS_ROCE_SGE_IN_WQE * HNS_ROCE_SGE_SIZE,
 	 * In addition to ud's mode, no need to extend sge.
 	 */
+	inline_sge = roundup_pow_of_two(max_inline_data) / HNS_ROCE_SGE_SIZE;
 	if (!is_ud_or_gsi && inline_sge <= HNS_ROCE_SGE_IN_WQE)
 		inline_sge = 0;
 
-- 
2.43.0



