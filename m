Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E52E140E3D;
	Thu, 11 Apr 2024 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830727; cv=none; b=P0CEl6JgNr2F/Pt2s27973BWBt4A29+koZzrZu9lVaYrhqNkB5pouywgN3jquMZaUSFkO1t/5hbnN1jSMOTgFW9nZNHZjKINkETTb73EnQ5iV30nfincQPZYZDSXOoLYjVlUU+FVIBxnNQ/lnEhknPOT1+KshowV6dc+GCMbjMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830727; c=relaxed/simple;
	bh=hgl3E0tupiuzSLFq45IhqZwz5LHpYUitZ/XcrUzGREw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKoRNCuNzY9W23atFU5bLgSQbzweB2t6IO2ckSugprFfzYgs8WPoWn3DJxDFT+pE3SSNRoBgDqDRarnWCed88zgApOQyEH+f3urqYnimhDVl+sv8Le+CahzaM+pYyxrEcRC1eY3cXUQKP49h2fMJ6bqHIM2JAlIZwcWJa2VSYkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP6dqYdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP6dqYdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E99C433F1;
	Thu, 11 Apr 2024 10:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830727;
	bh=hgl3E0tupiuzSLFq45IhqZwz5LHpYUitZ/XcrUzGREw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VP6dqYdXgUrnMJGR3yYZgmm6Rbr9BHX9rYGxgRomR3h81M1FlQkcasnWq8I9ZrtBh
	 FTe0Mo7Je58gnoi7F4rVUo+0QjzAoYMhQf+N6/8HSVDVTnUnTlAPHH+6BgS2Ragfka
	 58CcpfCdZ1DBTtCdHJTV/SnEP25hf2k2dU3zBbKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/215] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Thu, 11 Apr 2024 11:55:05 +0200
Message-ID: <20240411095427.785439974@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bb2198b40756d..ae1a97dd0c3cb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1787,6 +1787,12 @@ static int console_trylock_spinning(void)
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



