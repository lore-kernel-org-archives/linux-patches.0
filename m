Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9466F074;
	Wed, 21 Feb 2024 13:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522602; cv=none; b=p2YFGdkTduk7RtotvrmgamJjSbsGy7ClL33espWXojJufwPdvktqMketa781c+it05OTn9PyYQSE0tPYTEmfMP4THruhX80PIT9UjN6dGffPkei2KqePeS8QCOCbns7jcpTWujkasRN6F6kKNrisDWbTHsQSTlyWIRwZr8rQaaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522602; c=relaxed/simple;
	bh=PxYAQ+w8XwfYujVEQ2xC2bEIFWSyK2/aC5Kj8W/kfUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpFW9YSyKpCtIDY2kmxeT4ts9fsPnylPhRDSa+KaISakwpw/howMTO/2ZCfrnlkPHDpILDPe3L5rzeC6VYPz7G1MFY2ILR6AhR+i5LtWdsvkzFWwPxrH3RW8C/z9zpEpxjQ1+A9jBnRtahjG3GFKH3UQVnJWjYGXLFbrE7n0Hnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwMksmxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwMksmxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45815C433F1;
	Wed, 21 Feb 2024 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522602;
	bh=PxYAQ+w8XwfYujVEQ2xC2bEIFWSyK2/aC5Kj8W/kfUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwMksmxCbTkZnLGN/862n0oXzlzmmo+VMmJy5cQnpHn6GN0apcLzdzBx6A94Z+KpG
	 wroBpEvRK39ymPRUzwhbBsmQhWWnutNLBaa2A9AZ7JPIh9ugj/PKxEyWFdqNnSadVm
	 zzTzGhvCJy4oL93b3MVWB6D6hWWOB0qft8WUGs98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/476] scsi: libfc: Fix up timeout error in fc_fcp_rec_error()
Date: Wed, 21 Feb 2024 14:03:50 +0100
Message-ID: <20240221130014.514768356@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 53122a49f49796beb2c4a1bb702303b66347e29f ]

We should set the status to FC_TIMED_OUT when a timeout error is passed to
fc_fcp_rec_error().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20231129165832.224100-3-hare@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_fcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a1015a81e86e..a6efbcc27181 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1686,7 +1686,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_fcp_recovery(fsp, FC_ERROR);
+			fc_fcp_recovery(fsp, FC_TIMED_OUT);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
-- 
2.43.0



