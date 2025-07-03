Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7952EF9B3;
	Thu,  3 Jul 2025 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556048; cv=none; b=VBtaqRQSZPeiYp7jxzPBbffF7jGJINuxsH6Zr/CGeqT+g8Q0hu78NFpGP4tQJZojIlHLK0Vt0icKVctvXKzgPMreIAaD+PeMjc1hWBXlhqnPI/UFqbqM7agsXUAYRSW1rT94ZlnHN6v+C1pC19HprkgKF/h09fRsss0iZw6Xlw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556048; c=relaxed/simple;
	bh=SMH+ySaCPWqSHai0mvNRqUHNmMCwLEwGVeIzDrCBm8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEmfWRqGhm/C2MLegHWCi0pWXd4KNV7DCk63q8yQ9ALWYZxxTShEagsxZAtc+CaSywZv8kwSXqRSg6mXP7bA++0aWI1xps7s1p+YLXhLQVGGX9Fakw5WqBpcHy77rZpH+6hu8FuMlzTdlZgT8Ct4Ffxc4kVBGZ299v6gAfD0Zi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvjO6W1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvjO6W1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2A5C4CEE3;
	Thu,  3 Jul 2025 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556048;
	bh=SMH+ySaCPWqSHai0mvNRqUHNmMCwLEwGVeIzDrCBm8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvjO6W1JO+1U/LfTyNHS1rhOpPml6vMQVURyjAS8F51gPFX1KgRSnVfVJhz4HOYAh
	 ZKHCpbKj/JH4+YjVDqZZj7FzksgvMGiuD1GbytLydWAfJbhP/bsBQ4ebrpuSSRuH+B
	 RSlzIKk1z/0fPgFTH74/R8kMEUXpvl1bMYCllbD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/132] Drivers: hv: Allocate interrupt and monitor pages aligned to system page boundary
Date: Thu,  3 Jul 2025 16:42:26 +0200
Message-ID: <20250703143941.660628850@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 09eea7ad0b8e973dcf5ed49902838e5d68177f8e ]

There are use cases that interrupt and monitor pages are mapped to
user-mode through UIO, so they need to be system page aligned. Some
Hyper-V allocation APIs introduced earlier broke those requirements.

Fix this by using page allocation functions directly for interrupt
and monitor pages.

Cc: stable@vger.kernel.org
Fixes: ca48739e59df ("Drivers: hv: vmbus: Move Hyper-V page allocator to arch neutral code")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1746492997-4599-2-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1746492997-4599-2-git-send-email-longli@linuxonhyperv.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 744d2809acc3f..7bb94e0dd0f66 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -205,11 +205,20 @@ int vmbus_connect(void)
 	INIT_LIST_HEAD(&vmbus_connection.chn_list);
 	mutex_init(&vmbus_connection.channel_mutex);
 
+	/*
+	 * The following Hyper-V interrupt and monitor pages can be used by
+	 * UIO for mapping to user-space, so they should always be allocated on
+	 * system page boundaries. The system page size must be >= the Hyper-V
+	 * page size.
+	 */
+	BUILD_BUG_ON(PAGE_SIZE < HV_HYP_PAGE_SIZE);
+
 	/*
 	 * Setup the vmbus event connection for channel interrupt
 	 * abstraction stuff
 	 */
-	vmbus_connection.int_page = hv_alloc_hyperv_zeroed_page();
+	vmbus_connection.int_page =
+		(void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (vmbus_connection.int_page == NULL) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -224,8 +233,8 @@ int vmbus_connect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.monitor_pages[0] = hv_alloc_hyperv_page();
-	vmbus_connection.monitor_pages[1] = hv_alloc_hyperv_page();
+	vmbus_connection.monitor_pages[0] = (void *)__get_free_page(GFP_KERNEL);
+	vmbus_connection.monitor_pages[1] = (void *)__get_free_page(GFP_KERNEL);
 	if ((vmbus_connection.monitor_pages[0] == NULL) ||
 	    (vmbus_connection.monitor_pages[1] == NULL)) {
 		ret = -ENOMEM;
@@ -341,21 +350,23 @@ void vmbus_disconnect(void)
 		destroy_workqueue(vmbus_connection.work_queue);
 
 	if (vmbus_connection.int_page) {
-		hv_free_hyperv_page(vmbus_connection.int_page);
+		free_page((unsigned long)vmbus_connection.int_page);
 		vmbus_connection.int_page = NULL;
 	}
 
 	if (vmbus_connection.monitor_pages[0]) {
 		if (!set_memory_encrypted(
 			(unsigned long)vmbus_connection.monitor_pages[0], 1))
-			hv_free_hyperv_page(vmbus_connection.monitor_pages[0]);
+			free_page((unsigned long)
+				vmbus_connection.monitor_pages[0]);
 		vmbus_connection.monitor_pages[0] = NULL;
 	}
 
 	if (vmbus_connection.monitor_pages[1]) {
 		if (!set_memory_encrypted(
 			(unsigned long)vmbus_connection.monitor_pages[1], 1))
-			hv_free_hyperv_page(vmbus_connection.monitor_pages[1]);
+			free_page((unsigned long)
+				vmbus_connection.monitor_pages[1]);
 		vmbus_connection.monitor_pages[1] = NULL;
 	}
 }
-- 
2.39.5



