Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D71581FC;
	Tue, 18 Jun 2024 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716020; cv=none; b=N3VvqcPcrnXBybUMtnl32fAp0eEge1o35805/Pgclo5RivU1GrCQHost88wTsTQaRmUuYmrVeJo+rfKRg1ViWI8vthVQp28d7LKfSpRPtYeNc5ntGEOVbXxw4iXQr8gPDCjsVVg9pxl6Qf/Dllsj/2qxz4TIWJdPtf473UmJrL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716020; c=relaxed/simple;
	bh=BFYGE+T9k96s50AZbAk9cN7SEapVXtvaela5oq6e7nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu+udQZs1XwfPZKn4UpaxvrvyNF7j2y2k4ooNMKoworBfcIm4Iri9UVql/yICC0v2k4A64GburUAMiorwc/WcGBdLzymHGjP5UhomTWNefz4KGUkJ/o04/HEyypSX98kT8pKo8lDwqsnDO54fBNQlWdH3CHby7gvr6bLtuj5l2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8Q8C1j4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8Q8C1j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8C1C3277B;
	Tue, 18 Jun 2024 13:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716020;
	bh=BFYGE+T9k96s50AZbAk9cN7SEapVXtvaela5oq6e7nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8Q8C1j4K9xy31zkuUs5VvLheVZ3hJADOqGO/FuCDqos0PI/89JbY71kGRi5EerG0
	 qvUbv6bWdLVH3lPFRn1HbdXlB99XGzjJvsPkQ4FTnasQBh3Kx2TgVqh54ntSFVh4lI
	 X9aq4reLwTQ8p4X+CFxapFNN0LTse/N2QVfLlQ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/770] fanotify: enable "evictable" inode marks
Date: Tue, 18 Jun 2024 14:35:58 +0200
Message-ID: <20240618123426.807214102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 5f9d3bd520261fd7a850818c71809fd580e0f30c ]

Now that the direct reclaim path is handled we can enable evictable
inode marks.

Link: https://lore.kernel.org/r/20220422120327.3459282-17-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 2 +-
 include/linux/fanotify.h           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ad520a2796181..3a1325c90ff86 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1806,7 +1806,7 @@ static int __init fanotify_user_setup(void)
 
 	BUILD_BUG_ON(FANOTIFY_INIT_FLAGS & FANOTIFY_INTERNAL_GROUP_FLAGS);
 	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_INIT_FLAGS) != 12);
-	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_MARK_FLAGS) != 9);
+	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_MARK_FLAGS) != 10);
 
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark,
 					 SLAB_PANIC|SLAB_ACCOUNT);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 3afdf339d53c9..81f45061c1b18 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -68,6 +68,7 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
 				 FAN_MARK_ONLYDIR | \
 				 FAN_MARK_IGNORED_MASK | \
 				 FAN_MARK_IGNORED_SURV_MODIFY | \
+				 FAN_MARK_EVICTABLE | \
 				 FAN_MARK_FLUSH)
 
 /*
-- 
2.43.0



