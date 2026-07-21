Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039DF3382C7;
	Tue, 21 Jul 2026 17:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656243; cv=none; b=u5KiKgC6xjryzT9FvoJmYZgLbl/0qMuu798N6hyZna7JSsiI+vGau3nPHTH8hJ4jtLBA90ROPlDLB2MXMfxYb7kWhvylVacbaF7XOUVAFK7Ml5osNu1MB9Y9k2xH5QoQQ3UXoeDQMZrxzwKR8izTm97HNR+f1iqW7nldqC8lngg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656243; c=relaxed/simple;
	bh=iQidMVk7pvaAZzrfvFMOSamHydfs3XxaaUqu1w29ldg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEygKBvgEdGRmuBRIG9Z7Dro3rkST/TSFEDl9f+8lNDu7vP6DPKuvKbRFCNaPnftvITf8MFabOkQzzbC8WY3h6gSFKTA8hnt4p1Fj4mI6eLk77jEQKzPEY6znXTzNtxNiFLlKTuh2iDs9oqJS9DDJUH/DF8yKd+rii8ARNcjymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/7vyVtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/7vyVtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A51F000E9;
	Tue, 21 Jul 2026 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656241;
	bh=qrRirkQzkMUVzIuTUCr9VAycYsNqFuZOfBD6tzaTuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/7vyVtGxrsHapKBhnod+IgFF/jyq6uGha5O60bPcuZBWXGmyij1yLJvaUCVW1vmH
	 uWpSJWDd66jZwwqGsriRULb5AEWlcqbiDAtoPX/W1lOEBed5iS5bHyPtY1dlFbUKTa
	 LED22/YvMm7WPv59nD8YfbMXcMBlfLn9Ozi6fzjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	liuxixin <gliuxen@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0312/1611] nvme: fix FDP fdpcidx bounds check
Date: Tue, 21 Jul 2026 17:07:08 +0200
Message-ID: <20260721152522.097014217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: liuxixin <gliuxen@gmail.com>

[ Upstream commit 0967074f6830718fd2597404ef119bddd0dbfd00 ]

The fdpcidx bounds check sets n = NUMFDPC + 1 but used > instead of >=,
incorrectly accepting fdp_idx when it equals n (i.e. NUMFDPC + 1).

Fixes: 30b5f20bb2dd ("nvme: register fdp parameters with the block layer")
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: liuxixin <gliuxen@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7b6b42b20641b0..24a5ca35aeb255 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2229,7 +2229,7 @@ static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
 	}
 
 	n = le16_to_cpu(h->numfdpc) + 1;
-	if (fdp_idx > n) {
+	if (fdp_idx >= n) {
 		dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
 			 fdp_idx, n);
 		/* Proceed without registering FDP streams */
-- 
2.53.0



