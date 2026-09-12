Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA2F242D65;
	Sat, 12 Sep 2026 14:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223000; cv=none; b=kD1xTO1pLFGm+pHf5JP8/lcghsRp/t6Wh9xrIvCWFS9qXqxp//XefoCGqPI5TTh4wUjDGaBh3hU2Ucc94RBH1S9eAJMtLvLeZh0QfbcyHwfTVGK/pBqcHJF61I8bR62OkRYQ89WyL3uUnayCcSBujBFXJMZlYSYT6kbwc6o/51g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223000; c=relaxed/simple;
	bh=zhp0XfFA+A09PdPC9urdOgZHnFSoNIdxlHyTwm1MInc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9YRIoadYDqAdGgUKsfZjmllB/KlHj33RsDlWr9GRosNpbsI48ZB2VxlKO+R+1fPHXW0kd0ciLo5T/QbaBTaceyAYpxkFQ0YHnyCwyImeyQaqaq1ox7PiftKduWF1xhfviYpVhBHrZS7UguzvCN74LCqjQgcvNUCeot+zz/hf5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IejozytV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IejozytV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD91F000FF;
	Sat, 12 Sep 2026 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222998;
	bh=UfuN6mtCMatA8EMOYJkgkFNyD5fGKsNHBkkcpoitPVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IejozytVCVpshF4/V59UZEcj83HgIlhtWOsAHh0HkFCEo4h61WKROTUZhsFiqVQ9j
	 QudFBwm6dorflYUj/3lCxmOyzhxm39ChjSeQ7VSu8fdcYlMk+kn0NSi0gHHFWykaNl
	 o5ODp6wVBkDkjIfBkT1ckf6+wDh+mmOgc+pi0K0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0700/1424] hwspinlock: propagate errno when registering single lock
Date: Sat, 12 Sep 2026 08:52:12 +0200
Message-ID: <20260912065622.973868390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f279dd010b73e..c13f4bf73ffc0 100644
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



