Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3307CF30;
	Tue, 23 Jan 2024 02:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975732; cv=none; b=N3W1c9byoejA3hKivxgopGM3ntgGDtaI1+FScoctQJz0gsXNHAx1SmPkLgh6H8cwXK7r/Lkn2oHhgR9gXavtadN+17vChGwyxSAlUkGZCmaxS0gnO9Vx0BnlCls1BRLjh6zYM/PK+njh9vZ8HJk9BP3gjz3XiLEJ8RzXNcz6rTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975732; c=relaxed/simple;
	bh=7cgBVp2eIdpteAvTCIdWCKW0evmFQCL4Am4OiTxAZSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvxKiqdYkTBl03JJdJXuXOBaFJPj7qpmhlCc0LQwwgw49UuWdW1SpMLLyg8DbpE1mVyF28DId8h5Dit7yonv3FyPtVFU6E87BlC1xDhap9QB6ZO4/XUryappAfb5oYufCD9rq73wGiwjHwn9SIL9Z2UuApaahXRphqjNy2SnDH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUm3RmT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUm3RmT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B135EC433A6;
	Tue, 23 Jan 2024 02:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975731;
	bh=7cgBVp2eIdpteAvTCIdWCKW0evmFQCL4Am4OiTxAZSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUm3RmT6xpDdmsc1FNZnVpCsSxz3USkZCRcAYR+wb/PkQFBl0AD5/D3tQzA76Jemi
	 1LgdF7WS3k0zwhhtw/kfEMGeBKNrRga3sbc/7F8aVfRio5rbQJj+pXVzIhdch0hqOc
	 UBNFfEbLCXLRaj7RmEyo/P5TLblQiqjhje9H7nz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 493/583] tty: dont check for signal_pending() in send_break()
Date: Mon, 22 Jan 2024 15:59:04 -0800
Message-ID: <20240122235827.103003704@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit fd99392b643b824813df2edbaebe26a2136d31e6 ]

msleep_interruptible() will check on its own. So no need to do the check
in send_break() before calling the above.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230919085156.1578-15-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 66aad7d8d3ec ("usb: cdc-acm: return correct error code on unsupported break")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b6ddc1bf307b..ddcaf967f64b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2484,8 +2484,7 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 	retval = tty->ops->break_ctl(tty, -1);
 	if (retval)
 		goto out;
-	if (!signal_pending(current))
-		msleep_interruptible(duration);
+	msleep_interruptible(duration);
 	retval = tty->ops->break_ctl(tty, 0);
 out:
 	tty_write_unlock(tty);
-- 
2.43.0



