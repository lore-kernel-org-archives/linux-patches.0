Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7DF18F2C5;
	Mon, 28 Oct 2024 06:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097245; cv=none; b=bAgae8/SMepafDnN/phk3qQNQZnuFfwZ+v5gDdmwpRI6VT46ZBeXaFrmKsEEiWIGCbSnuassi3DBd2HPvWDxVpEXQx3PAUfWfwYWjWXIS2tDUxl6Pcu7mtM3WxzFMf32SjhFGBn1ovQGi+/kh5f2e6Y3khYgpk3m1LNapHnwWVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097245; c=relaxed/simple;
	bh=HPBP/lznW4bHmralzpO83mQtJG8Gqd7ZjoQbnNryO84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAqi74Epp6JM3D8h7ze677hH596NFHqAwXbE1tX2OPb0ENJ/pXyzut/nid65kBSOD05ppg03w3LchSpJV2GCowKYXeVp5rhyLYqLdK/qOn75JkkhLPO+k5ieiivjK+Hk32ORKawcpNDfxsnjAZW1dcMuxL/kW2tqRZazjqn320Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1n75o0a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1n75o0a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B2FC4CEC7;
	Mon, 28 Oct 2024 06:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097244;
	bh=HPBP/lznW4bHmralzpO83mQtJG8Gqd7ZjoQbnNryO84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1n75o0a/tcAW2FREFgKwiGN77HvpzslJiIIFASdKJSqjsBgNqH0BepJ9YfRVpnWmW
	 xQpxUju/a0zxyesRTRw81ELUtu3Wk514S+WPlXWnYwDkrHUH8PlfTmDsLO1/m3JVdZ
	 nc8Nvj2hfoX0gqjO/NrR2gcNhV13qQCfm7h6/jwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/137] scsi: target: core: Fix null-ptr-deref in target_alloc_device()
Date: Mon, 28 Oct 2024 07:24:43 +0100
Message-ID: <20241028062300.015037350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit fca6caeb4a61d240f031914413fcc69534f6dc03 ]

There is a null-ptr-deref issue reported by KASAN:

BUG: KASAN: null-ptr-deref in target_alloc_device+0xbc4/0xbe0 [target_core_mod]
...
 kasan_report+0xb9/0xf0
 target_alloc_device+0xbc4/0xbe0 [target_core_mod]
 core_dev_setup_virtual_lun0+0xef/0x1f0 [target_core_mod]
 target_core_init_configfs+0x205/0x420 [target_core_mod]
 do_one_initcall+0xdd/0x4e0
...
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

In target_alloc_device(), if allocing memory for dev queues fails, then
dev will be freed by dev->transport->free_device(), but dev->transport
is not initialized at that time, which will lead to a null pointer
reference problem.

Fixing this bug by freeing dev with hba->backend->ops->free_device().

Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20241011113444.40749-1-wanghai38@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 13558cbd9b82e..7be48bfbd42e4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -733,7 +733,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
 	if (!dev->queues) {
-		dev->transport->free_device(dev);
+		hba->backend->ops->free_device(dev);
 		return NULL;
 	}
 
-- 
2.43.0



