Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE33247CC83;
	Mon, 31 Aug 2026 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184870; cv=none; b=XQ2bnfS88rvf+vPMfoKczpjECR7TNniLx3I3fLTqcc/Q+ABsvm0w1TE6getSWx1Uv4o4UT8BRkx//GNnqmV5XFHiWF0SZLMYvjj6Wn+88+9JvgIm9Jiu/P1VzQADUVoH1iRhdEeym89yDZFuSJMtsTHB8ZYqGc6o/+v2td6DHW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184870; c=relaxed/simple;
	bh=hBphHN2V/al2l9YW+GdVmoxbBZzFCvwlJqKMcey+qI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndTH7Ieiz4PEhmOfSTnPzxMR5Dc1KvzgeexuWXzU8Y+tV1NBLorsWxD7z/FnUX91lvdCbs0RBpS8TstpeHuD/Bn0D/1zUkxtJjlOpGarEAF5MxuYHLQtL47gQkFhE5IaIhoz3fZl1543uCR2dBmu5l1Afjl5/wq70lqSvaYirQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1taYWLDQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1taYWLDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFD01F000E9;
	Mon, 31 Aug 2026 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184869;
	bh=hm9gBW5q4A6njKidaOegCOnBTxtxW7QPppCTkrP183o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1taYWLDQTNQf3sz8IOuMlRUC3f/hxGsHKXqB5fQUwVb5dW9fwOGBUsovxE5uwnUXi
	 oRz+EF6H9E72Zoo3UY6VRGAVKkuAvTIw9DIgtQTpG69d6hSNGHLQxGATfQbJ1JLpIf
	 MCI4hiEQ4GDhYZ87flowRKdS6YBv2ZVDlqdTobpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/92] Revert "PM: sleep: Use complete() in device_pm_sleep_init()"
Date: Mon, 31 Aug 2026 15:34:26 +0200
Message-ID: <20260831133401.123840840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 2fe7ebb3d50c8571a9dbfeaf900f34f4c58f6bd6.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index dc3d30860ef32..ef5157fc8dcc5 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -101,7 +101,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete(&dev->power.completion);
+	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -238,10 +238,6 @@ static void dpm_wait(struct device *dev, bool async)
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



