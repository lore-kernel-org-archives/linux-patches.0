Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3B51DDCE;
	Tue, 16 Jul 2024 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145224; cv=none; b=FAkVLp8LD1PouD6yTQ+wHDTXsFD7gWCOOMIBlowLauZ/29SvRubxtxdvC19M3Qkkwp1UlJC2KFUvk99LrS9qsd1KqrbGq0I8HOU1fflZXEkjD304uQM6OXY1vLe9iD2aAL0oQRltQAgmdEUnECa4kjAd8Bh0AtcnoamWNaogKSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145224; c=relaxed/simple;
	bh=NsqVSpuxgu0bfKmbBl/hvnFXuf7PXMEDuMiqVUho2jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKk0qYq9qMMQlcFk7Bv3FjDZ2mEm+7inE6H5pQczZCYliN/prTDlsIvbAlgBqx0d9cFtCQWLzaMtViErS4CblRwegUf820qGSwgl2mVvedAa+bgqDDutRW1EcydNsMKHa/vRsjfMZfbfYSFzhwbJYdZhexad+o9jEYg9YfMi1Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T66wN697; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T66wN697"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B7EC116B1;
	Tue, 16 Jul 2024 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145224;
	bh=NsqVSpuxgu0bfKmbBl/hvnFXuf7PXMEDuMiqVUho2jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T66wN697YUI3gkwom/KqELQ93yUNmT+2iIxc/H+tJbfngKfHTFyCSPjmA28TQ9znQ
	 4JMCzExx/FfD5y5XFQJusAu7hXujEjuT2fmLPY5bFQ9Xu1FFgY6AQek9pnR/PjATE7
	 oEGWjtjsRkSdkKcmK6cNCKNFYAXszHYciCjGIRoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 139/143] i2c: testunit: avoid re-issued work after read message
Date: Tue, 16 Jul 2024 17:32:15 +0200
Message-ID: <20240716152801.341624200@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ca43e98cae1b2..23a11e4e92567 100644
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



