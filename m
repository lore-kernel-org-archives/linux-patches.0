Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C8B155A4E;
	Tue, 29 Apr 2025 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950677; cv=none; b=Vlh1rChcpVK1qUQpcMILEmEZ5qNV5N3MCiB/YypStbZSSi2iokkcRFcLmpK4uR+OPPa8kHPGa7IkXSzb0QheYboxrdc/kQbi7IdCHCpFEEPTudNskHVQaemgj21uIGYBGPLcUyaFP+cOqAql24jHiG6X081GOVMKl6LUueCiKj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950677; c=relaxed/simple;
	bh=PRrJdrDY1o0fIjGf61Bfv61HzqidVnAgCBV3R1bClaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6KUeke833Hz+79heuUc+MMAxFA1xFdOHuWGYrindwIRsPZl2yyOQmnr+SCviBmIacfcAn1DDWPga//f7AgfeBHJ6C20XrgFAOscukt6pHMlwWd4fNlp7/LbRDwcV9d4gzNvXs5ge4VMBCiN8k+VURvfeY1mDMI0HrPRedZJbuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRUes1iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRUes1iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA61C4CEE3;
	Tue, 29 Apr 2025 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950677;
	bh=PRrJdrDY1o0fIjGf61Bfv61HzqidVnAgCBV3R1bClaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRUes1iyhbcfDuFzOKs5APHy0n0UEixuOZcCeb84Yt5ZpIzbITbANXh3KzNd3p61A
	 9RbyxOuAsNPQcbhKwafVtoxuYVzIcx1AhbW0IuBZJg6ZvSlqqW/RNg1fwlWrjoOKCg
	 MfeWNfUIm4NAte1DjvjK2hpW6gPqwl8ezKuyTLWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/204] nvmet-fc: put ref when assoc->del_work is already scheduled
Date: Tue, 29 Apr 2025 18:44:19 +0200
Message-ID: <20250429161106.402544339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 70289ae5cac4d3a39575405aaf63330486cea030 ]

Do not leak the tgtport reference when the work is already scheduled.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 68ff9540e2d13..570c58d2b5a58 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1091,7 +1091,8 @@ static void
 nvmet_fc_schedule_delete_assoc(struct nvmet_fc_tgt_assoc *assoc)
 {
 	nvmet_fc_tgtport_get(assoc->tgtport);
-	queue_work(nvmet_wq, &assoc->del_work);
+	if (!queue_work(nvmet_wq, &assoc->del_work))
+		nvmet_fc_tgtport_put(assoc->tgtport);
 }
 
 static struct nvmet_fc_tgt_assoc *
-- 
2.39.5



