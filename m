Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7220421B8F6;
	Mon, 23 Jun 2025 22:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716571; cv=none; b=hrhfv0tJjg/JopWt8chMB7rLjDnPP5fcVp36L8yG7vHjFDlHRPTuNYqpGzOl2WzRI/vZ9ISp0diFUNiBV9pqWUZJgvzVIBGjvbuHpZuX71s9sju66Bu4AqzAnxEHFvnTyzbvCVNKQh03ZjK/OWvzcbqyWf76zUrLe1xrAYnif74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716571; c=relaxed/simple;
	bh=jHBtBRDzmVT/Rzh9HbsYzgf+fJ9wGaCHWbZztLJ5AC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KckW1uHUiDz7yAQxTW5CXjMKXNL/fpbQqnbnjPiaH7XTuOAKvGLSh9cGy5ryFdshfI/itJ3Fd22yXb9mSD19i4zOzzxcG65wTBeqbn9iUf9R6xXSZ25Erk3nUt5igrDfBy8Ie3b/eOmwcBtJl/O/mkLWpFleBw+F8kIC7SQv4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DccZCozz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DccZCozz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E60C4CEEA;
	Mon, 23 Jun 2025 22:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716571;
	bh=jHBtBRDzmVT/Rzh9HbsYzgf+fJ9wGaCHWbZztLJ5AC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DccZCozzzGp0qaMA4hK4g/sLFAhRuFf8wEnpkgfCYe7Z+yvHspa5hAxSJfyvilUq1
	 ncd5KUkQ+qRyOp79PB+cU93PSHspwK6RS2O0nblyAbTx4CLCkX8ta9B2+v2r9L0xwf
	 yoiMnezJto3HEangLBCMSRyagHz0bZMVTkfWEFSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/414] scsi: lpfc: Use memcpy() for BIOS version
Date: Mon, 23 Jun 2025 15:06:43 +0200
Message-ID: <20250623130648.682993973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6748fba48a07e..4dccbaeb63283 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6020,9 +6020,9 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
 	phba->sli4_hba.flash_id = bf_get(lpfc_cntl_attr_flash_id, cntl_attr);
 	phba->sli4_hba.asic_rev = bf_get(lpfc_cntl_attr_asic_rev, cntl_attr);
 
-	memset(phba->BIOSVersion, 0, sizeof(phba->BIOSVersion));
-	strlcat(phba->BIOSVersion, (char *)cntl_attr->bios_ver_str,
+	memcpy(phba->BIOSVersion, cntl_attr->bios_ver_str,
 		sizeof(phba->BIOSVersion));
+	phba->BIOSVersion[sizeof(phba->BIOSVersion) - 1] = '\0';
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"3086 lnk_type:%d, lnk_numb:%d, bios_ver:%s, "
-- 
2.39.5



