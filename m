Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7366FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B2AC433EF;
	Mon, 16 Jan 2023 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888898;
	bh=bIQA4dkqKJc0tb27tV6y/ZyNWMmQ9Z8x3QuJ+lDPMFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iq2LzdsmnxY5Mswxbh1UbBUKvhtzrlOY/OTTUHDmco2u4aTu+YbJa5B+OeNKGBpA
	 ngBGqjgQouu2CzfToVzTtu7o0cn7qQua+baaia2qvWTjBNnrXNZETJZzd+F7zTyZwM
	 T7qetwfuERKuGUoBgqx1d0NzJaalx86+hnv900tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 151/338] RDMA/hfi1: Fix error return code in parse_platform_config()
Date: Mon, 16 Jan 2023 16:50:24 +0100
Message-Id: <20230116154827.437175673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 725349f8ba1e78a146c6ff8f3ee5e2712e517106 ]

In the previous iteration of the while loop, the "ret" may have been
assigned a value of 0, so the error return code -EINVAL may have been
incorrectly set to 0. To fix set valid return code before calling to
goto.

Fixes: 97167e813415 ("staging/rdma/hfi1: Tune for unknown channel if configuration file is absent")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/1669953638-11747-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/firmware.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index c54359376cda..8499f27ca3c0 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1761,6 +1761,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 
 	if (!dd->platform_config.data) {
 		dd_dev_err(dd, "%s: Missing config file\n", __func__);
+		ret = -EINVAL;
 		goto bail;
 	}
 	ptr = (u32 *)dd->platform_config.data;
@@ -1769,6 +1770,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	ptr++;
 	if (magic_num != PLATFORM_CONFIG_MAGIC_NUM) {
 		dd_dev_err(dd, "%s: Bad config file\n", __func__);
+		ret = -EINVAL;
 		goto bail;
 	}
 
@@ -1779,6 +1781,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	if (file_length > dd->platform_config.size) {
 		dd_dev_info(dd, "%s:File claims to be larger than read size\n",
 			    __func__);
+		ret = -EINVAL;
 		goto bail;
 	} else if (file_length < dd->platform_config.size) {
 		dd_dev_info(dd,
@@ -1798,6 +1801,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			dd_dev_err(dd, "%s: Failed validation at offset %ld\n",
 				   __func__, (ptr - (u32 *)
 					      dd->platform_config.data));
+			ret = -EINVAL;
 			goto bail;
 		}
 
@@ -1844,6 +1848,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 					   __func__, table_type,
 					   (ptr - (u32 *)
 					    dd->platform_config.data));
+				ret = -EINVAL;
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table = ptr;
@@ -1868,6 +1873,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 					   __func__, table_type,
 					   (ptr -
 					    (u32 *)dd->platform_config.data));
+				ret = -EINVAL;
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table_metadata =
-- 
2.35.1



