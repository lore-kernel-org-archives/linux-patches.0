Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F8038910F;
	Tue, 21 Jul 2026 18:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660167; cv=none; b=tGHXj3TQAsXuJqQEa/Bcx2LIooBcJtgjJJzFu0YHJBNgTOnWC5sFOx+k1HtXvx/eM7fRBgYzjCDrnq1beVzHOtsMje6cGzL8yPMR65t+GEMoIvmRJOtmO/fqNhEwvs8AyfiLQFQUc8g0BHRqhByn4FlmForM29Zyfvjyw4fGmfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660167; c=relaxed/simple;
	bh=/yyf4YieUYMpg3FuGCa3qEwyLIrXTpfHI/rHGxkA1O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O64V2vx/aSbpmOdrMfYJXx6YJSwggYFLLriXvSbB5jAA8PZRUgcK4UBnkEyJfiEk3yaMF/TZNEknk4JtpSae8axeUJY0UMXu94att/wwBK4qD0jM5w5k09ypzPtWtg74Y9/nhSd/NjXZ4/gFL4aJ5tci3P0QFyPDuB8kXH8UVLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbSX8K3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbSX8K3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF861F000E9;
	Tue, 21 Jul 2026 18:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660166;
	bh=qzhlldjEnZ+dkDSWoeW+gr39tocDZLTwAuEtXWVGS+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbSX8K3uy+uI0Gy9+D6wJh36Jrf5XuhO7crys9ct8rlcZstNMel2397fxT02vCpL9
	 eTXFeWyjRhfplGDV301UMK/24nmhaMx07TdMtfiMj9fLO4q72d/l4fOFoZkxQG7kj1
	 z+lf3jN3ZqXI2ueH/AL9nrYW5x7ppS7bXgOGtIkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0834/2077] staging: nvec: fix use-after-free in nvec_rx_completed()
Date: Tue, 21 Jul 2026 17:08:27 +0200
Message-ID: <20260721152612.460031648@linuxfoundation.org>
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

From: Alexandru Hossu <hossu.alexandru@gmail.com>

[ Upstream commit 26813881181deb3a32fbb59eadb2599cbe8423f6 ]

In nvec_rx_completed(), when an incomplete RX transfer is detected,
nvec_msg_free() is called to return the message back to the pool by
clearing its 'used' atomic flag. Immediately after this, the code
accesses nvec->rx->data[0] to check the message type.

Since nvec_msg_free() marks the pool slot as available via atomic_set(),
any concurrent or subsequent call to nvec_msg_alloc() could claim that
same slot and overwrite its data[] array. Reading nvec->rx->data[0] after
freeing the message is therefore a use-after-free.

Fix this by saving the message type byte before calling nvec_msg_free(),
then using the saved value for the battery quirk check.

Fixes: d6bdcf2e1019 ("staging: nvec: Add battery quirk to ignore incomplete responses")
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260427081713.3401874-2-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/nvec/nvec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 952c5a849a563d..2a3499dd4d6342 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -494,6 +494,8 @@ static void nvec_tx_completed(struct nvec_chip *nvec)
 static void nvec_rx_completed(struct nvec_chip *nvec)
 {
 	if (nvec->rx->pos != nvec_msg_size(nvec->rx)) {
+		unsigned char msg_type = nvec->rx->data[0];
+
 		dev_err(nvec->dev, "RX incomplete: Expected %u bytes, got %u\n",
 			(uint)nvec_msg_size(nvec->rx),
 			(uint)nvec->rx->pos);
@@ -502,7 +504,7 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
 		nvec->state = 0;
 
 		/* Battery quirk - Often incomplete, and likes to crash */
-		if (nvec->rx->data[0] == NVEC_BAT)
+		if (msg_type == NVEC_BAT)
 			complete(&nvec->ec_transfer);
 
 		return;
-- 
2.53.0



