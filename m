Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6652F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E65C4339B;
	Wed, 12 Apr 2023 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289405;
	bh=4h7XxP2l6FPHUUSG7kgVsDjORIV0/8sty62BgSyJBu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMaABO/ZBFkIj5ZZCOlR3VnAcI5uZDBDNBCJcjU42iBvjGnTnBpI6KpAzWGqU3uAl
	 CL5T7JStSUGLU4XsHJ/ARwRPVKMiBlTQySqOW4jyCmnDk4OiBR7agK/hM8fx94RacG
	 JNh4l1XXRxRpD38b7gmKx+ORYnwzf9Otl3up/RUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 6.2 085/173] tty: serial: fsl_lpuart: fix crash in lpuart_uport_is_active
Date: Wed, 12 Apr 2023 10:33:31 +0200
Message-Id: <20230412082841.492525782@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sherry Sun <sherry.sun@nxp.com>

commit 178e00f36f934a88682d96aa046c1f90cb6f83a7 upstream.

For serdev framework, tty->dev is a NULL pointer, lpuart_uport_is_active
calling device_may_wakeup() may cause kernel NULL pointer crash, so here
add the NULL pointer check before using it.

Fixes: 4f5cb8c5e915 ("tty: serial: fsl_lpuart: enable wakeup source for lpuart")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230323110923.24581-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2896,7 +2896,7 @@ static bool lpuart_uport_is_active(struc
 	tty = tty_port_tty_get(port);
 	if (tty) {
 		tty_dev = tty->dev;
-		may_wake = device_may_wakeup(tty_dev);
+		may_wake = tty_dev && device_may_wakeup(tty_dev);
 		tty_kref_put(tty);
 	}
 


