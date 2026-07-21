Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C95635C6AB;
	Tue, 21 Jul 2026 22:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674162; cv=none; b=ZByFZjmfZS7Tx0gTVzzFNrCBOYZX3ubKszJpu8CUf8OezCC36P5na7D0vR4Xvi/mVsbANb6GoJnC0eu5XQIMk/5wkud8/DT1F/6f1cpFBoy7x5mC2GxwhqBnHtoFx9GjSPZIXP5tICMHGrOQULvXY5sT3XBMpZLOmQo/C07r/zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674162; c=relaxed/simple;
	bh=z3YoExNk4+50JvyG9LT5RckUFXRjFCysZaX6rNHKOfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2xvXkrdbKEP4KWrP9yBEK6q7lBSxoZMe/VgPlDYj+/vJmWn3FMQzKQ0Otv7uNJSmCwtV+x6JbhuZNyEpgyPydIgbjNBAToNvKtqr/qQh0zN2JEatToqxEwMkDk7A2NeN1VwU5nfhhRevDBF7iHji7vM038pYMDsDU7Kcm9AAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbQTqpXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbQTqpXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9351F1F000E9;
	Tue, 21 Jul 2026 22:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674160;
	bh=xhrJMOJchyVnvBbX5KAizhq5FitjJu065AHbVnWvXog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbQTqpXSAaJojTCe1Hb02/ToYwkjYc5cMTPGLwD5nkMrJrgCfZE9+6yCTxLlPq+pE
	 UtTLTqN56dlLLLLIwobyxCtOmH0vvQoJfAaE/bwZEA+dy6VnmPunELueJ5dkG1JkxL
	 ZW4duE2ZYTeZyAy39h9xW+c02kj2UzWWURVrWQRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 435/699] fbdev: sm712: Fix operator precedence in big_swap macro
Date: Tue, 21 Jul 2026 17:23:14 +0200
Message-ID: <20260721152405.507581903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

commit 5dbe5b65df0b0c0ec77492427c274b7b5011890e upstream.

The big_swap(p) macro was intended to swap bytes within 16-bit halves
of a 32-bit value. However, because the bitwise shift operators (<<, >>)
have higher precedence than the bitwise AND operator (&), the original
code failed to perform any shifting on the masked bits.

For example, 'p & 0xff00ff00 >> 8' was evaluated as 'p &
(0xff00ff00 >> 8)', effectively neutralizing the intended swap.

Fix this by adding parentheses to ensure the bitwise AND is performed
before the shift, correctly implementing the byte swap logic.

Fixes: 1461d66728648 ("staging: sm7xxfb: merge sm712fb with fbdev")
Cc: stable@vger.kernel.org
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/sm712.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/sm712.h
+++ b/drivers/video/fbdev/sm712.h
@@ -101,7 +101,7 @@ struct modeinit {
 #define mmio_addr		0x00800000
 #define seqw17()		smtc_seqw(0x17, 0x30)
 #define big_pixel_depth(p, d)	{if (p == 24) {p = 32; d = 32; } }
-#define big_swap(p)		((p & 0xff00ff00 >> 8) | (p & 0x00ff00ff << 8))
+#define big_swap(p)		(((p & 0xff00ff00) >> 8) | ((p & 0x00ff00ff) << 8))
 #else
 #define pal_rgb(r, g, b, val)	val
 #define big_addr		0


