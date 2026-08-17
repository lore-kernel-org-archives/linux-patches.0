Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2B93F23D1;
	Mon, 17 Aug 2026 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975854; cv=none; b=XxCg9t7YtBBGHR38XADINbwbtZyDOq5WK2MogpyMeMr8rE39jlO5XQdPRg7+03iDH516yn2AQMWMCPS8QzGu+vWrN1VTeeTqogbmhoSSZRGPAVx+/z2A5HnUvU+5lvl41ref2OG5LCA+g1lUEu3Wmw2TUAwjck/t/P2RUOCr/lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975854; c=relaxed/simple;
	bh=+R9TAbKJkB/952x2UecqKe7wZj2WeC2GFtU6OExzXrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnQSO0krFssS78M2ApYhu0/A2/3dUlMbfvR2RDgIv+DrHrgVGPyk9oh+tPlNseCRJiEK8L8di5PKMz4uq71f95AIj+1yv3W50PFUJZjuVnJ4V75GPB7xxhGzjEN16oFt9jq1fTGLK2hSI5Z4otTUGq/rF0yTDfsAdthu8pdjvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEPXHeCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEPXHeCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E0A1F000E9;
	Mon, 17 Aug 2026 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975853;
	bh=J0ozImhUhs3xJkhpYxMEPGWqkC+Lp2uPylH4T7k6duI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEPXHeCrZVPeLzpvBID21+BfWtRaTHG2kKYLp+7T/JFgxgEO08rIxsTBltnmLFziS
	 47D9SOmgWbdyyGDMUCoWNwmpJ6it2rO10IGOFnbaPUCW2KIiboZaF8DvV/ipZ3GZyV
	 A8GUNKYpaTg6tJyLqSkLIauTtvUiXkIraeuK8hyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungmin Kang <726ksm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 171/389] net: slip: serialize receive against buffer reallocation
Date: Mon, 17 Aug 2026 15:30:10 +0200
Message-ID: <20260817132545.844342567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sungmin Kang <726ksm@gmail.com>

commit ee7f9bb9320add61f7b367d7e6cd55e3a3a4d65d upstream.

sl_realloc_bufs() replaces rbuff and updates buffsize while holding
sl->lock. slip_receive_buf() reads those fields and writes through rbuff
without holding the lock.

An MTU change can therefore race with receive processing. An MTU shrink
can expose the new smaller rbuff with the old larger bound, causing an
out-of-bounds write. A receive callback which already loaded the old
rbuff can instead continue writing after that buffer has been freed.

Serialize receive processing with sl_realloc_bufs() by holding sl->lock
while consuming each receive batch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Sungmin Kang <726ksm@gmail.com>
Link: https://patch.msgid.link/20260718073631.1674-1-726ksm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slip.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -692,6 +692,8 @@ static void slip_receive_buf(struct tty_
 	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
 		return;
 
+	spin_lock_bh(&sl->lock);
+
 	/* Read the characters out of the buffer */
 	while (count--) {
 		if (fp && *fp++) {
@@ -707,6 +709,8 @@ static void slip_receive_buf(struct tty_
 #endif
 			slip_unesc(sl, *cp++);
 	}
+
+	spin_unlock_bh(&sl->lock);
 }
 
 /************************************


