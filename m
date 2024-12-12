Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8904220969B;
	Thu, 12 Dec 2024 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023210; cv=none; b=k/94EA75q6TZawGuB/F4kA3/qmF16bEB6u3+1/0v2AFRZpY5US4Kzkqbm7J3sKEz69wS+i96YhVLx+ZmDX1uKdxAta0td7PjrkOfUsG++SXmdV7Pcwz38gk0vdKzG+EHXKkkWLkIutlgQSGP0v6Ibp9xA4bzEAcPLSr41at/N5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023210; c=relaxed/simple;
	bh=DioWKRJF8g2BrprQAXlS+1neCiXulrLhFll5RU10Noo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnpFJZQulJBpTAnv6D54xXgSADIfMn7119HsKu8oQkI8tCfJZcnBul3bV6GbNVAEWtxwkVRJQ7PO2IEvSip9AX1vt1ogqpIKKSnrS0KW6Usf7y2eZiHUaDl9fw5c30yTF3ZBv1lTuuB8vbDTjZExQkRiueQt5v1hRK0NLuy6a98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0b+Cl/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0b+Cl/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDCEC4CECE;
	Thu, 12 Dec 2024 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023210;
	bh=DioWKRJF8g2BrprQAXlS+1neCiXulrLhFll5RU10Noo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0b+Cl/d/Tl9Ijkc0A+vOy1xyYXF7Hwfn1v+8pUhqjeCrDis6mqTQkCtXGCulJOEL
	 4CqcKPkOBVTfwehxhtUxtgf+bK7MBxiY1JbbuwD4W+dD4cMgbuYs/15m2ht0WVU5w9
	 77copvDQoHbPGgblCjl0hmVjt6G5BjQpmVJb0tBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liequan Che <cheliequan@inspur.com>,
	Zheng Wang <zyytlz.wz@163.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 460/565] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again
Date: Thu, 12 Dec 2024 16:00:55 +0100
Message-ID: <20241212144329.913861386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1731,7 +1731,7 @@ static void cache_set_flush(struct closu
 	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
 
-	if (!IS_ERR(c->root))
+	if (!IS_ERR_OR_NULL(c->root))
 		list_add(&c->root->list, &c->btree_cache);
 
 	/*


