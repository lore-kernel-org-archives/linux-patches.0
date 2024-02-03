Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F29112E51;
	Sat,  3 Feb 2024 04:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933361; cv=none; b=pRRlYS7tplzOfp+IjYsDnT0E+rivpcnYtEDhg6/zCt3nuVLfd1gy0G71Eb3tbnRjLh8D86MVPRPrQJm/yn6zm/9y4JI8+fnxoBMHwLb0ecVx8dkWl5Gijdc8V9i6y3QewEdKjSGxFEM6iAC+1F2G0OYzMeqIS2s61DpBKrnjNzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933361; c=relaxed/simple;
	bh=38lcF6KZG8IQW8BBAqz1zclIjwqmcfvwmNlhPd2/02o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqcdLIGo7pKQQptrk8B9txadLe9UT3wkFNhqMkZSalnTxgPn41k/qOGK+VUuczBI6rAf4bQxHFqYgpd29ecBDmq6QHd3DDen+iRIGtxuRx5pARZPpUmH7rp1eOIf2032T+fRCT7ItK6BYnZzceN/K/Zrwd9vkCZN78uPyK47te4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoX6Uh6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoX6Uh6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F03C433F1;
	Sat,  3 Feb 2024 04:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933361;
	bh=38lcF6KZG8IQW8BBAqz1zclIjwqmcfvwmNlhPd2/02o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoX6Uh6Gi8dPhYEXx8yuMEj9yhrT81XjbvkDsA2ONi/2VJAulrR+xzPfzIZU9DIYJ
	 f8T5mr277ao19ePfN+8n/teeZPHKuZkGYsbygsnei3ARbu1i1bBz+Ee0DHZ9+rcTFz
	 pR0Sck3hhIperY6/vdXLT8+/RqqMNyBhd7puAc0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/219] scsi: libfc: Fix up timeout error in fc_fcp_rec_error()
Date: Fri,  2 Feb 2024 20:03:58 -0800
Message-ID: <20240203035325.899737248@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



