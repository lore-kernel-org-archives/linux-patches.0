Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D2F522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD6C433C8;
	Sun,  9 Jul 2023 11:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901557;
	bh=44wYcN7dU3HjPXSPPhoYLcbj/0dBYkBjyGKjKQzP/0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwEUvKDnPpHwdr4V/uufPXUnUENuDvlolUMrKYQBOPOlrphNngHHQQQEQMZEr3tVu
	 aystpxCRCK7MC0L6NVGCexVmO0P5sljVSrk7sH36nokClCCLZ1lQeXt/HPkJi7CcKd
	 EhnLNyplPIiE2gELP2qwB2bXXZ3sw7weSfzfaQy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Yang <wenyang.linux@foxmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 034/431] tick/rcu: Fix bogus ratelimit condition
Date: Sun,  9 Jul 2023 13:09:42 +0200
Message-ID: <20230709111451.897136502@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wen Yang <wenyang.linux@foxmail.com>

[ Upstream commit a7e282c77785c7eabf98836431b1f029481085ad ]

The ratelimit logic in report_idle_softirq() is broken because the
exit condition is always true:

	static int ratelimit;

	if (ratelimit < 10)
		return false;  ---> always returns here

	ratelimit++;           ---> no chance to run

Make it check for >= 10 instead.

Fixes: 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle")
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/tencent_5AAA3EEAB42095C9B7740BE62FBF9A67E007@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d6fb6a676bbbb..1ad89eec2a55f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1046,7 +1046,7 @@ static bool report_idle_softirq(void)
 			return false;
 	}
 
-	if (ratelimit < 10)
+	if (ratelimit >= 10)
 		return false;
 
 	/* On RT, softirqs handling may be waiting on some lock */
-- 
2.39.2



