Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF581EE033;
	Wed, 17 Sep 2025 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112954; cv=none; b=jjYqzwBzCnVRkG9X44ywFQBnEGPZslEWFxsoCl3SqmzCckrEWo0Sirmmi/12GzyWjhduB7rrw71X45NzM0xl0FGMHsGMTfwxbwtnfLC8tpfwkt3oAjyaZLyxjgDmoqHTc3GimhlMeSts18aY5XQhnoLb9t5znMDS6ql1zkrmQwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112954; c=relaxed/simple;
	bh=yMTyQ/OtBTkuGgaYrMVVKnGneT9B/c9u3QoQMbEkaLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeLvooh+m8P14ILHqWnkwFWIeX0QWBpNjoZLWVYJA9mAAklW9ZJKNVW8a/UeOR2C6kbj4lVhNmc0du5Q+08YTDp172iiQv/1didb/aqcNcceKZ7UAt7V2PIKIkQyZeKNEr66apwrK0Lm8l0AOPJFrnBUKv3HKuoxBXSLEbKl9d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPQtIJl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPQtIJl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F95C4CEF0;
	Wed, 17 Sep 2025 12:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112953;
	bh=yMTyQ/OtBTkuGgaYrMVVKnGneT9B/c9u3QoQMbEkaLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPQtIJl1qYvin/1U/9xGn+VFDN52uz2ThqjghgRmIBxflYcpvfZd8OlNC4kGObsMz
	 Idj9AKq0e/qMJrmnMTzlCo/cNKPhu5fGtPkBNPDAvLhIHwg5KrPjOv6crzLPRLYNmv
	 uqBMheXP3Da9oEljUNjl/rfzaiXQ3GuU2U1XvLys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.16 126/189] drm/panthor: validate group queue count
Date: Wed, 17 Sep 2025 14:33:56 +0200
Message-ID: <20250917123354.937446802@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit a00f2015acdbd8a4b3d2382eaeebe11db1925fad ]

A panthor group can have at most MAX_CS_PER_CSG panthor queues.

Fixes: 4bdca11507928 ("drm/panthor: Add the driver frontend block")
Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com> # v1
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250903192133.288477-1-olvaffe@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index 6200cad22563a..0f4ab9e5ef95c 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1093,7 +1093,7 @@ static int panthor_ioctl_group_create(struct drm_device *ddev, void *data,
 	struct drm_panthor_queue_create *queue_args;
 	int ret;
 
-	if (!args->queues.count)
+	if (!args->queues.count || args->queues.count > MAX_CS_PER_CSG)
 		return -EINVAL;
 
 	ret = PANTHOR_UOBJ_GET_ARRAY(queue_args, &args->queues);
-- 
2.51.0



