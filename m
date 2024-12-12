Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA76211493;
	Thu, 12 Dec 2024 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024666; cv=none; b=dTqDhblupoo19FvwywekkbZruZ/YpC2V/dvnxV0HGUz42pi1c5ELeWCBKkZK+91RRk6NmtR/xRXSVBdmhHfYRIOhH0AHtK5yqzzGruBf5bsgj9lwa2lDuANIas3O49PquN/swqyAnaOxt/lFSHpgaYR+cEljWVULuOt/RgoMqTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024666; c=relaxed/simple;
	bh=kdDdsBJ6czEk7gdEZlhpmIjgQ1rUBsjSTql2WvrWfQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h06HmW/zP4uimJJXFpjCHBVZgbNSOPf3XeFhfpF2DI4PS2BKn0Uw5+hz/Lcm93/g0NeTyUcay2e4KxqvDr4iRgXtaIiuMVQsfyKV27vTEWUSd8dZ1B+eewXjh5iDXQJ2CN7Yi1wXM1/cQsftXDl7qZyV0jLO9evnQItVDiffLn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJzXqGvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJzXqGvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A95C4CECE;
	Thu, 12 Dec 2024 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024666;
	bh=kdDdsBJ6czEk7gdEZlhpmIjgQ1rUBsjSTql2WvrWfQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJzXqGvUQ2NTSROD0VMl8w8HClBIh1irKZhfcySxUqZrgnBYOR5u5Cby76RPQ4GzU
	 Ss4643NBXP/mlu7RKzcQy1i9znCAx/+dytfmEpjuL+ulkFxylLArvN31ZwTgcCXEXY
	 vkB1AODtTUIM3TafgSvVbwllELnTkf0r1UThIpgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liequan Che <cheliequan@inspur.com>,
	Zheng Wang <zyytlz.wz@163.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 371/459] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again
Date: Thu, 12 Dec 2024 16:01:49 +0100
Message-ID: <20241212144308.325439166@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1750,7 +1750,7 @@ static void cache_set_flush(struct closu
 	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
 
-	if (!IS_ERR(c->root))
+	if (!IS_ERR_OR_NULL(c->root))
 		list_add(&c->root->list, &c->btree_cache);
 
 	/*


