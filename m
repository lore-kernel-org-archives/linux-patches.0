Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A33347BD2;
	Wed,  3 Dec 2025 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778722; cv=none; b=ZuvF4QOrPZ8hXjriadywzAllnExApZALueTL+l9zkQX6vRe6oIZ+SIArcaRuh9pIr9QuAtHG1VBHSFHsP+ZvT4e3tnnocckrIxg+mijH0CYMhJe5+pAOtVa1EFjkaCxZLUOTf38qD7Hu65gtgo9OLkqWa7vM1595+kpyfW8VCqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778722; c=relaxed/simple;
	bh=Y/yYU/kiWOjAshVe7QUz+dhk23DLKeCRH/AkmCzjG30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7yWt3EJOejSEfM0B3EpoHT4wVwmXB36x4ncqldfD6lV0ANuOAeL9WLP8C7PZz2WZWk7ejjtt/ETSIn/aLFsyg77Je3MTtQFYBZ6zsBc5n2qastf3kYpSnAO9H80kVE3PHPbN4hbOYHlwhh+ftwRw2z3q8ovTHZc62560SQT//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6h8S6LK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6h8S6LK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5887CC4CEF5;
	Wed,  3 Dec 2025 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778721;
	bh=Y/yYU/kiWOjAshVe7QUz+dhk23DLKeCRH/AkmCzjG30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6h8S6LKwFneq+qGnAEU8E4oncIGK32F96rdHS17ogALgTqj3Jda34Fe08oxEQ2hW
	 WURhZfBaxH6jYBwheSFQ272jzcj38wU63GBFtudIP+vC1G2L+7QbXQf8mUCyd+M+7M
	 qKPaiIDOopcPw45VK9AHQTeZuwVuJXVQ3NOhJhZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wonkon Kim <wkon.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/568] scsi: ufs: core: Initialize value of an attribute returned by uic cmd
Date: Wed,  3 Dec 2025 16:20:42 +0100
Message-ID: <20251203152442.159319572@linuxfoundation.org>
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

From: Wonkon Kim <wkon.kim@samsung.com>

[ Upstream commit 6fe4c679dde3075cb481beb3945269bb2ef8b19a ]

If ufshcd_send_cmd() fails, *mib_val may have a garbage value. It can
get an unintended value of an attribute.

Make ufshcd_dme_get_attr() always initialize *mib_val.

Fixes: 12b4fdb4f6bc ("[SCSI] ufs: add dme configuration primitives")
Signed-off-by: Wonkon Kim <wkon.kim@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251020061539.28661-2-wkon.kim@samsung.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f9adb11067470..d78ac2817c1ff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4027,8 +4027,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			get, UIC_GET_ATTR_ID(attr_sel),
 			UFS_UIC_COMMAND_RETRIES - retries);
 
-	if (mib_val && !ret)
-		*mib_val = uic_cmd.argument3;
+	if (mib_val)
+		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
 
 	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
 	    && pwr_mode_change)
-- 
2.51.0



