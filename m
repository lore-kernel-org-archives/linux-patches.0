Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B847634F8;
	Tue, 23 Jan 2024 01:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975040; cv=none; b=JGYCDSN8ZwE+noD+ATRu5OraV17F8MEuwlYFLQxCFhByHIM9wP2DP5btRc6m8ZaHlNPPQ7Kutk74456fkzhcRlbfspratnGGwUO/m8DN1KJIbf6nKUCCyHaeLQaKZZbItubIxFAoKHmWNjVtL+CYBEhj5GeBjLzjUEaO1WPII2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975040; c=relaxed/simple;
	bh=NDu/FtKrRFRNR/rX0bFt77sI8nB6bH7+cHDzYE+tEzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwmB69DHqelRd9KTmrGLXBihKXlkBT6ihVa9A0vcmDM+SRqpzODxYJLQP4C2mqSKLWwN8uOpVL4LlQ/bD105A1JJqihMt6h6UZmOoVcMwcfA/1oW6rdNHtAdX2eZ/uLKpSQInf67fnHWVqwMKi55P+Mw0gZ3Ooc4NMCOrRysTMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgHcX1ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgHcX1ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E734AC43394;
	Tue, 23 Jan 2024 01:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975040;
	bh=NDu/FtKrRFRNR/rX0bFt77sI8nB6bH7+cHDzYE+tEzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgHcX1ciHsITa8ry8Vb2mGeUGuntZAozI4PiXJjxq0eWrkOYv0ksuH8sxdl6nbKqr
	 PcUVwHS/29iYjC4Ag5h2bSQTeQOw3Qs7Yh+LCxlOoFvpmMFztPAO1ASiUGwluIQAxZ
	 7Y4sAA/dtRzv2oFNdHf58D92jMQaaTRxshmQ6g40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/374] tty: dont check for signal_pending() in send_break()
Date: Mon, 22 Jan 2024 15:59:34 -0800
Message-ID: <20240122235755.947218695@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a18138ce67b2..cdbf05e76bc7 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2513,8 +2513,7 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
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



