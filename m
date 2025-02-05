Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EF77E792;
	Wed,  5 Feb 2025 14:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766649; cv=none; b=lHONQ1IKZUuUUzYLUTGDocePZwsvhdDQwcRJ+yV4ZvvU981VP2EPjsLlwPsTMzIbduLLw4tAtDBUeTgu4a6R4oqlg9VO7+pNVRS2Ab8gn7F7gtohQMkfoDX7MIf8XkqBa79Wm/fWGP/UktTM2RQecnxwmBUikDVfxHeEv2VSkJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766649; c=relaxed/simple;
	bh=tfH5GPb1HRpwV56pLwRgQbSQGqAEBXD3jdpMX+edlpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGs1NDUylTd/W7VrEWSj98UP1eQL5K2uHy1Pg0aOYpHbKRNjPPRDPDWo9a+e6Pb+RRlB0zHbA6gnMsFLkN5eDaqrtJcXZGMFRfnsFvDoWSfQSv+9GJJ5NUevZbMMz7DD0fxexzSimgODF4ddsfBKQ7FpvvVK65BXdvkv2eObg3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1IYuZl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1IYuZl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B70C4CED1;
	Wed,  5 Feb 2025 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766648;
	bh=tfH5GPb1HRpwV56pLwRgQbSQGqAEBXD3jdpMX+edlpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1IYuZl6TpPxHHupP4NMpiEFXnNdXpoeg77EaeaDZkmSyj1HPVswxdCMHOByaZwRm
	 fTJMapsWtc/qMnd2e8X88qK0Si3FGLKr2QkBCo7ha6LgmRxyF+3ZRfAmBPhar87E1N
	 bOWiCaHRp2NuE7j+IxOk+2UcLf9oXbKnWsAWopC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 295/623] ASoC: Intel: avs: Fix theoretical infinite loop
Date: Wed,  5 Feb 2025 14:40:37 +0100
Message-ID: <20250205134507.516841044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 27516ef571859..d443fe8d51aee 100644
--- a/sound/soc/intel/avs/apl.c
+++ b/sound/soc/intel/avs/apl.c
@@ -125,7 +125,7 @@ int avs_apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	struct avs_apl_log_buffer_layout layout;
 	void __iomem *addr, *buf;
 	size_t dump_size;
-	u16 offset = 0;
+	u32 offset = 0;
 	u8 *dump, *pos;
 
 	dump_size = AVS_FW_REGS_SIZE + msg->ext.coredump.stack_dump_size;
-- 
2.39.5



