Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BADB1A00E7;
	Thu, 15 Aug 2024 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728895; cv=none; b=lHmfG56NdHntc3UWe5yy6HuJtmNQE0kMJ9PPVHwfqM8GT8R957TNP67kxmlBSxvoYTPvHPRG7hNxZDr1oWeRnl0VDOGubY1pmppTYRJFVVBQQkQhbVWGnz48hmiS1FH79oW43/YppMrXGbPHWRsXiDYWl75T6ZOT4wAUmGr7WRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728895; c=relaxed/simple;
	bh=gz5/ujEDqROsDHdjEP+2ugrqYZTfvqdO6mrmhrJmD4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsBM3u80rPH6fvEg5jkUrsQ0//wG+nN4yY5gNDqWm/5IxwKEFH7yFW7I57BlSjoLpKHKFolguqiZVsTa+yYy67u+GOgfOaZZX5Ka2LmnoetF+P0KFkYVHAWiiUDnTn6uW8OAFUtGa2z1ycaS1RdYhSeexBjjhrlH8znBFsPB7VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOM80XTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOM80XTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23973C32786;
	Thu, 15 Aug 2024 13:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728895;
	bh=gz5/ujEDqROsDHdjEP+2ugrqYZTfvqdO6mrmhrJmD4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOM80XTxq5VYYLahhtbsCynlQS3mnokz060Z06vc6SaccGaXE/RUa5dh+jRw/ptfA
	 d0w+/YV9UA7mMkguJhouacjPz9wIECWY/REsnSYOJIMVdawa8YcMkYVy7c6fqZcB1k
	 8NSjeV70rR4YQKgoKzTzKBmQL5BwIhQXpuawyK2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/196] driver core: Cast to (void *) with __force for __percpu pointer
Date: Thu, 15 Aug 2024 15:23:50 +0200
Message-ID: <20240815131856.403787659@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d68b52cf92251..7b4346798d5fb 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1058,6 +1058,6 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
 void devm_free_percpu(struct device *dev, void __percpu *pdata)
 {
 	WARN_ON(devres_destroy(dev, devm_percpu_release, devm_percpu_match,
-			       (void *)pdata));
+			       (__force void *)pdata));
 }
 EXPORT_SYMBOL_GPL(devm_free_percpu);
-- 
2.43.0



