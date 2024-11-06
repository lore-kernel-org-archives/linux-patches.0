Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2361C1F1318;
	Wed,  6 Nov 2024 13:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898192; cv=none; b=tosNhLI1PKt8BX3fYjAc2zWlZ8lRCsZ0I06HdrO17aSMlLCrC8ud8fMWZM9UQtdp9T00WqnQZAuFKVhG8SYk/swOR0vfCTUnwyiFGwC9awkCP5PuwroMRrBpGbVtFdzKKncJBwWyNk9uW9rx1VgK552RcGsGXPKEZsQjF9496qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898192; c=relaxed/simple;
	bh=3jebAbuE+DO8dLxQzvQzTT7O4Ycs5Yec6VK5ZX2EpLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuO1mf4ilFc2QCLRUgJfnYo9Wwta7yM8Xi3j5THyotI5OlN3Y7EkhxoejvoYA9Y9oLvYtHzqEG0sKi8DtnkO0boDVJO4Gt98Mk0CkEv2cTgJeqQzWfL6ji+MxAqxKOE5uFfA9X22xPVx1FuaOK1f6d41PsqPjFMZNJqMScky7SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWjt46t1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWjt46t1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB37C4CECD;
	Wed,  6 Nov 2024 13:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898192;
	bh=3jebAbuE+DO8dLxQzvQzTT7O4Ycs5Yec6VK5ZX2EpLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWjt46t1MklfXwXXbOaOn9lGpth6mhTU19pwamyiSfy+YDPA6tyt4CrrnJq6D7VSG
	 UaBPvZKK/Cbhx34fzfJYoZrRtQvvU6IFvGrprhYzO/xjvemjlb2zczlO4qTXwA/2ry
	 HVgRgTBiKp73rqcjgRT9mo+TYZO/fs8/XziNHZIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 148/462] drbd: Add NULL check for net_conf to prevent dereference in state validation
Date: Wed,  6 Nov 2024 13:00:41 +0100
Message-ID: <20241106120335.166426025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

commit a5e61b50c9f44c5edb6e134ede6fee8806ffafa9 upstream.

If the net_conf pointer is NULL and the code attempts to access its
fields without a check, it will lead to a null pointer dereference.
Add a NULL check before dereferencing the pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 44ed167da748 ("drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://lore.kernel.org/r/20240909133740.84297-1-m.lobanov@rosalinux.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -876,7 +876,7 @@ is_valid_state(struct drbd_device *devic
 		  ns.disk == D_OUTDATED)
 		rv = SS_CONNECTED_OUTDATES;
 
-	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
+	else if (nc && (ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
 		 (nc->verify_alg[0] == 0))
 		rv = SS_NO_VERIFY_ALG;
 


