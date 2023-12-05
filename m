Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637186AA0;
	Tue,  5 Dec 2023 03:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG0ZmXP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDD2C433C8;
	Tue,  5 Dec 2023 03:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746371;
	bh=yShgrrSQzAINEGmpu8bfGaYsU339wZjTpVN0mDWkowA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG0ZmXP3g7CK4NxXFfCjUUJ+AASFoD1VgyMfpwLIuGsx1VqTpOgi1jrkWX0bZqW9i
	 ZbnNd4G6UIgYhlLvl9r6Nb6dv4MFlHQs2H9dhvSyf9KusMKOoemzKDqDSncuEr6j0i
	 Kq5Mo4sfWxx8JBgIh+RhMB4YpMbJ9W2X2ltDuqqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coly Li <colyli@suse.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 14/30] bcache: check return value from btree_node_alloc_replacement()
Date: Tue,  5 Dec 2023 12:16:21 +0900
Message-ID: <20231205031512.344244798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031511.476698159@linuxfoundation.org>
References: <20231205031511.476698159@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coly Li <colyli@suse.de>

commit 777967e7e9f6f5f3e153abffb562bffaf4430d26 upstream.

In btree_gc_rewrite_node(), pointer 'n' is not checked after it returns
from btree_gc_rewrite_node(). There is potential possibility that 'n' is
a non NULL ERR_PTR(), referencing such error code is not permitted in
following code. Therefore a return value checking is necessary after 'n'
is back from btree_node_alloc_replacement().

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc:  <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231120052503.6122-3-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1483,6 +1483,8 @@ static int btree_gc_rewrite_node(struct
 		return 0;
 
 	n = btree_node_alloc_replacement(replace, NULL);
+	if (IS_ERR(n))
+		return 0;
 
 	/* recheck reserve after allocating replacement node */
 	if (btree_check_reserve(b, NULL)) {


