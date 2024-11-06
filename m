Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990561DE8A2;
	Wed,  6 Nov 2024 12:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895127; cv=none; b=DvDDshey5tgr9ffEJWOgNPbak2DBnHEhStlzj9mwhyETh1hYuYDuCCaha3byUjbT9ODlJlrBJLG85L+OKu8WO/tgCP/DyvQfCnwVQDtfSBbYf0vpiVA44PLJW/krdNgpCputImL62wNfw3pIcS1KNsOvRF+hcoT+Jbl6gVhqZ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895127; c=relaxed/simple;
	bh=qyPkkL1N8G9nVKq8rD7TIuDAjWo+YkfD8VRxMMBUzGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP5gBOLyTZhoeTzQXOllBy11iRCb9WOZqOc0l8UQsr3Iw0W+Axd+uNwyqGn76UvLIq0FgtdA1uzAbx0jTnaYJBov9z7eFoxLi5+bkpDOnDtt1gQCudfTSMpeFZw5EldDStTawhsJDtKB7sNr9hRZ93BZK+3RAH1jELqYjJd22ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyaBlQ7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyaBlQ7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F13AC4CECD;
	Wed,  6 Nov 2024 12:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895127;
	bh=qyPkkL1N8G9nVKq8rD7TIuDAjWo+YkfD8VRxMMBUzGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyaBlQ7xNtwjW4X8GxqP2J2rDQePBPd77h3NZXgvw+krOWrKwhPkKOvlFMFAv0qDI
	 z4ZRaAb0z2g8WZ5jWfaH0yECG1qWnV1ivsQBsOfQmkAisUM1ji+yw49+38tnZbiiJR
	 0FTSFRAHDmnxkzivlOu5Qa4/TkPhYDiJsw6m51is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 114/350] drbd: Add NULL check for net_conf to prevent dereference in state validation
Date: Wed,  6 Nov 2024 13:00:42 +0100
Message-ID: <20241106120323.720134431@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -888,7 +888,7 @@ is_valid_state(struct drbd_device *devic
 		  ns.disk == D_OUTDATED)
 		rv = SS_CONNECTED_OUTDATES;
 
-	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
+	else if (nc && (ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
 		 (nc->verify_alg[0] == 0))
 		rv = SS_NO_VERIFY_ALG;
 


