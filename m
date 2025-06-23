Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD63E4315A;
	Mon, 23 Jun 2025 21:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714965; cv=none; b=LlrUXiqqNRYsSsaJepVSNOtOpLCW5qBQD83oXGPQ4a+mVmJHYFoCcn2pwP5Wft68hulvb3uOM24PqADlRt2yKf2RAid0eMgDWhZtZSfRCdDgk7HjOpnbN5rdcGpawO6FLwu2SLmrqAmbFNcl3PevEiiZFyRoMjHiQCKGlWvoapc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714965; c=relaxed/simple;
	bh=31RuLpQMZ+LtTIHTB+r/73c8kYv97lba3b1wWZJOvhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKAdEO67g+nXu52nM6QAoyERlJZyblTGD5tcbfApOx9Mu2P5S9Rd/HPSY1NwwenMFpzXMBSzzROVHrcLPnaZqFBhOkXqb4dVknutIAHA70eA9lcL529brV4xLnt1mMyy6H8v3omUry3dNNKAFWAiU7fdxfeBX6giF0DkjP+TyEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyA+c8GJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyA+c8GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452A0C4CEEA;
	Mon, 23 Jun 2025 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714965;
	bh=31RuLpQMZ+LtTIHTB+r/73c8kYv97lba3b1wWZJOvhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyA+c8GJdQYZBhgauBPrD83csTP3aAxVQPAOPLf1Wdxl8Il+h3zdN6y0HkNxiimmE
	 JJp/+bmNwGaI4eLglVyjc/ezsOmAJqrVK2c9vpWRSOd1baYKKeTIbXrlrmc6g+YejS
	 PY+yD4eGf+D3r1xMtzwre8TzwRfVePWsB/JCDHzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.12 147/414] Drivers: hv: Allocate interrupt and monitor pages aligned to system page boundary
Date: Mon, 23 Jun 2025 15:04:44 +0200
Message-ID: <20250623130645.725680505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit 09eea7ad0b8e973dcf5ed49902838e5d68177f8e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/connection.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -207,10 +207,19 @@ int vmbus_connect(void)
 	mutex_init(&vmbus_connection.channel_mutex);
 
 	/*
+	 * The following Hyper-V interrupt and monitor pages can be used by
+	 * UIO for mapping to user-space, so they should always be allocated on
+	 * system page boundaries. The system page size must be >= the Hyper-V
+	 * page size.
+	 */
+	BUILD_BUG_ON(PAGE_SIZE < HV_HYP_PAGE_SIZE);
+
+	/*
 	 * Setup the vmbus event connection for channel interrupt
 	 * abstraction stuff
 	 */
-	vmbus_connection.int_page = hv_alloc_hyperv_zeroed_page();
+	vmbus_connection.int_page =
+		(void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (vmbus_connection.int_page == NULL) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -225,8 +234,8 @@ int vmbus_connect(void)
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
@@ -342,21 +351,23 @@ void vmbus_disconnect(void)
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


