Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3B541A51B;
	Sat, 12 Sep 2026 09:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203617; cv=none; b=gJfbp435tiR7TJ6TSh8TxGyARQ9CQNxWzX0SwsImos1jbKsV6UYx3xvpMTFxeA6h9faD5M9Lz6OfLXg81oU9biHl3Y7qC01K/0OP7XdLC0hDetvVsYo3j45kA6uLpGJRPMXz0I8FQlJmQjty6SxE2acIGWHbBE34A99E6XJvGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203617; c=relaxed/simple;
	bh=o9VnZcKGXKXl5VY1qc1XaXVolIP9lXkSCpt43YqD7ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F42xKXM1OaXARh60pcoBWQaNwXp8l1Ags/5m7TRLfYkPxDkyOXH8f1qcj3A1T/P4JWdofQy2dySHLLImB5WHhfMMdipTA3u0yJkSmhIW3hbpOqarYxjS91a6xFvTCTXQXUgNNzcfZMOBnzmeL3VBl8Vp1IClMFkGiqQhPlRBaVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/2uTkOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/2uTkOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6491F000FF;
	Sat, 12 Sep 2026 09:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203615;
	bh=3ze8rx7EM26Y6kyRJNf7F+CH260qzlCffXlmXdo/BM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/2uTkOCPRRpfRt4DZVufCBxUf1CXZwr0Z2jSxjosswD1gl2KjNRrxU1nKpKnwzbq
	 F6t9H3ec6DGUQ2ukcy1V4URS7yv8hCSoAjVNtD1tQyGo4T2jnWDeEzNDpVoy95yB8F
	 kJ/tXSVTPwhzPG5176Iv/0PjKZMXBOIqRyYlGYyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1444/1815] scsi: ufs: core: Set task state before io_schedule_timeout()
Date: Sat, 12 Sep 2026 08:53:14 +0200
Message-ID: <20260912065722.916224081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 686c21301e026..86f49c0522ec0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1317,6 +1317,7 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 			break;
 		}
 
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
-- 
2.53.0



