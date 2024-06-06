Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E851ABE3A;
	Thu,  6 Jun 2024 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683302; cv=none; b=QtcKj+M+/UWbpjz3vvP0irex/53lSdk5dVuDkEFQdJgqnzijeXzoVon4azCclx2nQhZ6wxlnNEBvFJFitGx+uoFekzbYmNVvE5neHSXlfFiKl7YjviBJn8NNvsAfdHMcRTut90TVRhBFYynhR7YkB+AddNzk6vWIGUGDlZY85IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683302; c=relaxed/simple;
	bh=0vLShWbYH/yzkuRmbSG8y+ITUC31b/qqBv1LJBvaFJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyBwGDj4WBjEmKkT+P8W76XrIFMEYy48nYQNPAGMqDZxQHD7TjbRyGBlodKWHwPAtc6kqONle6r0BGoaN62JArlRNMkZqu6oeFmy0+CKe6skV2trdiJ9gGLm9Pbb91uh5Q+uqwOLohjyNhO1tp25qhtwv5Rt9KpphdCQoQGZrZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrS98yJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrS98yJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E13C2BD10;
	Thu,  6 Jun 2024 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683302;
	bh=0vLShWbYH/yzkuRmbSG8y+ITUC31b/qqBv1LJBvaFJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrS98yJ429iRbzXoayq4DUbI/w1fqhRUp7CIv8NRBNi9pS+htg0JguEf49XUIgPTI
	 R5BHbZTn4t/eTRXHQaCkvSUO6ru2+nuIm6AeS/2Z5Ir8/9E6snQL+yX8q+BLaqcAaJ
	 5uOO34dHYa3SjUSaZDFJkEw5JkwdkKifB9H1Wmtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/473] ax25: Fix reference count leak issues of ax25_dev
Date: Thu,  6 Jun 2024 16:01:52 +0200
Message-ID: <20240606131705.983215755@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

[ Upstream commit b505e0319852b08a3a716b64620168eab21f4ced ]

The ax25_addr_ax25dev() and ax25_dev_device_down() exist a reference
count leak issue of the object "ax25_dev".

Memory leak issue in ax25_addr_ax25dev():

The reference count of the object "ax25_dev" can be increased multiple
times in ax25_addr_ax25dev(). This will cause a memory leak.

Memory leak issues in ax25_dev_device_down():

The reference count of ax25_dev is set to 1 in ax25_dev_device_up() and
then increase the reference count when ax25_dev is added to ax25_dev_list.
As a result, the reference count of ax25_dev is 2. But when the device is
shutting down. The ax25_dev_device_down() drops the reference count once
or twice depending on if we goto unlock_put or not, which will cause
memory leak.

As for the issue of ax25_addr_ax25dev(), it is impossible for one pointer
to be on a list twice. So add a break in ax25_addr_ax25dev(). As for the
issue of ax25_dev_device_down(), increase the reference count of ax25_dev
once in ax25_dev_device_up() and decrease the reference count of ax25_dev
after it is removed from the ax25_dev_list.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/361bbf2a4b091e120006279ec3b382d73c4a0c17.1715247018.git.duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index a56d12fae464b..dd1d616dab367 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -39,6 +39,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 		if (ax25cmp(addr, (const ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
 			ax25_dev_hold(ax25_dev);
+			break;
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -88,7 +89,6 @@ void ax25_dev_device_up(struct net_device *dev)
 	list_add(&ax25_dev->list, &ax25_dev_list);
 	dev->ax25_ptr     = ax25_dev;
 	spin_unlock_bh(&ax25_dev_lock);
-	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -129,7 +129,6 @@ void ax25_dev_device_down(struct net_device *dev)
 unlock_put:
 	dev->ax25_ptr = NULL;
 	spin_unlock_bh(&ax25_dev_lock);
-	ax25_dev_put(ax25_dev);
 	netdev_put(dev, &ax25_dev->dev_tracker);
 	ax25_dev_put(ax25_dev);
 }
-- 
2.43.0



