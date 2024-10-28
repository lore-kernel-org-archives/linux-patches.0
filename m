Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43118837;
	Mon, 28 Oct 2024 06:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098117; cv=none; b=sRh0h83WIR6Ezcb5j3h5yxxvtKgIEoT0/hITEAUQ96gLQTFJXqTbCsGpfYP4O5/+PWPfaO3dCuxcbbqSR7Jx62EnxnA4XZPUpgoZGnGawyGlC2cHIM9kJ/6+yZouOhZyqKwTxes3TGLO/yRZvTPDLxz0sIzLb0RPT4f7/985/no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098117; c=relaxed/simple;
	bh=zaz8JUkGDmW+EstlLit+I5j/1zpzG0IYb/0l/9PucdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrenEFtJIPjSIgY6NzVT7EG6Mm3TgRy9kCqRvRxgclmdIRzXWEJdD63rZ0soIjVWoRJoscwHq+q4Mp6WMPIG/fB9EtKwLS/AO4vDW1jCprHDuES/C9P7yeWHq4eiTuhHAoqZ+zEPnXy5Uhj6YFSrQII9Qh8pBASKteIzHf2sexk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7Jxe6b3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7Jxe6b3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0B6C4CEC3;
	Mon, 28 Oct 2024 06:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098117;
	bh=zaz8JUkGDmW+EstlLit+I5j/1zpzG0IYb/0l/9PucdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7Jxe6b3ayWYsCTWkIX5LDIcIMNed4GWchWtxIhIU5ds9vxl+b7qu+E1n+ZWVIxHK
	 UpAg5k/+OxecNSIRJkwT6AqLIPP1o2tnkPR/jscHvma7/rMNrw6H9331l2Ze4WbhnA
	 M9VVEYYNbsBOV76HT6trApyMWQ8v4lK9l6FtY6Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 084/261] scsi: target: core: Fix null-ptr-deref in target_alloc_device()
Date: Mon, 28 Oct 2024 07:23:46 +0100
Message-ID: <20241028062314.137836212@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index bf4892544cfdb..bb84d304b07e5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -691,7 +691,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
 	if (!dev->queues) {
-		dev->transport->free_device(dev);
+		hba->backend->ops->free_device(dev);
 		return NULL;
 	}
 
-- 
2.43.0



