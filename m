Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E11D12F5;
	Wed,  2 Oct 2024 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880402; cv=none; b=UGKAAK5jbMQGwfFNv1k+S+IaYhUpH1V/f8caBU2NyXhTFeetXcHt0cdgnUA715LWu+wzmeGlEk6Aq82yxkMdiyu68SeoFbdSfj/BFgWr1TZIlP9aRjpfDsAK/k3Jm2TYvuhl9XKTcAispIdtGmv5MfAs2A78BLpgt8Cqok9zX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880402; c=relaxed/simple;
	bh=HT6QLV+AY/5whHC8RogS+BlQFHL4akmd2KOwoJ1FydA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWXhZQTqfNHdoV3EgycMF2eB72TyWZmeCBBnNHuLc1qSQpf9ETBeRg4jmd16pcCRYRqQD516UoKADFKf4ie2mE6VQWmx3jRsMAl9BmeJeDf0lEVrWGwl7KDs8FTIdmTHvDjsFTw97y9iHxndo6mqpHlUTpyRg9JmP9fSLfy+Sn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy3Pr1jN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy3Pr1jN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF01C4CEC2;
	Wed,  2 Oct 2024 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880402;
	bh=HT6QLV+AY/5whHC8RogS+BlQFHL4akmd2KOwoJ1FydA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sy3Pr1jNdjWSvmo3tqVchXUdc8WLlfCske4nFM4O0grdlx62UiZus0TOMnkZUCjVN
	 AsbIEmf3kZsSFLcnWygS/njrE+hMZeESC/8dXXjvdNF8Y4HNMm6074oPzUEs8dFFXd
	 5+4y/6CYZ5kjaIdelAILBXxxTOdoI17xqDQf5kZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 447/538] drbd: Add NULL check for net_conf to prevent dereference in state validation
Date: Wed,  2 Oct 2024 15:01:26 +0200
Message-ID: <20241002125810.086373490@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


