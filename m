Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21852151988;
	Wed,  5 Feb 2025 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766231; cv=none; b=OmcCErB+unJaGElt+irHfWcK0DZdSC3RLW44sMTOaxUZ1A0pzmKQodyZ6ZIl9b0oGW0uuBnO9I/eMDcqDsKCVoUR7WPIZ2ODUJ/bMVdIKCQduN9eN0ZBA5RCJPjQ0gmL0kRItmo5xkoNx03qLyQnPQ+iqqGAgMxo9dcs3GgbHic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766231; c=relaxed/simple;
	bh=6dKbylZiir/mVSo2Y/IhZK9M64402ymhy9w2JiFklh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9iBa+TOKLc5ro7L/eSw9jl6Lqkbzn/uPqldaaHZh0Mnb7EKK2Hu50x/lT8bfsaeC5U0aOrDxFTI/2RnKgNlndLI8yXOaCEfoS+mMwsjt6CGDmlaui9/pm9inx5lLsAw/Ao4ED3D0IX5G2+Okh4N7cVdGfruyvUIlZTVZSNFGno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gq4n59nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gq4n59nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8536EC4CED1;
	Wed,  5 Feb 2025 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766231;
	bh=6dKbylZiir/mVSo2Y/IhZK9M64402ymhy9w2JiFklh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gq4n59nxVH2w19lnPfNZrtRVRe5UOuB74ZdY1t498AdtaQ3G5+63RhjNCfk5ixx/y
	 eX5ieQxmpVCPfem9jzCVQxebePdJ+BPH/b9pslJ4+RnR0kZlz7ORFPgSJzVDspY3Jw
	 cEwUN47WgcQkeUW4mwZbTNU/ixQceoti9XolJGGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/590] ASoC: Intel: avs: Fix theoretical infinite loop
Date: Wed,  5 Feb 2025 14:40:30 +0100
Message-ID: <20250205134505.797280915@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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



