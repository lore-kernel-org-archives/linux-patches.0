Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC14F3C2B80;
	Sat, 30 May 2026 18:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164375; cv=none; b=Y+Jq6k7yMtOGcBQawiLPViYstypy0RlCMCiwmoM3YORe7wIO0TLCRwu8c4ywWrGaQxgpbfRdjQdfwISdbpzMiQFmo+nRk9HVa8FqmpEzYs/EZibD9M7sfCYIykFPanSlp+j1VaXMpxM8lh1162//Hptn7sQW+z/USGFzaUhbxE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164375; c=relaxed/simple;
	bh=rLrr7GSC6CD6Fu0Y5wuaK5jyTKDokVZM7iflSbaRtWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2Ikxrp4ge5fW1KdWNwRmQbe5DMuywqdEZKV/ecaBZDsB5asXxp/J17i4CcBtJsS9bE8puD0loGitJI7dbGQmB34dY90GkyQvXpUqX+Lw8PHOA+jD9IBF1BzL9lE9V7cQicTG8ki2z+LEioYxbpBaiDgIytwl9iOJAzgVXa5qb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSZuUzsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSZuUzsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD871F00893;
	Sat, 30 May 2026 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164373;
	bh=BnqGX8Y2FdFZrKan2TtSX+x4qlsNO30U1LKnG6E3O8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSZuUzsrItqdLo/6f0znKsAlO45XbsCZ0EvyEV0AdmS2CnarPh6pOQG0NAU/YRuMb
	 5Z29gO8H/AprCsN5dpTcKcMeZIRxy+oMOmy3774A+AoV8wt8h7BtVCqOZLMRhOLfNI
	 F+EXVJUpgSIgDPvZZwe3OVextsI+SU0uQ4FcktHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/776] scsi: target: core: Fix integer overflow in UNMAP bounds check
Date: Sat, 30 May 2026 18:04:10 +0200
Message-ID: <20260530160254.047858552@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 2bf2d65f76697820dbc4227d13866293576dd90a ]

sbc_execute_unmap() checks LBA + range does not exceed the device capacity,
but does not guard against LBA + range wrapping around on 64-bit overflow.

Add an overflow check matching the pattern already used for WRITE_SAME in
the same file.

Fixes: 86d7182985d2 ("target: Add sbc_execute_unmap() helper")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881593C61AD52C69FBDB0BDAF7CA@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index f6132836eb387..2d76f2f455942 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1232,7 +1232,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
 			goto err;
 		}
 
-		if (lba + range > dev->transport->get_blocks(dev) + 1) {
+		if (lba + range < lba ||
+		    lba + range > dev->transport->get_blocks(dev) + 1) {
 			ret = TCM_ADDRESS_OUT_OF_RANGE;
 			goto err;
 		}
-- 
2.53.0



