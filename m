Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292C178B7C;
	Wed, 21 Feb 2024 14:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524119; cv=none; b=KDlwPSYdKyheLLxtfJXlr3uNCnhMHRllgBfM5aA/YX58hFu7PoTWRi0jyyfVXcliFu28lXxhu6EkIjvBklBfnKEZVkVpvTMuRkLBuaFs/+xIOb3jWO/Jpn6OxktBJxhMn9jMnVkGNcSHsJyU1oA2GrckD022RUdwYXz6XVzYrZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524119; c=relaxed/simple;
	bh=c/eP+kNwSgp1uePyduPyCa9R1c5/FgwrRXPlU8ngR2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxcK4bQl3bOriENTnpyPsG62swe4SSbHJjixtO54KNaMR4V2HLBuEftX7JrOPlWEmLivX3E/ep9MxHPxDbf4pufOrK1TsZeTbOL0Pw+fpBTqZbGwxs/5ksNJ7YV8TbWVVhyQLplUk/yxzP4mpox6KBV7J+bGsgMWLS4YqWtmYfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt+jxIzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt+jxIzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD1CC433F1;
	Wed, 21 Feb 2024 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524119;
	bh=c/eP+kNwSgp1uePyduPyCa9R1c5/FgwrRXPlU8ngR2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt+jxIzfWg//J4lmQbkweze6k/NAzYh6W+zlG4ZcYQp2yvmW3k4k/gvozSMNWOvOP
	 /ajYGJxNnWJs5+I1pepNUz8UJIhihr6uscoOIFVGrFyeutkIAsfb9DcSU/ZT1MRT0z
	 hlWpTpt98aDGzsEp90avY/4sl6j/O9NeiRc3kG84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/379] scsi: libfc: Fix up timeout error in fc_fcp_rec_error()
Date: Wed, 21 Feb 2024 14:05:29 +0100
Message-ID: <20240221125959.358925493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f005ada489b..61c12dde967e 100644
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



