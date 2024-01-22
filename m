Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA2B64CFC;
	Tue, 23 Jan 2024 01:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975059; cv=none; b=dp7Y6i7kRnGcgG2w4qzEVaQ4fBCP9+gRZU6NS9MM+7rG8NX33rbfgpwFhn3t3tpHDGBiKrtgPTGN9P4icc9TJuzQyfi5Rl3+CqTb8+G08sEBv+p2bDxatsqsygQdUka02cInlL79+I31wOisbFEja3mlIaWgykykMmDXlhUFdx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975059; c=relaxed/simple;
	bh=lITLzO4lTF5MsrPL7BAuMEhba9IQHbeIWdF9GHCc9Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCooBkIoSTPqLqDGcedpw0T+6K8XD17bSNKe38+g9PEWC/Bp99abKHQZ2p0QOB/+wHEuVd9ioTME8mLXN2ax0I1AuaFB+qA0RMkzBrXE1JYOWSwd9ooiQJAATllmUnMGEwsNs8ORKiufzF+nvCApS/PBQ+rULYnLyjfF1RJcB/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uF0Rolal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uF0Rolal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011F0C433B2;
	Tue, 23 Jan 2024 01:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975059;
	bh=lITLzO4lTF5MsrPL7BAuMEhba9IQHbeIWdF9GHCc9Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uF0Rolalpe0tdEQdmo9Njn2qrC/LtN29lHESfmFsEaoO7aU4jMIEF37eL0RzXfl99
	 Ko9KB918XOMDfnglNwXYdkcgPvLGDWCgmcIdOLKjMJmmxWs2mXHZqUqkZYVWr/4ti5
	 e7UqBbsX4U8NSGeFHtFsb6p4E+g7GmWCe36u1g1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/374] tty: use if in send_break() instead of goto
Date: Mon, 22 Jan 2024 15:59:35 -0800
Message-ID: <20240122235755.983111169@linuxfoundation.org>
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

[ Upstream commit 24f2cd019946fc2e88e632d2e24a34c2cc3f2be4 ]

Now, the "jumped-over" code is simple enough to be put inside an 'if'.
Do so to make it 'goto'-less.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230919085156.1578-16-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 66aad7d8d3ec ("usb: cdc-acm: return correct error code on unsupported break")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index cdbf05e76bc7..82b49aa0f9de 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2511,11 +2511,10 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 		return -EINTR;
 
 	retval = tty->ops->break_ctl(tty, -1);
-	if (retval)
-		goto out;
-	msleep_interruptible(duration);
-	retval = tty->ops->break_ctl(tty, 0);
-out:
+	if (!retval) {
+		msleep_interruptible(duration);
+		retval = tty->ops->break_ctl(tty, 0);
+	}
 	tty_write_unlock(tty);
 
 	if (signal_pending(current))
-- 
2.43.0



