Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2893FBE4A;
	Tue, 15 Jul 2025 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586685; cv=none; b=kVpCQIcz1RlvICW5zkG0TgHNGLeYE8uUNri05kzFI4l9zzZBiUfG7FqiW/ufkw7Jn/WqWmSHbGwIBDU7o3VHFKfiWYo9pET0fWR1KOhB0n8eME0Pbavz6EhDlNuTJXRiiLDjbLiX7yYckHvzfxClDtrsissj+4E0wlXQZQNxpeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586685; c=relaxed/simple;
	bh=+LVFQh0Ztl2eEZrpu2z0qAj2USBvqOx0nxZVxvIuIrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kd+9X5xoiUWjU6ciJMdq3eF/L+6M3rHoCMvbqarPYCkcJiaGX+eF79qrQdcPKnkKEuPPkUdZOJILTBpkmPmEz18wojrw0h492lEpi0MOHfOP01M8egBqtWOm+HxuB/qpQ0uzzQnClSrrchxFFjcVXhCyth5exwn/hLthWnmqon8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2+9IHmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2+9IHmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB4DC4CEF1;
	Tue, 15 Jul 2025 13:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586685;
	bh=+LVFQh0Ztl2eEZrpu2z0qAj2USBvqOx0nxZVxvIuIrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2+9IHmUCL1t2TxjuOF7FaJJXNyb/NJgJW0viA1NmVjaawS3bmp3W/Bs2uFYHgRQG
	 ZgdpUpqrn+mEi6Jaca5cDM+wimA3EzKmB5vdTy+C9ojTQDO0XMjZTtlXGVJLK9Fdn2
	 x0Nn9mk4B90CWgLKB5pwAPaltYZJg8zkuNGZ+rOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 010/192] EDAC: Initialize EDAC features sysfs attributes
Date: Tue, 15 Jul 2025 15:11:45 +0200
Message-ID: <20250715130815.273423010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiju Jose <shiju.jose@huawei.com>

[ Upstream commit 1e14ea901dc8d976d355ddc3e0de84ee86ef0596 ]

Fix the lockdep splat caused by missing sysfs_attr_init() calls for the
recently added EDAC feature's sysfs attributes.

In lockdep_init_map_type(), the check for the lock-class key if
(!static_obj(key) && !is_dynamic_key(key)) causes the splat.

  Backtrace:
  RIP: 0010:lockdep_init_map_type
  Call Trace:
   __kernfs_create_file
  sysfs_add_file_mode_ns
  internal_create_group
  internal_create_groups
  device_add
  ? __init_waitqueue_head
  edac_dev_register
  devm_cxl_memdev_edac_register
  ? lock_acquire
  ? find_held_lock
  ? cxl_mem_probe
  ? cxl_mem_probe
  ? lockdep_hardirqs_on
  ? cxl_mem_probe
  cxl_mem_probe

  [ bp: Massage. ]

Fixes: f90b738166fe ("EDAC: Add scrub control feature")
Fixes: bcbd069b11b0 ("EDAC: Add a Error Check Scrub control feature")
Fixes: 699ea5219c4b ("EDAC: Add a memory repair control feature")
Reported-by: Dave Jiang <dave.jiang@intel.com>
Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://lore.kernel.org/20250626101344.1726-1-shiju.jose@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ecs.c        | 4 +++-
 drivers/edac/mem_repair.c | 1 +
 drivers/edac/scrub.c      | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/ecs.c b/drivers/edac/ecs.c
index 1d51838a60c11..51c451c7f0f0b 100755
--- a/drivers/edac/ecs.c
+++ b/drivers/edac/ecs.c
@@ -170,8 +170,10 @@ static int ecs_create_desc(struct device *ecs_dev, const struct attribute_group
 		fru_ctx->dev_attr[ECS_RESET]		= EDAC_ECS_ATTR_WO(reset, fru);
 		fru_ctx->dev_attr[ECS_THRESHOLD]	= EDAC_ECS_ATTR_RW(threshold, fru);
 
-		for (i = 0; i < ECS_MAX_ATTRS; i++)
+		for (i = 0; i < ECS_MAX_ATTRS; i++) {
+			sysfs_attr_init(&fru_ctx->dev_attr[i].dev_attr.attr);
 			fru_ctx->ecs_attrs[i] = &fru_ctx->dev_attr[i].dev_attr.attr;
+		}
 
 		sprintf(fru_ctx->name, "%s%d", EDAC_ECS_FRU_NAME, fru);
 		group->name = fru_ctx->name;
diff --git a/drivers/edac/mem_repair.c b/drivers/edac/mem_repair.c
index 3b1a845457b08..1df8957a8459a 100755
--- a/drivers/edac/mem_repair.c
+++ b/drivers/edac/mem_repair.c
@@ -324,6 +324,7 @@ static int mem_repair_create_desc(struct device *dev,
 	for (i = 0; i < MR_MAX_ATTRS; i++) {
 		memcpy(&ctx->mem_repair_dev_attr[i],
 		       &dev_attr[i], sizeof(dev_attr[i]));
+		sysfs_attr_init(&ctx->mem_repair_dev_attr[i].dev_attr.attr);
 		ctx->mem_repair_attrs[i] =
 			&ctx->mem_repair_dev_attr[i].dev_attr.attr;
 	}
diff --git a/drivers/edac/scrub.c b/drivers/edac/scrub.c
index e421d3ebd959f..f9d02af2fc3a2 100755
--- a/drivers/edac/scrub.c
+++ b/drivers/edac/scrub.c
@@ -176,6 +176,7 @@ static int scrub_create_desc(struct device *scrub_dev,
 	group = &scrub_ctx->group;
 	for (i = 0; i < SCRUB_MAX_ATTRS; i++) {
 		memcpy(&scrub_ctx->scrub_dev_attr[i], &dev_attr[i], sizeof(dev_attr[i]));
+		sysfs_attr_init(&scrub_ctx->scrub_dev_attr[i].dev_attr.attr);
 		scrub_ctx->scrub_attrs[i] = &scrub_ctx->scrub_dev_attr[i].dev_attr.attr;
 	}
 	sprintf(scrub_ctx->name, "%s%d", "scrub", instance);
-- 
2.39.5



