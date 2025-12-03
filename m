Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B92A3451D7;
	Wed,  3 Dec 2025 16:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779102; cv=none; b=Uh/gnrUzOrDaWh17vXC6QsySFwC6QXOhJ4z6tleuCzdUgqXG7emX0eh5ZnMiSxqbI3PURUvJMHHgrbN2GNStZvtWwOxyqT2YHgJzxFJvPiFrECZgwGMj6Vqk5yB8UK/A4mTcV35cuz3ahBctLi1z+IMfyjGvxKZhzTKxHbNxoVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779102; c=relaxed/simple;
	bh=AhwrgmEZd3jJflDfx+KDkjzpDSjZIx6uMijD0qvIFX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyaD030yWpx1Sb09HqLrnxnpt9XU/kOxN2jCoEIE0j5Fyz/W8cdOrMbubkvkGa4A+MM8tULLuZQS9ei318DkKQzXfdGU2zj1GAW6FS0FBorBCo5sNs+57WkrHTPAlLFHp8Qwo+m38PayffjMgh3T/t4cDuaa2TXw8IlaNHEwizI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPskPfP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPskPfP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA56C4CEF5;
	Wed,  3 Dec 2025 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779102;
	bh=AhwrgmEZd3jJflDfx+KDkjzpDSjZIx6uMijD0qvIFX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPskPfP/lsjrh0gOAA4ViiY6/1kkeV7WGHhzBocQme4MBdMPncEbQ3CgNwr8rylp/
	 kC9adQTi+Js6HSWCXSVGyo0+DSdsg2dnALiJ4/YL+UlFinGQWmrcIIggIKNa2SVhef
	 w46JweNpvPFpEKd05Tret3PdH94bITvi8BN1zCLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/568] scsi: ufs: host: mediatek: Fix invalid access in vccqx handling
Date: Wed,  3 Dec 2025 16:22:38 +0100
Message-ID: <20251203152446.440422667@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Chao <alice.chao@mediatek.com>

[ Upstream commit 5863638598f5e4f64d2f85b03f376383ca1f2ab7 ]

Add a NULL check before accessing the 'vccqx' pointer to prevent invalid
memory access. This ensures that the function safely handles cases where
'vccq' and 'vccq2' are not initialized, improving the robustness of the
power management code.

Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250811131423.3444014-11-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index df17e6d606ded..1c6348ee58092 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1230,6 +1230,9 @@ static void ufs_mtk_vccqx_set_lpm(struct ufs_hba *hba, bool lpm)
 {
 	struct ufs_vreg *vccqx = NULL;
 
+	if (!hba->vreg_info.vccq && !hba->vreg_info.vccq2)
+		return;
+
 	if (hba->vreg_info.vccq)
 		vccqx = hba->vreg_info.vccq;
 	else
-- 
2.51.0



