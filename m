Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F301DE3AE;
	Wed, 19 Feb 2025 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955541; cv=none; b=AzEG7J0csREV6UBTDA1JhITwUqsLJIWi4I3fIE6PuxtJYVeC22IE5eux9KuNZCkZcqpLuZkX55h4HoYcdawWzgPRMPG6M8Jgjjg4HFNtoyhZl/V1IctevceyFkJqvOop75W2i2AnDeSDfAA0j6DqSZqZ2aKHBERH3lF6NUaNzHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955541; c=relaxed/simple;
	bh=PHH3TKWF3RLHG3SgfCKX6bCCp/vmvMan43V0nfsFcjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e86+E6ctfE8ynHhB5HWhoSdUJRiWTnPB5fypLvGH0chG+gGXfdu3v1KbI/uk4D3t3Utu11A5TN+LHg5s6KnW9623ZZkYpxd24DodCy3B+bNiWzKStROQ3tzzBf7uNs98LPt9KEyUPh2vz454a2XuchLNcGcTF6UT2lkS1k214uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDBAMrrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDBAMrrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D073FC4CED1;
	Wed, 19 Feb 2025 08:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955541;
	bh=PHH3TKWF3RLHG3SgfCKX6bCCp/vmvMan43V0nfsFcjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDBAMrrEfGkWvr91b7jjrR6CgY7rj+ApouZIVyhDkzzmHsw5nV3dGxv+GvV0bc5Cv
	 1KP2VFnzUBQ4SXk+Res9938MfLQQrAuvFnFTnPeMbRkC6zfy1td7L71UwRdHDaZVXf
	 J43+GOr8C6Sz8lxihhhEs+A11hHnUkwOXbWUgEEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/152] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 19 Feb 2025 09:27:31 +0100
Message-ID: <20250219082551.544333548@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 1e95c798d8a7f70965f0f88d4657b682ff0ec75f ]

Currently, this does not cause any issues, but I believe it is necessary to
set bsg_queue to NULL after removing it to prevent potential use-after-free
(UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-3-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index f21423a7a6d7d..8fbd46cd8c2b8 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -216,6 +216,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);
-- 
2.39.5



