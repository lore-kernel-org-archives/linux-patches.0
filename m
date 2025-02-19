Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DD11A314B;
	Wed, 19 Feb 2025 08:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954231; cv=none; b=t8YfILFL9n3B5lnzfgxhJz6ENyg+CD+/qvu4yD013mrCRTD+iRSJZ0YncTFt2voEPJG/onxT1osAZc5PRh4OxuBbmskRFYXUbbkXbuVaTDe+bBx1XxhF7XEt+WZ6aFyGjjzav0A5PC5VAyDOyulXYdyNjGl8Xo42i74/icgDnpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954231; c=relaxed/simple;
	bh=dzuAT1P7ZQh8sTeUs2uxLcyGCrNYBB2tVT3iIdF/jPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWWp9y6ido2tKhW65OWNKCSbkPM68OrowJaETH/eJZD0zuwfF164KhDYJ9feEzNhD8b7dFr7XOMwyKGswujZ2D8gnn1drmKG8IoSMim02Ynh2PgK2T1rh4qUMk+Yio7Lzw2N42WlpQNsSnmpYS8dlI/YFfUEmF5+LYBz+3ofOpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s62e/wQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s62e/wQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B06C4CED1;
	Wed, 19 Feb 2025 08:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954231;
	bh=dzuAT1P7ZQh8sTeUs2uxLcyGCrNYBB2tVT3iIdF/jPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s62e/wQJ4VomnyIZRw2ISLItzgY6EGL8XfXJHxO9j1q85Y1YGIMDkT6ll67m2Zsu+
	 8zgFu5WfFpUhF6nq6M8W1vmR4R6P+6UzUH1vwhBEhtXrYnlDz4NTnDkSHDEeyCJDcq
	 e5diZcKTtqq/kqTfnhGTc0Y+ZOhFbtpA4XubiIYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 106/274] orangefs: fix a oob in orangefs_debug_write
Date: Wed, 19 Feb 2025 09:26:00 +0100
Message-ID: <20250219082613.765337529@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit f7c848431632598ff9bce57a659db6af60d75b39 ]

I got a syzbot report: slab-out-of-bounds Read in
orangefs_debug_write... several people suggested fixes,
I tested Al Viro's suggestion and made this patch.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 1b508f5433846..fa41db0884880 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -393,9 +393,9 @@ static ssize_t orangefs_debug_write(struct file *file,
 	 * Thwart users who try to jamb a ridiculous number
 	 * of bytes into the debug file...
 	 */
-	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN + 1) {
+	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN) {
 		silly = count;
-		count = ORANGEFS_MAX_DEBUG_STRING_LEN + 1;
+		count = ORANGEFS_MAX_DEBUG_STRING_LEN;
 	}
 
 	buf = kzalloc(ORANGEFS_MAX_DEBUG_STRING_LEN, GFP_KERNEL);
-- 
2.39.5



