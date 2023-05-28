Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97513569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245F4C433D2;
	Sun, 28 May 2023 19:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302007;
	bh=7eLY0e0u0n1cXrl+zwmS+i0aQaEpAcOHri/0Eqa7Yz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNyxi5ayjnT5l38Ghc5qgSA5mDlFPOBK4vD93k/YYBn3NhwT+iYE1Gk02MKyxJ3L2
	 q0UY1RD4N4YLhBof5mzs6uGz1LpYoFQ6uk7h7O6/c2NtXlDWTzrV+Iac4D/d5QNJSd
	 7b1OX7VFip+LksjeZsFgvyuRKH3zht+2x2EDcsvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Oakes <gregory.oakes@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.4 123/161] watchdog: sp5100_tco: Immediately trigger upon starting.
Date: Sun, 28 May 2023 20:10:47 +0100
Message-Id: <20230528190840.930555395@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gregory Oakes <gregory.oakes@amd.com>

commit 4eda19cc8a29cde3580ed73bf11dc73b4e757697 upstream.

The watchdog countdown is supposed to begin when the device file is
opened. Instead, it would begin countdown upon the first write to or
close of the device file. Now, the ping operation is called within the
start operation which ensures the countdown begins. From experimenation,
it does not appear possible to do this with a single write including
both the start bit and the trigger bit. So, it is done as two distinct
writes.

Signed-off-by: Gregory Oakes <gregory.oakes@amd.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230316201312.17538-1-gregory.oakes@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sp5100_tco.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -98,6 +98,10 @@ static int tco_timer_start(struct watchd
 	val |= SP5100_WDT_START_STOP_BIT;
 	writel(val, SP5100_WDT_CONTROL(tco->tcobase));
 
+	/* This must be a distinct write. */
+	val |= SP5100_WDT_TRIGGER_BIT;
+	writel(val, SP5100_WDT_CONTROL(tco->tcobase));
+
 	return 0;
 }
 


