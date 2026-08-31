Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BE14CCDE9;
	Mon, 31 Aug 2026 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185177; cv=none; b=Ub0QeW90/9lU35Xi6gaRSoEzG5OQ1uBq2AaGexUFnslLl7ErDWoMoi8iJNUUk2iY7uu7Xc5o1mnhXQejkLhH4t4iU+fXhWrr3M1vChBbUxJqzgRUeJwbCq1I54wF7wFx8BvAJEqruRmnh9DDagr/FZ5ip5U8iKEXab0mrpJU9QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185177; c=relaxed/simple;
	bh=xGOzWgeW/CwILly4EwXN5f++kDD+DCJvEQydSXpPd5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQrniwmt1kwdRvmjtTb7aED8Tic0nXpw0MUlghxBvDPzcjT6Ho6MdRGC4SHRLGDlJTJ6tAXWN8Nah8NnVd8KD0xnDrgRB3IrhPBrv8WZxURA1A4AAshMQawif4BuJs6XW7513AuSP+3Oa5Z8vBzkhmP51/Ofkf0Z+uRKvk/XQcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqmlxzzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqmlxzzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402E21F000E9;
	Mon, 31 Aug 2026 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185175;
	bh=ydPUqUvSDShZsViAdeh2b7Gpdm1QgRC+w8EjSndLWqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqmlxzzz400xiX9hSq8v/FN/8A158AHdIZIZRH/nV28xtxVf8o+22FxuGlSSmkGFJ
	 X5tpKjgjvXST/LSFk3LmvKMLKbMTnB8ku6JqRMGe5lxkPAlkXVe/eghwIRmYH6o4y1
	 ygLZFaysl3SOEsyV5NI7WuhfkRVInSW2VF5vTQ4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/43] Revert "PM: sleep: Use complete() in device_pm_sleep_init()"
Date: Mon, 31 Aug 2026 15:35:19 +0200
Message-ID: <20260831133359.037128144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit d77b629876f15ebf9d9987e60b6747fd73ca8148.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 24a7e280e3007..964573e30d691 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -102,7 +102,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete(&dev->power.completion);
+	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -242,10 +242,6 @@ static void dpm_wait(struct device *dev, bool async)
 	if (!dev)
 		return;
 
-	/* Devices with no PM support don't use the completion. */
-	if (dev->power.no_pm)
-		return;
-
 	if (async || (pm_async_enabled && dev->power.async_suspend))
 		wait_for_completion(&dev->power.completion);
 }
-- 
2.53.0



