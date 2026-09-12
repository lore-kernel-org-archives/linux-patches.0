Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7379C23BD03;
	Sat, 12 Sep 2026 12:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215184; cv=none; b=XIAzp+yIaf0wFed5b6x6U41WFxG61AZnFb5eJAYuySETxvRblOiBvAjzJgXnSnJrNLHxv0ZeTcbxM8N+zVRXx721vvVZgn+mxc9pPuG6jC946RlvwhTpw2BB8Z8LloK0tqQe9f1UbNKJlqGgDmrmCMMV5te5FOCariVLlwGD7Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215184; c=relaxed/simple;
	bh=yyWHSH9qNRoUMkEvXgYGMETc528bewoB/Satc/Stgy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsRkr6R/2IhOzKPqCprMcguQ8cF0RPPea/nQqZ/FZZe/UtQHFXRZLelWyKEZqxtmz++p5jW232DTabnLlEXEOG+g2/gjvKYRbBGW+UDOoNPKAqf6LumA0bVhLDJJD8QwKAYwNQAsfrz2lYW0Cfp8d4muoXTKyj1ELrZV9dLVkB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xw2EHO+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xw2EHO+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41461F000FF;
	Sat, 12 Sep 2026 12:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215183;
	bh=1+vZjPc8EjFUf1ZNMVDQ7z1xzQrb8Sjp/TCX0nvT0FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xw2EHO+P6ro/Jw31jPoFvzBOtIUvCEwJoJVp2EcRb0TrrGMeco5Gg6NJhqoqAMpRs
	 z8+CJGE3HVjhzWgMP4G7LlDcHr4ACcg68PzL6FUcmba5zgmm/uAcpo09uLk3S36yjL
	 9f7hHYfQ/+4wRC7THEMhL/vJmgyZN3rh2cIqIcMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0480/1376] hwspinlock: propagate errno when registering single lock
Date: Sat, 12 Sep 2026 08:48:26 +0200
Message-ID: <20260912065618.232169919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6505261e60686..b27a2e33a6117 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -472,7 +472,7 @@ static int hwspin_lock_register_single(struct hwspinlock *hwlock, int id)
 
 out:
 	mutex_unlock(&hwspinlock_tree_lock);
-	return 0;
+	return ret;
 }
 
 static struct hwspinlock *hwspin_lock_unregister_single(unsigned int id)
-- 
2.53.0



