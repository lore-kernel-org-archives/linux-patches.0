Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B600A329C6D;
	Sat, 30 May 2026 17:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163974; cv=none; b=smIA+J+kqcMY8fzT8C7QOliTxiPaSH7tkfddGtgcMwmmPNaa6jC07oQMyB5BzJUPJCVhk7v5tL3DEjMXPz+q1ZIee0/b8xoROib4YbmDavdKwVWHt5Y6PWY2UQEDtJgZgs/ApHKZQZuDPVrEJ9cqb3arF41eHJ6kE44/cPRn9Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163974; c=relaxed/simple;
	bh=y8BdBwJ5Z7RCcCqbIU23mp89OshsPqS4fEAlKj1in/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzxlWKWGDXAguwGaMtTUfGraDWvJOl84i7+eUEsBqzGZ/XsW7Rjzjz3vgNi7wWUBBgiYlL1pZcU0vjaywFN72+GPNPr+0r4K6jzGHFxBiR4YIUVLeu6/uUGFTtrL7jf1So11O9ZeWV43jzmNIYK6v3pZXc/YyQdylLBvJ/6Z2Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htCg+bGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htCg+bGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C517E1F00893;
	Sat, 30 May 2026 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163973;
	bh=AWNtkhFzFoOrbu8uTeb0Ucr0BmWZRscMK8uPjq56YFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htCg+bGvwDZagprRpgLEOepctzPhDRBlb6+XXVoTk/d5jODemqJbnRD/PApbd07xA
	 DShNdpyB7mjGAEVE/T5ZCZP7Nquz8UVvqDYfk0wzDUryxjCyISt38ySBjl2mikKC9d
	 GpxzcXe5n8pqPkR1co3B1CI/HMD/JQe0+pb4TVdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ecdb8c9878a81eb21e54@syzkaller.appspotmail.com,
	Mashiro Chen <mashiro.chen@mailbox.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/776] net: hamradio: 6pack: fix uninit-value in sixpack_receive_buf
Date: Sat, 30 May 2026 18:02:11 +0200
Message-ID: <20260530160251.248369371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7ccf56a7f0e0c..b0935a895f333 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -430,7 +430,6 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 	const unsigned char *cp, const char *fp, int count)
 {
 	struct sixpack *sp;
-	size_t count1;
 
 	if (!count)
 		return;
@@ -440,16 +439,16 @@ static void sixpack_receive_buf(struct tty_struct *tty,
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
 
 	sp_put(sp);
 	tty_unthrottle(tty);
-- 
2.53.0



