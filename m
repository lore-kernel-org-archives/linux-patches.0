Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA3E27D786;
	Tue, 11 Nov 2025 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823475; cv=none; b=NKCSIQjxwX+OXPcjlHn5r0sdhn+VkVOYQS20fEjKhcYsp81KR607rYFtszm7GswIYaraiPnIxakf6vTfjgM675Dw05aQfAF8hquBj45Sd/FwlTSvS2u3mE9N1ODVrsg44GD7VCwnFqNK9mjO5ebs6i5AM3jvGrchJzNMbb+5Wqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823475; c=relaxed/simple;
	bh=PF22k3YWnVQrq4Hw4mJzqhLmcW5j2FTzuMIEUMTvJAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7QN4++j8DrtDmeJRiliUcVFHUwUrXKf+f7VwrMVGSuW7lUG3DgzdG4zdALJuJbk9vvt6ynLwMJQDjZ7NuSAQVE7qpQHqGpb1yc5z/0xCQViJRdv4wu7Pw0ZjabfP/v5DdxrHm8jBF81m1RsS6EPiRaSRU638PlhzNneToMWNGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17i7SuO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17i7SuO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB0DC4CEF5;
	Tue, 11 Nov 2025 01:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823475;
	bh=PF22k3YWnVQrq4Hw4mJzqhLmcW5j2FTzuMIEUMTvJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17i7SuO54QTe6wBw1jznVIqt5PvYV3ybPrXXmALyzDYaNdjx0RoeEe3sVHBekgHTQ
	 GRqjhyFV12pX5mITlpGq52W8nMfyrXYbhYuL/gGWtB61mhrQzAtWG33iLk/cmecBBT
	 9XZyHRtyjso5O/puycBgw7UjPCSvcnWzO5LBKRRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 307/849] scsi: ufs: host: mediatek: Fix invalid access in vccqx handling
Date: Tue, 11 Nov 2025 09:37:57 +0900
Message-ID: <20251111004543.834777790@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 82160da8ec71b..bb0be6bed1bca 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1589,6 +1589,9 @@ static void ufs_mtk_vccqx_set_lpm(struct ufs_hba *hba, bool lpm)
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



