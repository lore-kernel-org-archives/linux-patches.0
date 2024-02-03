Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0526171CE;
	Sat,  3 Feb 2024 04:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933545; cv=none; b=lpPm2FouYtztzDy7TdJ69E7icQqdp0UGey8KyY7/zDQ/wS3jS04OKOumk3zT616bG4TXfit3iS7AqFT2OYZ55vwcugLgCCnIxi5fvZUzUwtvroEzgOjwzmpNMYHO8Gnxz8OcwIJ3AXEV2HUtcYyWwed+xCPpCssA2Mz8LFQSCag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933545; c=relaxed/simple;
	bh=5QA8HAsBL3TgVz/XtPnuzFUOoKbSTZc0fba7bTJirOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvnjH/ezt/Er6ChYZDKQ/jjXrYwg67Cw3OgV5t1hYgGb/yMbkx1qOKKoq+7H7DgiwxTsi44wll3oXwHsxRanW0ivoykmx/kuWK/fSmwLkIBWuIqS+2DknNzjJaIIZ3+RZ4TB5ucLyRkwhjd5xmXzpwjrdcLmVfmpbVCw2LRqL8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYObazfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYObazfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1D5C43399;
	Sat,  3 Feb 2024 04:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933545;
	bh=5QA8HAsBL3TgVz/XtPnuzFUOoKbSTZc0fba7bTJirOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYObazfDYa0MePG+tL2SyEQASVzkkBfr1fhbMEBGhe1ECf2RtmjCxHg0IFjfK5wqK
	 zbBlYirY+O+X99dBUydZ8nbHvi79tHHOmeBbScrIrWm7uFvsqJ6oX01H/ZvflKvR3d
	 ODozz8VKmz3YR/poCc8G9riaGy+65e0FodBC+RlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/322] scsi: libfc: Fix up timeout error in fc_fcp_rec_error()
Date: Fri,  2 Feb 2024 20:03:10 -0800
Message-ID: <20240203035402.159611434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3f189cedf6db..05be0810b5e3 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1676,7 +1676,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
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



