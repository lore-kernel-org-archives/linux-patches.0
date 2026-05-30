Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C88395AEA;
	Sat, 30 May 2026 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160939; cv=none; b=GY4Pe4y+T6ZRdrDw/8J/DPlNBXqfq5tQ8yfu8AO8LpthqgUTRX6Dk/+ep1qcmlcuJBBXeX1GjjCCdlC9rcQUsSrjtw/nLRvH60zKFiNiU6hsXfJLRE4FiyEC7DNunIsm68K+oGaycahgv0xk62ANa8Rr8G7m1EwLR/jsFSlNLwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160939; c=relaxed/simple;
	bh=yRKH5P3J4N++Pa60Eb8LJtVfS5nh1k/XUJR9t5TVBPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdFpwH2zVWvcoAasNAXYHLWsCDtxyQUy4Jh5gISQqYr1S2eOUeLOLPeZIhoBhxwyxVlIB62Y9h64DN0WxuEph/5zKFKuNcUB+//twftm4RqLBTGa8m6fgx/rYX4AMPaozx8q92mZhl7tO5Y/pOEfbeTJBVQpekkKpdKa2UEk2+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgJZ70EU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgJZ70EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194671F00893;
	Sat, 30 May 2026 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160937;
	bh=h2QdRSMEgAYkeHS/R+fCj+/hB3ZsFe9lbmw4MLvqIP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgJZ70EU3l/aXPHqcRjuBzxQB1aS5aQsQZOUVXqssdKWUvkdMAfQa7lr7vFogXilU
	 R3Sat19qrFwLyllo222fx6K1jXcDWJeeXpuNmmoUTUpb9ppl4mowSU6luRzh565oQu
	 8CJCHq9F4wiU2fZFCKkXt7pcA4frk4kx7Pz7EZAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ecdb8c9878a81eb21e54@syzkaller.appspotmail.com,
	Mashiro Chen <mashiro.chen@mailbox.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 479/969] net: hamradio: 6pack: fix uninit-value in sixpack_receive_buf
Date: Sat, 30 May 2026 18:00:03 +0200
Message-ID: <20260530160313.527867873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mashiro Chen <mashiro.chen@mailbox.org>

[ Upstream commit bf9a38803b2626b01cc769aaf13485d8650f576f ]

sixpack_receive_buf() does not properly skip bytes with TTY error flags.
The while loop iterates through the flags buffer but never advances the
data pointer (cp), and passes the original count (including error bytes)
to sixpack_decode(). This causes sixpack_decode() to process bytes that
should have been skipped due to TTY errors.  The TTY layer does not
guarantee that cp[i] holds a meaningful value when fp[i] is set, so
passing those positions to sixpack_decode() results in KMSAN reporting
an uninit-value read.

Fix this by processing bytes one at a time, advancing cp on each
iteration, and only passing valid (non-error) bytes to sixpack_decode().
This matches the pattern used by slip_receive_buf() and
mkiss_receive_buf() for the same purpose.

Reported-by: syzbot+ecdb8c9878a81eb21e54@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ecdb8c9878a81eb21e54
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Mashiro Chen <mashiro.chen@mailbox.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260407173101.107352-1-mashiro.chen@mailbox.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index fe85cffa4f945..ac953fad5d8d9 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -397,7 +397,6 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 	const unsigned char *cp, const char *fp, int count)
 {
 	struct sixpack *sp;
-	size_t count1;
 
 	if (!count)
 		return;
@@ -407,16 +406,16 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 		return;
 
 	/* Read the characters out of the buffer */
-	count1 = count;
-	while (count) {
-		count--;
+	while (count--) {
 		if (fp && *fp++) {
 			if (!test_and_set_bit(SIXPF_ERROR, &sp->flags))
 				sp->dev->stats.rx_errors++;
+			cp++;
 			continue;
 		}
+		sixpack_decode(sp, cp, 1);
+		cp++;
 	}
-	sixpack_decode(sp, cp, count1);
 
 	tty_unthrottle(tty);
 }
-- 
2.53.0



