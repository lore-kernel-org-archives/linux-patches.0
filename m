Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B970710A1C;
	Sat,  3 Feb 2024 04:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933452; cv=none; b=a8AxmnEByTQaKO+YG8J54mFDHG01ctNe4DZjJWcrcPnsAXqNK2NSCPK/QNtctk1ojasbGEFKh8ybpqeoEO13dgjQPRn3WzmpDoerCxM26Y9tnRQJx2441GXu8MTQ5WkhKFtuPof/ZTX02Q4GtAxgdzleseeDPVojrKJzRkTPewg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933452; c=relaxed/simple;
	bh=OqF6UHtXsoYhH4Q/9D6NWL/HEK1ysD6b3mZOo54+oSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yzu9fhW+39BJl5gQ3xeA9YSfklH4c2wcom/BwvYXiAxIcYMEXRaggcUwiLepQYr9LFXT+vbYsAM9oYhGTUnCL2LQjSkXkAtpUKH/nE0/lP1Wc+fl0sT1oHO4NUKGKV4mEve2Pfygkc/Qbumsd57j7aIqjEDSFo28o6u4Ify/o9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iamJzlts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iamJzlts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F49C43390;
	Sat,  3 Feb 2024 04:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933452;
	bh=OqF6UHtXsoYhH4Q/9D6NWL/HEK1ysD6b3mZOo54+oSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iamJzltsB+cCOOhuEOwmLSJdg6ph/9gCIR2dOzS3rnv1omvbbT1+p/AWL3ycIZASM
	 DhS0FZTZ+n/KOooiQiaLGYkI/d/Mk0vLQR94BlXccurxKwKG8FyVyNw2H3RJbd9ELv
	 /72DZWk30vMjyacvwAXGmHFcv4uxLp0Mqbcnesgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/219] HID: hidraw: fix a problem of memory leak in hidraw_release()
Date: Fri,  2 Feb 2024 20:06:01 -0800
Message-ID: <20240203035343.116208612@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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
index b617aada50b0..7b097ab2170c 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -355,8 +355,11 @@ static int hidraw_release(struct inode * inode, struct file * file)
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



