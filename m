Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9FC1465A8;
	Tue, 25 Jun 2024 09:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308845; cv=none; b=WMD5cNUf8a+aV+DPUijUQX/M87/81zA0rdlp8WSesljJyW+WJ84euG8OPdthD4AKFHK1WS8YD+asfVB88n+dx5KPjQCktI+nMu9fWj8Xz8kc7xO9kGtHU7ciZUI1MQquUlnvxV74wXcRYUrw62E15VvHU9z6rHstLCFD7Vxb3/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308845; c=relaxed/simple;
	bh=DYwf7b/gwjG9yw8SyYCqk9W3YALtN0wNct2qgeePs4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTa7R/KgfnmOpQzTQjt53ch/jE1hDInaU0lFyHZ8/1wOfLOjXQGSyGTqxSmGBqJN7Ny1lQxiWEk8JiFga9obRS2X1uMCloUgVJA//U8/EokSbcWUudu2HdN+Q6MGxisQgy9TLkiOakTZ850bFIr4i9AlotV/6pUfoDqYwhQf1is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcI3w89e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcI3w89e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9420FC32781;
	Tue, 25 Jun 2024 09:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308845;
	bh=DYwf7b/gwjG9yw8SyYCqk9W3YALtN0wNct2qgeePs4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcI3w89e5J3n52g4Zln+WSlc+an4Wn8PG3PtizzJX2FYbtl8/tR0A6GCDS/mAifDA
	 JPU4ZERtKxhm24+69HoOpMJM1jXr3NrjP/hC2oPdY3F+OMJ68ZvRNEIuvnnOW97qDg
	 8wLpvNtDf5TzJce/0cUzbARI5y6stz3pV7MpAUm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/192] fs/writeback: bail out if there is no more inodes for IO and queued once
Date: Tue, 25 Jun 2024 11:31:13 +0200
Message-ID: <20240625085537.209869939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit d92109891f21cf367caa2cc6dff11a4411d917f4 ]

For case there is no more inodes for IO in io list from last wb_writeback,
We may bail out early even there is inode in dirty list should be written
back. Only bail out when we queued once to avoid missing dirtied inode.

This is from code reading...

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20240228091958.288260-3-shikemeng@huaweicloud.com
Reviewed-by: Jan Kara <jack@suse.cz>
[brauner@kernel.org: fold in memory corruption fix from Jan in [1]]
Link: https://lore.kernel.org/r/20240405132346.bid7gibby3lxxhez@quack3 [1]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1767493dffda7..0a498bc60f557 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2044,6 +2044,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 	struct inode *inode;
 	long progress;
 	struct blk_plug plug;
+	bool queued = false;
 
 	blk_start_plug(&plug);
 	for (;;) {
@@ -2086,8 +2087,10 @@ static long wb_writeback(struct bdi_writeback *wb,
 			dirtied_before = jiffies;
 
 		trace_writeback_start(wb, work);
-		if (list_empty(&wb->b_io))
+		if (list_empty(&wb->b_io)) {
 			queue_io(wb, work, dirtied_before);
+			queued = true;
+		}
 		if (work->sb)
 			progress = writeback_sb_inodes(work->sb, wb, work);
 		else
@@ -2102,7 +2105,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * mean the overall work is done. So we keep looping as long
 		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (progress) {
+		if (progress || !queued) {
 			spin_unlock(&wb->list_lock);
 			continue;
 		}
-- 
2.43.0



