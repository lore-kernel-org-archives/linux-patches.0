Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6853219DFBF;
	Tue, 16 Jul 2024 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145517; cv=none; b=erH+uYJFjPVHCSSGyYdhz/rwIJ49YD/JFV26baG2s8qsRLHde7Wzw5+mnq0RMNBP9bVsw7ek47WxtYC2rLK0pFFQeirlWZuypEZy2a6CAFgYRIyCRUdjdIkTfq7mBJjlwxWY8iMX/k9pd/Bmkeiofb5Fs0a2LllTY1qf09seKw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145517; c=relaxed/simple;
	bh=OYWg0WCUqTfHdRmYKgq22l7Pg8b7pLPO3A+J5yziRT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8oHtCGkM8/mtsK/xpN/UoHiIKqtShyv3C5GivV41NJSVK+TIJTSbJQLsL+GxrksAQzz7TGgoOe9lkZiZxs0q6l7O9PNFBmh+fyijvmEJ6BmhePSlcQtbUP5UpNkZeeH0xs52bj4A9pGo0vOfTt0Ju64pmAVNgJvbHlGcO4D0nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvyZ7MKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvyZ7MKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96324C116B1;
	Tue, 16 Jul 2024 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145517;
	bh=OYWg0WCUqTfHdRmYKgq22l7Pg8b7pLPO3A+J5yziRT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvyZ7MKY7gm0FKjDgYKi8LYiWUrOmTvTofEVtHUwUpDTTARnu1lHGRdpKmBnLZJ/1
	 VAYLQQYSqgtd6OoUuj/uAQ2II91j9wOmH1z4JE8d6PdInbH4Zc6PU5+3MQeFpgga7Z
	 Wk8+CReI9jX86BBOqDnQRJG6PliYi/v4DjFu0Mcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 91/96] i2c: testunit: avoid re-issued work after read message
Date: Tue, 16 Jul 2024 17:32:42 +0200
Message-ID: <20240716152750.012980332@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 119736c7af442ab398dbb806865988c98ef60d46 ]

The to-be-fixed commit rightfully prevented that the registers will be
cleared. However, the index must be cleared. Otherwise a read message
will re-issue the last work. Fix it and add a comment describing the
situation.

Fixes: c422b6a63024 ("i2c: testunit: don't erase registers after STOP")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-slave-testunit.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/i2c/i2c-slave-testunit.c b/drivers/i2c/i2c-slave-testunit.c
index 54c08f48a8b85..b9967a5a7d255 100644
--- a/drivers/i2c/i2c-slave-testunit.c
+++ b/drivers/i2c/i2c-slave-testunit.c
@@ -118,6 +118,13 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 			queue_delayed_work(system_long_wq, &tu->worker,
 					   msecs_to_jiffies(10 * tu->regs[TU_REG_DELAY]));
 		}
+
+		/*
+		 * Reset reg_idx to avoid that work gets queued again in case of
+		 * STOP after a following read message. But do not clear TU regs
+		 * here because we still need them in the workqueue!
+		 */
+		tu->reg_idx = 0;
 		break;
 
 	case I2C_SLAVE_WRITE_REQUESTED:
-- 
2.43.0



