Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C5B11717;
	Sat,  3 Feb 2024 04:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933936; cv=none; b=ZdWjnD+u88xG19DXIjP1283Ezw70/2i94mrlQSQA9TtV64G3YRPbAwDF3xnrn7JeF0I3kqXLtflvdGnuSsZuAgNI0Gh4z+k9bMC9xgSS4Kxf3LckQwokxbRsqEIN/WCvpQ0tLiWWittIkwjAZjo27l+KVHzVpO56vvZGviQlprs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933936; c=relaxed/simple;
	bh=8dRRkc/fwvIMRPxH3jB+PTBBVlK/NYentOKhxhvmKF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVtrFfWBscYBKAebxQ4coDsxkrIKzDSArsQ6g8ybqq/j1bFCmtxJBqky+QW51K4M6yWw/TD3kulvS8TfqJMrfa8XBJcAszo04whBXHHjNz0JXxQEVUU/d3UYXYwyVYHQknsZu3Xt2FK+iimqqKJWSv6v6w8W3lBITSauFIQXxRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAckoWlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAckoWlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE86C43390;
	Sat,  3 Feb 2024 04:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933935;
	bh=8dRRkc/fwvIMRPxH3jB+PTBBVlK/NYentOKhxhvmKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAckoWlZCmkYJ0N2cTz7XJZetkRcMC2TENvpT0SQc95K8gnws/lNFIfeoYdjfOLDt
	 YI5PMV0RXV+2PhgLa3x8u3GbsmACopYnNjYVJzxn2TqgWkF4tIxWMj7becpxDKyuNu
	 MkC6IQJnYf88GK3E9AOFB0MPjgwZVUc44ma7PB1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 297/353] HID: hidraw: fix a problem of memory leak in hidraw_release()
Date: Fri,  2 Feb 2024 20:06:55 -0800
Message-ID: <20240203035413.224119793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit a3bdcdd022c68942a774e8e63424cc11c85aab78 ]

'struct hidraw_list' is a circular queue whose head can be smaller than
tail. Using 'list->tail != list->head' to release all memory that should
be released.

Fixes: a5623a203cff ("HID: hidraw: fix memory leak in hidraw_release()")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hidraw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 13c8dd8cd350..2bc762d31ac7 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -357,8 +357,11 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	down_write(&minors_rwsem);
 
 	spin_lock_irqsave(&hidraw_table[minor]->list_lock, flags);
-	for (int i = list->tail; i < list->head; i++)
-		kfree(list->buffer[i].value);
+	while (list->tail != list->head) {
+		kfree(list->buffer[list->tail].value);
+		list->buffer[list->tail].value = NULL;
+		list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
+	}
 	list_del(&list->node);
 	spin_unlock_irqrestore(&hidraw_table[minor]->list_lock, flags);
 	kfree(list);
-- 
2.43.0



