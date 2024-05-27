Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE2D168C4;
	Mon, 27 May 2024 19:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837696; cv=none; b=fizW7i0HmKZIXYu2xQAT2axdOolB1qbDZp43JWlvHUYO+wabJdRDHpJ8LRIdSE10wwbm5+gEB3lnL/9Hl6n7IeLGl5DZ288J4eIzgm4ehSKNseWH/prKgXwtXawZ6IcS99IlI2bOypYg6Go3fpNnd8VtUbYB5PJ3eaUfFd3rNi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837696; c=relaxed/simple;
	bh=lM+9ttsnFiTz0Dp23Mwx3U0hprTe86Sgeh2Nmn/v7QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIK9N7DXXPSSPJWlg0S7RGaG2YcpuFfhT9eJf3xF35raT+vf7FH/QLeq/GC2fWWhwKo/FW6ZBERDNVzyZRhAQsJIWht6lRnB+9UE25Csxa96/JVHoNuY6/qdvhfXMWXKEp2SJ6cvWuQ2XTN+oissiFbUFZ0cM9iaw1mOACKXDog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BQbDyh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BQbDyh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A16C2BBFC;
	Mon, 27 May 2024 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837696;
	bh=lM+9ttsnFiTz0Dp23Mwx3U0hprTe86Sgeh2Nmn/v7QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BQbDyh9ugODDSDUvB8PDvMpiRFzrMcc4p62RQMX+V1kGyVR7YHF5T/xsAHZTDkcl
	 fvtScXqA5QP5Sb4oHy64J3kLskQFxqXQniekiAmfgHN5xApYBEa69B6EIKasGcPSJy
	 BycSlF7dn32N98pZVlKyDDuQmgsnek1Qjgjcmsy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 109/493] nvmet: prevent sprintf() overflow in nvmet_subsys_nsid_exists()
Date: Mon, 27 May 2024 20:51:51 +0200
Message-ID: <20240527185634.090352810@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d15dcd0f1a4753b57e66c64c8dc2a9779ff96aab ]

The nsid value is a u32 that comes from nvmet_req_find_ns().  It's
endian data and we're on an error path and both of those raise red
flags.  So let's make this safer.

1) Make the buffer large enough for any u32.
2) Remove the unnecessary initialization.
3) Use snprintf() instead of sprintf() for even more safety.
4) The sprintf() function returns the number of bytes printed, not
   counting the NUL terminator. It is impossible for the return value to
   be <= 0 so delete that.

Fixes: 505363957fad ("nvmet: fix nvme status code when namespace is disabled")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index b7bfee4b77a84..3ef6bc655661d 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -731,10 +731,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
 bool nvmet_subsys_nsid_exists(struct nvmet_subsys *subsys, u32 nsid)
 {
 	struct config_item *ns_item;
-	char name[4] = {};
+	char name[12];
 
-	if (sprintf(name, "%u", nsid) <= 0)
-		return false;
+	snprintf(name, sizeof(name), "%u", nsid);
 	mutex_lock(&subsys->namespaces_group.cg_subsys->su_mutex);
 	ns_item = config_group_find_item(&subsys->namespaces_group, name);
 	mutex_unlock(&subsys->namespaces_group.cg_subsys->su_mutex);
-- 
2.43.0



