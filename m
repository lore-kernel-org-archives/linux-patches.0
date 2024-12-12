Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D421766D;
	Thu, 12 Dec 2024 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016412; cv=none; b=W2R9MEysPhUSngdgCioQiubbmEbY86aTb5Ki0bc1PqqIuQRrXsWLyy8vREbpjBeOqmro+/3I13ObHsKZkIqYvJP6xOSemepJCqYL7PbEfz5AitkJCZGa/pkCf/fn2uZf00v+/YEyT8xBLltL8FYLbtw24z6+w79dJDzPIQZPuso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016412; c=relaxed/simple;
	bh=do3tALeFNhB3hoiQvJM4Msfr4+GFTXHRtcjaD57IXdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GECUR+bKuOzJkVE3wbR9cWUPFmxeqN8KAmJwruXqCNDQOh+OpcC/1Z8FqRDV7rZHlSZ1Ui0iO3ePGgjtsnPd3RTS4grvcr4/2KQ3fw+yKW6ZG0wcof1TDYLYqHkKOYIqQL+Yv6SH8+HnBXQs0wI5QFY3pVR913yv/KJrUGBwUg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr9dLA8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr9dLA8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678FCC4CED0;
	Thu, 12 Dec 2024 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016410;
	bh=do3tALeFNhB3hoiQvJM4Msfr4+GFTXHRtcjaD57IXdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr9dLA8qHurOa9DGNumD2zEaFPkW0yThToCPYrWVPmsPQJNajqep+uQNuWEUSNPnC
	 +P1vUfMjpdjgkdP77qNyjjK1X0QBU9EXSHDbLEetmIDJ8Dpm3Yi9lIin1NcwzSIWGy
	 Ceci1LuJZJHyvLXgMsA14X3aEr1jgYJ5GVs7IG9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liequan Che <cheliequan@inspur.com>,
	Zheng Wang <zyytlz.wz@163.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 161/466] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again
Date: Thu, 12 Dec 2024 15:55:30 +0100
Message-ID: <20241212144313.159076739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1718,7 +1718,7 @@ static CLOSURE_CALLBACK(cache_set_flush)
 	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
 
-	if (!IS_ERR(c->root))
+	if (!IS_ERR_OR_NULL(c->root))
 		list_add(&c->root->list, &c->btree_cache);
 
 	/*


