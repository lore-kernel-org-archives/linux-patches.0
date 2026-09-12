Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BB947F3C1;
	Sat, 12 Sep 2026 13:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218328; cv=none; b=UcWPByfPVhb7CXONsoYz/9F2t+SSJow3INrn9Vx+mD3qy7qaUBQvCNQADIISuRaYXoBLENRVKc0fDjzDBeRSiWKtofaymS6neK38Q/yNd5In1kh02/0jKsKTEEcwp2afunKWMPSEmMbjJEsc4wkvmkVJfV+puZwNruc9qGQ9sSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218328; c=relaxed/simple;
	bh=F/kpx1wlc1RUsbVaFgejimf+LCkBdvDlQpdhUbiOlY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J14j2aCdL4No4XrYA0la/ifTOWLdLoLSxi6rrs3c+C0cLf1vlbnJ0+p7NCq/7lW3swsE78xbsq6f1X1bNPrwQgFsDrwZ55OKwvF6V7h5ilwu0T75/DxyVIsxme8Q5W6xnn7DKKwcN53FWgqCaT9SKI9PPqk3JGVria+G182AHIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6F3QoKR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6F3QoKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007CE1F000FF;
	Sat, 12 Sep 2026 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218327;
	bh=vgeDyR4HCLQjBqYJUDvbkGRXiOGcN/B+gva71nKbdZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6F3QoKR8kppnXiedu6X3KoKto3Q79D+bvCZdHxuppqdXNCgwVWndlfEa0GRPE/Xk
	 cuWWhxhbMkTBB5GTzGyt05xY+inIh6ZIkuOyEGuJLr1mdRiNP/m9p2mGJQsSvZQgh/
	 k/t5z5zuPBJGP0+0B+Pm1+SzPo6zuS9MZqZs3Yyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1123/1376] scsi: ufs: core: Set task state before io_schedule_timeout()
Date: Sat, 12 Sep 2026 08:59:09 +0200
Message-ID: <20260912065632.592707361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5575fbc9905c5..ca19577135de6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1311,6 +1311,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			break;
 		}
 
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
-- 
2.53.0



