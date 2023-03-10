Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8972848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA01C433D2;
	Fri, 10 Mar 2023 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458319;
	bh=k5XWIl5XB4f65o6A0XZFfzI5aSXS0CJa1Wdvb80QDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxmSGQPQUjczpBPWF26o3EKEVm6WL8Wqj3IUlejx3uPnQCIlpvaElLFAxFYUbC+cm
	 bE8y/uCrAF0zOGe4i7yIGgWC/efBV7yF7/feGc9RS9UQyX5qK0xaOx46DFS5N/mzmI
	 UO19Y5UHpdumzzAvnW61hVcoU8Ua2fK0HYj7iB0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/252] iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
Date: Fri, 10 Mar 2023 14:40:09 +0100
Message-Id: <20230310133726.666433434@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit e56d2c34ce9dc122b1a618172ec0e05e50adb9e9 ]

Smatch Warns: drivers/iio/accel/mma9551_core.c:357
	mma9551_read_status_word() error: uninitialized symbol 'v'.

When (offset >= 1 << 12) is true mma9551_transfer() will return -EINVAL
without 'v' being initialized, so check for the error and return.

Note: Not a bug as such because the caller checks return value and
doesn't not use this parameter in the problem case.

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20230126152147.3585874-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index c34c5ce8123b0..b4bbc83be4310 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -362,9 +362,12 @@ int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(mma9551_read_status_word);
 
-- 
2.39.2



