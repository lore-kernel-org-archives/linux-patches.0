Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1DE1BDC3;
	Mon, 14 Oct 2024 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918426; cv=none; b=kOGcGcW7mgzweWZQqQv8PwaQQT8DXVjAuzJzusNEJxuOp9uAawML2aCGrR/HrFpBNMlGaVaw4BDHRjbsMrDFE/wRhih9Yf7Fd1k01wVmKYfpNDb1NfyOpDZnb7Fu3GGa6pKH6EmplKdhZWQEOQ4NL52BddV2S0z3j7raqEgbIdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918426; c=relaxed/simple;
	bh=rMPoDrOsKrKxxU0D/xV725KWvvLZOCVtCY6HgMX/5sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfciOg8aT5WrOaCRcmXDrdYPqAjkM4IBTJMLxEEn51VWcYwfM04c+7gobyhv+3SFzsiEmICwvMK6S+3BTebQ3oUTdzzAxKP508eoq15qfQzOwMk+HDsXTwTougioTdVAilHaz7k8+000967uEPqtuDP7Aaxxd9Swq4ljSUgi32I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lfx2XGpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lfx2XGpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639E3C4CEC3;
	Mon, 14 Oct 2024 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918425;
	bh=rMPoDrOsKrKxxU0D/xV725KWvvLZOCVtCY6HgMX/5sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lfx2XGpzfhfVGDIw1bVvcUmJWz7284kuOid8H17XafqEOV686/3seIgJD4JrACmQJ
	 FSDNuGEStLfJVL/Wo7it2JUSiMY+pxk6/39Yt64Z6HEfzD6s6DT6n4MbjHJujvPJkw
	 cKjjkX90i3jFgIG9E6Ke6D4bcziUeypyKO5w07IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 319/798] drbd: Add NULL check for net_conf to prevent dereference in state validation
Date: Mon, 14 Oct 2024 16:14:33 +0200
Message-ID: <20241014141230.487687018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
 


