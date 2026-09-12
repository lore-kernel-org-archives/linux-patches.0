Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BB4384242;
	Sat, 12 Sep 2026 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238461; cv=none; b=HhHYGT3r7q5mGAJUGsMYD7JKkPGn4IOJIU1Wlt1IMjfWPR4hDUWkFVMLDH5n3jw3xMC89f0xVeBifGLpc7Qs+b1QQP4QPtT9naZtBUpjPWwwJTTRMCMBXETXn69yc7Y7DAwhHaKyBUb4/CPjDsoO+ZDP6/Tf4AR1J6sr0EDQNIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238461; c=relaxed/simple;
	bh=06rH7eAnMi2wVP+LwbQJVfNUQj0cOxh4JP3MXpOSlFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtcRJ0qK7aviGloN9MlApCQHCglvH3g89JTyNTKzNgKA69SHlAPwAWdFIHN9q/cxOAzz6AOLDw0lXFTC9Pq3gRKiVMUztK7Fg+xsp/+RwiKpo3/J723uJZRm41TAy0fk+zx3/27c0PjD1Lt7NVeaxuD+HylG5OshmUET8ApHpiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drZy5Rgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drZy5Rgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E8E1F000FF;
	Sat, 12 Sep 2026 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238458;
	bh=SeCMo+9C3abTQSrYokmVjltnRDBnmifqQawZjFOPZgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drZy5Rgg2U8hhZXR/GKlcL0t59zzwUscbaNTm1e9Zs3wvaK6djXMXD+VD1fpR04CB
	 zacSRSjaYUC2WI40RFWFr3qkkaiaIlczDHjiy7Fm9liA2neitOKzkkQQBi9qRtTiOq
	 yA8bZySz6zWrQeMB0r6xCY1Ef6Xf15qWlzQvbWm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/935] clocksource: Unregister subsystem on device registration failure
Date: Sat, 12 Sep 2026 08:58:16 +0200
Message-ID: <20260912065537.514984921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 57575be840c5a..3b494001e96fe 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1465,8 +1465,12 @@ static int __init init_clocksource_sysfs(void)
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



