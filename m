Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827C324E000;
	Tue, 29 Apr 2025 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945881; cv=none; b=XYQYCExhoc25kyDniUfAMVJYuqai0yEZK/glk24ApIA8Oa/17f5y4WE1IYWJigmMlUb4w/iH1n/XNG3owVZv2Go6ERa/LSNOddbTSgNko2c1j03uAv/RnrTPPbeYf28rNXuj3vbeR016SPI51X9/anm6LENGNvO55x2PlpkQa+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945881; c=relaxed/simple;
	bh=voHCXKiJim7djPRlwbyhyUhc31BbdBFmkwpbV2IIG34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlZtW21lfB3miC8r0e2ce1rRYaMyaO/7zqwfs+a7apfj3o0dtzzZVeHKM9z/e0XVvwet9x4jn9f3AU+McBs2i6PBnNsRzK+GZYyN1RbL/0ziRhnADTjDGGy9aFL7IeitBYtKV8Zb3XKV0tEdZWDwi723p7feQ8oSEFvxYVneSHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WomPLyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WomPLyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB30C4CEE9;
	Tue, 29 Apr 2025 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945881;
	bh=voHCXKiJim7djPRlwbyhyUhc31BbdBFmkwpbV2IIG34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WomPLyCeDwJMN9DFO4J4+TJKKcsyhojaeYgMpAB2UxhpHrR9vaAMS+8nuXUCeZSR
	 cv6+6EE3SKaBBXzHYVHoxcqFtcVaOpGsfVN5MyXp6VDO+YiVKZMuPWYIg8bLs3gBnM
	 Y+8EvMHAreqos3rhK/7w6KLgC/Qv769a9HZ4MGEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 053/311] scsi: ufs: core: Add NULL check in ufshcd_mcq_compl_pending_transfer()
Date: Tue, 29 Apr 2025 18:38:10 +0200
Message-ID: <20250429161123.212357893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 08a966a917fe3d92150fa3cc15793ad5e57051eb ]

Add a NULL check for the returned hwq pointer by ufshcd_mcq_req_to_hwq().

This is similar to the fix in commit 74736103fb41 ("scsi: ufs: core: Fix
ufshcd_abort_one racing issue").

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250412195909.315418-1-chenyuan0y@gmail.com
Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 464f13da259aa..128e35a848b7b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5658,6 +5658,8 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 			continue;
 
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+		if (!hwq)
+			continue;
 
 		if (force_compl) {
 			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-- 
2.39.5



