Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8914116DC28;
	Wed,  5 Feb 2025 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768342; cv=none; b=oSG7BCY5eIk2NZcgNtvr/IPEKzWs/xxWqO/UPnhYHIAH+sH33jnTuVg/aSM1HR28n7KSNQzkeLeVNr7MCVPZgrNxtk0MvlzSzszKl7v2L45VKw8T0EktMqNqWZiYLckk4ZBwHH+/f9WdlNAfenBrZ7Wi8O0fd8u+Js/0b0RKLIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768342; c=relaxed/simple;
	bh=OAnZ6g1JKXnZknSGtauvkBat4n/oHopI8G2FF1yCoXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=da1pMOr8iOvjRKxhf9TiujEZWjuH6jjU0uw9Y0oNNuYuenDyp1HgwmtCxxhAfzkWrC3fDzriZJJnlwPfjfDJT36kTRSC5aTqfDH+Q6nTAEESfVlV7bjjIfIUQT2GruukD4Ow1Y10OuAhob02dUXDYk6DG4LmHwl9rG87kqqr9zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMjK23Qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMjK23Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C25C4CED1;
	Wed,  5 Feb 2025 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768342;
	bh=OAnZ6g1JKXnZknSGtauvkBat4n/oHopI8G2FF1yCoXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMjK23QaGGXjb3m6lxI/x9asW6Hc7tESjsfVESbXRWKQdSoScHfsYd/VsB/88di2g
	 +JhV+3E3vd/hpK1gdIKgdNSWEWuhYC2ebYfyde5ubSqb4YAXL4miTnXLUoqRVF4ROW
	 W9MSfBXsrrBdGdKj/b0X+fTHs0rcMA8mFpPfkiro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 533/623] ptp: Properly handle compat ioctls
Date: Wed,  5 Feb 2025 14:44:35 +0100
Message-ID: <20250205134516.616934193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 19ae40f572a9ce1ade9954990af709a03fd37010 ]

Pointer arguments passed to ioctls need to pass through compat_ptr() to
work correctly on s390; as explained in Documentation/driver-api/ioctl.rst.
Detect compat mode at runtime and call compat_ptr() for those commands
which do take pointer arguments.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/lkml/1ba5d3a4-7931-455b-a3ce-85a968a7cb10@app.fastmail.com/
Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20250125-posix-clock-compat_ioctl-v2-1-11c865c500eb@weissschuh.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index ea96a14d72d14..bf6468c56419c 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2010 OMICRON electronics GmbH
  */
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/posix-clock.h>
 #include <linux/poll.h>
@@ -176,6 +177,9 @@ long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
 	struct timespec64 ts;
 	int enable, err = 0;
 
+	if (in_compat_syscall() && cmd != PTP_ENABLE_PPS && cmd != PTP_ENABLE_PPS2)
+		arg = (unsigned long)compat_ptr(arg);
+
 	tsevq = pccontext->private_clkdata;
 
 	switch (cmd) {
-- 
2.39.5



