Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6164C97;
	Tue, 11 Nov 2025 00:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822167; cv=none; b=BJBv4BatPd7csTUS3P83u3iIDC7XIaxa0grzjTjFLgzwidZmLmOYE2+5hh7b70AeUWdeoTqYvWIeLlCd+50Rycq8jx45GtHKteteeLHV1MedDgCpQtACS4qiqQcAYNJvzwfzzZIt/5vLN2j87D5esh38/nb2+SbDtP3FQeYmCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822167; c=relaxed/simple;
	bh=JoKmNx7nyqhRhwCQMeGr0BVSmYoHr3VCMFZCU8UIVME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vg3O6Agbs07Is1NfOMTnxtHorO35f6L3DW/znbmfHEm2R5pIPcWqPZdWryGUx/Qezh3MN2HqmZnOlqvmY6ZnA5e9g4kVQdtpTQEAB+Z7K/QiDmoW/rlLlVcwvFRtsfSD2JKrjwfwG/40fN2Ff9yYVNB0pvzYsFrGmscR/ygl/BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOWObdPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOWObdPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E10C116B1;
	Tue, 11 Nov 2025 00:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822167;
	bh=JoKmNx7nyqhRhwCQMeGr0BVSmYoHr3VCMFZCU8UIVME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOWObdPnM6tHoyNggms9Oi4itTUZXmZ1811fWTyw2IvqO1QnSOIvw9yJqdwYeVMqU
	 cp+i6l8lfE9xbnzjok5b+0w2YQTRB5odl8mbP/DYG+W6rQ8bSFaeCfYvYlbjCpveo0
	 6hycFarIxM37Xovjbj20PZ0VCfZdwoqg06DIbdaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wonkon Kim <wkon.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 044/849] scsi: ufs: core: Initialize value of an attribute returned by uic cmd
Date: Tue, 11 Nov 2025 09:33:34 +0900
Message-ID: <20251111004537.505303219@linuxfoundation.org>
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
index 465e66dbe08e8..52f2c599a348e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4278,8 +4278,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
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



