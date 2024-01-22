Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F2D7CF21;
	Tue, 23 Jan 2024 02:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975733; cv=none; b=QN+q14h8MoOGoRU/Dm13RttM2KPtek8u5vObE1E9fqskv9VB6oNDk0DfBN9iagTxPf5h57R6gZchIu0XYJsW1MdKXyeNEDfIxWO2Jp4owQ+mdnGLpkhcUNtlStahbLNdkPtcPtRfq6DRCwf4pb8DPOP5Jvkcah3L53NwRWqfdMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975733; c=relaxed/simple;
	bh=7EVPGNX/bHS82MgR9xbFpzJFrDd0a5QaTOghO5nzSdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3ybOBM8xpnR21dCo825FfSfswMVXUa5Epcf4mcnxo1xRLhRNE01nool+xC+wwqMh90tGY/fBYv0dPYJObMhwOmQmldddOXMWraoeIhHjQifVyxM58iMZLLdUCAGOStu1L77qtvTu/yK/TcYN7zCjHB79P8J4zsr/WM8FL921VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrVRQ9HA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrVRQ9HA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F66C433F1;
	Tue, 23 Jan 2024 02:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975732;
	bh=7EVPGNX/bHS82MgR9xbFpzJFrDd0a5QaTOghO5nzSdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrVRQ9HA3iCfH8/XJdOJS3t+iCqUjO4vaOUBeIu/2DzttXNJJLLLYz/7RA7/FOpWo
	 dyd/vklo4aMdMcTX9DpCmt6NgUKYwNRRUlvuZgQuwquWj6bj37cS4fvEkMZWxkcfUG
	 ycoxCIcwnywquzfkece99H0zehEb8AHspcDr118Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 494/583] tty: use if in send_break() instead of goto
Date: Mon, 22 Jan 2024 15:59:05 -0800
Message-ID: <20240122235827.130587912@linuxfoundation.org>
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
index ddcaf967f64b..724ebf82f2cd 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2482,11 +2482,10 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
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



