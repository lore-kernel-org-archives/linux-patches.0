Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6162926FDBD;
	Tue, 11 Nov 2025 01:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823318; cv=none; b=mGhWuxhrkiXoaY1GMRxApFN/7LkG5lktZfQoXp8koA5jpihAs4ynJVsf8w8Od1N0PwIAnwe29DqERW/pXFFHTWaq3eXfVw+aZ4/W636qUO8Bgk7NNUi32FyKpEqhzaiz1hStBe77kAe+6rfbZT9olI1RwQ2zIx0u3Aabv+mMgJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823318; c=relaxed/simple;
	bh=OCm94MuMPUu6vfcFWxv2ux7o+VOzTg4tO8ZsyTDtYCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZxl2B9CH1B4FgTvnSfR3NYN1xMwJzVpdexgx6HB4dy0xHoklT26iunB7qGDD3Uqj8HavvZ46qVrpfLUpEBIAElXOw9yeQYF+26/fSHzuH7ze51Pwrk/uRs1dFOrLixtbqINfOzAv49N1ubtxt7uiEQAq0afZkt3GG/mdx8EYbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9NM+M37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9NM+M37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE674C16AAE;
	Tue, 11 Nov 2025 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823318;
	bh=OCm94MuMPUu6vfcFWxv2ux7o+VOzTg4tO8ZsyTDtYCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9NM+M371wzx7t0VQD8vOoAJ/RNIyJaJ1VB3tN9DmGJlzK2a9OFV5nwqctf5npO70
	 ++0PXR+COAr7wvOAhUgHT0bG0jNz+XfGmCSQn66+lKPmKt0mlwaqIBqEkm2a5fp7HR
	 UHSeGNdQNIHshz1nSpmL/5rzmx787X4k1vBp4VOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/565] scsi: ufs: host: mediatek: Fix invalid access in vccqx handling
Date: Tue, 11 Nov 2025 09:41:14 +0900
Message-ID: <20251111004531.826737116@linuxfoundation.org>
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
index c0106fb3792d4..2be74662f960b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1426,6 +1426,9 @@ static void ufs_mtk_vccqx_set_lpm(struct ufs_hba *hba, bool lpm)
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



