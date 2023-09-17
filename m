Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C6A63BB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B559C433C8;
	Sun, 17 Sep 2023 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980481;
	bh=R319RyPyS26RBAlcChmTcoVvQ63P9L1u9oKIz/Bmk+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWRSpIlHQCdjlJlu0Yi8YcReqvF/+uPxOro1A/OY7ai6Jg8L7Z8YNIGYD+7ekDLnt
	 2AOG/3oL/NukiFSCiNZZGlEHOqi9/ndIoV1CL4qiDmAJnykG0k1bzxzyOE8oQdNd6r
	 V16vlbCHenJN8vubH+iXMy1VId6q6myDTDnN9gAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 205/285] btrfs: dont start transaction when joining with TRANS_JOIN_NOSTART
Date: Sun, 17 Sep 2023 21:13:25 +0200
Message-ID: <20230917191058.669956635@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 4490e803e1fe9fab8db5025e44e23b55df54078b upstream.

When joining a transaction with TRANS_JOIN_NOSTART, if we don't find a
running transaction we end up creating one. This goes against the purpose
of TRANS_JOIN_NOSTART which is to join a running transaction if its state
is at or below the state TRANS_STATE_COMMIT_START, otherwise return an
-ENOENT error and don't start a new transaction. So fix this to not create
a new transaction if there's no running transaction at or below that
state.

CC: stable@vger.kernel.org # 4.14+
Fixes: a6d155d2e363 ("Btrfs: fix deadlock between fiemap and transaction commits")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -292,10 +292,11 @@ loop:
 	spin_unlock(&fs_info->trans_lock);
 
 	/*
-	 * If we are ATTACH, we just want to catch the current transaction,
-	 * and commit it. If there is no transaction, just return ENOENT.
+	 * If we are ATTACH or TRANS_JOIN_NOSTART, we just want to catch the
+	 * current transaction, and commit it. If there is no transaction, just
+	 * return ENOENT.
 	 */
-	if (type == TRANS_ATTACH)
+	if (type == TRANS_ATTACH || type == TRANS_JOIN_NOSTART)
 		return -ENOENT;
 
 	/*


