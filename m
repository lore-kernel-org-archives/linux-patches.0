Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B711D0490;
	Wed,  2 Oct 2024 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875748; cv=none; b=rGjBxEEKjjBNS/SW8EtkrZK/GEmxYSBf1PaNeActqo1DL5kvCI2c52nL/brWnqFmSG2w5Phpy5jEy0cKBWCJj227bGrRjsJEuIL0ljkXccOXtDNSdjlBKVdF4jB8u6U7rD6jfaK1iX3BbdcKHl2NlWpzDCkWfQtJvHzORgVjyAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875748; c=relaxed/simple;
	bh=Ety97NRixfQLHDQedIgSX9UM0kE+skLSf51O1+XBLcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVadgr+V+qAzX1GlhBL+ySOj2pZ2mbdGAGRUQKij+gLcfCyma05Cq+47GskPeFArsv27qQ3KRW2aEhpGImrvYJmFOUhgWW48wx6h9UVa0ywbEv85PLZqImkYnjZqosroKlKt0Vdi4JqDBTWgLDAnLL+6PyQ6y8b19hPz5frFvmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8Wozi9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8Wozi9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32697C4CECE;
	Wed,  2 Oct 2024 13:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875748;
	bh=Ety97NRixfQLHDQedIgSX9UM0kE+skLSf51O1+XBLcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8Wozi9h9ZA/o3BNF6PVFL5ovDIGwqL8KPYdimZj0mztvWv6dyIBG/CJNk1qMYXSs
	 j1DfbCu98F9X5CgbT0DUZi73I4HpwNbstMGhNIznHgf4CLTiCtYdaKdi9dbwiLWkAU
	 069/dy84npz+toEkNS6GkqtP7jlfUg7RrvuIfLBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 207/695] scsi: sd: Dont check if a write for REQ_ATOMIC
Date: Wed,  2 Oct 2024 14:53:25 +0200
Message-ID: <20241002125830.724497347@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 0c150b30d3d51a8c2e09fadd004a640fa12985c6 ]

Flag REQ_ATOMIC can only be set for writes, so don't check if the operation
is also a write in sd_setup_read_write_cmnd().

Fixes: bf4ae8f2e640 ("scsi: sd: Atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20240805113315.1048591-2-john.g.garry@oracle.com
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9db86943d04cf..76f488ef6a7ee 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1382,7 +1382,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
-	} else if (rq->cmd_flags & REQ_ATOMIC && write) {
+	} else if (rq->cmd_flags & REQ_ATOMIC) {
 		ret = sd_setup_atomic_cmnd(cmd, lba, nr_blocks,
 				sdkp->use_atomic_write_boundary,
 				protect | fua);
-- 
2.43.0



