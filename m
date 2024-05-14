Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4E138FA3;
	Tue, 14 May 2024 10:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682677; cv=none; b=qqcwXmZjbUIsCYlJZzieZ5rSbK3EZOivMNQ5q5xjJZB2Fd/jpi8FMJPUvNi5ujFOXDFANhca5TRc3HwQM2Z3LXrlZeqEpV9jmV0FzJkqZzpQh7KJX0fShvaV37akf/uD/E5qZeR3fej1VqppCc4TIWG0HY/kGKafovAFwsZK2Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682677; c=relaxed/simple;
	bh=6D13qjhVCI3xL6BWtKCpA3v5DRl192vJV1MAGJI6OIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sn361zikfLDaljC+Gqt5Us5Sfn8nO5LUwF+NRRKS2Aa6hnotnAdntkR5widcEx3TDOAAOSbdhSFYhGL4uDKXnenVbpAoAMsavSIqNiwEgW4k9Zs+CjjMDGVr2ERtZXDC8isCJq0e3AgjdAn2uGJNS9Z0VYPTWndBcW94ezLBkZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvmYVl7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvmYVl7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A4EC2BD10;
	Tue, 14 May 2024 10:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682677;
	bh=6D13qjhVCI3xL6BWtKCpA3v5DRl192vJV1MAGJI6OIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvmYVl7eYkE7TsXUtDecb5ftotqhCMGk6M3tUZPHaInG7zcY6wohqkiQ3Es2Fz/9z
	 E7lqw9MOMWR4BZx5HcChJDAqCyMDCg17/UMt9kaT5QrHNFpYlY+hbitJ05MyM2I2ie
	 J/6ZbMoGZa7dd0cAr9qgFkLbViixYKQmxH02aFMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Ner <rohitner@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 096/336] scsi: ufs: core: Fix MCQ MAC configuration
Date: Tue, 14 May 2024 12:15:00 +0200
Message-ID: <20240514101042.229840630@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohit Ner <rohitner@google.com>

[ Upstream commit 767712f91de76abd22a45184e6e3440120b8bfce ]

As per JEDEC Standard No. 223E Section 5.9.2, the max # active commands
value programmed by the host sw in MCQConfig.MAC should be one less than
the actual value.

Signed-off-by: Rohit Ner <rohitner@google.com>
Link: https://lore.kernel.org/r/20240220095637.2900067-1-rohitner@google.com
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 0787456c2b892..c873fd8239427 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -94,7 +94,7 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds)
 
 	val = ufshcd_readl(hba, REG_UFS_MCQ_CFG);
 	val &= ~MCQ_CFG_MAC_MASK;
-	val |= FIELD_PREP(MCQ_CFG_MAC_MASK, max_active_cmds);
+	val |= FIELD_PREP(MCQ_CFG_MAC_MASK, max_active_cmds - 1);
 	ufshcd_writel(hba, val, REG_UFS_MCQ_CFG);
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_config_mac);
-- 
2.43.0



