Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847004087B;
	Mon,  1 Apr 2024 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988845; cv=none; b=T0nNON1+7/67m6JKASZKmi1r+tBIl3xdYWKQ4QQxdNRRCmQzj/X0cwutOa7gZP3Y3ZAfMYsce7lCmzBBCITKNSv++sBjmrBLhKeJS6LQsiDEc1H9Narr/mnNdcuOdlV104yXCKt/gI3ySUskep/RVrf31/3oN9hW9abjlZxu4s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988845; c=relaxed/simple;
	bh=ww4ZOq0fv2eHz4sFA49nkSmqLSnTbmN2ZXGNMYnqU80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLEVv3QcuS37bSavsjquVFR9XqFXq6DDbKw83aFCdZf5G1WRjaLY85PsCl7DGeQm21zWjprLSX9o9zuHqe+wo5fmoomf4X2MsHp5IBAg5craW9Xws8r0l21ei2xdH5dKAGTYBZr1S0m8D8c6EmcIYoTG5I96BrgTIbw/Yqsyfl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gu4C6edd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gu4C6edd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BE9C433C7;
	Mon,  1 Apr 2024 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988845;
	bh=ww4ZOq0fv2eHz4sFA49nkSmqLSnTbmN2ZXGNMYnqU80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gu4C6eddKehgR6UjTdu7XfJ9b3WJKu94KlNzklvyt14YNd8QdZujfyt9+lfJHbYlZ
	 i6/qqCXtOrboe7qweBVgz1AVkvt/+zyWBIXZjHg1YtNDlzrprV6RwJGxtBs4w2dlNv
	 fCxc4nvX55oEGNuLwzYPcIotKDjGIgkhWVwdrcBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 306/432] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Mon,  1 Apr 2024 17:44:53 +0200
Message-ID: <20240401152602.317267672@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



