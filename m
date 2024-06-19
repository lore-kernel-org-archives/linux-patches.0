Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156C4143757;
	Wed, 19 Jun 2024 13:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803516; cv=none; b=NBy2O87QCXnB12Ko3M9rtjXH6ciAqM76G0qiKTrv8UtYb6YSDABuMAmL+6LKd+B+RrokBUCYwWcksDQEkj9wdq9oQBy1QKNHf4SVHjdC0j4K1nR6R3RX6L5oWNFzIOmXn3wKiD+it+c21XZAYuHROEdQXfKfT+O63UJz7nXt1tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803516; c=relaxed/simple;
	bh=ywIOVuAcG6xaNACwb0cNTY1K1iLJrR+x/sNaJIKvXWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIgobldYvQgT+/X2IjPwL8+/Lwp24cNuf3szCLMVDX7oHoo8h56Q8/Fp+KlEyYaIEHwVCs91yz/nOm3Rk0k4yKL2vDrE7IdCCsnkRCpDaupUaSe2AxnVfwFWwGLv97v9kcNiL8jEpLq1Qu4yNe60Cq5Ww+vY3wVC5wUPDiBQWf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXjZzJ1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXjZzJ1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C0AC2BBFC;
	Wed, 19 Jun 2024 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803515;
	bh=ywIOVuAcG6xaNACwb0cNTY1K1iLJrR+x/sNaJIKvXWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXjZzJ1iUkaU1YQfBLi9QPbZSmgiOYsd+ovnjFZ8wnf/tcA+YkdvNEgXB94q+kfeM
	 JgCLuvlTHm52tm+rp1r7K9xSoqA3kTeUjH8pgwk+kZYuDzIYfVPBTsusiVy1ce+7gU
	 TWfI6mG3hIMfQEs936MKNvdeYsIfSDBRDVQh6D98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/217] ax25: Replace kfree() in ax25_dev_free() with ax25_dev_put()
Date: Wed, 19 Jun 2024 14:54:15 +0200
Message-ID: <20240619125556.980697995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fcc64645bbf5e..e165fe108bb00 100644
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



