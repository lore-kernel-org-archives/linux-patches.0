Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061F11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF7BC433C8;
	Mon, 28 Aug 2023 10:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217754;
	bh=qgP0zrs1RgUyd3HTs/EQDkHrD9MILVAC2O0XKnvwi8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiyBVJFljPM4Leu/ca84yrN/sOXC19uEmCNqs8t9O46V1wxq3QXK2AtAqzry79mxa
	 sVYlvaR6GUOdyyv6appApVUuapcLG5YgpaFvFCXUUZl7YpuNnRI6fWb80lexvP29J0
	 AB8yiu3fcvYEAeBiqLpo1Qpos7mQdG6bwQpfHpVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Immad Mir <mirimmad17@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/57] FS: JFS: Check for read-only mounted filesystem in txBegin
Date: Mon, 28 Aug 2023 12:12:30 +0200
Message-ID: <20230828101144.577715264@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Immad Mir <mirimmad17@gmail.com>

[ Upstream commit 95e2b352c03b0a86c5717ba1d24ea20969abcacc ]

 This patch adds a check for read-only mounted filesystem
 in txBegin before starting a transaction potentially saving
 from NULL pointer deref.

Signed-off-by: Immad Mir <mirimmad17@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_txnmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 224ef034004b7..2cb460912468e 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -367,6 +367,11 @@ tid_t txBegin(struct super_block *sb, int flag)
 	jfs_info("txBegin: flag = 0x%x", flag);
 	log = JFS_SBI(sb)->log;
 
+	if (!log) {
+		jfs_error(sb, "read-only filesystem\n");
+		return 0;
+	}
+
 	TXN_LOCK();
 
 	INCREMENT(TxStat.txBegin);
-- 
2.40.1



