Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E344434D93A;
	Fri, 21 Nov 2025 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732505; cv=none; b=lyiUuq8GnTlouC3sBGFmLUl2Jl+Q80V7OhG1tO83oifE/96jKq9l5F9eDTFccNyd/vNsDnlif3bdkgIguZiueWhMaBuC8v4q97KyE6oU6ukpUOSUQZveJ8rhmqy1+ti48aCrdmj3kqIRY031KkUtSwZdNljxpsVSi9fBLRFj4tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732505; c=relaxed/simple;
	bh=eWTvKtWDANx5n63SbhdLxM29vsZnKRn6xcdTLlNS2Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxc2pwGbvGOxed62S2vIOreNxMEN6oNh1vF2ES13TuEyv9YZGkrjgGqNoxysSZ1fAbunRHxCs4dKGZBubet7/3hUWwn2FyYYFzGr0/4xQ2krcxDKZWvMErnJCZLAZmIjaWWsbPwaF7K7mrnubd99MhYD7dN9u0ecpnj4AqjfD28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvKBgwSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvKBgwSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EC6C4CEF1;
	Fri, 21 Nov 2025 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732504;
	bh=eWTvKtWDANx5n63SbhdLxM29vsZnKRn6xcdTLlNS2Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvKBgwSbhYEJpo/WbGqXCQKLGEgfvqAdzO294Db7xYMm3FIucbA17oL2p78Esoi30
	 /+22z6LEHqz7NJyhdhvTqj+l3Yb3JxWpBUmOU/HHv50A6YySOUNVfX44o0oPVDc2JQ
	 ORuwr6CIrhtN6eaP+7u5Gzhssw7Yi0p8JNi6Q5cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/529] scsi: ufs: host: mediatek: Fix invalid access in vccqx handling
Date: Fri, 21 Nov 2025 14:07:24 +0100
Message-ID: <20251121130236.176072687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 90a698f8a082e..7ede6531bf40c 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1316,6 +1316,9 @@ static void ufs_mtk_vccqx_set_lpm(struct ufs_hba *hba, bool lpm)
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



