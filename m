Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADFE1C07DB;
	Tue, 15 Oct 2024 13:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997609; cv=none; b=kG4NEZhPaiT59O9TTj6Cirbbh3WNqM9nHextWndLZGmnNQ0zfFZx7y7nsadqwIhAoHo/NqrkINJyxk4w1NakjyZdZbZRJ4SNfC4q0Oh9jSrcLv+Yok7y/9quMg6W+fxBNBKZk2trW9XMVkcbodS6M2BM/ytTmDJ4aRuIiPPB7gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997609; c=relaxed/simple;
	bh=bmjDflcShSPyufruBSo7fzJKtLVc7tEDJEHsJ7N85kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pW43py1km8nqY0rQPJRjBvqU24sHRmgOJuZYmAOJK9hrzcSpY30tCqYPA67h9qqxy9n/HhJ+gUl14DFf9vzloQ7XIubzxUMdFIyDUFM78xgS62eaW5QPQWRtoI9pe37K/ZF2ZbyK5qVh7Sz8PcMgxRuWd6vKvLwUMKHNgt4m//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKLihY3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKLihY3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C792DC4CEC6;
	Tue, 15 Oct 2024 13:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997609;
	bh=bmjDflcShSPyufruBSo7fzJKtLVc7tEDJEHsJ7N85kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKLihY3bHOj/HO+D3X3IYOzAlRWoOLaSxab0RuTRkpbj17w2CgHMENi7u+ExNLrOD
	 F22N1D90qtGwAjUSBZoiJfd/Ga2pehE9bjvt1IUriyChsAtud1T2HB8cXkk1pU7vEl
	 ZCMzsWc11lON1+5hr/CWVc2/IWM0mBTVrcMbWVGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 232/518] drbd: Add NULL check for net_conf to prevent dereference in state validation
Date: Tue, 15 Oct 2024 14:42:16 +0200
Message-ID: <20241015123925.947478001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
 


