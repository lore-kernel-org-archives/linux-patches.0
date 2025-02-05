Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6D2B640;
	Wed,  5 Feb 2025 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763686; cv=none; b=Y1z04dB3lDZXDCcck+riikka6YoOchjf1Ol2wjzak1uvYL19PW8dCng5lIfgXJcJhqtG6n8QDJ+bgMmk5UJ6MD0plR7bfyHQhf7kGje+b2g++A1859+lXBdg1dm8Zwy1qdOm5GMMgtg/q5GES6yM/yGzCK3n/Z2/foBnj3pskak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763686; c=relaxed/simple;
	bh=eiACKx+ipNUllS4f6JnjI/NuZwfvQ6BQ9gNqD1XdEkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQmy8Zn1SKO53/fHNtQ5H/bUl88mXa3t2xI5HjmgB1RgUNUoe5QId7p3u7GStqexX9jKitLvI0MjJ8liRW5eA4tLhg+Oq0CuDEpvO5Wg31gKQdFyn4cveGoXgCKGb8xP4BOhDpsPC/kUSi0V/AjHkXinAZzGlQhvHyXYp9eZ2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyIafgkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyIafgkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB697C4CED1;
	Wed,  5 Feb 2025 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763684;
	bh=eiACKx+ipNUllS4f6JnjI/NuZwfvQ6BQ9gNqD1XdEkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyIafgkq7jFYB7CTEjs6Qy1+ibRZnTUrWdRTDiHctGivrUHUwzModfHjCiZpL0kqQ
	 1FlTebPeQhBD8CUra5VTWpBByFV+HZ/uY9+K8T3XffYV2yIavhnOfYsPcg1XgCoKCW
	 1+/STpf94LVOUX7JiIPfQpPTVL6mvJEMm9NogHkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/393] ipmi: ssif_bmc: Fix new request loss when bmc ready for a response
Date: Wed,  5 Feb 2025 14:40:15 +0100
Message-ID: <20250205134423.968273503@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ab4e87a99f087..e8460e966b83e 100644
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



