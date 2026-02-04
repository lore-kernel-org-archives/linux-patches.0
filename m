Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2166F4218B4;
	Wed,  4 Feb 2026 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216895; cv=none; b=rqPZqMiwyVlfKD116RWhhhpdSiRA6QNK3JP6mf6xDTuaRPenDfLjf/UBDIrxaLib8dHEm5NycBpOL8fauiMcKKGdUvLGrAHUUGPo+AjNhrXmLXzOlSPY+j/oW7EgNXO/vBLORwT3tZCBWnJJ8EhlXSXPufFsKYcLKCsmxh5En2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216895; c=relaxed/simple;
	bh=tl7AxjjDcNY9plGKgr2sHBk7xlKa3oX/P1q/mrb1t+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K40wtxBMBcrZSeQnkRNwaU7nPS7i+omELhpaUjf5JBlyZeJFQvflulBSokmQJy3yzESnIOCG101aIsHyRKRB820h4xr67JIKK/Bjx8+65aeTffnR872X5UW9cHMV6uLFs0axfj5aqRqR4iVJolQ6xNajx+EJV/uFrWn9pRKoHoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYj6Z7EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYj6Z7EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945B6C19423;
	Wed,  4 Feb 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216895;
	bh=tl7AxjjDcNY9plGKgr2sHBk7xlKa3oX/P1q/mrb1t+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYj6Z7EF1gYpjT5JdpWOYVk1LZi3sUlBbDIrl6mhrRhFOsokPJm9smziNHU7e9DQB
	 xVSoqQmljExa6RRL0cl3rJVT/AQUZcAAPL2eZKqrycQ/XRHnEVyyafhyCmSKVbLmdU
	 fIgVGu5fjY4yYgrB1YoDVXCOhZ/ezXtFESBzhH7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/206] Fix memory leak in posix_clock_open()
Date: Wed,  4 Feb 2026 15:38:07 +0100
Message-ID: <20260204143900.235544868@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 5b4cdd9c5676559b8a7c944ac5269b914b8c0bb8 ]

If the clk ops.open() function returns an error, we don't release the
pccontext we allocated for this clock.

Re-organize the code slightly to make it all more obvious.

Reported-by: Rohit Keshri <rkeshri@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Fixes: 60c6946675fc ("posix-clock: introduce posix_clock_context concept")
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linuxfoundation.org>
Stable-dep-of: e859d375d169 ("posix-clock: Store file pointer in struct posix_clock_context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-clock.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 706559ed75793..a6487a9d60853 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -129,15 +129,17 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 		goto out;
 	}
 	pccontext->clk = clk;
-	fp->private_data = pccontext;
-	if (clk->ops.open)
+	if (clk->ops.open) {
 		err = clk->ops.open(pccontext, fp->f_mode);
-	else
-		err = 0;
-
-	if (!err) {
-		get_device(clk->dev);
+		if (err) {
+			kfree(pccontext);
+			goto out;
+		}
 	}
+
+	fp->private_data = pccontext;
+	get_device(clk->dev);
+	err = 0;
 out:
 	up_read(&clk->rwsem);
 	return err;
-- 
2.51.0



