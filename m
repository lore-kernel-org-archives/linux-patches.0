Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D792117E90E;
	Mon, 27 May 2024 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836976; cv=none; b=lSfLUJ9LxOwV5sJlDURmvJdAWipm0NIl3uixZzka/+hQm0YVUBbK+LT2TsBbkQviuRM5s47nmT1W4jE6bF6k6A/j1QfGuGID9eiXAlhXjF36i9AZ4uPtkGlBSTq78dVlkYXXmukgx/UC8Y4qHUqVHW7+zqXn1R6RlaNuWVYU6RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836976; c=relaxed/simple;
	bh=5kNROnP1tn/wwrnhyaF4oNm9E0PQOidzaHmbhqhlXQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsDi+YOxCJDmshdLsgfRC78NkLTXniwIIy0pfEhntzIql6eZZuTebC15eFvdT7nMpAE4NDoOFIFOtGvfmHCk1iGiQbL/cbKni0jj9TNSrEhFAvB9E/4LYInQPCz071EjhzwSPvwxhIXnItyOuK6MoirfMb736dsSpnbwmmWadhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvOaydk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvOaydk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB43C2BBFC;
	Mon, 27 May 2024 19:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836976;
	bh=5kNROnP1tn/wwrnhyaF4oNm9E0PQOidzaHmbhqhlXQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvOaydk6NX7bGAHeDf8W107LL872LO9uk7zYiCXNdfGZ9YrqVUEUnPVkMQAK3Nqn2
	 5Luhtg8XvareYTWn3/pfG/j2ljaqKz8v/ZWAxp72rHYdh46fat7+1HjRgVBwhzAo0l
	 olGwLHDSzRFmpcwIadmd16ltNrAs3PQqQEM6AGJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 261/427] ax25: Fix reference count leak issue of net_device
Date: Mon, 27 May 2024 20:55:08 +0200
Message-ID: <20240527185626.811713120@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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



