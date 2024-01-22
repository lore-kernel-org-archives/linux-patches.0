Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E9B3FFE;
	Tue, 23 Jan 2024 00:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970947; cv=none; b=p8n11tbHAy639XeU8GDg4SKoz909lWwOS0Xj2fKgy4nMSfXgECP+6/QAKje6UBBEjfKyw+bffw2tRm6HY9EU9+Q620CGvBBDZWiy6lQso+MThf9Sd6SyQFXBYPiUgcngCfCun07aDfZtpAiuHHsDso150eo+IdA7OJqf18JXF3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970947; c=relaxed/simple;
	bh=HgQTH1kdWtXMahbMNUddfZWidp655py30ovrrIp7Txo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwPnGtyd2VT5uxefJvCV6OsIOE4HGg5OvJQrM5xszIoUt5nfQ7v4MK9nzQZSrW9mIGul8UEKTWY1+fyzT5kvndBGKC5tEExZY1faxo5oPlzMMEsnuJh6HsCiBAndAt8fK8YetwXUgYO8OHfPWYNuNv23IzHbaXEHukjOwEevBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iGWegJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iGWegJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17191C433C7;
	Tue, 23 Jan 2024 00:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970947;
	bh=HgQTH1kdWtXMahbMNUddfZWidp655py30ovrrIp7Txo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iGWegJ8XJSEbr5gJrD4JeceTWVAVoCPAAvvJyRYMZuIvu1keA5asvM00aFwj3y2l
	 s5Tp/AXmpuEk+r/mvUuuSy4/qhfwniQVbyo+boeWwwVLmCrWYeGDsUS8ykAJ3jy/jP
	 ScDWi6cgq5RdBHt15AqAMT7CWzVytoJEtxMFGGlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Dufour <ldufour@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/286] powerpc/pseries/memhotplug: Quieten some DLPAR operations
Date: Mon, 22 Jan 2024 15:56:00 -0800
Message-ID: <20240122235734.110995873@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit 20e9de85edae3a5866f29b6cce87c9ec66d62a1b ]

When attempting to remove by index a set of LMBs a lot of messages are
displayed on the console, even when everything goes fine:

  pseries-hotplug-mem: Attempting to hot-remove LMB, drc index 8000002d
  Offlined Pages 4096
  pseries-hotplug-mem: Memory at 2d0000000 was hot-removed

The 2 messages prefixed by "pseries-hotplug-mem" are not really
helpful for the end user, they should be debug outputs.

In case of error, because some of the LMB's pages couldn't be
offlined, the following is displayed on the console:

  pseries-hotplug-mem: Attempting to hot-remove LMB, drc index 8000003e
  pseries-hotplug-mem: Failed to hot-remove memory at 3e0000000
  dlpar: Could not handle DLPAR request "memory remove index 0x8000003e"

Again, the 2 messages prefixed by "pseries-hotplug-mem" are useless,
and the generic DLPAR prefixed message should be enough.

These 2 first changes are mainly triggered by the changes introduced
in drmgr:
  https://groups.google.com/g/powerpc-utils-devel/c/Y6ef4NB3EzM/m/9cu5JHRxAQAJ

Also, when adding a bunch of LMBs, a message is displayed in the console per LMB
like these ones:
  pseries-hotplug-mem: Memory at 7e0000000 (drc index 8000007e) was hot-added
  pseries-hotplug-mem: Memory at 7f0000000 (drc index 8000007f) was hot-added
  pseries-hotplug-mem: Memory at 800000000 (drc index 80000080) was hot-added
  pseries-hotplug-mem: Memory at 810000000 (drc index 80000081) was hot-added

When adding 1TB of memory and LMB size is 256MB, this leads to 4096
messages to be displayed on the console. These messages are not really
helpful for the end user, so moving them to the DEBUG level.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
[mpe: Tweak change log wording]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201211145954.90143-1-ldufour@linux.ibm.com
Stable-dep-of: bd68ffce69f6 ("powerpc/pseries/memhp: Fix access beyond end of drmem array")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index a5f968b5fa3a..0e602c3b01ea 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -481,7 +481,7 @@ static int dlpar_memory_remove_by_index(u32 drc_index)
 	int lmb_found;
 	int rc;
 
-	pr_info("Attempting to hot-remove LMB, drc index %x\n", drc_index);
+	pr_debug("Attempting to hot-remove LMB, drc index %x\n", drc_index);
 
 	lmb_found = 0;
 	for_each_drmem_lmb(lmb) {
@@ -499,10 +499,10 @@ static int dlpar_memory_remove_by_index(u32 drc_index)
 		rc = -EINVAL;
 
 	if (rc)
-		pr_info("Failed to hot-remove memory at %llx\n",
-			lmb->base_addr);
+		pr_debug("Failed to hot-remove memory at %llx\n",
+			 lmb->base_addr);
 	else
-		pr_info("Memory at %llx was hot-removed\n", lmb->base_addr);
+		pr_debug("Memory at %llx was hot-removed\n", lmb->base_addr);
 
 	return rc;
 }
@@ -719,8 +719,8 @@ static int dlpar_memory_add_by_count(u32 lmbs_to_add)
 			if (!drmem_lmb_reserved(lmb))
 				continue;
 
-			pr_info("Memory at %llx (drc index %x) was hot-added\n",
-				lmb->base_addr, lmb->drc_index);
+			pr_debug("Memory at %llx (drc index %x) was hot-added\n",
+				 lmb->base_addr, lmb->drc_index);
 			drmem_remove_lmb_reservation(lmb);
 		}
 		rc = 0;
-- 
2.43.0



