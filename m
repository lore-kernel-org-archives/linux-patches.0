Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72A614F9E7;
	Wed,  5 Feb 2025 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764551; cv=none; b=cZAEWC57q0jOAoR8b/DbXczA4tWPhWH+bVKnUQ/EG6yMo6pRQAqfqEge82+Xga38XwClJeDpsNEG1XvmiYaNw3oXqWQ1kGmjiscbzW5wJ6fSRVTnahuN2U0zXXTJDMG5p81cnes1dourqoeqPj4aefRj+sdHA5KYb/iVs4Aeprc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764551; c=relaxed/simple;
	bh=atlgMCwcpL1IVmx2WffOaIsdPhMvAWPo/FhfWbZ724Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUS8rFK+3ESua1GvZKQmcXOAptXnBjvaDpJw9+f1IEs4/9KwQ8uq1Sx9Dt9vw8Ytt6j0I5ZF+U6DcummUwyc8D/YKDfXzvpX+7+2gwyUdaDN2wGM2xLvlo0UD83oXeyotqVUj7Gj0P0GRF0qqhZbzfljMaH2XjT3jVzV4TXprt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvGm1BdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvGm1BdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BEDC4CED1;
	Wed,  5 Feb 2025 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764550;
	bh=atlgMCwcpL1IVmx2WffOaIsdPhMvAWPo/FhfWbZ724Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvGm1BdFnEPD9TovP88cq4tRMdsG8XRV4icJqdISrgewbmEVxBTtaKGXXakdpYs5/
	 F0u3TM4RYk5JEyD3rVtxnm0k0WdLUJxcSpOU+2LAxzfPyBvU5wqqj2nPsMxzk7txWv
	 qQGACnfMrnK7YqAMm0AiTrKD/29TBR3BERzd60Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/590] ipmi: ssif_bmc: Fix new request loss when bmc ready for a response
Date: Wed,  5 Feb 2025 14:38:12 +0100
Message-ID: <20250205134500.511175011@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Quan Nguyen <quan@os.amperecomputing.com>

[ Upstream commit 83d8c79aa958e37724ed9c14dc7d0f66a48ad864 ]

Cosmo found that when there is a new request comes in while BMC is
ready for a response, the complete_response(), which is called to
complete the pending response, would accidentally clear out that new
request and force ssif_bmc to move back to abort state again.

This commit is to address that issue.

Fixes: dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")
Reported-by: Cosmo Chou <chou.cosmo@gmail.com>
Closes: https://lore.kernel.org/lkml/20250101165431.2113407-1-chou.cosmo@gmail.com/
Signed-off-by: Quan Nguyen <quan@os.amperecomputing.com>
Message-ID: <20250107034734.1842247-1-quan@os.amperecomputing.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ssif_bmc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index a14fafc583d4d..310f17dd9511a 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -292,7 +292,6 @@ static void complete_response(struct ssif_bmc_ctx *ssif_bmc)
 	ssif_bmc->nbytes_processed = 0;
 	ssif_bmc->remain_len = 0;
 	ssif_bmc->busy = false;
-	memset(&ssif_bmc->part_buf, 0, sizeof(struct ssif_part_buffer));
 	wake_up_all(&ssif_bmc->wait_queue);
 }
 
@@ -744,9 +743,11 @@ static void on_stop_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 			ssif_bmc->aborting = true;
 		}
 	} else if (ssif_bmc->state == SSIF_RES_SENDING) {
-		if (ssif_bmc->is_singlepart_read || ssif_bmc->block_num == 0xFF)
+		if (ssif_bmc->is_singlepart_read || ssif_bmc->block_num == 0xFF) {
+			memset(&ssif_bmc->part_buf, 0, sizeof(struct ssif_part_buffer));
 			/* Invalidate response buffer to denote it is sent */
 			complete_response(ssif_bmc);
+		}
 		ssif_bmc->state = SSIF_READY;
 	}
 
-- 
2.39.5



