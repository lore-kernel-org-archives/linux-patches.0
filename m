Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2278F24397A;
	Tue, 29 Apr 2025 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947118; cv=none; b=Y3VYQOUEMum4mR6KtaVZza7c6ET6IRigNVMnUo7Mi9mkPbyuefgWUqauMkZoWgqj89Xz8ZEGJwT8D4cPlSFnI+njLCgWg/MsvS3I+/V4D6M22xbtUqdLmaGCoZC4V4+Az0+tEv/ONKjolX63pNjfMSN6R4ro9mGDgrDi3M/Slz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947118; c=relaxed/simple;
	bh=+9npQ6Lale+KaMfptes2W9SeNiFt4UM6x+brR74/1PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFAqDLhRSKGG058/5tQiY4sxLTkdVFWyUHwc2vmL+BRkccWY4MsukxkUR/hwAe9oZvBuacHE6iQX5cq0x5KGU3SZvMOaUDc3lwDzOUdrG87FRmS+9GufXvlW+pW5ubHg7sKGDCg9ps8SPnzYheQkndvWJ231tkrVHwUO3rbFVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q46+uDhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q46+uDhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FD0C4CEE3;
	Tue, 29 Apr 2025 17:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947118;
	bh=+9npQ6Lale+KaMfptes2W9SeNiFt4UM6x+brR74/1PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q46+uDhGdAEo4CzotKU7I47EANZJAObziheEDERxf7LJ/wCBTki5R3oxwQPzvcSFH
	 0qM5oCM6dQoNzRNvRII5KfbVHA/VTIB8Tg4a17QohKpA1uh/GA9daUvrT4igP3jA3W
	 TtLq0+LPb7JTFmGMfsiqS+wdo7ay60IeNCJiJPYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 178/286] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Tue, 29 Apr 2025 18:41:22 +0200
Message-ID: <20250429161115.227151652@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

commit 1e95c798d8a7f70965f0f88d4657b682ff0ec75f upstream.

Currently, this does not cause any issues, but I believe it is necessary to
set bsg_queue to NULL after removing it to prevent potential use-after-free
(UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-3-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs_bsg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -175,6 +175,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);


