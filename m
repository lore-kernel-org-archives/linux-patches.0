Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6E31EEF7;
	Mon, 27 May 2024 19:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838251; cv=none; b=X8y0e/0H2QnZN2T6bBoEVS7gEWzCnMqGwUzxSLExORgZ9AVqTQawuN6yPP7VaA/0cB7/gllxbxPYiLLKojbZoMQJA7C0KLCtY14p7aeegNcW7ssukzKhsz45Z4u9R8XmIgz61RQMUf4loLh5SsigmKAmR+gM50KKED3a31tOza8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838251; c=relaxed/simple;
	bh=Fo0p1+PxisyUQ8V6tiOS5ddmRzV8q5kIo6NaOdbNza8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQO677zFABqQYaPPkLmv1Cl1SjeB0N6+8Hvj9sbAwdhkI4sUjHSKAu+DvnHBDKYRt+ji/eAp9DQzK2RXvVl1lxUlai8UUHr0TObMZir9yh08QOtgivzQWJkQahub7BTVvagFYw1uOl7ghEbCCPuRt+T2AR0jGPzP3s0+Gs6BSbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0T2+EV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0T2+EV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28289C2BBFC;
	Mon, 27 May 2024 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838250;
	bh=Fo0p1+PxisyUQ8V6tiOS5ddmRzV8q5kIo6NaOdbNza8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0T2+EV/bH8oJk9TW5Jtf84LYrBXMOfkk9Rj95uLixM319boWcLLnwfFyiQ99lN2E
	 Z1HJ3H278X4KHjdsTYHpZsRDy3YZx89dMpVEM4XOHnPahQ694nv3TxO4vCkF9ugzax
	 hz4KuwGDsyjW1vmkZTzHsU8bpw4PmNbu6KTsbeTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 323/493] ax25: Fix reference count leak issue of net_device
Date: Mon, 27 May 2024 20:55:25 +0200
Message-ID: <20240527185640.835474924@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 36e56b1b002bb26440403053f19f9e1a8bc075b2 ]

There is a reference count leak issue of the object "net_device" in
ax25_dev_device_down(). When the ax25 device is shutting down, the
ax25_dev_device_down() drops the reference count of net_device one
or zero times depending on if we goto unlock_put or not, which will
cause memory leak.

In order to solve the above issue, decrease the reference count of
net_device after dev->ax25_ptr is set to null.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/7ce3b23a40d9084657ba1125432f0ecc380cbc80.1715247018.git.duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_dev.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 52ccc37d5687a..c9d55b99a7a57 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -118,15 +118,10 @@ void ax25_dev_device_down(struct net_device *dev)
 	list_for_each_entry(s, &ax25_dev_list, list) {
 		if (s == ax25_dev) {
 			list_del(&s->list);
-			goto unlock_put;
+			break;
 		}
 	}
-	dev->ax25_ptr = NULL;
-	spin_unlock_bh(&ax25_dev_lock);
-	ax25_dev_put(ax25_dev);
-	return;
 
-unlock_put:
 	dev->ax25_ptr = NULL;
 	spin_unlock_bh(&ax25_dev_lock);
 	netdev_put(dev, &ax25_dev->dev_tracker);
-- 
2.43.0



