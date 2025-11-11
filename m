Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C627253944;
	Tue, 11 Nov 2025 01:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823026; cv=none; b=MTxLtFKgR0e/izm8/YFRCXPXFkhYvk4RgZqqB2hsCdmTkmB+1Ncn/QKhGf6oICmuyUDuNcRZWv5HWSOiMx9fvSbum0fptMPke6q1hzAe0DXLChmb9CQYcIhc5vPQMkzj2Tpv627abQBG+SJJIECkTUb5pTipoXi5pFv+BSkOuwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823026; c=relaxed/simple;
	bh=LqwF9DlP2ZhRrf1nMYJQLyDl05H3CdeuzG0OYTn171s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/Oo42A6oSg04WCwKCDZd3myeBfWfsC4tMbvToqKycBOZ6Xsm2STFREPZEdZn34Arq8Z28G9qajJtBBdrZFkfgk9Rk5+M/pReLQm/hvM8t4un4JN+5zpR5avZ02kCQsoNa5TdrvGJfkmdboiLW/4GB8Kykv6cVn6r718/RVanQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yb7q3pCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yb7q3pCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D30C4AF0B;
	Tue, 11 Nov 2025 01:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823025;
	bh=LqwF9DlP2ZhRrf1nMYJQLyDl05H3CdeuzG0OYTn171s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yb7q3pCQRDn9deKDVByzhqiEvgLecGhgqWuW0lmFSEN1e8QTOOwbstAYBpI8z9/lM
	 8VKANRuyhNaziC+hs94+9Sz2WObI46gCjDkT/INb5hrpuQLpsroZhygOlaR/MnnN64
	 bsWEm/7mrjEJ96LCq2iVIXA46u4ltHq+bSvPg4AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/565] nvme: Use non zero KATO for persistent discovery connections
Date: Tue, 11 Nov 2025 09:40:13 +0900
Message-ID: <20251111004530.470222206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 2e482655019ab6fcfe8865b62432c6d03f0b5f80 ]

The NVMe Base Specification 2.1 states that:

"""
A host requests an explicit persistent connection ... by specifying a
non-zero Keep Alive Timer value in the Connect command.
"""

As such if we are starting a persistent connection to a discovery
controller and the KATO is currently 0 we need to update KATO to a non
zero value to avoid continuous timeouts on the target.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 24d82d35041b5..a3b9f8ea235f7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4740,8 +4740,14 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	 * checking that they started once before, hence are reconnecting back.
 	 */
 	if (test_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags) &&
-	    nvme_discovery_ctrl(ctrl))
+	    nvme_discovery_ctrl(ctrl)) {
+		if (!ctrl->kato) {
+			nvme_stop_keep_alive(ctrl);
+			ctrl->kato = NVME_DEFAULT_KATO;
+			nvme_start_keep_alive(ctrl);
+		}
 		nvme_change_uevent(ctrl, "NVME_EVENT=rediscover");
+	}
 
 	if (ctrl->queue_count > 1) {
 		nvme_queue_scan(ctrl);
-- 
2.51.0



