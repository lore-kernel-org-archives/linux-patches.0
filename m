Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC651548C;
	Tue,  8 Jul 2025 16:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992735; cv=none; b=ZuCKsn+LMiBS42dUwM4ugeGOIuPDieOF2ip4naY6UjPPPDkBXLzQZmCnXqEfbHUJgYOIjrlsjrhDTJa8V3dV+ZRf9Jo+GU5QSb5ftXweIfUbVB6WDTLz9yfBBM/kEzMIVrN5pp8RkC0u5hnoBiGaelRLQRwlWW3tZFJPmpEDrJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992735; c=relaxed/simple;
	bh=t6gs4uNThTKYJeZlfC0fYwqOHy9wsEd2VKiYArXxCB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPsUyfDFU1pW0jGHF6ai999Xs5mFgzN+uxC20vGMjXOfeouCvoLFluhDHU9FFsEz+j1trFLC4uuccys+z5oqIqKQajixA6XFb9X9E2/gF2I+ZSbEs1hxnTJ5WgAGf2YiZsk7Puza2KqXbQFm1vHGjHCagxf6p8dg6ddoACYVjO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2g+tLjbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g+tLjbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F59C4CEED;
	Tue,  8 Jul 2025 16:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992735;
	bh=t6gs4uNThTKYJeZlfC0fYwqOHy9wsEd2VKiYArXxCB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2g+tLjbCkVCm2gdWWHDD2+Tekb/J/IhYbTx4F4e2zYSgxU3em1Yme3nskyYbD3d35
	 WU0PxGoxihwvaYRB1RI12dT8r3QTcb7d6275P0k1Px2tamkoOEOzXG1i6BCqR3u7nv
	 TBrTqsHfm2u8h9dtHhAPSNLAVHAj+LEtVIzGFnf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/232] nvme: Fix incorrect cdw15 value in passthru error logging
Date: Tue,  8 Jul 2025 18:20:57 +0200
Message-ID: <20250708162243.059732126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 2e96d2d8c2a7a6c2cef45593c028d9c5ef180316 ]

Fix an error in nvme_log_err_passthru() where cdw14 was incorrectly
printed twice instead of cdw15. This fix ensures accurate logging of
the full passthrough command payload.

Fixes: 9f079dda1433 ("nvme: allow passthru cmd error logging")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index eca764fede48f..abd42598fc78b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -380,7 +380,7 @@ static void nvme_log_err_passthru(struct request *req)
 		nr->cmd->common.cdw12,
 		nr->cmd->common.cdw13,
 		nr->cmd->common.cdw14,
-		nr->cmd->common.cdw14);
+		nr->cmd->common.cdw15);
 }
 
 enum nvme_disposition {
-- 
2.39.5



