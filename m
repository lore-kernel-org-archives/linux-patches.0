Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1023019ADA1;
	Tue, 16 Jul 2024 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146352; cv=none; b=EeIwaZNsYJ8W6krP/PnhEhE0wy3QQFZ31k81gPpxl6J6yZ4m1/T+ijrKxlPP6ls/F+sOL/M2BAr+0jei6bghNWC74Tom1xF29tZWIRlo3S9yl2LdymRVOnUMz/TOiqeagO1AkU2QFxKFkheCtgfi5BxDuM2e+xxPo/ysfACEQnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146352; c=relaxed/simple;
	bh=VV3UBFWBPa8bto92RaNzBsdGSepXq8qaV4rK1UHLuNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSqD7A6ReUnF66IZQEpcoE6ot8uUFQXrFGUd4S1vTX1VlH45fifuYFCsJNU6lcjnFIbNRF/6Tjmc34Fy04DGWdcidgfwuc9oS0RskkQSC9izWbrfzNWsfKxyhHgE75HY9xLmx8rcB+y8irqKDhspRpnvAQgc6dYZQv+Lga5KcZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2NFiqVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2NFiqVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEF3C116B1;
	Tue, 16 Jul 2024 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146351;
	bh=VV3UBFWBPa8bto92RaNzBsdGSepXq8qaV4rK1UHLuNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2NFiqVC+KnRV19HrDOFrwDCAdB1ew6UGi+h6Xav79ArWXRdxeScDZeCpim75hh76
	 elzcRBY4wGr2vtU9OCdJ3sl8fwCWt9uxPAjmGsxkNy7eANjd+JtV7RdpZP16+DZtiN
	 wwp0vqUx5FVMJRT+hdT6zQ3F421dt4yFshMSLvuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/144] i2c: testunit: avoid re-issued work after read message
Date: Tue, 16 Jul 2024 17:33:28 +0200
Message-ID: <20240716152757.855095978@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cd0d87b089fec..bdb7d71dadbc4 100644
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



