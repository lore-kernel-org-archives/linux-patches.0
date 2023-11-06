Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1BA208C0
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uiTf355"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC582C433C9;
	Mon,  6 Nov 2023 13:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276757;
	bh=mJpb9rnxGppv9TQxA0xuRzXea0iceEYToht9h1La4IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uiTf355/+f3FxIuxyFCQJ9z6tLZTvreExuHIBTkl5PasL9CtOCgtSAAk9Z6s9SEm
	 3wIBwr8V7x+vSpUxHyxiqRCmEfHLvswbSsBhU8V9pgpHUMX8yi6JryYEgLbK5HYUfK
	 lNUcgYowRtigrJNFqKSlfwwIT043043qYMXRchFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Richard Purdie <richard.purdie@linuxfoundation.org>,
	Bruce Ashfield <bruce.ashfield@gmail.com>,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Randy MacLeod <randy.macleod@windriver.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.5 86/88] serial: core: Fix runtime PM handling for pending tx
Date: Mon,  6 Nov 2023 14:04:20 +0100
Message-ID: <20231106130308.979479321@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 6f699743aebf07538e506a46c5965eb8bdd2c716 upstream.

Richard reported that a serial port may end up sometimes with tx data
pending in the buffer for long periods of time.

Turns out we bail out early on any errors from pm_runtime_get(),
including -EINPROGRESS. To fix the issue, we need to ignore -EINPROGRESS
as we only care about the runtime PM usage count at this point. We check
for an active runtime PM state later on for tx.

Fixes: 84a9582fd203 ("serial: core: Start managing serial controllers to enable runtime PM")
Cc: stable <stable@kernel.org>
Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Bruce Ashfield <bruce.ashfield@gmail.com>
Cc: Mikko Rapeli <mikko.rapeli@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Randy MacLeod <randy.macleod@windriver.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Link: https://lore.kernel.org/r/20231023074856.61896-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -147,7 +147,7 @@ static void __uart_start(struct tty_stru
 
 	/* Increment the runtime PM usage count for the active check below */
 	err = pm_runtime_get(&port_dev->dev);
-	if (err < 0) {
+	if (err < 0 && err != -EINPROGRESS) {
 		pm_runtime_put_noidle(&port_dev->dev);
 		return;
 	}


