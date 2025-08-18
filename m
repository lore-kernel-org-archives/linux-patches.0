Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA78D226D0F;
	Mon, 18 Aug 2025 13:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523405; cv=none; b=kxI+fomzaYg5khOtSfaL2c35S5OoAfgmEx0JBbO+YslvFTE0+p3OVHF5fEUWgXjro+8db2WJTkc1OrEF6XX1sgu4A4y3PuB3m1rCMllRvDY4Bzvcm7Tt2eZt3Vt3ilcHZKUSOAm11Mgq1VlLCmJj3As+KdpQk9vNCGrbI61hzYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523405; c=relaxed/simple;
	bh=HPbMH2D/kIg3mv5sfCtZoUx73yI3f/typsk2rBNKeBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP+d4j5VqSXQZFmeejrn/MMEQnyZXdogntGUmgsIcMGZdyjeZXugo1to5T1SWBC8PbJ2B61fKxp2QEoFBDw6c2Sf2zpnAIa6cZs36EISG9iKbyXwdStUc5Ku+ai2+YUNAqKeBObQzbtBJhXDmCNOLKILZ8qPUyvX/fRG1icFynQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8qYMF2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8qYMF2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A20BC4CEEB;
	Mon, 18 Aug 2025 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523405;
	bh=HPbMH2D/kIg3mv5sfCtZoUx73yI3f/typsk2rBNKeBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8qYMF2Dt5gjhRQBdXaWR7jheNIncgLlwP46pGxkhpxEIynrR6yesFqUqxm0wXXWP
	 L4Auizs1+j2XWDti+tuJTf8p3BK6U/WGyANh1eA3mOKZnwO6YvbcSg70TTNJtRde/q
	 E+e83P3iDFdmMhnpcmWzYnEub7j0f/7qn6G+uZCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 162/515] char: misc: Fix improper and inaccurate error code returned by misc_init()
Date: Mon, 18 Aug 2025 14:42:28 +0200
Message-ID: <20250818124504.618081695@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 0ef1fe4bc38673db72e39b700b29c50dfcc5a415 ]

misc_init() returns -EIO for __register_chrdev() invocation failure, but:

- -EIO is for I/O error normally, but __register_chrdev() does not do I/O.
- -EIO can not cover various error codes returned by __register_chrdev().

Fix by returning error code of __register_chrdev().

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250620-fix_mischar-v1-3-6c2716bbf1fa@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index dda466f9181a..30178e20d962 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -314,8 +314,8 @@ static int __init misc_init(void)
 	if (err)
 		goto fail_remove;
 
-	err = -EIO;
-	if (__register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops))
+	err = __register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops);
+	if (err < 0)
 		goto fail_printk;
 	return 0;
 
-- 
2.39.5



