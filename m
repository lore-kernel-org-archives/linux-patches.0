Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6DC746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894F3C433C9;
	Sun, 17 Sep 2023 20:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983055;
	bh=7uH/qq8VLOiF/0vLOzykWm45WKF3kYKYmFRriAp1L2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMrrvX7eNR4+h9UxpGSiDCT8/0dwDWvz39qnj4JVThkjYhoAmYDumH0rYtPkNFJ3n
	 PxA5uiEti0Pxl1hw5kU1bXpWMSF9vjwzgkvs/wG3kne40mjTCpyPro+K2ckIluKXSZ
	 JYDmad4qGZLuUOS10WZO0UrGQ7MjuEoVmBHiXFlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/511] ceph: make members in struct ceph_mds_request_args_ext a union
Date: Sun, 17 Sep 2023 21:14:19 +0200
Message-ID: <20230917191124.197154600@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 3af5ae22030cb59fab4fba35f5a2b62f47e14df9 ]

In ceph mainline it will allow to set the btime in the setattr request
and just add a 'btime' member in the union 'ceph_mds_request_args' and
then bump up the header version to 4. That means the total size of union
'ceph_mds_request_args' will increase sizeof(struct ceph_timespec) bytes,
but in kclient it will increase the sizeof(setattr_ext) bytes for each
request.

Since the MDS will always depend on the header's vesion and front_len
members to decode the 'ceph_mds_request_head' struct, at the same time
kclient hasn't supported the 'btime' feature yet in setattr request,
so it's safe to do this change here.

This will save 48 bytes memories for each request.

Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head structure")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ceph/ceph_fs.h | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index bc2699feddbeb..8038279a14fa0 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -459,17 +459,19 @@ union ceph_mds_request_args {
 } __attribute__ ((packed));
 
 union ceph_mds_request_args_ext {
-	union ceph_mds_request_args old;
-	struct {
-		__le32 mode;
-		__le32 uid;
-		__le32 gid;
-		struct ceph_timespec mtime;
-		struct ceph_timespec atime;
-		__le64 size, old_size;       /* old_size needed by truncate */
-		__le32 mask;                 /* CEPH_SETATTR_* */
-		struct ceph_timespec btime;
-	} __attribute__ ((packed)) setattr_ext;
+	union {
+		union ceph_mds_request_args old;
+		struct {
+			__le32 mode;
+			__le32 uid;
+			__le32 gid;
+			struct ceph_timespec mtime;
+			struct ceph_timespec atime;
+			__le64 size, old_size;       /* old_size needed by truncate */
+			__le32 mask;                 /* CEPH_SETATTR_* */
+			struct ceph_timespec btime;
+		} __attribute__ ((packed)) setattr_ext;
+	};
 };
 
 #define CEPH_MDS_FLAG_REPLAY		1 /* this is a replayed op */
-- 
2.40.1



