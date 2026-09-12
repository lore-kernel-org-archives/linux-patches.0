Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAA23451C8;
	Sat, 12 Sep 2026 19:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242681; cv=none; b=nHDRSYp5+dVsgNzJN28O/JsPTPQE6iBgFAXwNub85Tj2SjFTO1qq7n9wbSai5Q8el/Xs7qJtECdoisFMV7M8T9L28UsiiSX+Y9K+2GJ1iCNewNFgTJjSIrEfLB6N0MvMIuhUJGArhkQEOALaQxPdW5maGkcWygKXMuuJM2MCW3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242681; c=relaxed/simple;
	bh=dm3AObb+8Dz3NAjhXR2HXxgbpo4jCG2NQC3E895r9tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouFoYs97x+HA1mCgCJnwm6tUYi7E1nDzEoMxoL14sqabDbJMky8hpE2T4We2wYL4z7qe1VaZqGj4wz/s3J86le13Wb3nFn56tP/6Lktp+THsyCM1adslS4ZVweJd1KMUMiPRHYwmS535RMhalS2m/yYERhIz4mjvhKchfVB2EqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpwcvcm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpwcvcm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E6D1F000FF;
	Sat, 12 Sep 2026 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242680;
	bh=VZ5fghG1sJZcEjdOkyBos/0HJeq3haBz+JhlcFcvP2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpwcvcm3L1CTtd6F8WOizrbu6wozIChae0NS5Inox3ii/cu9nupI0n0cRR+JaZ7JY
	 lLHxwiQJt89ez//pe7Nisr4H3iRrJ4W5pEhATVCBC4zODEYJWRN1cOMuDKF+s1Hskn
	 NggSOQ1lcu9CneW7zLCiHuY9DabRWmlswTaZ+QL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 489/798] scsi: target: core: Replace in_interrupt() usage in target_submit_cmd_map_sgls()
Date: Sat, 12 Sep 2026 09:01:57 +0200
Message-ID: <20260912065528.348430645@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 513e29946ab22f66cd14670024f6c98b5b913462 ]

target_submit_cmd_map_sgls() uses in_interrupt() to crash if it returns
true.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

The usage of in_interrupt() is clearly for debugging. might_sleep() is
better at this because it also detects other contexts in which it is not
allowed to sleep, like preempt-disabled section.

Replace BUG_ON(in_interrupt) with might_sleep().

Link: https://lore.kernel.org/r/20201220203638.43615-6-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ef63cc441703 ("RDMA/srpt: Pass the mapped task attribute to target_init_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2fd2a513c6b96..57b6a94981cdc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1612,10 +1612,11 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	sense_reason_t rc;
 	int ret;
 
+	might_sleep();
+
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
 	BUG_ON(se_cmd->se_tfo || se_cmd->se_sess);
-	BUG_ON(in_interrupt());
 
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
-- 
2.53.0



