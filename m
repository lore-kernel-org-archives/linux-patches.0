Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA341DDCE;
	Tue, 16 Jul 2024 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145889; cv=none; b=pwXLjL1tUttN0jKthXiG5rhOC2eWyDqfW6V7PmEbQRQyG8V71tR2D0ExeKajwCXipTltPFjtwFj/mjMlbvp7Rvqwt1+zujyLioJ9MblfRI4baepBhPyw349P1tOJBcX16f44V9CtOothnIjzifYzt0eFHHQz+wXi/TRNXIK9hYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145889; c=relaxed/simple;
	bh=9NgpkoVgX5lcIm2Lpwchcn9BCoIUkndTV2Kj4TEqJf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhaoYvc07HwZsKaRX5hadrCwRcWVU7Gu4Rfkk8OKs27AQcmcO6ur2WN6c81diVpTzzsXT6KWoZa6Us/cyS8Fji8IZzcik23BAVPfAO6Iewe8jn2XwMvTAWPIk5nqKrGdL2mWIrEmgIvmDQdqAIbQPAIa+dDW30/189fh8lDX6oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmbrDIva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmbrDIva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CBAC116B1;
	Tue, 16 Jul 2024 16:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145888;
	bh=9NgpkoVgX5lcIm2Lpwchcn9BCoIUkndTV2Kj4TEqJf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmbrDIvaPCQpYvxj8psDGfKQzyCu8eCZHZW2Nh0PaEocOMMpHjLvH47p7R8NNHBjF
	 lTyLdrvsYHcxA141bR6XVG+D0tV2Hs9OYlJxVlWtk71nBfg7yyatUArCuaw8FD24uJ
	 /KfhRflAgdroEELiMi1y6TDKP9pb0pWtdLY5Aq14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/121] i2c: mark HostNotify target address as used
Date: Tue, 16 Jul 2024 17:32:53 +0200
Message-ID: <20240716152755.599175203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit bd9f5348089b65612e5ca976e2ae22f005340331 ]

I2C core handles the local target for receiving HostNotify alerts. There
is no separate driver bound to that address. That means userspace can
access it if desired, leading to further complications if controllers
are not capable of reading their own local target. Bind the local target
to the dummy driver so it will be marked as "handled by the kernel" if
the HostNotify feature is used. That protects aginst userspace access
and prevents other drivers binding to it.

Fixes: 2a71593da34d ("i2c: smbus: add core function handling SMBus host-notify")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 3642d42463209..1e873ff0a624d 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1064,6 +1064,7 @@ EXPORT_SYMBOL(i2c_find_device_by_fwnode);
 
 static const struct i2c_device_id dummy_id[] = {
 	{ "dummy", 0 },
+	{ "smbus_host_notify", 0 },
 	{ },
 };
 
-- 
2.43.0



