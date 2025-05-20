Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D22246773;
	Tue, 20 May 2025 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750162; cv=none; b=R/K5WpX4dw1atKfJqd3aqZB90OEaf6g08qJuHofmJ9AF7YJPEW6zr9peR91+IeSD+SZTXYk/vgseylL5hiaQ2YNJY76M5WfgTmYUK0/E8x+Na5QOrfygivrH02zQ1DBx7Qqitw3vApRS6/B2Ci2p58KdR68mXIyEyclrTGmf6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750162; c=relaxed/simple;
	bh=YsR3nBS630w788QaFwQDJKRja/zYTzXGgQBtq0pVew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1EI8/rq4bKgd5013atIJhRmzeibg7/gVBy7Q3f7EkcQVkPXoErTkrWTircOHurczRM0ZnsOsidxQ3AuZzmBHalLCwQ3bAPXoSwnA5Z39JncQTk90AmHl/WAUSn96m7RwlbSa0LQip/yBWcfhL8V5JhcKVsfEM2tA9UiwW41gO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svq3Sl4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svq3Sl4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE58AC4CEEB;
	Tue, 20 May 2025 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750162;
	bh=YsR3nBS630w788QaFwQDJKRja/zYTzXGgQBtq0pVew8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svq3Sl4HhMGbMiOQJe39CNUIxbbeCe3YqUYHRQ7q7ffS+Jbp1N3UJ6738OzYqs1EO
	 fBm8KAiHtBRhkNECCAwHcJQewVrrxi2I5TCIvM2l4Y4ZutzUs8uX4HxuBltslMkJEO
	 3+y9WDkzmQxpkpKySlTN5Jii2daT9P7acGZto1EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/143] octeontx2-af: Fix CGX Receive counters
Date: Tue, 20 May 2025 15:50:17 +0200
Message-ID: <20250520125812.492929301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit bf449f35e77fd44017abf991fac1f9ab7705bbe0 ]

Each CGX block supports 4 logical MACs (LMACS). Receive
counters CGX_CMR_RX_STAT0-8 are per LMAC and CGX_CMR_RX_STAT9-12
are per CGX.

Due a bug in previous patch, stale Per CGX counters values observed.

Fixes: 66208910e57a ("octeontx2-af: Support to retrieve CGX LMAC stats")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20250513071554.728922-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 8216f843a7cd5..e43c4608d3ba3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -707,6 +707,11 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
+
+	/* pass lmac as 0 for CGX_CMR_RX_STAT9-12 */
+	if (idx >= CGX_RX_STAT_GLOBAL_INDEX)
+		lmac_id = 0;
+
 	*rx_stat =  cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT0 + (idx * 8));
 	return 0;
 }
-- 
2.39.5



