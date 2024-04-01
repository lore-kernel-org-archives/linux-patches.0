Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EC2BA3F;
	Mon,  1 Apr 2024 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990250; cv=none; b=Wpw5PwZdJPSl2HB3P18I2uLUBjYRQmVH0SvguMKD5/RgOBBvI7gyItTCM+BWrudtWdWZkqIQYJGeVKP6/twSbQnWRyaOrfeccB7VufwP2bEl1ntg2BxsTceyLtGLM7osLuutPMw3ACu+OMY+xINi+9fPTYR0fSO4TQH4/JYioFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990250; c=relaxed/simple;
	bh=w5O/zxz7xM191vBMvg4ypqSajPZLkrwTRffL2n7kUuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1sI3fVtRxu9pP+Z+8OiAWUNcEqyV0xbjXIviOvGNhAUqHcUdIKMQdwz2aqnSVrYIY0E7LMMqQFOdUzs86OYV4l8AfXOtNMaXsN3/popan6MoQMf0hr79muf72xt5aoRi9+V5c/eSAnzPgG2mozkoPWZWOlimjnfAHm1Mm5HWh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MK6pnUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MK6pnUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8DDC433C7;
	Mon,  1 Apr 2024 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990250;
	bh=w5O/zxz7xM191vBMvg4ypqSajPZLkrwTRffL2n7kUuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MK6pnUK90vdKPUfa6CwUpK0xebPepQzAsotWDb3PYq39uWgy4QMDb/SK8XUphxQR
	 gykAsijXo7DEfoIgIU7OABVUaJqy89M5cLVUw23NFN8r6jS4u1ono1EQ+A43u47Bc6
	 VDxizyUubwPZh0/zTZgQbKXxoMKt2S9Puqx5GNyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/396] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Mon,  1 Apr 2024 17:45:41 +0200
Message-ID: <20240401152556.609919397@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 8076972468584d4a21dab9aa50e388b3ea9ad8c7 ]

console_trylock_spinning() may takeover the console lock from a
schedulable context. Update @console_may_schedule to make sure it
reflects a trylock acquire.

Reported-by: Mukesh Ojha <quic_mojha@quicinc.com>
Closes: https://lore.kernel.org/lkml/20240222090538.23017-1-quic_mojha@quicinc.com
Fixes: dbdda842fe96 ("printk: Add console owner and waiter logic to load balance console writes")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/875xybmo2z.fsf@jogness.linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c358c04d05162..35d32d66fb114 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2007,6 +2007,12 @@ static int console_trylock_spinning(void)
 	 */
 	mutex_acquire(&console_lock_dep_map, 0, 1, _THIS_IP_);
 
+	/*
+	 * Update @console_may_schedule for trylock because the previous
+	 * owner may have been schedulable.
+	 */
+	console_may_schedule = 0;
+
 	return 1;
 }
 
-- 
2.43.0



