Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126032FFDEA;
	Tue, 17 Mar 2026 17:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767098; cv=none; b=E3MNw0LWDSRh1WMxuMg1MMl3NoMw/P+4le/nm9PAvD+Q1EXPgZ4kg1TjgThJJz+NvgaaEpcGAf1BnRxIdSl1Gi2UywfAHjAuQsXnzcPOaeP0babWV7N0nVgooJzDkkZaYlcx5Vcoy3TBLJZwgMwyz1M/7cP0P7QU5Bs25KETWCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767098; c=relaxed/simple;
	bh=2mUsQ32Y0b0PvsAUoUTQ532Hb67LtJINrDLCrT/m5yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0YyNnwsv6fuA68ZSw+zdipDk4W44Axr9aRBY/TVPtFU0ObLcBEBvJVHKy6+wzZP4mzsiI7KOAp6Q/Ph6rtvjZPLka9RYxP13kESycikO9WA2WtVgBQcepWhUyWVLY9qWU5soNOLLyRIQtnl1g9+D5OXZ4IJjzRrmbaRqhDBr/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hKeJa3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hKeJa3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175C8C4CEF7;
	Tue, 17 Mar 2026 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767097;
	bh=2mUsQ32Y0b0PvsAUoUTQ532Hb67LtJINrDLCrT/m5yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hKeJa3h1OqAGP5arwogv0ostCxxp2l42x1LHqERuKVDKRwVSdKk5+gkFHsxhl+de
	 CQov0ZxlIL1nyV28em4yvknxDH1P+2FPCvpRSMEhZcAWfpIeIYRkjSqXnMrV/nTRa9
	 oLGaqO1xPCfopNQHmF/vp5JCGrBnMfzymiGvcLF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangshuaiwei <wangshuaiwei1@xiaomi.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/333] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
Date: Tue, 17 Mar 2026 17:30:43 +0100
Message-ID: <20260317162959.889075830@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangshuaiwei <wangshuaiwei1@xiaomi.com>

[ Upstream commit 2f38fd99c0004676d835ae96ac4f3b54edc02c82 ]

According to JESD223F, the maximum number of queues (MAXQ) is 32. When MCQ
is enabled and ESI is disabled, nr_hw_queues=32 causes a shift overflow
problem.

Fix this by using 64-bit intermediate values to handle the nr_hw_queues=32
case safely.

Signed-off-by: wangshuaiwei <wangshuaiwei1@xiaomi.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260224063228.50112-1-wangshuaiwei1@xiaomi.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 403f8989b1448..fe1425ea6718f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7078,7 +7078,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
 
 	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
-		outstanding_cqs = (1U << hba->nr_hw_queues) - 1;
+		outstanding_cqs = (1ULL << hba->nr_hw_queues) - 1;
 
 	/* Exclude the poll queues */
 	nr_queues = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
-- 
2.51.0



