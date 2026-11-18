Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047677;
	b=EnQSf4jjeVfYmYFsnfc+QEbk5rx11Wq0nXxF2aVEnKW53IFXGYcud7HCBevksKoGbuKD
	 wwJ0NUKsdNrSJ+89BA1nORH3ORTU1Xz1noftZ8FKW8/QB5CqX7VfFU5IVjsw4gWOU3GXU
	 uWyXEnC4oqoy/PRNkesWdPCtr74sRYKji4IOk0yYR7h0QQtMwJ53Q7HNSFuhqZFv+hQVv
	 2cpRh0D3H3oyZDO17sd9TKFrdHUDzTszvbwSzwJbNjrdpDhE7oHuL8IIcchOwN6ros6EA
	 CujUEyrkPjAKYxPhqnqcgfby4PjE8T5JlAFlFCXVLiNO9EAnOWBEK/btyn/zwnk7YMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2XKnXP5wOewRxU5DrjUAlMM4VPhR5bzOijSTw+kx+so=;
	b=th4Io0Vn+gdoP1ktzOMb0P0qu+IqxHw5UlP7vpmpcki5jWtaikUKSO2blROGgFMxuuDP
	 PjDuk0l9ty7nt69tUA9RhEcKiB2ROJTxrBbrjZrpXuHxAboprskcbt+GzJ571Ph30kv5n
	 Llo4FdTVO2hcDJm1tcKYeDJCeyeJRP3QUndFuGX7tjD832gxKaNvnKsPev2d4884cJU1q
	 ZF1CIXrzRuWP8qEdifmvbJqcQALL0ZquIkrR9kqoEuu52wIZ7i0COPqMNZC3UJ9vHyrP7
	 IuyHg/qF1ombIXIvhyqPgWpurO3lgnwLvGbvH1f5ok26XnEEza13qPltn43D3c0yqkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGR0HYa2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97805606A32A;
	Thu, 19 Nov 2026 00:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGR0HYa2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D121F000CC;
	Thu, 19 Nov 2026 00:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047677;
	bh=2XKnXP5wOewRxU5DrjUAlMM4VPhR5bzOijSTw+kx+so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGR0HYa2AYQIWEHiPgcZ2EAJWnCDsz8bmAeZaWN9oYV/aVYyOMnBVBRTDSEWVt0K8
	 VJNaMQUakz3dS+vpobNUW52hClU3UI6EqnwUeXts9tXDb2SaM9ETwHSd7D2yCLCesU
	 WXtrfd3JmtIOVNkWi7Zg/yNqoUIY1qihUsKujq3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1722/2857] comedi: dt2811: fix shift-out-of-bounds in IRQ check
Date: Wed, 18 Nov 2026 15:45:56 +0100
Message-ID: <20261118150303.323573368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 471ce96a9c415b8a67bd5081ac2089a458cacc2f ]

The IRQ number passed via comedi_devconfig->options[1] is a signed int
that comes from userspace.  The check `it->options[1] <= 7` does not
reject negative values, so a negative IRQ number reaches
`BIT(it->options[1])`, which is undefined behavior and triggers a UBSAN
shift-out-of-bounds warning:

  UBSAN: shift-out-of-bounds in drivers/comedi/drivers/dt2811.c:570:31
  shift exponent -251 is negative

Add an explicit lower bound check (`it->options[1] >= 0`) so that only
valid IRQ numbers 0..7 are accepted before the shift.

Fixes: f2975a9b2ab9 ("staging: comedi: dt2811: add async command support for AI subdevice")
Reported-by: syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6ab21240.e548f532.1ca396.0018.GAE@google.com/#R
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Tested-by: syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com
Link: https://patch.msgid.link/02c46315293a26169d2a3862a2047959a1651ef4.1790061387.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dt2811.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/dt2811.c b/drivers/comedi/drivers/dt2811.c
index c2ec5e4fb689f..c422317ef1398 100644
--- a/drivers/comedi/drivers/dt2811.c
+++ b/drivers/comedi/drivers/dt2811.c
@@ -566,7 +566,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dt2811_reset(dev);
 
 	/* IRQ's 2,3,5,7 are valid for async command support */
-	if (it->options[1] <= 7  && (BIT(it->options[1]) & 0xac)) {
+	if (it->options[1] >= 0 && it->options[1] <= 7 && (BIT(it->options[1]) & 0xac)) {
 		ret = request_irq(it->options[1], dt2811_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



