Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D680B13D525;
	Wed, 19 Jun 2024 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801989; cv=none; b=G5wWVpIhh8tyYb4Rkgmq/doioNF0gXH20bxPmxt1ISRe1F7PkF8MEOwMBM6Wo5SbisPNdbUsmT/2au84OYkxlQNXhhfBLnL+1OzuRbIW0tmlpTXOO1uq39IGWs+NpGWXWWT7jIRp6sMXoPY+JHyUKfZXFm7dnEAtXveLbRjBgcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801989; c=relaxed/simple;
	bh=EAFshlkfAgINn8Hl6g23XmlT4/+ePKZb+1s0PqdR8ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jvf420xUE7AoNEbfN4Iyc7bCyaL0lHhhx22Gp4rLOIuxvYNBZkyn97EYsKUQbnypRYlLQ/y7USPbaKXEejHLKz03xTdhXhocG4GYW5RTN1wwk+BNqnbPi8HOsAxlvUXD4rV2pQr7wfVFzhad0mNdv4wsEYDMNWIEFXmYyGT97Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vYXWWXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vYXWWXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A812C2BBFC;
	Wed, 19 Jun 2024 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801989;
	bh=EAFshlkfAgINn8Hl6g23XmlT4/+ePKZb+1s0PqdR8ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vYXWWXC7BgxwGusYlf3qRQqiiXqpCuXkt+7SsH3gFJA6texZNLufQ4ap71DK9j8k
	 CIZ4gn/RCaW6dd94FUAeDLsT+Hrm9QtB9VIjR4JqdzuU8Lf/dl2StrOG2bCXyIchE+
	 P4qNhLWzyNh5g7/BaPI+BXTZDzjRz+zUvwWAED+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/267] ax25: Replace kfree() in ax25_dev_free() with ax25_dev_put()
Date: Wed, 19 Jun 2024 14:52:48 +0200
Message-ID: <20240619125607.018352607@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



