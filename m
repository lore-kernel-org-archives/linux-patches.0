Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B22A1E489;
	Tue,  8 Apr 2025 12:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115922; cv=none; b=Ihzberxx26AvTJR9CIdr/QdbfYeSRd0bGtqLEhNUQigX/KkU1Vsx0dkyXudb9/jTVlqGzGWg/N9Y+8xrFERAS/BJ7icHgv/ez4OhN/gLUeBleTUhq+cDpB2UVsXnljilwFKhMdoRId/YxWsY5f3UWxn6Sfp7StwWIfjBd4MzxGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115922; c=relaxed/simple;
	bh=w7Tph13PZEm5SOg1s9IaPMQjV66DQqLW4A/7Fs54wQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAeOWQ72xm4l4QGyBJ2tgCkGPp5A/0EQu5XpP1ya3pJx7HM/rNsGaf+W8RNw0kIKrl1SFqRIbIwnGUv7jFhpDtYt57L0WvBF1+gVeTlNFZ1oWVz6w4IvumsC7mwTZwiAvUdyyQrjDDDzur1kIREYYd2+9rEKLPc1lo1LoAr4ypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C002X7Qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C002X7Qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2FEC4CEE5;
	Tue,  8 Apr 2025 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115922;
	bh=w7Tph13PZEm5SOg1s9IaPMQjV66DQqLW4A/7Fs54wQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C002X7QyUOG52fQ20yTVJ/NT8eM53Nw46OpvoChP+QQDPn+xUH54OZj+YGdzZ8p/D
	 yf3RVjlPn5G+mjzCsrd+u6EWJKsOVOsHeLAJH5cZNtdyS3Z9S9b+CjK8Fww2pgfTVb
	 KrYBPCE3RAyXSzDb4NvApazFpykn4PbAH7vdxeDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/204] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:51:23 +0200
Message-ID: <20250408104824.796004963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 8144e9c8f30fb23bb736a5d24d5c9d46965563c4 ]

Make sure we are not using DB's which were remapped for link status.

Fixes: f6e51c354b60 ("ntb: intel: split out the gen3 code")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen3.c b/drivers/ntb/hw/intel/ntb_hw_gen3.c
index ffcfc3e02c353..a5aa96a31f4a6 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen3.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen3.c
@@ -215,6 +215,9 @@ static int gen3_init_ntb(struct intel_ntb_dev *ndev)
 	}
 
 	ndev->db_valid_mask = BIT_ULL(ndev->db_count) - 1;
+	/* Make sure we are not using DB's used for link status */
+	if (ndev->hwerr_flags & NTB_HWERR_MSIX_VECTOR32_BAD)
+		ndev->db_valid_mask &= ~ndev->db_link_mask;
 
 	ndev->reg->db_iowrite(ndev->db_valid_mask,
 			      ndev->self_mmio +
-- 
2.39.5



