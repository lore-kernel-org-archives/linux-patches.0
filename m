Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2153F8F4;
	Mon,  1 Apr 2024 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987408; cv=none; b=l1Ellt1a4h18ExE0qvOVh4dvgRdHENvUb9SxC1uXRIbysY0+Inm/kSiaY/4wDOdHJqf38MoG2SX7LSvtYFde+Kgnny8hWs3VqHw2NG/RmmdviAPCccDBpoKJSyspfXtsFAgyzBDTkFbW3zQV55cQA3+7V3dqVg2LSnCZOXG82Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987408; c=relaxed/simple;
	bh=Fdg/oeLhxK54LGAPca40j5UR4YuBp/CSBNU/fePmL4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl2vIirkhEY4uHQzf9Ah0xZTUoyOt60JAF606a7w7dpJ/m0jUOz1hf90t067/qMErFTkNOQeUMnpOqjLVIGcp8ogDWOs/8mmj/v9duLLzWu4ZIjYyq1mHwNYXqQFFL5yWMxTDsvXKNQYUuXPTBIBXerORwp4CdROnoRTJyGdrNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hI6AZd02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hI6AZd02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2F2C433C7;
	Mon,  1 Apr 2024 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987408;
	bh=Fdg/oeLhxK54LGAPca40j5UR4YuBp/CSBNU/fePmL4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hI6AZd02yDZygK3GO6r+UudiQ4wonIcjI87k5+LMjhNJ6Oegfhrz0IXafvpZMVBAg
	 L1SOTuvXTiK4qjPAxUwPPcQiBAPgIwXqIlnjWxzHvBShKj3mhpiqqnvj6MUNtikkU5
	 hz84SBaZnCQVehzLXGHhQLNVN6KCu8JJAjun0p2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 261/399] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Mon,  1 Apr 2024 17:43:47 +0200
Message-ID: <20240401152556.979480689@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index a11e1b6f29c04..7a835b277e98d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2026,6 +2026,12 @@ static int console_trylock_spinning(void)
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



