Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65E61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A31C433F0;
	Wed, 28 Dec 2022 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240983;
	bh=4xWzO25yKAwrZVQzrnUup2pMc6HbbTZB6NYWqInom50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9DWRZMhTsoqqavHgF2Rd93YF8/3UsjKYK/aYNuhzv8l81NhMf72ru4PynwHSifV0
	 aLIw7FaSGHvX4jCZxQxSEziFJ5ncvcktuaJvljeQlppPc+CozpQQfReRPuVG2VQszG
	 xt7dXHzOFLxdr9VtFItAeHS8/xhhilRCiiIYW2iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/731] RDMA/hfi1: Fix error return code in parse_platform_config()
Date: Wed, 28 Dec 2022 15:38:51 +0100
Message-Id: <20221228144308.859254737@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 31e63e245ea9..ddf3217893f8 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1744,6 +1744,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 
 	if (!dd->platform_config.data) {
 		dd_dev_err(dd, "%s: Missing config file\n", __func__);
+		ret = -EINVAL;
 		goto bail;
 	}
 	ptr = (u32 *)dd->platform_config.data;
@@ -1752,6 +1753,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	ptr++;
 	if (magic_num != PLATFORM_CONFIG_MAGIC_NUM) {
 		dd_dev_err(dd, "%s: Bad config file\n", __func__);
+		ret = -EINVAL;
 		goto bail;
 	}
 
@@ -1775,6 +1777,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	if (file_length > dd->platform_config.size) {
 		dd_dev_info(dd, "%s:File claims to be larger than read size\n",
 			    __func__);
+		ret = -EINVAL;
 		goto bail;
 	} else if (file_length < dd->platform_config.size) {
 		dd_dev_info(dd,
@@ -1795,6 +1798,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			dd_dev_err(dd, "%s: Failed validation at offset %ld\n",
 				   __func__, (ptr - (u32 *)
 					      dd->platform_config.data));
+			ret = -EINVAL;
 			goto bail;
 		}
 
@@ -1838,6 +1842,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 					   __func__, table_type,
 					   (ptr - (u32 *)
 					    dd->platform_config.data));
+				ret = -EINVAL;
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table = ptr;
@@ -1857,6 +1862,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 					   __func__, table_type,
 					   (ptr -
 					    (u32 *)dd->platform_config.data));
+				ret = -EINVAL;
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table_metadata =
-- 
2.35.1



