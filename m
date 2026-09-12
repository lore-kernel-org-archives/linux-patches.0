Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3197356744;
	Sat, 12 Sep 2026 11:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211279; cv=none; b=l4LgmqrsEz/xjcBVPJJsvK5/1NX4EyszEgavQS+EAuwEb+lPGhihqAB1HzwAdFgWXrCU7fGX2sgR34JxUtMboAE3sbbL1R/+NJU4wOj4xDWIw/l/+pjp0MPLnIp6ST2Lc1AxoykMZ40DsTxpm0yRNgNrXgq3ZBpUXjEvm3Jw+mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211279; c=relaxed/simple;
	bh=va+Pf7gYvpsp2eu1LrGgEB9jyfMFFY0LsMsGdqYhSI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvmU34Hw7NBFj5XDY8lYRYTCuDzLO9ie0DCz+F6fV6iWh2pccjghkYi7ygCSh3YNxYzj4vwrvKyL3FJy25rS/o3o74sQ0qdxi9p3U08ZQ5ASH3KrIBB9BXnX34Gx2tRlcltLrohDMxbX5/R/T3FvmnUTTH4FZOasdIvd4MuMId8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEHelZic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEHelZic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830121F000FF;
	Sat, 12 Sep 2026 11:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211277;
	bh=6dZ8BJu6iHUGV4HitCM7cfpeIooEIxw5IjEJS7xuceg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEHelZic4im9wsBLkIZJOMyI7L8DIvg/nikv0R9OBBnAGbfTkyF8neaC1+qHARD7Y
	 574ElhCi6m+nXGRA49RZACQ44JvDShGQWEymSmf04bd4ufB6360a5kNFTtEqDBHUPY
	 aqZicsJfqXrrctSBhUJl61eVBt419TMDKdEwFORo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1156/1518] super: fix dying superblock warning messages
Date: Sat, 12 Sep 2026 08:55:25 +0200
Message-ID: <20260912065649.608709988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 9ac8fd831252e52aa78399eaccc11a72f6c2af1a ]

WARN_ON_ONCE() takes a condition, not a message. The string literals
are always true, so the warnings still trigger but the messages are
never printed.

Use WARN_ONCE(1, ...) instead to print the messages and keep the
once-only behavior.

Found with a Coccinelle script. Clang's -Wstring-conversion also flags
such calls but is not enabled in kernel builds.

Fixes: f0cd988016f6 ("fs: massage locking helpers")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260808123802.73687-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 8af2ee9395bcc..3fe887425c8e8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -2083,7 +2083,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 	int ret;
 
 	if (!super_lock_excl(sb)) {
-		WARN_ON_ONCE("Dying superblock while freezing!");
+		WARN_ONCE(1, "Dying superblock while freezing!");
 		return -EINVAL;
 	}
 	atomic_inc(&sb->s_active);
@@ -2247,7 +2247,7 @@ int thaw_super(struct super_block *sb, enum freeze_holder who,
 	       const void *freeze_owner)
 {
 	if (!super_lock_excl(sb)) {
-		WARN_ON_ONCE("Dying superblock while thawing!");
+		WARN_ONCE(1, "Dying superblock while thawing!");
 		return -EINVAL;
 	}
 	return thaw_super_locked(sb, who, freeze_owner);
-- 
2.53.0



