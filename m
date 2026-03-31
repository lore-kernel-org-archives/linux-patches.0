Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A098B3F7867;
	Tue, 31 Mar 2026 16:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976163; cv=none; b=Kn8NIiMSfZFbUuPEFhdGJ7DRbgyzK+LbHMeLtGMyvLj00PtRuvtL5VAU/6S/UfJ5VHJeSS5FgusRvNuvnsNf4qyfefvZI3HdQV4yhckTvRJwaFDchUBHAqSYE+KJVVipu21281KIFYgtU9XK7RmW4e12w1FTgdhPbtBTTZKuQQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976163; c=relaxed/simple;
	bh=GUWpfeGS7EBl8sH2DWv8fP1IsaCLX8XWJaadc9zy1Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC87RY50VhkeoVv+boalejbISxZgUDK4ShgUzocFrlXelCbxD2ayZIIv/w6E/HYqPefOZxngtBX8SeKaZTWkgtrYQAu66eSNEcLA1qv+ileWAYMFr0i1uU/7pzKh9d6VJooewlB3N7ovrSzP41PDR5kHS4CtfEisS0Kax93ZeZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzJxvJNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzJxvJNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BFFC19423;
	Tue, 31 Mar 2026 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976163;
	bh=GUWpfeGS7EBl8sH2DWv8fP1IsaCLX8XWJaadc9zy1Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzJxvJNn5pyLszWFTMBiNJfNXCpFjuYZPUxQks1BDwkWt+Q/zeSlt50FjDyukWJV2
	 vlN6MmQBaZl6kixU8I5BtwonGOEXQ/IeIiMHgv4LrVs/mEopYdpekZ2UrJpiPqc6T1
	 du0kcjXDUtGCFnrwroKE1W8saLxKbw7n1zKpjVHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/244] dmaengine: idxd: fix possible wrong descriptor completion in llist_abort_desc()
Date: Tue, 31 Mar 2026 18:23:01 +0200
Message-ID: <20260331161750.295240848@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tuo Li <islituo@gmail.com>

[ Upstream commit e1c9866173c5f8521f2d0768547a01508cb9ff27 ]

At the end of this function, d is the traversal cursor of flist, but the
code completes found instead. This can lead to issues such as NULL pointer
dereferences, double completion, or descriptor leaks.

Fix this by completing d instead of found in the final
list_for_each_entry_safe() loop.

Fixes: aa8d18becc0c ("dmaengine: idxd: add callback support for iaa crypto")
Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260106032428.162445-1-islituo@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 94eca25ae9b90..b246da3cfb55d 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -138,7 +138,7 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 	 */
 	list_for_each_entry_safe(d, t, &flist, list) {
 		list_del_init(&d->list);
-		idxd_dma_complete_txd(found, IDXD_COMPLETE_ABORT, true,
+		idxd_dma_complete_txd(d, IDXD_COMPLETE_ABORT, true,
 				      NULL, NULL);
 	}
 }
-- 
2.53.0



