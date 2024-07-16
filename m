Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E4619E7E3;
	Tue, 16 Jul 2024 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144813; cv=none; b=Kvv9DxEmnHS7PN8E9cY8aTy3gweS6ibEptcdNYwb8BKR+ooAhueLZLlyiwOBEKZKUBk+zzN1t9J3BPidSDWvF6WxEL8g3bF0yCVsP9FWlfIK/64YJ9OSSA8VpyxWmkTQcbI3a/mhk+Jad2V8U0ha6GyZa0uG9W1Wu8lZfWhCvXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144813; c=relaxed/simple;
	bh=zftNQ9RKLhVgNCLTqyJadC7VNZgBUvIowAo7LmrjOZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U07DVhE27UvSb3KjRGVsnW6EbgUM4Iid0vwfV+oP/zPv+oMnLQabXMZy6VjFbf3Yp+2mx6l6ZOM2d7Z9Qss9lULkn3IaCIszAWJmcXb2sbuFowCGOHR5eEXgJJMQRB1e2V3C8fmQgsIPtlXgZR1hd6Bky3+qG+FuHvLH0q4L5jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM1bb8pR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM1bb8pR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B20C4AF0B;
	Tue, 16 Jul 2024 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144812;
	bh=zftNQ9RKLhVgNCLTqyJadC7VNZgBUvIowAo7LmrjOZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aM1bb8pR9JyEb938gkx269bJZXmfhUx+XT+6uU5T+x9Svy9UV6lIeNLuQBC5S+loO
	 95UdTF0M+HfwVegyri2A8wf5pMYuQwySHA75R6QfY+ETOpJ90hYnmdb5nLXLwvVrbP
	 2l0cwV/to0QvUj7NAzuP0N+rNq4pLrPgSOyL8+q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/108] i2c: mark HostNotify target address as used
Date: Tue, 16 Jul 2024 17:31:57 +0200
Message-ID: <20240716152749.912624394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e8a89e18c640e..6fac638e423ac 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -969,6 +969,7 @@ EXPORT_SYMBOL_GPL(i2c_unregister_device);
 
 static const struct i2c_device_id dummy_id[] = {
 	{ "dummy", 0 },
+	{ "smbus_host_notify", 0 },
 	{ },
 };
 
-- 
2.43.0



