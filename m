Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBA74C97;
	Tue, 11 Nov 2025 00:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822346; cv=none; b=DvbskjSNsTJVNhVZJcu5cv7UsPEYJ0lE5OgBxX4GyGzJXEX6QkgiGrfNHN5QYDx/UuKsGpKmPRysP1rltIvaWlB4pR1a2yLE92ESSzBpHzzaQ0hN8gl4g4qEs92bOPQN1bshRrhnAeKS84I/iZdLLtJp4vKv3CNH02IYMG8K3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822346; c=relaxed/simple;
	bh=ctH3c9NWbs4wbOebTH70URlVGvX47XVcpEuWJ7EjE38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipzzZoCFATm22whyXA3QnZGw2s8Yux0NAqPoj6LWV1bSSOd/OerZvJGhCP5iiW4XQ8CBr0IA+9IOsBGM6sbR43K+EknCQlYeADlRObgtZqf48ELmiZ59YzeA7Rz6uwWxKgVxAWaou4lO2IguYQm2CyKQXbHqwF/fQ7dKgSyO67Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1tAw2ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1tAw2ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D070C4CEF5;
	Tue, 11 Nov 2025 00:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822345;
	bh=ctH3c9NWbs4wbOebTH70URlVGvX47XVcpEuWJ7EjE38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1tAw2qlieR8g55r4lvOUvSuVTn9R+e/RZYLyvcqYC1qGIk1QkjIPAGRFAXRSRvsO
	 53OCbIb0agxsD7Hy/AOUZJ9dr1/It3XQtvmKCJIebHVPcYJmbMtZzFnXQr4N6A1kW1
	 k1+GcbuQ2BwlSSTPzLetGvQKbVGu0SVim2FyhzQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wonkon Kim <wkon.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/565] scsi: ufs: core: Initialize value of an attribute returned by uic cmd
Date: Tue, 11 Nov 2025 09:38:07 +0900
Message-ID: <20251111004527.583602158@linuxfoundation.org>
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
index e079cb5d9ec69..2d07902ce7f1b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4239,8 +4239,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
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



