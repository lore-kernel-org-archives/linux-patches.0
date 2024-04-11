Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D842145B05;
	Thu, 11 Apr 2024 10:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831821; cv=none; b=c8Tw/wKSVvmhClHhuHjZT3FyckKqy9LdXYsKon7e15SRCzHnDqsyPmYAUxZwXwnYkXh3pW3O3L/TsV9aiHioFKNBFIJ9JIsCTj0+w5FNWil1MysHQihuI2oTQeJywZ3vUtpIHu45slETp3rPsFoATC40DtR+6O1wVPejulmDjgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831821; c=relaxed/simple;
	bh=crm9iU1rIFw0RhIgsPcB2ZvgZeuZzHIO9BT4kCvWNS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzFYRlaaEwjERt/Ar+cib2OcFu+JSnUZfca1xm07/05gii9QeFTjQ5vNhPbNDUlohZxXHbf9S9SXaWluXerKDr9dto/oDA4ABq5ehgTfxB2IZAStvIQAmEF49umUiWKfMz9IVrwf/Dv19Zl/SRbf52xheXBzOVVp+KLGINjubIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOl0V4vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOl0V4vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EDBC433F1;
	Thu, 11 Apr 2024 10:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831821;
	bh=crm9iU1rIFw0RhIgsPcB2ZvgZeuZzHIO9BT4kCvWNS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOl0V4vpzXXuBkhtCNe1ple08s7cKTHTgQCSMU4u5fzV4csq+P0PaQLFzzlxgvpY0
	 EAZxKUrjGtBY44qHh4Ooon9WCzKUhRmQUVjWxsAyTLC72qk/8+ldZZ6nrSdQkuN7Mi
	 U1eZ7z/zv1VEUu/HUBYbwOJ8uSTzbGm1syY/YQ8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/294] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Thu, 11 Apr 2024 11:54:59 +0200
Message-ID: <20240411095439.749890691@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 255654ea12447..a8af93cbc2936 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1866,6 +1866,12 @@ static int console_trylock_spinning(void)
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



