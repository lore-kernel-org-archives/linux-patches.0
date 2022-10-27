Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5759FAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0524C433C1;
	Thu, 27 Oct 2022 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890167;
	bh=sRSibHzq0H/78sdMNvmGsd94+aYQZpn8TI6yMhhDJrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpGaphTV5C8HntPtJ4xVUgtOQRwhsAO04zuXpvU92VnVZFGM7eT6g4zWLjtSVlFDh
	 Z54aKwsvCyu6p60mhlvIJ8bbT9rIqPgxiESh6jN+pZGqHKTNWgIxZnHPnpayY9AUZQ
	 wKsCvt9++ZkvIg6z1YpBOl0sCYuzC7nzU9C2xn5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/79] cifs: Fix xid leak in cifs_copy_file_range()
Date: Thu, 27 Oct 2022 18:55:45 +0200
Message-Id: <20221027165056.469819014@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 9a97df404a402fe1174d2d1119f87ff2a0ca2fe9 ]

If the file is used by swap, before return -EOPNOTSUPP, should
free the xid, otherwise, the xid will be leaked.

Fixes: 4e8aea30f775 ("smb3: enable swap on SMB3 mounts")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8ec55bbd705d..668dd6a86295 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1263,8 +1263,11 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
 	ssize_t rc;
 	struct cifsFileInfo *cfile = dst_file->private_data;
 
-	if (cfile->swapfile)
-		return -EOPNOTSUPP;
+	if (cfile->swapfile) {
+		rc = -EOPNOTSUPP;
+		free_xid(xid);
+		return rc;
+	}
 
 	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
 					len, flags);
-- 
2.35.1



