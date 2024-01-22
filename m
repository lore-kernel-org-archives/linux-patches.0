Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0E51350E1;
	Tue, 23 Jan 2024 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971946; cv=none; b=VmAKWdGd9Zo2lSlN713k/6g5vZjL3rMxlcheuVYcRgzON0awfIboBfBOYo3Hh9ZAg1ok9WusAGRFA4HDZ4mCYk5hmnPf20GESQ9dZUQGT1HuKW+W4+ipBnIHx4VPZevNyC7JITK8PoKVtBYd9Hm82kX8b8PVpliIsi9ZoA5rLjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971946; c=relaxed/simple;
	bh=DAWgWSXmAjaeNNeCcnwVOfu0lR9ffHdo+Tw78qoa4Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9pMLDe7KXnLPc3QcX2bS6xJLALL9LkQo39y19oCSniO7SH/QoIelzqDKFcoQ4XPxkSmlD+i6G+QSn9+ilPOq1VeqfYWRS/fhRcs837HUiSAxcvdZg0xvcdQc6FGYBuld//3T4YOohRSA/CaXxdrzT62hrygApNEVfh0s3WPwqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpB21PpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpB21PpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4881C433F1;
	Tue, 23 Jan 2024 01:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971946;
	bh=DAWgWSXmAjaeNNeCcnwVOfu0lR9ffHdo+Tw78qoa4Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpB21PpDPBKVVMnLNsUfGzEpwzAkQ5wW4v930A36I2ae27WgaVDX2HUuQvi2MDozd
	 xLzR8xyylIUkvBEhIoeNPoUeXcoRnHcxk2U6Jp3jFD9ArzxR3pfprMgTO/qcGhla4M
	 hdwqOpeY2yPClzU1lxJBmNBQ8U4+zbbvEGoabNis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/417] tty: dont check for signal_pending() in send_break()
Date: Mon, 22 Jan 2024 15:58:46 -0800
Message-ID: <20240122235804.214135572@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 745fc4ec4399..41e01a8ccc4c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2481,8 +2481,7 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
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



