Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB9A1519A4;
	Wed,  5 Feb 2025 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765097; cv=none; b=Ko/GLefvFWuAR5fiJkGlxOMpgJ6SwW0IJI+1JbwE8V/7NbxU/+/i1tqKNXp6thLkvmWb8aqZMsTRIniXPLMSyf+GkOzJjZ0QDsvXY2O2IubCpzfeTB/ZGmn6/pSiaf9tbsAZBBXqOP6ArLob6qyjp/PMQKZYsUKNPpF2mwh9zTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765097; c=relaxed/simple;
	bh=AWXY/sgSs3xZaMn/ui4xfOdQn7HKjqNQp1lZLv74xXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1NKkMfXv8unO1HsxBSo6euC9EEbtU7w4BgF3/GGJVWYCjXzgoWbkt5uC4B88Ii9KurMAjT8O+JZ8ExHKgWDdrRiDVrWAKyJGdDjyzTe2MZ/tIW5KPnypZWbIXGFBbo9wVQ78kJ0zG/f1ECI2wv5FXqg3dTRP+u/zXrY84b7kk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/zVAtPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/zVAtPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E380C4CED6;
	Wed,  5 Feb 2025 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765096;
	bh=AWXY/sgSs3xZaMn/ui4xfOdQn7HKjqNQp1lZLv74xXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/zVAtPbRso1EhxlTHlOvyqNsff7jgsQg63XpXtrh5xdcb95hwuHM2kR1T8PWpc6S
	 Cavbfcj8c0J8Umud+EoU97O+YOsLPvFiei6KviblAei+fmVPFevr1l/Y9OwGAVmK4/
	 ko5vSTXjJn9Y/EHHdhWC3YIS8+axEvNqPgwHdLEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 143/623] ipmi: ssif_bmc: Fix new request loss when bmc ready for a response
Date: Wed,  5 Feb 2025 14:38:05 +0100
Message-ID: <20250205134501.704115326@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



