Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E69522F0F;
	Thu, 17 Sep 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664231; cv=none; b=J0Nfh2eWWeHZr5UHogkGWJ9Sy6WxIffb7waMe4xxd914qQzXgWZqtEZclswCq8upLJTX9kMaOE3AvVSZMLEbpi9vYnEIHAu9dZdunjXKmG5UJXmUsidIf1+3HFPd4i7dCSk6+mQ9o5AFd0ZoljdAThLnif9kVpRnnoiDAYJGuSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664231; c=relaxed/simple;
	bh=pHL0xE25XrkY+SgSUOwm2VNZnoGi0k+waaFWmDEY6B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkFJUh0b1Rle3Q7K0NTM+QbtwzRWwGeQAaq0LaNXjqdqPPgNPrvU+RsTbw+c66B4cM9gjXmzK8vyvxk58szXIInFpJGKQP6ZRDTILjiJokcaFOv7+8qATim6HGDIYkThaPWfBKaIwWNyfddmWLYoGik/0a7kQPY2iilUGtk0coE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZaAXp52; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZaAXp52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733E91F000FF;
	Thu, 17 Sep 2026 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664229;
	bh=X9hfIT54Ymeg9j8MyzGP5Pt01Tnqt4adHQz6bG50SOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZaAXp52nsmGLNMcEugrn0rN9ipEJgBGI4+tfO7HTwacRYp4FdZmfBdszzA2K1TGU
	 djRNIF5u5QZ9dVlggxFlALYXtRiGX8VX3pD09dVWzl+aIsqs0QYK2D/3oFDs+EMpte
	 4MzxXAeNbv0BuEMBU3tPnXvUJRBvGs6VbSo2fppw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	liuxixin <gliuxen@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0303/1250] nvme: validate FDP configuration descriptor sizes
Date: Thu, 17 Sep 2026 16:01:38 +0100
Message-ID: <20260917151600.327852446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 0ef4daa6534a510d61ea67c8ad9bb5097b0dd5f8 ]

Validate descriptor sizes while walking the FDP configurations log so
dsze == 0 or a descriptor past the log end cannot cause unbounded
iteration or reads past the buffer.

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: liuxixin <gliuxen@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fd4f9cd445075..b34c6b4d65877 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2240,14 +2240,16 @@ static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
 	desc = log;
 	end = log + size - sizeof(*h);
 	for (i = 0; i < fdp_idx; i++) {
-		log += le16_to_cpu(desc->dsze);
-		desc = log;
-		if (log >= end) {
+		u16 dsze = le16_to_cpu(desc->dsze);
+
+		if (!dsze || log + dsze > end) {
 			dev_warn(ctrl->device,
-				 "FDP invalid config descriptor list\n");
+				 "FDP invalid config descriptor at index %d\n", i);
 			ret = 0;
 			goto out;
 		}
+		log += dsze;
+		desc = log;
 	}
 
 	if (le32_to_cpu(desc->nrg) > 1) {
-- 
2.53.0



