Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F96139579;
	Tue, 27 May 2025 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365746; cv=none; b=o90hbszE9DUKOJiDMjKXWjgJJl2WownKtJbjUZSHnvC1Ffk0g6c81hBvYx59vwZtRYFEaAD2cmp5z5FFw1aMHMbT35xS9Be/ik5aeVYuB0wnFdkPxykM+P/hJmdfe3w38dgnmBHmyNgivL6XizE7wa06q2/0kKUze8CD/vPSrSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365746; c=relaxed/simple;
	bh=7xkU43q8ZhCTZiF+Z0BgGYee+Yf2p8M5E1ZEvD06dw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOMCK/jHjrJf2EECqQiSUgHE96k/raT6tTHtMg4lveK1JuMPUxGTu6b9psZBmxCZdlb9JdHHZnULKFvtN3bRkscRFXQjEEtKEIFQw7bGf2G278tR2xpGr3vjN89Cyv4bTLrmPucUBVUiOA7tdp53usW6Nkmu8p3SyqfdTy4QQMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THLSbKkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THLSbKkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28315C4CEE9;
	Tue, 27 May 2025 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365746;
	bh=7xkU43q8ZhCTZiF+Z0BgGYee+Yf2p8M5E1ZEvD06dw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THLSbKkVjCP8eSa9/q/LKyapEG0Ibao/XeB8GiN/8jFlpsjpJ02XRUl36+hNXayXF
	 hvKCsjZmoGNzScpPSYb9jyoHryy7Ct26XmrbM9tPJ8zJqREL1Us/Q/yXrYhh/4+JOb
	 1J00GtmPQLxxuISSuZuLpZE0zZ4i1KpCTkjyq6xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 474/626] dm vdo: use a short static string for thread name prefix
Date: Tue, 27 May 2025 18:26:07 +0200
Message-ID: <20250527162504.249517357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit 3280c9313c9adce01550cc9f00edfb1dc7c744da ]

Also remove MODULE_NAME and a BUG_ON check, both unneeded.

This fixes a warning about string truncation in snprintf that
will never happen in practice:

drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
    "%s%u", MODULE_NAME, instance);
     ^~
drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
  snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "%s%u", MODULE_NAME, instance);
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/vdo.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index fff847767755a..b897f88250d2a 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -31,9 +31,7 @@
 
 #include <linux/completion.h>
 #include <linux/device-mapper.h>
-#include <linux/kernel.h>
 #include <linux/lz4.h>
-#include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -142,12 +140,6 @@ static void finish_vdo_request_queue(void *ptr)
 	vdo_unregister_allocating_thread();
 }
 
-#ifdef MODULE
-#define MODULE_NAME THIS_MODULE->name
-#else
-#define MODULE_NAME "dm-vdo"
-#endif  /* MODULE */
-
 static const struct vdo_work_queue_type default_queue_type = {
 	.start = start_vdo_request_queue,
 	.finish = finish_vdo_request_queue,
@@ -559,8 +551,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	*vdo_ptr = vdo;
 
 	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
-		 "%s%u", MODULE_NAME, instance);
-	BUG_ON(vdo->thread_name_prefix[0] == '\0');
+		 "vdo%u", instance);
 	result = vdo_allocate(vdo->thread_config.thread_count,
 			      struct vdo_thread, __func__, &vdo->threads);
 	if (result != VDO_SUCCESS) {
-- 
2.39.5



