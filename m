Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB7C317145;
	Sat, 12 Sep 2026 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229361; cv=none; b=XSpx9WJhlgIAts8ldJUSXe6S5Ay3GVB+HKk13J246QA37nOQMFIdTQbzhFQ01HWj+gN5cdi6rtnX4yQjAaUOwFk/6MzSjHwJNwmFHpGMSEeBt/rLVQCYqdW1CNC6B8S2qd4b4vZZ+GmEYVIkHy8dBsNP7JIgWXiZ9ukXxuhUNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229361; c=relaxed/simple;
	bh=+ASILvn5ywPz4/6ws8r7hY3ml2pPWl1OngUj+hMDQt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXd3f8lyYevl58fbtgIZGPYKtyN32+YKJalgtD++hVZgta8U1NoiA+F2UpaaAoJUUn/9hTi+ZtLY2VjNI7pQdOg6baouYVl0/j7VqjrGorfxOtjA9BKKsA92qIgVkSH/jlktzsOGl7mKc8geZ2E4jyPTID7mQsSXqzUMEOdzxCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILQbO99n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILQbO99n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB661F000FF;
	Sat, 12 Sep 2026 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229359;
	bh=DxXg/75Nz0uZ/px5lriPXGYb1V/LdvjNJjeKurnOG5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILQbO99n3xZsV2/XOSQJM3QGFs4wASvJF7WiUtaAxq8F2TVy83B6fq362XxWf1zJW
	 UVvY0f9lsVcKsao+NVIaxLi4p1YXtIX30y4Lj0Z06I+r98DhiHN/LZSwBPZ9vUcDmZ
	 asgKoBMH5dEE8UgVuUfBFvIP7SOzzUXAncnh2W0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0574/1191] hwspinlock: propagate errno when registering single lock
Date: Sat, 12 Sep 2026 08:55:02 +0200
Message-ID: <20260912065601.138642492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



