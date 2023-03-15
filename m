Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4154431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F5C433D2;
	Wed, 15 Mar 2023 12:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883815;
	bh=jez07NPNbeloQ0W4CNLmkdHmbG+SEt7LRb7joAVLHUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Zzu+SarQuvSncAGc9Kztn1BCUm7qqd5YRpz20xzPQqiaIE6TgS9we7ksA6RRRgCs
	 pd00AtqZ757RvCbd9653ndKMJK+vDqwobbqQQuqEl/o43fOkjjMPE0zunFlYMS2YHv
	 MPRKuOLcBu7/n5CvVCkiyI2WjY4OQ+nBf48A+/WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 6.1 141/143] filelocks: use mount idmapping for setlease permission check
Date: Wed, 15 Mar 2023 13:13:47 +0100
Message-Id: <20230315115744.919936821@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seth Forshee <sforshee@kernel.org>

commit 42d0c4bdf753063b6eec55415003184d3ca24f6e upstream.

A user should be allowed to take out a lease via an idmapped mount if
the fsuid matches the mapped uid of the inode. generic_setlease() is
checking the unmapped inode uid, causing these operations to be denied.

Fix this by comparing against the mapped inode uid instead of the
unmapped uid.

Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Cc: stable@vger.kernel.org
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1862,9 +1862,10 @@ int generic_setlease(struct file *filp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!vfsuid_eq_kuid(vfsuid, current_fsuid())) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;


