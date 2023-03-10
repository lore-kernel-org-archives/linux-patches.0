Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9766F8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AEAC4339B;
	Fri, 10 Mar 2023 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457438;
	bh=1tYfkklAt84DLqXG8UKW3jbjYmFY+1EiJ+dj4OS2AJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjSEEYiB8ANszc2F90ZGD1vJdXXVctyzIYKkAdoCRzVStOfbIRsgxQlC1yUG0H7ES
	 MllsolTBoTKBYLj3Ba0Ruob4wWwUg3ypSO/i1RYc68LwNhqynkqz2IYHAjpVppQWqt
	 1B+6KEoR8nf1hlBJAxwa4og5lo6QHflFsaUQiOaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/200] iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()
Date: Fri, 10 Mar 2023 14:39:05 +0100
Message-Id: <20230310133721.375433182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

[ Upstream commit 64a68158738ec8f520347144352f7a09bdb9e169 ]

Smatch Warns:
drivers/iio/accel/mma9551_core.c:299
	mma9551_read_config_word() error: uninitialized symbol 'v'.

When (offset >= 1 << 12) is true mma9551_transfer() will return -EINVAL
without 'v' being initialized, so check for the error and return.

Note: No actual bug as caller checks the return value and does not
use the parameter in the problem case.

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20230126153610.3586243-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index 86437ddc5ca18..b898f865fb875 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -296,9 +296,12 @@ int mma9551_read_config_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_NS(mma9551_read_config_word, IIO_MMA9551);
 
-- 
2.39.2



