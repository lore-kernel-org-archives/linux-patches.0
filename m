Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65BC14900C;
	Wed, 19 Jun 2024 13:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802721; cv=none; b=JzDKeykNeG4FElE/q8p0akbs6CtV/XKcNBvu1s4KB0Kl6+e69nRM395zFdE/sQsG1aae8f4EpMdsRPnfvyRAlINnL1AXxN++mWxYrS58r4IwI09nw6e5pdLJ78hVVsU66GK5+AFkxBsKy5Cqo6MOxRKAPwA2u00YS2jhjupVGa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802721; c=relaxed/simple;
	bh=b9+ABTiVWp6wQB314BiGHdRqV0Aix6XED05GTzI4q5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6a2iwYfYclVMsvlB8ED228gwQEx0BgGKwLKo9bnjksDSNcyrmYp2pVaHL2kRKqPt8+xADevMKivfjAwpxwtDfTT5GTwB1w4NPuEydgN8SHaG/Y8LgrT0Lxa1qPQIvovfosIJGAvDi6Bona3JkVqJWMDjGv7gUgRF6oPXw8AZAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYhEeHIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYhEeHIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4425C2BBFC;
	Wed, 19 Jun 2024 13:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802721;
	bh=b9+ABTiVWp6wQB314BiGHdRqV0Aix6XED05GTzI4q5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYhEeHIntL7vm7gJWwS083IV+euyQKHp5glYojOMbWJfpRbRicqiTZmAfh5wppV3a
	 2MTb55a7IwbMJoFJyhGZPlvU992fQRg21h1jP0BeLa9p7Qceqse6cf2HDgaEPlvGYl
	 qJndnbNL02QGphcuUxLRFkzarK9lgLSbmnqhvQOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 025/281] ax25: Replace kfree() in ax25_dev_free() with ax25_dev_put()
Date: Wed, 19 Jun 2024 14:53:04 +0200
Message-ID: <20240619125610.815244267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 166fcf86cd34e15c7f383eda4642d7a212393008 ]

The object "ax25_dev" is managed by reference counting. Thus it should
not be directly released by kfree(), replace with ax25_dev_put().

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240530051733.11416-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index c9d55b99a7a57..67ae6b8c52989 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -193,7 +193,7 @@ void __exit ax25_dev_free(void)
 	list_for_each_entry_safe(s, n, &ax25_dev_list, list) {
 		netdev_put(s->dev, &s->dev_tracker);
 		list_del(&s->list);
-		kfree(s);
+		ax25_dev_put(s);
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 }
-- 
2.43.0



