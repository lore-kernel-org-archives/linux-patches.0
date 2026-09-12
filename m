Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A131C5799;
	Sat, 12 Sep 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226404; cv=none; b=Z1ZoKVB2pqg4n0Hxf0o+nZsiX/6+rszQbmYZhzb+tRowb9mdRfA4SuDKpwo1P4si+fZJ6AHNFA4oei49VxI2uNB8t6eG05oY7jg+DI6rx8c/20yDK6QI9snKGRsss3QoI/j6bm3bGNVoMU826IJ9zY/44J0UWulRtQjSjpfrA40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226404; c=relaxed/simple;
	bh=/Ms9HKkNn8DrDyulitWKCDHpMplt2uGAq9YCgaIVj6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmrdVbIAAbB0bDMLJxWU6FCk9KFg9bhab/SvdNgECGkxZ7IrdX4whkqF7GXl7uVUWB4iPhjTU8g+e0peNp8WSye9uzGN6bJWNS3ndOBN0rCTBWHeKzoezmpmkSohvSvgU0s5ehELBocCIuvq1k7LJvWMkVv7vm09EQtk3ODSjSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpiMf652; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpiMf652"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6A01F000FF;
	Sat, 12 Sep 2026 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226400;
	bh=///otZ1mZsvBMquGIRsxqoJ22qZSUSa96UGxo3NKwJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpiMf652WY3C+O8/SC+he9uXmhIdWCHJV2hSFpOcdgHGzzKmcNORDhi00rl660V8W
	 cbyJSEwrNNpI5g+mfQjl+Ef8CRrqjOp0J0EQxbkYCU7MjuUjafIk2HuCwZtBHD/l1M
	 oCYmJDWF8paPcY9dPGcX+4DvsuA+IRLX3skluL6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1393/1424] slip: remove slip_hangup() to fix use-after-free in slip_receive_buf()
Date: Sat, 12 Sep 2026 09:03:45 +0200
Message-ID: <20260912065638.457118353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 23c53269f2baaedf2d92784290cb9ef6db2a3bce ]

Jaeyoung Chung and Eulgyu Kim reported a slab-use-after-free read
in slip_receive_buf() when racing against tty hangup.

tty_ldisc_hangup() calls ld->ops->hangup() while holding only
a read lock on tty->ldisc_sem (via tty_ldisc_ref()).
Because slip_hangup() simply called slip_close(), it ran concurrently
with reader functions such as slip_receive_buf().

slip_close() unregisters and frees the net device and its private
struct slip, causing concurrent reader threads in slip_receive_buf()
to dereference freed memory.

Line discipline close() is already guaranteed to be called under
the write lock of tty->ldisc_sem during hangup processing
(in tty_ldisc_reinit() or tty_ldisc_kill()).

Remove slip_hangup() so teardown is serialized cleanly by slip_close().

Fixes: 5342b77c4123 ("slip: Clean up create and destroy")
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Closes: https://lore.kernel.org/netdev/20260825150655.1450271-1-jjy600901@snu.ac.kr/
Cc: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260826105238.3323436-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slip.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index a57b8387ab346..3e400349b7c8f 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -886,8 +886,6 @@ static int slip_open(struct tty_struct *tty)
  * Close down a SLIP channel.
  * This means flushing out any pending queues, and then returning. This
  * call is serialized against other ldisc functions.
- *
- * We also use this method fo a hangup event
  */
 
 static void slip_close(struct tty_struct *tty)
@@ -915,11 +913,6 @@ static void slip_close(struct tty_struct *tty)
 	unregister_netdev(sl->dev);
 	/* sl_uninit() has dropped the slip_devs[] entry by now */
 }
-
-static void slip_hangup(struct tty_struct *tty)
-{
-	slip_close(tty);
-}
  /************************************************************************
   *			STANDARD SLIP ENCAPSULATION		  	 *
   ************************************************************************/
@@ -1280,7 +1273,6 @@ static struct tty_ldisc_ops sl_ldisc = {
 	.name 		= "slip",
 	.open 		= slip_open,
 	.close	 	= slip_close,
-	.hangup	 	= slip_hangup,
 	.ioctl		= slip_ioctl,
 	.receive_buf	= slip_receive_buf,
 	.write_wakeup	= slip_write_wakeup,
-- 
2.53.0



