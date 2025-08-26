Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3069533A03C;
	Tue, 26 Aug 2025 11:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208008; cv=none; b=spylvB0YYuezXEjAtiihTgpTOed6mNO7NnvHqdPbXwnmGZD4XplukNVHKiYFxSy52CshgVTIOr/zXJwIQ6U8N4y/Afb90PQHulmyiW9Mzo8fd6hSd094nJ/S2JSBcnf0VYvNDfT6qvTyeSKdjYQmGi1T/+svg89L4Y0Ot0OxEDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208008; c=relaxed/simple;
	bh=NTcwTXBkeUVz/GWS+FeBB5W3i+jr+KP4XDNRG/FQ7jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzZSnSLZ6mToD79nfMxh9SYToY2Xe0H8qz/EyHWKE7g7NcTz5wOCJQSrPQZkxu8+PFViPNnNAhAzdGrgjgDlxe0o02uKU7UQivVVguGYdk0LlANEGiFj2L8CHTtRUoERbQTk+viIUfvseesj4xsYlU636i1S0jPP7dpWAjAamlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdnLnVqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdnLnVqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709F0C4CEF1;
	Tue, 26 Aug 2025 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208007;
	bh=NTcwTXBkeUVz/GWS+FeBB5W3i+jr+KP4XDNRG/FQ7jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdnLnVqmmV0zHOuqkovFyPqIabyf95v4k0kcvKkCBm36ofhrZgtEKGoy3quo+pQ/w
	 tJxDsGIStssbgu5MZFU7DUtHpwmID3ydOdhuBeyh6N2aSo0xSA1trI/PKQuSFHZbwl
	 nkdMGLf8yjybVwYEXmdbPTWuZHenIi3dju9h2oO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 402/457] scsi: ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
Date: Tue, 26 Aug 2025 13:11:26 +0200
Message-ID: <20250826110947.230165558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e5203d89d59bfcbe1f348aa0d2dc4449a8ba644c ]

The UIC completion interrupt may be disabled while an UIC command is
being processed. When the UIC completion interrupt is reenabled, an UIC
interrupt is triggered and the WARN_ON_ONCE(!cmd) statement is hit.
Hence this patch that removes this kernel warning.

Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250815155842.472867-3-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f2eeb82ffa9b..5224a2145402 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5533,7 +5533,7 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 
 	guard(spinlock_irqsave)(hba->host->host_lock);
 	cmd = hba->active_uic_cmd;
-	if (WARN_ON_ONCE(!cmd))
+	if (!cmd)
 		goto unlock;
 
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-- 
2.50.1



