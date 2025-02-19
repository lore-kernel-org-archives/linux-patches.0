Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02FD1A315E;
	Wed, 19 Feb 2025 09:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956257; cv=none; b=bggH8edyhfPdFsnVSkICYl0lLdY6dEEx4fNJUU+uY6vmrmziUwffbykWauNWmlQm0IKD6uezk3BkIBIfT9OGK2T7XRqA8JuHwyC/eEVQujeO6wt8rSFTBdADuPmuFslhNEfVTbF0kIsksX2cIyUd9Uy2FrQ/30YBTl2HsAitDto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956257; c=relaxed/simple;
	bh=8x2MxYdH6mg7uyTf8Gl77mbVN3EHwHMc4ELPNCKYAao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMQumlB6SbtWp768SXqt754D5TW1OLhKGCDlTdc6klQLNsYl0W/0kWjejh+YQmAmdqojcau75GoQFcyz0aqAfm/eOFYUuw44WvZk1exSEZ5pdgcgMOdNj4rkjQ77r62ZJevddStEqCIC/vjdSrmwn9l+ghg3J9thtJIe5gvJMIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKtBo8A9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKtBo8A9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A43C4CEE6;
	Wed, 19 Feb 2025 09:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956257;
	bh=8x2MxYdH6mg7uyTf8Gl77mbVN3EHwHMc4ELPNCKYAao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKtBo8A9FdgXdq/BcSlFJ75u5l3LWVPf/QhoR/dIDmfDo3RHGsfhJ2jhi9XqcfVYB
	 L06+4g59KPWZ185sM46NrcuiPkD65p1f6rAHtQNrA58S2bKZOa8IyDKmQ/qnkWuQt9
	 x7vKqPccu9/YAAsHm9ksHAk/ADIZ59VUJekLeOmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/578] ASoC: Intel: avs: Fix theoretical infinite loop
Date: Wed, 19 Feb 2025 09:22:03 +0100
Message-ID: <20250219082657.663948023@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index f366478a875de..c4a0b9104151e 100644
--- a/sound/soc/intel/avs/apl.c
+++ b/sound/soc/intel/avs/apl.c
@@ -112,7 +112,7 @@ static int apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	struct apl_log_buffer_layout layout;
 	void __iomem *addr, *buf;
 	size_t dump_size;
-	u16 offset = 0;
+	u32 offset = 0;
 	u8 *dump, *pos;
 
 	dump_size = AVS_FW_REGS_SIZE + msg->ext.coredump.stack_dump_size;
-- 
2.39.5



