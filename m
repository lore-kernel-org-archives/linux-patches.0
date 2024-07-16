Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB61F19DF71;
	Tue, 16 Jul 2024 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145218; cv=none; b=CapssOhdM7m50Prr3Se+9aGHlj+LA3bBZrg5jtBWs514ad3BWZKXsRK0Mr+ljhsB+szqoYHp/NjALS9YYp7zKBRYj1eyToYWYGuu3o3NGatEHBpuE5Tgfu3Q9xkmBKSn4tnLH1TTKubTjkMLvUrrs95x8MRzQjnmHm9NrtzU8oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145218; c=relaxed/simple;
	bh=gDm01j+4s7qrN7mNsqhSK78FjHnhhvezKFC2BrLKGgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6HRdVQ8EORHmvSMeKvay1rpGSFxl5nm1yqGyopjoLCraOeLnfViSK4jufQWuRuP7FMtQjBxxCRz7mTCoY1hf1RoY2Lio9g1pAg7PQIkabqX1AzX7H6aQCRt2V7ZO+e4rhoiXi6Gs1oHulqteL2fFfoVwVveMw8TYqSQK9s8X8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEct9Hq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEct9Hq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F9AC116B1;
	Tue, 16 Jul 2024 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145217;
	bh=gDm01j+4s7qrN7mNsqhSK78FjHnhhvezKFC2BrLKGgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEct9Hq20jxJT64EBn5HEnVOgTcCziHoPxzNDThpc1kAXkv9HClf72/ozFI4PI6zy
	 mhIhbit57VxgwgzK5gP9ob3tXE3n2JiI8v+5TrtLxPPyci7oEyKEWUBYyAkyYI2DpI
	 UXJkN4StHg5Nh7rtrW7iMhpS+xviHf2m6QnaWEwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 137/143] i2c: mark HostNotify target address as used
Date: Tue, 16 Jul 2024 17:32:13 +0200
Message-ID: <20240716152801.265658998@linuxfoundation.org>
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
index db0d1ac82910e..7e7b15440832b 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1067,6 +1067,7 @@ EXPORT_SYMBOL(i2c_find_device_by_fwnode);
 
 static const struct i2c_device_id dummy_id[] = {
 	{ "dummy", 0 },
+	{ "smbus_host_notify", 0 },
 	{ },
 };
 
-- 
2.43.0



