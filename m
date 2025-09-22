Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96262820D1;
	Mon, 22 Sep 2025 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570000; cv=none; b=onmUCF2+BcOWasq6c8GYrazf7fp0Ubh81e5y3zKV/7I1S4kStroZfgpzbG4XM1eSRCmnFZKOkdWvgUeEMxuskrLgSIrwIbLZYlTousH3KcFWUbPjtvuuUectnpPClR30rU0YjerNWqTRETzUX53SJWRZbzpm6RGKV6Q4btDPmIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570000; c=relaxed/simple;
	bh=x4BEnhQF4Ac486yDUv42WZnGPKNHq6h6IwgL7+ETBH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8lx/3GdIeqt5VigDObzH57TGY3w1X5Atp23Hpq/nst704Y+WW65hGLmURSVd+8SPzgO30+Yhok19gUMFcnANnbob8dIfA7PEf6ca1wkofzl2gOqImRM/TAn+yN4dshCWQT5dF3UkA0YsYW6e4DpnNSkakciFXBN52faa/zxxPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSKs81q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSKs81q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFAEC4CEF0;
	Mon, 22 Sep 2025 19:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570000;
	bh=x4BEnhQF4Ac486yDUv42WZnGPKNHq6h6IwgL7+ETBH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSKs81q+NJQFwgHpP038o5w/vuivO2TPr12FCAtCdu1/4lqrcHyPTLEIGQ+1e9Ggz
	 BHiePwlkQXkbsrrudZ/U21OYREBEMrNIXqjkGZVmM9JUDML2MUKUKYo7VcjX8/nWJS
	 G40Rc3Eeijjn4rw1eWKOoHuyKqI0GGtnIeabvmJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/105] io_uring: fix incorrect io_kiocb reference in io_link_skb
Date: Mon, 22 Sep 2025 21:30:07 +0200
Message-ID: <20250922192411.102315027@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 2c139a47eff8de24e3350dadb4c9d5e3426db826 ]

In io_link_skb function, there is a bug where prev_notif is incorrectly
assigned using 'nd' instead of 'prev_nd'. This causes the context
validation check to compare the current notification with itself instead
of comparing it with the previous notification.

Fix by using the correct prev_nd parameter when obtaining prev_notif.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: 6fe4220912d19 ("io_uring/notif: implement notification stacking")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/notif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 28859ae3ee6eb..d4cf5a1328e63 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
 		return -EEXIST;
 
 	prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
-	prev_notif = cmd_to_io_kiocb(nd);
+	prev_notif = cmd_to_io_kiocb(prev_nd);
 
 	/* make sure all noifications can be finished in the same task_work */
 	if (unlikely(notif->ctx != prev_notif->ctx ||
-- 
2.51.0



