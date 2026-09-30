Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874961E0DD8;
	Wed, 30 Sep 2026 16:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785981; cv=none; b=ZyXqZ3wGeMvuwXILDo/rnTz2Hy/un+Je5swvLDjS/Wejk1bEojY4LfC25T+OlU7Gv7wA8PHjZ041u4NZUaSziYbCafm5+GcamPKx8MjDv3HnRr4Dfbqu1UdfFMBrwxR5Y0gU95JHJa1W3wkQs7JMpWmUoRSS/Tk0+dXgreQaR9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785981; c=relaxed/simple;
	bh=4nxJCpJSG5Sh2s299Gale3n4G0V6QAywdHx8elBNqHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7M4Hf5XbA9IHjjumlGU/BhgfAGcvKKMPYjwd66fMJdsR43T9INVU8FUsSnhv9BieVqcDEB9AuKJzv5MX0romTu3t1xa+w5XYD3Iy1OsMKavoU5D0EmOw9pWT7YJF0lDZ2QtbJb4Zm2IgVjVFJy9lKln44WR7qk33AAkTSwgDtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TdC5YOX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TdC5YOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9393F1F000FF;
	Wed, 30 Sep 2026 16:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785980;
	bh=xBStEWIQKkaXs5d2u3wOdb+MPF758R0G1uKBVIxQoUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TdC5YOXuon51G40tXRyTpsSYGL254NQOEHQsKmh9T2uyxel+a2BtB3bIzHa1ZbEW
	 yh3J4kdTH4rnI4Vg3Rv1qeKT7CI+KfYOnJuZOZeOndQCILF9Hu9iD7UgTeEt96r9Mn
	 08pnT+j/wD/WnqSkiUtOMi53Z6GBk95o/ECSLRxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bd317784d628820741b5@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 701/982] RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()
Date: Wed, 30 Sep 2026 17:23:57 +0200
Message-ID: <20260930152431.815396102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

commit 33fb59da49c4c3f5c2ec9f9d4447a56857a02c02 upstream.

iwpm_get_nlmsg_request() initializes refcount _after_ list_add_tail()
making it accessible to global list where another CPU can kref_get()
on nlmsg_request causing a refcount "addition on 0" bug. Fix this
by initializing kref _before_ list_add_tail() so refcount for
nlmsg_request can be incremented/decremented normally. In addition,
also initialize every field before list_add_tail().

Reported-by: syzbot+bd317784d628820741b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd317784d628820741b5
Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Link: https://patch.msgid.link/20260904131437.12917-1-jeffinphilip14@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/iwpm_util.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -314,10 +314,6 @@ struct iwpm_nlmsg_request *iwpm_get_nlms
 	if (!nlmsg_request)
 		return NULL;
 
-	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
-	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
-	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);
-
 	kref_init(&nlmsg_request->kref);
 	kref_get(&nlmsg_request->kref);
 	nlmsg_request->nlmsg_seq = nlmsg_seq;
@@ -326,6 +322,11 @@ struct iwpm_nlmsg_request *iwpm_get_nlms
 	nlmsg_request->err_code = 0;
 	sema_init(&nlmsg_request->sem, 1);
 	down(&nlmsg_request->sem);
+
+	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
+	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
+	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);
+
 	return nlmsg_request;
 }
 


