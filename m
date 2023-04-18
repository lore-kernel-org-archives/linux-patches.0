Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A349C2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BB9C433EF;
	Tue, 18 Apr 2023 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821053;
	bh=/jVknyqDoBXKUCtuDs+bg2w7QcWTLJv20qYAW+HF7aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0saa8sFhuVpRWDlqs5odkfWhlO1ymBQ9SiD/Z8+nqxdtaCvhSwUKkIaBEw0f1ovN
	 bQJcN/CI5qmhluH40hWnXw+BPm7SXLgUSPwryKjaM4PYEpG8Lk2RJ9CAowq+mJMNvo
	 bZVk++WsVInVaI6Q57yUlkFVSFMsWXT1o4wPHByM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Cherian <george.cherian@marvell.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	"Tyler Hicks (Microsoft)" <code@tyhicks.com>
Subject: [PATCH 5.4 74/92] watchdog: sbsa_wdog: Make sure the timeout programming is within the limits
Date: Tue, 18 Apr 2023 14:21:49 +0200
Message-Id: <20230418120307.376820411@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Cherian <george.cherian@marvell.com>

commit 000987a38b53c172f435142a4026dd71378ca464 upstream.

Make sure to honour the max_hw_heartbeat_ms while programming the timeout
value to WOR. Clamp the timeout passed to sbsa_gwdt_set_timeout() to
make sure the programmed value is within the permissible range.

Fixes: abd3ac7902fb ("watchdog: sbsa: Support architecture version 1")

Signed-off-by: George Cherian <george.cherian@marvell.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230209021117.1512097-1-george.cherian@marvell.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sbsa_gwdt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/watchdog/sbsa_gwdt.c
+++ b/drivers/watchdog/sbsa_gwdt.c
@@ -121,6 +121,7 @@ static int sbsa_gwdt_set_timeout(struct
 	struct sbsa_gwdt *gwdt = watchdog_get_drvdata(wdd);
 
 	wdd->timeout = timeout;
+	timeout = clamp_t(unsigned int, timeout, 1, wdd->max_hw_heartbeat_ms / 1000);
 
 	if (action)
 		writel(gwdt->clk * timeout,


