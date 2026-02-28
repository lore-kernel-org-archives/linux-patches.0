Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D61233FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300929; cv=none; b=pMA/yhg3QcltY/k+NO7SW1JruBQJ534cVT/O/IhhFdQyrLxeJtAoBB903aJRXoKVyBVGA4O7REjCrgBiIWrF3SyI8Zghtdof+CR1jA8t9SDvbXFqbYe75sArPXy+RVkuLjzOTUzbojuIcaeq06QlRjQ9sIsa/pCH1siJrN7yciU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300929; c=relaxed/simple;
	bh=WbOc48pJBDDfUlPeP7anR7Ynv05Vmmb383+6hK4/yFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2IDzBdnFZdE9QRcBbPMUKa7Uy8D99zhTDm/ld0zmMwQUlVwmqXzpmQksuIs7fKe/cHIjuSUIyGPPP6ZlNwDb9LNrSfKdpg3+bkLNjuCvo637E16rIBcHDMEJ+rHLUsLKVmfUrB/XfQdgVSxEheYsMPhjF1t+JC7Y9QhDBy397g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMmRRau3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMmRRau3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9460FC116D0;
	Sat, 28 Feb 2026 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300929;
	bh=WbOc48pJBDDfUlPeP7anR7Ynv05Vmmb383+6hK4/yFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMmRRau3aPB+mbxEzp0OcjqGhb7Kin66ZVIFNqqCNx9/xlDVUw3REF2l9VIglsJWo
	 +sGDIquGbpRuET/aCgF7fOvYQ+dmjvCT7ZUJbjcz4+CS3BU8TyRalMG6Ojc0Sfr4u8
	 lFKr6y4+/ZRIPgyxfX327FcgWaFBzRkd+rB2qGdY6Qbi1Gk4hc0Zic4uhoe9OtrbBt
	 MMarCFTYBAGUGyPQRNsUNn9bD1qhTexFzGoLnygVJJKsYXWUUsyhNsSXq/zSn1a3IB
	 BxOOzS/R8zjzC2nuiwBV+qc/rjWKcSRAtUQ2qO1YD77PQfFS+sy+/tRK9gj1ie2J1v
	 HJ7XVi7K8sLGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/752] rnbd-srv: Zero the rsp buffer before using it
Date: Sat, 28 Feb 2026 12:35:59 -0500
Message-ID: <20260228174750.1542406-48-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit 69d26698e4fd44935510553809007151b2fe4db5 ]

Before using the data buffer to send back the response message, zero it
completely. This prevents any stray bytes to be picked up by the client
side when there the message is exchanged between different protocol
versions.

Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 9b3fdc202e152..7eeb321d61402 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -551,6 +551,8 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
 {
 	struct block_device *bdev = file_bdev(sess_dev->bdev_file);
 
+	memset(rsp, 0, sizeof(*rsp));
+
 	rsp->hdr.type = cpu_to_le16(RNBD_MSG_OPEN_RSP);
 	rsp->device_id = cpu_to_le32(sess_dev->device_id);
 	rsp->nsectors = cpu_to_le64(bdev_nr_sectors(bdev));
@@ -657,6 +659,7 @@ static void process_msg_sess_info(struct rnbd_srv_session *srv_sess,
 
 	trace_process_msg_sess_info(srv_sess, sess_info_msg);
 
+	memset(rsp, 0, sizeof(*rsp));
 	rsp->hdr.type = cpu_to_le16(RNBD_MSG_SESS_INFO_RSP);
 	rsp->ver = srv_sess->ver;
 }
-- 
2.51.0

