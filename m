Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10DAAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6797AC433D6;
	Thu, 27 Oct 2022 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890348;
	bh=JdJn/9o0EpFKbKSqDVyIpUdzwW/fBKH4Ai+3IGpvqaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKfRlmEA+djG65snt7X8X1/VhfEZXiDngyKOCGBkTAAGpAo7wZOmnimmr0QKE1ozN
	 LQJ5y1sHQk8ndUn3dyldCp/jEhMHD5V89LggCil53pS2bhwtPsiUanwq1VGcgyaYED
	 LjZd5q/Sm5K9L/kOHgTtaWuQDHGkUpOUEW6g/7rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/79] cifs: Fix xid leak in cifs_copy_file_range()
Date: Thu, 27 Oct 2022 18:55:47 +0200
Message-Id: <20221027165055.626493417@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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
index bc957e6ca48b..f442ef8b65da 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1221,8 +1221,11 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
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



