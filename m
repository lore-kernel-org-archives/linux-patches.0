Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B9A15696E;
	Wed,  5 Feb 2025 14:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764547; cv=none; b=RDMK8/rkLaII0sGsKpzaf7Wqb4VHfXWGX/w1SF0qT9XWp8usT8Uqn2Be3tIVP/SzMCiwtb3jF8aynoKWfPfkeifqjhGtpldIBB1OEu1qaRLzCVI4xkeO69POHedW2+eGeeC/2f+rGkTGs22GFGxUYVExre/dKhfd54mEoyIGJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764547; c=relaxed/simple;
	bh=GTWUcBaJxJKTSKAyjTRZXrtolO+Li3cvD85mDrHyCGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0oVLsVQEzzKi0LPLJaBVDAzJlsWM069ubW4H/rMQiv1MtgqZMhNVPj7/J84723R/BMP4/n4etintxA2aMhpbSctgis0pgUUlkUXRwf6zn5HX/s7tvJ9pMNothE+r58rnnGXms+iWem9WG23PCTz6ex+pIFNB4/RQMiEDMTXHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQehPkeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQehPkeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CF7C4CED6;
	Wed,  5 Feb 2025 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764547;
	bh=GTWUcBaJxJKTSKAyjTRZXrtolO+Li3cvD85mDrHyCGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQehPkeumHeTnWdo7oDwRClkwG+OQq03NaSOsqXAgV6WEw/zmc0hy8KywpDNwpPf8
	 JrYhZ4qjiBP5j0TgH+uXjQ0/Prart1AaTcBk1mJX/PSRd6qePxQfqto9Z5hC8VntTG
	 D669Zj73I/jUy28VcRq0trznMAX7MJvOnCc5gfSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/393] ASoC: Intel: avs: Fix theoretical infinite loop
Date: Wed,  5 Feb 2025 14:41:40 +0100
Message-ID: <20250205134427.226238322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit cf4d74256fe103ece7b2647550e6c063048e5682 ]

While 'stack_dump_size' is a u32 bitfield of 16 bits, u32 has a bigger
upper bound than the type u16 of loop counter 'offset' what in theory
may lead to infinite loop condition.

Found out by Coverity static analyzer.

Fixes: c8c960c10971 ("ASoC: Intel: avs: APL-based platforms support")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250109122216.3667847-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/apl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/apl.c b/sound/soc/intel/avs/apl.c
index 24c06568b3e82..25c389632db4f 100644
--- a/sound/soc/intel/avs/apl.c
+++ b/sound/soc/intel/avs/apl.c
@@ -107,7 +107,7 @@ static int avs_apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	struct avs_apl_log_buffer_layout layout;
 	void __iomem *addr, *buf;
 	size_t dump_size;
-	u16 offset = 0;
+	u32 offset = 0;
 	u8 *dump, *pos;
 
 	dump_size = AVS_FW_REGS_SIZE + msg->ext.coredump.stack_dump_size;
-- 
2.39.5



