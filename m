Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CF52153EC;
	Thu, 12 Dec 2024 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025707; cv=none; b=rxwb1D7K8Xi02DvGPdfqIdr29JaJA/F1kLsHYd+WxqCsTk6f6ymuSpwHl9Vc6q7BWXENtZOJ+7N0aoOfsmSN/28Esc+zqgGkzAijbd5dqP0hE8rtfP94GhT2mPcEfk4+e8jo8xFoDharOkWKGihHdegSf64R5M0SvJeScwDKXFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025707; c=relaxed/simple;
	bh=kRNJWKsKt6yB9wbndhdlr810TuOS2eQoAay3h/itdYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsVo7T0Hmd+UiDa3zkTN3Z+XP/2cGVEhsF60OMS4BzXwLm3OXf6l+zhPDwyGBaf6+Vi5C5mT4Rlhj2anKPy+E7AhwUCB5LkztCO8QdtkkF93XvQXSYH21kyOc4AwOFkTlDzHbh4Vrr+rBL5cIEeXqv64j9Gz/kbbylglno9ZMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qs7DtRkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qs7DtRkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9F2C4CED0;
	Thu, 12 Dec 2024 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025707;
	bh=kRNJWKsKt6yB9wbndhdlr810TuOS2eQoAay3h/itdYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qs7DtRkLuwgr0WRPdfuGpQ8pS2LA8FvCC1XgZ3mv9SUDf5ihRvOq/mjkj7w9gETm2
	 RNV+eHDOxrWzagNpXKzisbtVs/17V2QA4ttCn+MhmJ1EL2KYKGmdQMmi1eYXYL8fzv
	 F69CzKphf6+xO4HIpRt0D1zNoSv/hrpHr40sL6Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liequan Che <cheliequan@inspur.com>,
	Zheng Wang <zyytlz.wz@163.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 260/321] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again
Date: Thu, 12 Dec 2024 16:02:58 +0100
Message-ID: <20241212144240.236574744@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liequan Che <cheliequan@inspur.com>

commit b2e382ae12a63560fca35050498e19e760adf8c0 upstream.

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") leads a NULL pointer deference in cache_set_flush().

1721         if (!IS_ERR_OR_NULL(c->root))
1722                 list_add(&c->root->list, &c->btree_cache);

>From the above code in cache_set_flush(), if previous registration code
fails before allocating c->root, it is possible c->root is NULL as what
it is initialized. __bch_btree_node_alloc() never returns NULL but
c->root is possible to be NULL at above line 1721.

This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in node allocations")
Signed-off-by: Liequan Che <cheliequan@inspur.com>
Cc: stable@vger.kernel.org
Cc: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20241202115638.28957-1-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1635,7 +1635,7 @@ static void cache_set_flush(struct closu
 	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
 
-	if (!IS_ERR(c->root))
+	if (!IS_ERR_OR_NULL(c->root))
 		list_add(&c->root->list, &c->btree_cache);
 
 	/*


