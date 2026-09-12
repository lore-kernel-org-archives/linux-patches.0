Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F9537C118;
	Sat, 12 Sep 2026 11:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211211; cv=none; b=D4Tir/GlpP5je+8f8TQ64jeLWtpj28kzlu5ylDwAq8Wu8+K+w1eVgWXT5wyFEXaiTOgO0E42YdSDDqlhlnHqPN0Yi0ISiHvnMostezsVbE7ortseZIupTLYqaKDpVCBqMpdJm18jvdKxXLBUMcaYGK/ezVKndxqnvXJrSB+N5MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211211; c=relaxed/simple;
	bh=sf+kSQEj85HW1F8xmtSL/avybsxIEeHAHclc0bIyqxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFGVHApGTIIqxWWNyge7GHhxfVsjpsX5Y49QrT4mCXkeKMWWvwlxdevK/fBCTVVXbkQemc8PqMsGXCiCWq+iLkeFxZYhiA0UoOaui9oebhqSQ0367XMU8tVm6sSvkSZ6JmzudpIY1FCdg58UeO38Rma/smottwXAiIy2yr6UWyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1sAYvOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1sAYvOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64D71F000FF;
	Sat, 12 Sep 2026 11:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211210;
	bh=hmTheuAw9BVhcQbf8qLLJQfjWQED4CIPGxwENows1D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1sAYvOlOULcIytOpdOrBFvlj+BOuHI42v5RbyPXQdJ3Jh6aAJbYa8ND5laKGNUmV
	 VN/v4K8bmsMt7i66hcu3jn9Hj58PAAGEpZlh9G15SUL8bwykGz6DefWi6nKTYWJ5Wz
	 hTSK1lVOepR9g2lVn3XnP3rL83exKzZdgL8raqv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1183/1518] scsi: ufs: core: Set task state before io_schedule_timeout()
Date: Sat, 12 Sep 2026 08:55:52 +0200
Message-ID: <20260912065650.238227647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 720d8b2f2457f4962ca353dd90395e2660d9a10d ]

Set the task state to TASK_UNINTERRUPTIBLE before calling
io_schedule_timeout() in ufshcd_wait_for_pending_cmds().  Without
setting the task state, io_schedule_timeout() returns immediately
because the task state remains TASK_RUNNING. This results in a busy loop
that wastes CPU cycles.

Fixes: 2000bc309703 ("scsi: ufs: core: Reduce the clock scaling latency")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/8fe4526ce272811b28e99048b42358dd8f7c48af.1786142946.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b51933b6cc826..c240bdb5654f0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1338,6 +1338,7 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 			break;
 		}
 
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
-- 
2.53.0



