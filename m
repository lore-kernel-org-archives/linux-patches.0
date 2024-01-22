Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B586F1350E3;
	Tue, 23 Jan 2024 01:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971950; cv=none; b=A4Jb6GGBQwldrbIuJwymXxvk+0iTylt+RAdng+ODVSFza9i4N20yoxwM6XHGK+se2zAp+JTDSKqXTHCu4Bdse36YQ4q/epeUfNM7cNG/vFvHNTLEfrY5EQ+7Da9DHBxBgAeJyroCaDJ2iywkwlNFK48uNJFYwnGifpwlBUzMWnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971950; c=relaxed/simple;
	bh=JdKJGqwnp4Nq2SZhSt4ykXhoNRAOAzCFmfNeUaV89JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST0nZjDWf+BO1lI6zaVyeHtIQSth9X1mqsptabhSgtaEHPzqS1M0+Z7ifG4litb/CPV7f1PMjqqnIJn2gCa1ODbWT6q5qGRekgiTPm+OtNOh16fojc0a0tntqu2TKMOekzzquDdDRPNUMbxklqKpNdd0IgLB9BEDcN4AiGyDmY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11bFDg9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11bFDg9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A396C433C7;
	Tue, 23 Jan 2024 01:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971950;
	bh=JdKJGqwnp4Nq2SZhSt4ykXhoNRAOAzCFmfNeUaV89JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11bFDg9X8wLI/EzkPDavwdzOTS/yKX5SETo7Rqq9f7bJ2yjdXpLpq+jdil5zLqNNg
	 MXKR37TVCbZU+hZdpqzH9PykFKwzRuH1OW3MQJnDoRI3GEdTO74j+GzWFe9rKhpUT5
	 er6+bWiAS35nt65+oMTczgxvChpH2Znz9nHUB2SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 359/417] tty: use if in send_break() instead of goto
Date: Mon, 22 Jan 2024 15:58:47 -0800
Message-ID: <20240122235804.253233028@linuxfoundation.org>
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
index 41e01a8ccc4c..43be3b42aaaf 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2479,11 +2479,10 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
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



