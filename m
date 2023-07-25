Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8079B1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0291FC433C8;
	Tue, 25 Jul 2023 11:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282991;
	bh=b5DAxg33cj2tHPTxN31GKwPM82ZUFVAQXamkAOWTxKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Veom/LloJvYld6b+7cYCNMnR9eWkxDJPRjt37RM5OHSHvrxZjjZuFFERv+C8he0p6
	 o/Aa1wewa/Xb9MW8PeZKkE0UakvtsCgNmqVwXljgXGur59PuWXmXFlGQrihUQivif3
	 GxLsxLvJhsCV4yN9Is3cEzR1zMdDmtfsC6sMNu6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Immad Mir <mirimmad17@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/183] [PATCH AUTOSEL 4.19 11/11] FS: JFS: Check for read-only mounted filesystem in txBegin
Date: Tue, 25 Jul 2023 12:44:49 +0200
Message-ID: <20230725104510.160546344@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit 95e2b352c03b0a86c5717ba1d24ea20969abcacc ]

 This patch adds a check for read-only mounted filesystem
 in txBegin before starting a transaction potentially saving
 from NULL pointer deref.

Signed-off-by: Immad Mir <mirimmad17@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_txnmgr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -354,6 +354,11 @@ tid_t txBegin(struct super_block *sb, in
 	jfs_info("txBegin: flag = 0x%x", flag);
 	log = JFS_SBI(sb)->log;
 
+	if (!log) {
+		jfs_error(sb, "read-only filesystem\n");
+		return 0;
+	}
+
 	TXN_LOCK();
 
 	INCREMENT(TxStat.txBegin);


