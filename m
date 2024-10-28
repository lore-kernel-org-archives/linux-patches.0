Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D71A2C697;
	Mon, 28 Oct 2024 06:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097613; cv=none; b=I7wUSmwmitfKMzR7bptRkB9dBtT/mJysdcysyavIXJF5MyUcRxIwFKokyoC0GuXT5urktJBueXf/5ABWuR4h80GQr9qXwIU1QXvVCzoiASboPwMVpmka3t094b7URlTpOQUACtmDsnaf8y8ynCKv9lOyXX6fYE4TJusoY4LkPm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097613; c=relaxed/simple;
	bh=hguTVCCMRroEBtJjW+QlnsbfXixfv9jy2/Sjp/Uh5Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7JutRAFA2F3/nvdqF2iibmNj5BQj7TnTvKdRtTiPEtjR0fYTKlQ8MEiT9OyYriCeZ1tdBqkHc5ImMWF8DEkZKIl9hye/G3DA+wk0MYCHqAH86FZFf8NdhMHIhY4IbSi0FDQofQh4SBnuokf1rtjjdtucuMmhcPSItIdTRMuAGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4ZCURdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4ZCURdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EEBC4CEC3;
	Mon, 28 Oct 2024 06:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097613;
	bh=hguTVCCMRroEBtJjW+QlnsbfXixfv9jy2/Sjp/Uh5Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4ZCURdE+iHVCf9L0qqkn1E3WjE4lQqxmVgaa6unln1E2KJRZriaV/z6xCgQJW2Yv
	 DYgsxaZF6fxseST35yGV8zToJLCAza+1Q0qfp1kifYKMx+xWJRjSiz+TMk6y5vI+yz
	 4bNleSyc9Fq/jwBQ4mcppfWkji8wr4lU2ujmrgL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/208] scsi: target: core: Fix null-ptr-deref in target_alloc_device()
Date: Mon, 28 Oct 2024 07:24:11 +0100
Message-ID: <20241028062308.399100548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
index 86590a7e29f6a..dd041ee18ac9b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -692,7 +692,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
 	if (!dev->queues) {
-		dev->transport->free_device(dev);
+		hba->backend->ops->free_device(dev);
 		return NULL;
 	}
 
-- 
2.43.0



