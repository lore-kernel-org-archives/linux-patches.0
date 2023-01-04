Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4177AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478E1C433F0;
	Wed,  4 Jan 2023 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849303;
	bh=QNYitRTXsRPTQuDH1PHy+wt3r6D9wX7U8hgp8ThngsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdEenJYzcvI5VFz0eBJByU9Ytz2uwCcY0g8zhzgRPI5KCuQgi7Vi0WvD0C7xRtzUv
	 fdHjVZQJPFz3VI2yV3wkFEK9l+4Pnkn/hKNk+r+TRZgCHKltPTvgtfjmQE+S7Mrio8
	 efdd9qWAVYvZK1MXFRVXeuTcJSJfX9rLbV6mkQ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.0 100/177] ima: Fix memory leak in __ima_inode_hash()
Date: Wed,  4 Jan 2023 17:06:31 +0100
Message-Id: <20230104160510.672945317@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 8c1d6a050a0f16e0a9d32eaf53b965c77279c6f8 upstream.

Commit f3cc6b25dcc5 ("ima: always measure and audit files in policy") lets
measurement or audit happen even if the file digest cannot be calculated.

As a result, iint->ima_hash could have been allocated despite
ima_collect_measurement() returning an error.

Since ima_hash belongs to a temporary inode metadata structure, declared
at the beginning of __ima_inode_hash(), just add a kfree() call if
ima_collect_measurement() returns an error different from -ENOMEM (in that
case, ima_hash should not have been allocated).

Cc: stable@vger.kernel.org
Fixes: 280fe8367b0d ("ima: Always return a file measurement in ima_file_hash()")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 040b03ddc1c7..4a207a3ef7ef 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -542,8 +542,13 @@ static int __ima_inode_hash(struct inode *inode, struct file *file, char *buf,
 
 		rc = ima_collect_measurement(&tmp_iint, file, NULL, 0,
 					     ima_hash_algo, NULL);
-		if (rc < 0)
+		if (rc < 0) {
+			/* ima_hash could be allocated in case of failure. */
+			if (rc != -ENOMEM)
+				kfree(tmp_iint.ima_hash);
+
 			return -EOPNOTSUPP;
+		}
 
 		iint = &tmp_iint;
 		mutex_lock(&iint->mutex);
-- 
2.39.0



