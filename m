Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C207D313520;
	Mon, 27 Oct 2025 18:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590449; cv=none; b=Eoa2fZ5ecU/4IiNjHkNELEnS57KtHZj2lRxZDxGf0eNl7VpEn+4aPu/fffF9Z4AIQDEU6NMB6Sw21XhUPePtVFD/de6x2jsdDkj/4JzHXoHIf2nqf7V3+UWDLDcJ1TOnepa6Rc795VdGTdL1PTmssKQjCeAR3lHfhhdeFM6fa0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590449; c=relaxed/simple;
	bh=V7uNahHcoHHurRXFNabyxQKqpAYT8PLnEdmacGCaLFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sea2pVC2QKkc4+jJMwRJS90K9kz11GCburWDlhufWrRKPgW5diAbML8XFE9hrLksag83aqKwR0fodxtBBmh6rPaOkJWxAXslZjQEpbX8HCtehbn+KmEgXYYS/2mSX+QwtMFrpgz+tUDpJ+BRvwKjb+yLZQ/Y1TkKEO6Ydkt5Knc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=janFtG3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="janFtG3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B44C4CEF1;
	Mon, 27 Oct 2025 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590449;
	bh=V7uNahHcoHHurRXFNabyxQKqpAYT8PLnEdmacGCaLFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=janFtG3lhSb7+MeG+G9xKJp5qfl++pkXeKBo8edrAD5KTQcM/u2VWRC0fowliYjG8
	 DgV8txbbGPaKntScujfI8w1JSpKNj+meHkAsZMTM0eKICybhmy6Eo56rH6+ksly9qN
	 4uk1BX+hyUd1aT12gqIRNqmVSdVJqOF1LDsbEIL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/224] watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog
Date: Mon, 27 Oct 2025 19:33:16 +0100
Message-ID: <20251027183510.337980399@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7dfd80f70ef00d871df5af7c391133f7ba61ad9b ]

When the watchdog gets enabled with this driver, it leaves enough time
for the core watchdog subsystem to start pinging it. But when the
watchdog is already started by hardware or by the boot loader, little
time remains before it fires and it happens that the core watchdog
subsystem doesn't have time to start pinging it.

Until commit 19ce9490aa84 ("watchdog: mpc8xxx: use the core worker
function") pinging was managed by the driver itself and the watchdog
was immediately pinged by setting the timer expiry to 0.

So restore similar behaviour by pinging it when enabling it so that
if it was already enabled the watchdog timer counter is reloaded.

Fixes: 19ce9490aa84 ("watchdog: mpc8xxx: use the core worker function")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/mpc8xxx_wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 3fc457bc16db3..18349ec0c1010 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -100,6 +100,8 @@ static int mpc8xxx_wdt_start(struct watchdog_device *w)
 	ddata->swtc = tmp >> 16;
 	set_bit(WDOG_HW_RUNNING, &ddata->wdd.status);
 
+	mpc8xxx_wdt_keepalive(ddata);
+
 	return 0;
 }
 
-- 
2.51.0



