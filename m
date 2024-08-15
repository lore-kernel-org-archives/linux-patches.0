Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF8919DF85;
	Thu, 15 Aug 2024 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731604; cv=none; b=RfNVJzCL7uMgOfgmFcaG5mn4CBn9LOUHRo+T46ZvKyyPK7JILB65oy1HwXhIRDEuVqlTdxJkjS59iPGeQpwb/G2RRIFvU88rDkhCFQaHOu2Mh2rtptbKxyYwBibZ0IQLNlOj5LvOdQSbBBkidDL3v+JL5Uf9G1GLYPZIKd8ZyQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731604; c=relaxed/simple;
	bh=i93hdX1UYNLzPeSSJ6xbJ9K+Fb5E01erLsPwC/dEeRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQUpyowXnijzBRM5nlM8/gCujlXLGK/f7yh7yVLyd4apZZ6R3SMH1fprEBGJj8G/kOdqfCu49dWyTil/rxO8cwWeP98jnFrzt/eMvFLaiNvvJd/LM3CmAJpIizMTELnVMkVyJPoLFqpkRLoMAk6dITs+zCjN7M/0D2lfiXWyUv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUheH34T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUheH34T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91CCC32786;
	Thu, 15 Aug 2024 14:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731604;
	bh=i93hdX1UYNLzPeSSJ6xbJ9K+Fb5E01erLsPwC/dEeRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUheH34TvxHRtLxzfyvfBslr9P40lCOSAQgfFb4rr/GMWzH3brmqYy/DlNa8G2Ivc
	 Q09ovuiHwQN96oD0y7wnDujCNJLqKTmXDDONbuRMd4qQSoDRKanvyw6EVkKZelVZYb
	 T/3mmpf91i4TjORynAjI27TW0sDvr4bBX6mYiahs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/259] driver core: Cast to (void *) with __force for __percpu pointer
Date: Thu, 15 Aug 2024 15:24:57 +0200
Message-ID: <20240815131909.117378583@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d7aa44f5a1f86cb40659eef06035d8d92604b9d5 ]

Sparse is not happy:

  drivers/base/devres.c:1230:9: warning: cast removes address space '__percpu' of expression

Use __force attribute to make it happy.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210401171030.60527-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bd50a974097b ("devres: Fix memory leakage caused by driver API devm_free_percpu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 0bbb328bd17f8..e8ad6a41ad4ce 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1112,6 +1112,6 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
 void devm_free_percpu(struct device *dev, void __percpu *pdata)
 {
 	WARN_ON(devres_destroy(dev, devm_percpu_release, devm_percpu_match,
-			       (void *)pdata));
+			       (__force void *)pdata));
 }
 EXPORT_SYMBOL_GPL(devm_free_percpu);
-- 
2.43.0



