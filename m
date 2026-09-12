Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6273F3285;
	Sat, 12 Sep 2026 07:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198113; cv=none; b=fwo5BkLDshMucu7qEPWOqkvRmrQQu02aZGfTH2FCQYxnoE+0IdT83yisXV3DiFySQbNtkOybGnzZivC/iemKlF5gDIaUZb6v5fLqBFH/0/PyzlX8yNNA4p6Wl+UfL3Qpht/IjoVaaiUo5VPTyGpoV3pvJhwtNkJdN/5xTci95S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198113; c=relaxed/simple;
	bh=onh5sD8RNZD5O7iuGPOuXKU4j0eeNgknmf10nw4yraM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGWQVmNARUjzYmNmMlu9gg8gLzvsyaq14DTKn5P16TIIcHsWfNY5BTu+yf3il+5VKHCdONtmrZ/jxSZetpVMTc993oxLSiJn/8tx6NMVa1f1kTMUIXlu9peZGCQn28KW/+pOhod8GoIfn4xzftKLufzVnI2TWqEM+8J1xaaS7pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x95TGXmz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x95TGXmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F711F000FF;
	Sat, 12 Sep 2026 07:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198110;
	bh=sPV/MXHdwMLsMO6FZiXGNHOz/hAqkdsV8ChDAitwTHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x95TGXmzdwkgo4quoWldANUGeNo5h0aNuTXUHS5zXiep8+uiHfCL1GM5N4aHZzan5
	 oAVFWbMkXH4vnCfCTo2XvWZDT3NV4ictcEAgFWCoRE8pcAXZCLTCb9+RfgHAFzkG3/
	 j1f8wRoip6IUBlBRRNdXirxNOtBARTakwnNvDRMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0311/1815] hwspinlock: propagate errno when registering single lock
Date: Sat, 12 Sep 2026 08:34:21 +0200
Message-ID: <20260912065656.246096365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cc8e952a67727..a509b73da190d 100644
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



