Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5B52F617C;
	Sat, 12 Sep 2026 18:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238572; cv=none; b=OQpfyfUvyaCHWH5M8ieuWSktC7G3c1XrqYAag5NAx2mbEVMJ+8sWZiwupfoNmph305uo9HidhGB24sYcgDxM26S4PItWQ99Lto5guV2rk9R3rGC4q2d8Awbg3clxCDmrJTmI+qSQvItxwuFkE7lDkWLZlk9OCGgiqgkcc0iiS2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238572; c=relaxed/simple;
	bh=P2HNbYFFniPlFo1wlI+f27LPQhHp1F2+f8SR1DVSpqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX5vPKT8j49xap1LfKIk/ow+FYkQqiANARstFtcuC+vxaM3aL5EUiPBswqXnV0VFFxxKdtGzqLmJfJes2daS2+jQXoZkEzaZisdsPjMz8wnP2dmCMgG9Y35FwSe97ZS3j/+Y9RQcCDjWABzBi49YKwESqohxqPfYFhdLlKgTxP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lofU88by; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lofU88by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56181F000FF;
	Sat, 12 Sep 2026 18:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238571;
	bh=GyQAR0I8E5BexAWbGjYvJiM1H93Tca0mdNaQKGDXSaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lofU88byhkkO6LnK2UqWg4b7apyRF6W1cbJeqmOy1tmU4Whm89pkat0H0qqCKaL49
	 6lchYwREgDuxK2YLDEtMXD/UcASielA2V/pzPuNZMlgHq3rGb5kZco3FPKTebtM2iE
	 chuNgEY00kQO+fzS2+Dl4BoCYxHVajkL4Mvk5/xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/935] hwspinlock: propagate errno when registering single lock
Date: Sat, 12 Sep 2026 08:58:37 +0200
Message-ID: <20260912065537.991009998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



