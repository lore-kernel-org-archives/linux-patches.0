Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F3147A64;
	Mon,  1 Apr 2024 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991267; cv=none; b=bJEqyJFKbsUg8g+9Mtoel9Cyq+1cZnebPH8jUd9SrHsoyNS2a26YY/hwrPH0qh5m2CItqb1e6Lk8kyFSPI7ir3NQWn/VMcHWrbNLe0qBaLivpTMU+gksA+2kyqmuvmUvtjfCg+Y6OMemmqNLlB4yrcBhPGMmKDbQiCDjofZ9gv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991267; c=relaxed/simple;
	bh=GhDefM2vhU2HhJexO6PZ5nCmy3+UxykQugJ0URUYnJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxN+TigCADLgzFt6YLRsZ+rfEtdrP1F7vCuDNGCrTPQvRFPKLdz0RzN0nhGDTr8vZ8gtEPuEAU7aVTtxwEYRB1O6sbpyX9jSU9ucNZ95KraEB4BspO8veMBq+oTZ5neB+JVR//ajXSUMFETqV/L95RCU6o765pdcVgi2GTS2YdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrRc/klZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrRc/klZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80437C433C7;
	Mon,  1 Apr 2024 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991267;
	bh=GhDefM2vhU2HhJexO6PZ5nCmy3+UxykQugJ0URUYnJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrRc/klZJkfsQ/yhZvS1vXVQYNQccwUT5rqFHNhzhp6N9fjpoSQw6wKjV/8ooXJl8
	 pJfYL/hz83d8UhDu865wYf0Km+1vUHxxlSNE31Olcr76T142QS9c7f9wlt2HFJcsdv
	 T5r9ud4Lxzv2R1TZfdmV4evsQnP1vCkOsYQ2r6Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/272] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Mon,  1 Apr 2024 17:46:14 +0200
Message-ID: <20240401152536.561886618@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c55ee859dbd08..0ae06d5046bb0 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1947,6 +1947,12 @@ static int console_trylock_spinning(void)
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



