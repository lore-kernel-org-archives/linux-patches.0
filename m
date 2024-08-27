Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2166B1C6888;
	Tue, 27 Aug 2024 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770309; cv=none; b=RC5lqv5TFYQ/tm1bXigr7nzU91XVUUaihVrjOusAfm9TbMSeuHpM3F5C1hIcQ3tGgCeKG6cCwGN0tu9M00Je2diiu3IPNejQu6hDbY9GIE95TAObNv/1fwzOcW06GfKyfV2Iv5hWths68lkgXyHSd+jxlWsBATq/+G7/Z/muaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770309; c=relaxed/simple;
	bh=e5LuU/nvbm0zw1XigW5Hscv/I1AAogPMJqXyeRhTzHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9m/ekvt/lu+cAcpmTWnqH6w+IWSsqG7vK70NOXmYKFW7R6jpd1h0Sv+Ft02IZhnZzJAHehte04lhN6zNgk/Tf5/5dJ4yinpnuDttpTRm8A0xqXUeNQJhNXt2PLh0o3xBlNb/NrxtZb/Xx40nmJ8QESp/hH4KLHQyJUnEk4vXUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6v2f3FX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6v2f3FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D55CC4DE03;
	Tue, 27 Aug 2024 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770309;
	bh=e5LuU/nvbm0zw1XigW5Hscv/I1AAogPMJqXyeRhTzHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6v2f3FXWmH0T5ptn7hWFgqmNbEggfPYrxM7GGutbr79LgsfLdZhP/cfTtCQnyyxM
	 yMVOvCpYoSSTuzl8lsxUDvftKrbLvh5n1mJjuFSikqUqYdm0ZaCNFjZqs19Udn8RAc
	 jGQtqFWWh7PaWbhUPOd7FtV0igk4bEY4J7pO6QXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/341] quota: Remove BUG_ON from dqget()
Date: Tue, 27 Aug 2024 16:36:30 +0200
Message-ID: <20240827143849.466633299@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 249f374eb9b6b969c64212dd860cc1439674c4a8 ]

dqget() checks whether dquot->dq_sb is set when returning it using
BUG_ON. Firstly this doesn't work as an invalidation check for quite
some time (we release dquot with dq_sb set these days), secondly using
BUG_ON is quite harsh. Use WARN_ON_ONCE and check whether dquot is still
hashed instead.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7a2c9b153be6e..23dbde1de2520 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -995,9 +995,8 @@ struct dquot *dqget(struct super_block *sb, struct kqid qid)
 	 * smp_mb__before_atomic() in dquot_acquire().
 	 */
 	smp_rmb();
-#ifdef CONFIG_QUOTA_DEBUG
-	BUG_ON(!dquot->dq_sb);	/* Has somebody invalidated entry under us? */
-#endif
+	/* Has somebody invalidated entry under us? */
+	WARN_ON_ONCE(hlist_unhashed(&dquot->dq_hash));
 out:
 	if (empty)
 		do_destroy_dquot(empty);
-- 
2.43.0



