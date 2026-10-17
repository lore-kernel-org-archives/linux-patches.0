Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC133D994;
	Sat, 17 Oct 2026 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252672; cv=none; b=SRaVYLcCjM13JXx63pcBsdeefPorkgPlSnqc8txWAvfbHbjcKbOO4oj4MNo1TlQoc9E+qrtrUhYEj8M5qZcGGqg4GbWzUK4uDIVyPk485AmLOAqjt8Ni8pme0PQ4qCXpfF1ynmuOBYMz0N5EvEZckXsqyfXKl5XhTgJ3s2Vsrxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252672; c=relaxed/simple;
	bh=1XOyhE7e35jsnaztS5BRWrYlujpjqgpo6ZKhYuvtjfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7qE4Et5Obzc27fcbQytUIKgMFRPxsf4mtirRHkAmIcoRITVBwxCNNN1wJqa6PYKxrfYzBldwiI+qmhSsSMvR6zCUbrTGV5aJnv/ApgoH5cvx/rahDnyIJDBOFCjDRGVEwVjlwSqnCD6pyFsOcU7ym6wXf1XrN6Uge+3S6dy6lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2ldxLMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2ldxLMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48671F000C4;
	Sat, 17 Oct 2026 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252671;
	bh=4f2av9FcQigK56HG/KwgUsoLD3bVtBh9oEyMpWlnBJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2ldxLMh+VOQldlIpKO24VfCGddqNGjoXutNpPCyPZjBTc096lZblrpmGtM4Hw0o9
	 Sov3mWYUE250XVXeickSoTdLDlvALAhKH4vEu6zgDTBa/oEG990maEdBB2QvoT1coB
	 m08N2ojn09A2CA9tXfGoHcQgXi+HMgS7TMMDgl3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 25/52] scsi: ufs: core: Add debug log for MCQ command timeout
Date: Sat, 17 Oct 2026 17:54:26 +0200
Message-ID: <20261017155105.664534305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 3abe4113e784b4a1135fe0e89828afecbfebf862 ]

It is difficult to debug situations where an MCQ command timeout occurs,
the corresponding CQ tag response is received, but the request is not
completed.  Add a one-line log to indicate when the CQ entry is abnormal.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260210070837.1820710-3-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8780be79a0f84..632f4522a4d63 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -314,6 +314,8 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr = 0;
+	} else {
+		dev_err(hba->dev, "Abnormal CQ entry!\n");
 	}
 }
 
-- 
2.53.0



