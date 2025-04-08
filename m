Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC96268C79;
	Tue,  8 Apr 2025 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111935; cv=none; b=qNXgc5vBETG3bFM6n+vkCOg73P1aFzmbavQkOUT7oGEtvEkeG50aMhXQOQi7RfLS/0Mr0pcjDNs/qJP/YgQShbmwIlBBnXuhs10eon7veN4B8K9NVk2NRrQAZ/eBL0Ek9mDyCz963y+aCVxxKaRbf6IenRwIML1h/BAhPx1iEQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111935; c=relaxed/simple;
	bh=IiYJJ0ltO25jL5ssbkxBv0CVwQpyUPo3fXTzgV3In0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbLph00CWNmSov9/C9Khp4c/PQ65HeY6flanWd/+naN2s0ezjd7KbzCPzUd9+9AdhtNAvmy4vIMbmWL1mnVrd/lJLA1wFKm4NxMlS5qgf+HWu4wNDu3s9e1Diq4F4Ms3pwc3Xpv41/lsSmvWQ7IFHFU8Iu1DP7Hoq4udrqRVgTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBgtzZWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBgtzZWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8924C4CEE5;
	Tue,  8 Apr 2025 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111935;
	bh=IiYJJ0ltO25jL5ssbkxBv0CVwQpyUPo3fXTzgV3In0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBgtzZWNc3BtyRkkEr3x7FwEYV4jPA/xeaq62OtOW9HL5jKRkdwMyZHVknxebqTde
	 I1DstWB9gUVaOhbqmWkz9v9ttvN2btnxjFliti4CVpa4QmWkEUQdCxFkGkPN9AgteN
	 l/YSzR7wkP80vCM5EVKr4tT1HMzMBgRfeSeUB/Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zdenek Bouska <zdenek.bouska@siemens.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 614/731] igc: Fix TX drops in XDP ZC
Date: Tue,  8 Apr 2025 12:48:31 +0200
Message-ID: <20250408104928.554022017@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zdenek Bouska <zdenek.bouska@siemens.com>

[ Upstream commit d931cf9b38da0f533cacfe51c863a9912e67822f ]

Fixes TX frame drops in AF_XDP zero copy mode when budget < 4.
xsk_tx_peek_desc() consumed TX frame and it was ignored because of
low budget. Not even AF_XDP completion was done for dropped frames.

It can be reproduced on i226 by sending 100000x 60 B frames with
launch time set to minimal IPG (672 ns between starts of frames)
on 1Gbit/s. Always 1026 frames are not sent and are missing a
completion.

Fixes: 9acf59a752d4c ("igc: Enable TX via AF_XDP zero-copy")
Signed-off-by: Zdenek Bouska <zdenek.bouska@siemens.com>
Reviewed-by: Song Yoong Siang <yoong.siang.song@intel.com>
Reviewed-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3044392e8ded8..706dd26d4dde2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3041,7 +3041,7 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 	 * descriptors. Therefore, to be safe, we always ensure we have at least
 	 * 4 descriptors available.
 	 */
-	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget >= 4) {
+	while (budget >= 4 && xsk_tx_peek_desc(pool, &xdp_desc)) {
 		struct igc_metadata_request meta_req;
 		struct xsk_tx_metadata *meta = NULL;
 		struct igc_tx_buffer *bi;
-- 
2.39.5



