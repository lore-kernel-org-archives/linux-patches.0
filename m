Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4E613AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442A3C433C0;
	Mon, 26 Jun 2023 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804171;
	bh=dhZneaUi7W/r+uKBoWD9WfUV4JA3BkezyGzkrmfEb7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba0XpSaI0a0XCZVsiML8YF7i1Gs+qg/Qh2Ky16iPikh6b5oyllmuvLGhab7URXDxn
	 puj8mc0wQ4gYjWo+cldZENcKr076Ou9/LQ5O+uJ4jeebJXFNQFeoRuHl72vvXgFpAY
	 ZSm5B3xbkEZIruJTe26i6uYpfz3ROBqG/P8WWWZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dexuan Cui <decui@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.1 048/170] Drivers: hv: vmbus: Call hv_synic_free() if hv_synic_alloc() fails
Date: Mon, 26 Jun 2023 20:10:17 +0200
Message-ID: <20230626180802.712039449@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dexuan Cui <decui@microsoft.com>

commit ec97e112985c2581ee61854a4b74f080f6cdfc2c upstream.

Commit 572086325ce9 ("Drivers: hv: vmbus: Cleanup synic memory free path")
says "Any memory allocations that succeeded will be freed when the caller
cleans up by calling hv_synic_free()", but if the get_zeroed_page() in
hv_synic_alloc() fails, currently hv_synic_free() is not really called
in vmbus_bus_init(), consequently there will be a memory leak, e.g.
hv_context.hv_numa_map is not freed in the error path. Fix this by
updating the goto labels.

Cc: stable@kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Fixes: 4df4cb9e99f8 ("x86/hyperv: Initialize clockevents earlier in CPU onlining")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20230504224155.10484-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/vmbus_drv.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1504,7 +1504,7 @@ static int vmbus_bus_init(void)
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "hyperv/vmbus:online",
 				hv_synic_init, hv_synic_cleanup);
 	if (ret < 0)
-		goto err_cpuhp;
+		goto err_alloc;
 	hyperv_cpuhp_online = ret;
 
 	ret = vmbus_connect();
@@ -1555,9 +1555,8 @@ static int vmbus_bus_init(void)
 
 err_connect:
 	cpuhp_remove_state(hyperv_cpuhp_online);
-err_cpuhp:
-	hv_synic_free();
 err_alloc:
+	hv_synic_free();
 	if (vmbus_irq == -1) {
 		hv_remove_vmbus_handler();
 	} else {


