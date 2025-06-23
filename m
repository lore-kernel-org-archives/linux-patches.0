Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5A21E8324;
	Mon, 23 Jun 2025 21:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713224; cv=none; b=fLM7KGcLfhV2O99AR8p8BzjbrkbN42Era1DKab/6ajhLpLZgZE4Tl6Bavi07TdXMJCA5bhGkjHKIaGwonRE2eZX3FNnweeGmDQTpwEgoqOmVsJY7axlbWuRrXo7WR2OF9dyf7UpBF/HWLOWXRTblF3VtyFNStR3IReh0bvJ+bYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713224; c=relaxed/simple;
	bh=+ZxXixCWLG6z8YaeM0RvkH7lChm2bNiBOHpS+A8qLxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmQEzl3Tn88DrVB728Ys5AvhpMob0/TmSueRJzH/HmbmjvU/0wdQDftZaWSc2jI7UgynP1+73XeAdJulN57kVSFz4oYt8SPzXGxnHmFSWyBKRgn0ppX263bbMUTbat1z5tbeq1vSFPLsTIRVBctz1+g1hnPox85OUQ705DUbchI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaxYSeqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaxYSeqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E69C4CEEA;
	Mon, 23 Jun 2025 21:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713224;
	bh=+ZxXixCWLG6z8YaeM0RvkH7lChm2bNiBOHpS+A8qLxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaxYSeqI1Ijt7QqD+5Sh1iZOKkQv9cy4sGDi0J8KS7sdPFXdkYAREO5XE4qIkSOxv
	 jLyOXuJWDxQz6CKF8vS2ff/YxPN9zTUThdvf4i6jVDiBXBojn/8eEgCWqg71mz1e0g
	 mwLGBqbPInnwVs8PMEUKRq5vVIH6oNBNs0C8FvJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/222] scsi: lpfc: Use memcpy() for BIOS version
Date: Mon, 23 Jun 2025 15:08:30 +0200
Message-ID: <20250623130617.330789825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit ae82eaf4aeea060bb736c3e20c0568b67c701d7d ]

The strlcat() with FORTIFY support is triggering a panic because it
thinks the target buffer will overflow although the correct target
buffer size is passed in.

Anyway, instead of memset() with 0 followed by a strlcat(), just use
memcpy() and ensure that the resulting buffer is NULL terminated.

BIOSVersion is only used for the lpfc_printf_log() which expects a
properly terminated string.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Link: https://lore.kernel.org/r/20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 04b9a94f2f5e5..e1ef28d9a89e9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5407,9 +5407,9 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
 	phba->sli4_hba.lnk_info.lnk_no =
 		bf_get(lpfc_cntl_attr_lnk_numb, cntl_attr);
 
-	memset(phba->BIOSVersion, 0, sizeof(phba->BIOSVersion));
-	strlcat(phba->BIOSVersion, (char *)cntl_attr->bios_ver_str,
+	memcpy(phba->BIOSVersion, cntl_attr->bios_ver_str,
 		sizeof(phba->BIOSVersion));
+	phba->BIOSVersion[sizeof(phba->BIOSVersion) - 1] = '\0';
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"3086 lnk_type:%d, lnk_numb:%d, bios_ver:%s\n",
-- 
2.39.5



