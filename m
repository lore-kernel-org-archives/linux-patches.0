Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE57814F9F3;
	Mon,  6 Jan 2025 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178361; cv=none; b=GzqFb+fobdqEIaw0tnxfI6y6pKFQ/cr2qAqqC6AsE+jGBQJcqb8EFV5qUbOHA5fmZlOH0jb1masT8AhxMkjL8oLnRoovicDTnJQUtc9zFrRU0hejHeoNp1zRvR8RoLmeBbKROMnQt4Qx2Sp3FB9av5b8G8KesU+FH8miwoyt9Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178361; c=relaxed/simple;
	bh=+dr2bzZve6BnVk44+8iMrujNZpb+WVOWC/aQZ6BEL9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEgUQicTp4J652Rm6N7r22p+ct4RAB4ENUwPkPs/f3ATQ9PEOY7tXYNRlw+SN9mtVQsK8iLm6ZZ2Vhf95d1MOESDA3EpdJ2TPVXxI5ZJ0spPFVXLl8v/308uI1XkHjm5zJVbswOLQ165hb98mnV8f/v7hh2GmpdlqUmB9VD+kGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWMe2jNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWMe2jNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A741C4CED2;
	Mon,  6 Jan 2025 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178361;
	bh=+dr2bzZve6BnVk44+8iMrujNZpb+WVOWC/aQZ6BEL9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWMe2jNx+TpvHEFkZ3dQ8dG1u8019oBI+ZzyA90iDTO1Invab9TL+nQCe8is12Sog
	 041k5WNUrWD95UqqMBJFtDkd77j6SpTaJxEF+VBpMG8sFR1jB136iQ1Qu5o3/qqF4L
	 m0OBSl4O3YHbDxGVNo+Mas3t2G+g2bWgYg5a8Qqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/138] scsi: megaraid_sas: Fix for a potential deadlock
Date: Mon,  6 Jan 2025 16:16:25 +0100
Message-ID: <20250106151135.545816255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 50740f4dc78b41dec7c8e39772619d5ba841ddd7 ]

This fixes a 'possible circular locking dependency detected' warning
      CPU0                    CPU1
      ----                    ----
 lock(&instance->reset_mutex);
                              lock(&shost->scan_mutex);
                              lock(&instance->reset_mutex);
 lock(&shost->scan_mutex);

Fix this by temporarily releasing the reset_mutex.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20240923174833.45345-1-thenzl@redhat.com
Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 365279d7c982..d709d261d0ad 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8868,8 +8868,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
-			if (sdev1)
+			if (sdev1) {
+				mutex_unlock(&instance->reset_mutex);
 				megasas_remove_scsi_device(sdev1);
+				mutex_lock(&instance->reset_mutex);
+			}
 
 			event_type = SCAN_VD_CHANNEL;
 			break;
-- 
2.39.5



