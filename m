Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA49746A5F9;
	Tue, 21 Jul 2026 15:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649075; cv=none; b=fAw8xfQoJ0Ag0OefsmXVEEFvsMDItgw+gAUb5l1meHfQb7Rw2TI3l50CjlIpVgz1oMiQ50OJPCkgtiCnmGDgGIABKS9FG2fYZCIg8nIwTeG01P1pEEuvEH5XyMaUM0pDNAkTpJO3e5XTd262fr/eRuBjceEIaZxeH2+aTDOaca0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649075; c=relaxed/simple;
	bh=MoKc36vffsVhI4ZOwzCSYX8uAHtgJkLnMBcDlcckZ+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFWhbTTzkkBIuMMeWwnbV+mptyahDkv8kO/d5kTNUdUsxoSJcImG3xCshe+ig7C/VoBnzUK5AO2ig24C2ZhOEcw6UNlK+tlzqvjD8bKiANzK34hEE8CdvYdc6SVmgWH+Oc8XghLWlQIFBpb91UnelswpV9c1eZUOza/iTkj+Q3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvDQGz6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvDQGz6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C02A1F000E9;
	Tue, 21 Jul 2026 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649073;
	bh=hJxDcjhVLHAgYKuF9VQlTKL+KQ/61DmX+QGEf3L9Dvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvDQGz6lz48CuUiKoEGmnauHSlxbHJcZSKw4mSvvMoTjPxaWPv2GdVee6wgmUA2Ct
	 Lz2sQfPm5htzLivAlpYF+zV82No2sTKCQqjp3/SzsmaWUqlEPGjroE4Ldy89S1nxDg
	 jC/515qjP+Qje34YrU4WpFrdjJPy1YM4trgTEGfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	liuxixin <gliuxen@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0439/2077] nvme: fix FDP fdpcidx bounds check
Date: Tue, 21 Jul 2026 17:01:52 +0200
Message-ID: <20260721152603.113394771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 96809227a0e229..a231da68658537 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2263,7 +2263,7 @@ static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
 	}
 
 	n = le16_to_cpu(h->numfdpc) + 1;
-	if (fdp_idx > n) {
+	if (fdp_idx >= n) {
 		dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
 			 fdp_idx, n);
 		/* Proceed without registering FDP streams */
-- 
2.53.0



