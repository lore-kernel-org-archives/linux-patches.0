Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440CE36828B;
	Sat, 12 Sep 2026 19:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242409; cv=none; b=pKP+WJ+x4R7c6RCPFMCz+tNK0AtE94f6wtLKxfGefexPxFH0Ba4eVWmTmW8iLw5fChz589pKowwI54qyqCXwLWpXe+rU27kWC90ylGqEd47X2H+2ng3GWKvTmqBVNU+tw1uPCVMPsifzNJeBbJbW8w3bsztoEU33qcDLuKvrbY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242409; c=relaxed/simple;
	bh=DlPWHCIjSWLPBfhhCSKufuXOGb9g/OvKWBaL7q3lRQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0OnTEtKQ+Jn+HcUljKxd7fABed5ZAQQtc1eY4TBmhNmqLbIki358fkcvdonqWbDQp7Lal4nEliogW8kKkbi4WoJgKrU8jL7woEj1R1xQkEU2IJmqI2XmkGHjWoFJSVC4FbQyD6nDm+Yw7CDi+P/qt72n/qjkmGdFZJvoeUt1oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HN1G004J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HN1G004J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A003D1F000FF;
	Sat, 12 Sep 2026 19:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242408;
	bh=CTUDvBH68KmXxmt9gWN7cwiVN7WkXIGumJAKJ5PXP1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HN1G004JcMHzywA+Cx3f3OJo/Atz2bMRCxgsR4bkCa0mAlxyvyco+L6eIVG82tO8x
	 jp6KdRiVxRvB/wjkYISMe5nrcz5UIlZfkKbtvQV3hztC2bfdv75EG8t7p1d52hH5ca
	 PlCdFKnzTHasGMr2J2Ld3U2L1a4y+dHBl//DHzFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/798] clocksource: Unregister subsystem on device registration failure
Date: Sat, 12 Sep 2026 09:00:22 +0200
Message-ID: <20260912065526.179022089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 3dee6537e728bd8137fda6eaf859f26e685943f7 ]

init_clocksource_sysfs() registers the clocksource subsystem before
registering the clocksource device. If device_register() fails, the
function returns the error while leaving the subsystem registered.

Unregister the clocksource subsystem on that failure path so the
successful subsystem registration is unwound before returning.

Fixes: d369a5d8fc70 ("clocksource: convert sysdev_class to a regular subsystem")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260702215733.84588-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index bd49fec0f624b..d2bf84507efd0 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1473,8 +1473,12 @@ static int __init init_clocksource_sysfs(void)
 {
 	int error = subsys_system_register(&clocksource_subsys, NULL);
 
-	if (!error)
-		error = device_register(&device_clocksource);
+	if (error)
+		return error;
+
+	error = device_register(&device_clocksource);
+	if (error)
+		bus_unregister(&clocksource_subsys);
 
 	return error;
 }
-- 
2.53.0



