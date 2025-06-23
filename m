Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA21615ADB4;
	Mon, 23 Jun 2025 22:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717367; cv=none; b=GNDb7JYn7eYMUwZ7vvQunqvrtcj9XkGau7Il2/XfLOr4pCJ+9Bbfb+VRYpaIws6B8YL2kAQAn8OKex1gBnLx7hk9ae+3xZ8nPbDN69GTO6GtZ5NJSRV/3C9o0p/6uxu2xzHQXh9gzkpba8DQPq8AxYuBFIxu0Wwp2wbXH/GJwAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717367; c=relaxed/simple;
	bh=mO6iaNC+PP80godl9+ptRwBH8g4hzmnkRAsTez5uo/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLng/0RtXVh7JvpDRm+OgC5VfZY7bX54gwzbpERP0vQhXrdmHZ0E46rqM4yhQRCyVFdWqBPC9AaOR7cDhim6bOjUmEpXJpTe+lwxs+lYpZVv1w8x9Xygq0vW8Heobsn46CHAzEkbmudGLTI2RVsEU87b87CzEYBS58BR0ZfXdow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zM6iICLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zM6iICLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6772DC4CEED;
	Mon, 23 Jun 2025 22:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717367;
	bh=mO6iaNC+PP80godl9+ptRwBH8g4hzmnkRAsTez5uo/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zM6iICLM624Q4duJwYZh7h2xHHCwJGKDSS0Yn/eIUOdhBS0IWfr182ILqtXLC9+pS
	 j62HjAAHjhD9s0YOQlnTUeTotZEji6aVKOrqlARbXLYjqAqGNC+Z5lMSl/H4q4Bbn+
	 A1I5Z3tOKRWoOfLG9nzTa8TjDcwTGy00I7zjzalU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/414] eth: bnxt: fix out-of-range access of vnic_info array
Date: Mon, 23 Jun 2025 15:08:31 +0200
Message-ID: <20250623130651.305771335@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 919f9f497dbcee75d487400e8f9815b74a6a37df ]

The bnxt_queue_{start | stop}() access vnic_info as much as allocated,
which indicates bp->nr_vnics.
So, it should not reach bp->vnic_info[bp->nr_vnics].

Fixes: 661958552eda ("eth: bnxt: do not use BNXT_VNIC_NTUPLE unconditionally in queue restart logic")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250316025837.939527-1-ap420073@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 5dacc94c6fe6 ("bnxt_en: Update MRU and RSS table of RSS contexts on queue reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2bb1fce350dbb..d0a87424c74ed 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15356,7 +15356,7 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	cpr = &rxr->bnapi->cp_ring;
 	cpr->sw_stats->rx.rx_resets++;
 
-	for (i = 0; i <= bp->nr_vnics; i++) {
+	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 
 		rc = bnxt_hwrm_vnic_set_rss_p5(bp, vnic, true);
@@ -15384,7 +15384,7 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 	struct bnxt_vnic_info *vnic;
 	int i;
 
-	for (i = 0; i <= bp->nr_vnics; i++) {
+	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 		vnic->mru = 0;
 		bnxt_hwrm_vnic_update(bp, vnic,
-- 
2.39.5



