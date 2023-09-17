Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E666FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11189C433C8;
	Sun, 17 Sep 2023 19:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980464;
	bh=dmsLguZ9znPnsJmAtocGyeM80bpyU/35NFFfSP2TJT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0caAjBwgMCTqjVSTWVBRxIW8D0yVdulUz9X00GfK5wMz/2F5Om4hqpPSfvm+32wFq
	 ym3x9pDhAd/LlidCihelhI/dDH0mMKv63Vs9QsmGssK2JVLvMLLmuH3b2/3oxTLGet
	 w+KX1D3o3eteahCVORJmgEFsYr7/CIAAwHp1+p+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chen <chenhao418@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 169/285] net: hns3: fix debugfs concurrency issue between kfree buffer and read
Date: Sun, 17 Sep 2023 21:12:49 +0200
Message-ID: <20230917191057.493860481@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Chen <chenhao418@huawei.com>

[ Upstream commit c295160b1d95e885f1af4586a221cb221d232d10 ]

Now in hns3_dbg_uninit(), there may be concurrency between
kfree buffer and read, it may result in memory error.

Moving debugfs_remove_recursive() in front of kfree buffer to ensure
they don't happen at the same time.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index f276b5ecb431f..26fb6fefcb9d9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1411,9 +1411,9 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 	return 0;
 
 out:
-	mutex_destroy(&handle->dbgfs_lock);
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
+	mutex_destroy(&handle->dbgfs_lock);
 	return ret;
 }
 
@@ -1421,6 +1421,9 @@ void hns3_dbg_uninit(struct hnae3_handle *handle)
 {
 	u32 i;
 
+	debugfs_remove_recursive(handle->hnae3_dbgfs);
+	handle->hnae3_dbgfs = NULL;
+
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++)
 		if (handle->dbgfs_buf[i]) {
 			kvfree(handle->dbgfs_buf[i]);
@@ -1428,8 +1431,6 @@ void hns3_dbg_uninit(struct hnae3_handle *handle)
 		}
 
 	mutex_destroy(&handle->dbgfs_lock);
-	debugfs_remove_recursive(handle->hnae3_dbgfs);
-	handle->hnae3_dbgfs = NULL;
 }
 
 void hns3_dbg_register_debugfs(const char *debugfs_dir_name)
-- 
2.40.1



