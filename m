Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF08F26ED46;
	Sat, 12 Sep 2026 19:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242463; cv=none; b=JZmMPtu5EOT1EZ41y0fL+P8DOujxOUgbwU3cbfr8lYGhMH7lGwd/fekEX28215U4Ojoywm0cmV82Wn7MTMGBWbpzISgsnR4qGJpxWorikhiQtoS4w21qB4GRg1LRJgdXAJKMvyMac4Co8v4wycx+S4VPzmW13QMOfxTBS+X5UIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242463; c=relaxed/simple;
	bh=c0Qx4r0dvu0IYWGF8BWnxPVMipiNtzUWPRNGAPZitcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5o5DmqZSqk4GXY/R+C1FjVSk1i2HOvvISNh87EMbL9QmqmmObUJW3JBBec87dvPpEFt7kz6YXCl8H2ulQNa8cOekXqwQVUBuXQ4wP779gX3jUMAxmPjKjeC+IleQYudmZLWUbHvCO6zvvpELKC+iPSpRPdOkeWjNeX+9ec9PMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qa4FqzDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa4FqzDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382B11F000FF;
	Sat, 12 Sep 2026 19:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242461;
	bh=WM2NAPHfBpivRk9P2qPIU4303c+E0dEYxzG0YzjkaeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qa4FqzDJsJXyhWB2PP73nBN31fLvxwjc+ajHMvQFtuO+A5vFvVhYKWGppq3l50U5c
	 Qm6PowKjCHxKp70pSFmP7qWcOHzOefjYTGSTvEeOuLkXUeH3+gkk0EZef5AHwBAq0E
	 PLVoV5bEW8RCW1zk3sD+hpDWtv0n4DLzCgqAzm/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 411/798] hwspinlock: propagate errno when registering single lock
Date: Sat, 12 Sep 2026 09:00:39 +0200
Message-ID: <20260912065526.572187382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit e088ffa9a00eaaaf90da74763e774ca160969c26 ]

hwspin_lock_register_single() always returns 0 despite checking the
result from radix_tree_insert(). Propagate the errno to make sanity
checks in callers of this function actually meaningful.

Fixes: 300bab9770e2 ("hwspinlock/core: register a bank of hwspinlocks in a single API call")
Link: https://sashiko.dev/#/patchset/20260319105947.6237-1-wsa%2Brenesas%40sang-engineering.com # review of patch 14
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20260512084856.30497-2-wsa+renesas@sang-engineering.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/hwspinlock_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 425597151dd3e..ed02ba245d460 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -468,7 +468,7 @@ static int hwspin_lock_register_single(struct hwspinlock *hwlock, int id)
 
 out:
 	mutex_unlock(&hwspinlock_tree_lock);
-	return 0;
+	return ret;
 }
 
 static struct hwspinlock *hwspin_lock_unregister_single(unsigned int id)
-- 
2.53.0



