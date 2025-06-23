Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61951E87B;
	Mon, 23 Jun 2025 22:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716394; cv=none; b=J27Wfb0lCSYTiEbn4OdSo6LiW9A4r9PP15pjUWS/G3XUmpktLCna1Kxje6jEpXSHCvLg0flnb7bvDnviJ/8kZHtzqR/6f4ae1ztZKaYHZTxxKD/ImM7TZ7EZqpdTdAqFGK5WYeDPR1gdBaJY5BfIfbA2V4+hF6sGns5zVvgy/r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716394; c=relaxed/simple;
	bh=sskoEcqTswoU5sD39TnbgB/AUoFDMg+h7UPN17Bk6Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGU0W8S+W7TPN+e6UAk0ZghAPtljQRJWVDvQXP6bOe/AJsR72UQrhFXyZH7Vfcn9Z+rgkBAVbfn/12gdfiMlSGx4S5gz8H5MrQWOEDm11g9RkyfeZwMNEhYUk0uL4kXh6+GCdT38xXG48OVcH9BaNEheW/LwJlSjFYZmxES56+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js7FHl5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js7FHl5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF42C4CEEA;
	Mon, 23 Jun 2025 22:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716394;
	bh=sskoEcqTswoU5sD39TnbgB/AUoFDMg+h7UPN17Bk6Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=js7FHl5P0Fc8l0fi375NrZYS/Ewn4wkothRfK7PUQuLJ4r4Njyj+7g19Ey1Pr5gH1
	 GffRLf1s7UORDd68LgxrzHkfSuKAtqE0VhRsDD1Bzr3YLjS4LcwWQygWXXJiFFlr7J
	 CtP1etHvqAkmox2lEFjHJCZN1TvjPhtA0fhD2G7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/411] scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands
Date: Mon, 23 Jun 2025 15:07:50 +0200
Message-ID: <20250623130641.847550048@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 05ae6c9c7315d844fbc15afe393f5ba5e5771126 ]

In lpfc_check_sli_ndlp(), the get_job_els_rsp64_did remote_id assignment
does not apply for GEN_REQUEST64 commands as it only has meaning for a
ELS_REQUEST64 command.  So, if (iocb->ndlp == ndlp) is false, we could
erroneously return the wrong value.  Fix by replacing the fallthrough
statement with a break statement before the remote_id check.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250425194806.3585-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d04669ae878bd..413b7adca0211 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5086,7 +5086,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		case CMD_GEN_REQUEST64_CR:
 			if (iocb->context_un.ndlp == ndlp)
 				return 1;
-			fallthrough;
+			break;
 		case CMD_ELS_REQUEST64_CR:
 			if (icmd->un.elsreq64.remoteID == ndlp->nlp_DID)
 				return 1;
-- 
2.39.5



