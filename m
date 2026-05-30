Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39422C11C4;
	Sat, 30 May 2026 18:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166605; cv=none; b=cOOYzafCwcKxHylvRIXR+bL/vruIPatqZH6xv9efb4F9haN1xLg9pUc6FBD4KCpnbmpgMCFk5zdl96y9eKY9WFQPglnZzcaqZjT02gqpLiW2MFqzLS3YXUlSQMtpLLw1dxQeXaTaEaiWtFjmHQqNTA6CNA2axFhsSXGR9Wkf1tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166605; c=relaxed/simple;
	bh=NMvKmj50LBn0R6pFULH5cz1OtSkevgGcDOyLxCfceV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5ebgmIieos/KHDoaGSnPB+pQu43f3/X7RWmlVLoremFR+AW6Tvau+SnQpxef0mi39EjBIx1CaTnrZaqYydqkwvB38OYtevPNYxQdQAFkhgEtjE9kf1abwb2VvBVbcbufn+3KMrgSKvAUFwsypQsdRdzu3YZyf+dgrJCboJp3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C33PCWYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C33PCWYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCF11F00893;
	Sat, 30 May 2026 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166604;
	bh=06L83K4Z1ZcYJdy709HtlXvsuAlRjt6kFwsoPKnkk2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C33PCWYSinKRmw7OLU8ka9TXv74LMSTo1URjag6lPsaGtJa7HqEtGd5szH/9rvwP8
	 c9Ju/MnoRwsviZc9vmMju74kLkGfF7F3TIfzqt2vpqWQPXEDwmrbdvMnc9cIxcF7Uq
	 mDtOJ+nnmA9CfDOOveUJWrxv44Dug1XqMxP4CRRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/589] scsi: target: core: Fix integer overflow in UNMAP bounds check
Date: Sat, 30 May 2026 18:04:39 +0200
Message-ID: <20260530160235.241692902@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f2809c44988b5..c997943efe777 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1201,7 +1201,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
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



