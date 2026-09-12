Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A39D345CCE;
	Sat, 12 Sep 2026 08:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203369; cv=none; b=eiQMbHpUeQDrxD6WEtbBF/8x8UGJBBEqvvP//xtKwJXoLwgkaUxkg6Lqll+Zlb1nBoAkaa6GB+k9hHjNz2PTfx1MFtTveNHRNmIEWbWWwkIY7LEI9Ay8x1/vTb4jFH/ukcueWyFR6vQr/AC/mAJhlL0PzZFfCFmmGtW3WQnRsLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203369; c=relaxed/simple;
	bh=XzFQceyhzR1ZiYt1kxph1CTFCCZKW8p8ocpz0y0loIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8g5Oz/GRYhnqJ7vdD58/bGGSpyZqf0L01/QLxLJ34lVBllOVC2A6vIeVdn3Bpj3wsZ5nK4M8bRHmn2YwRlTmisonvizxZwQw+0u2NAMDQtUHpTcCLcUyA4Ji95OlE0hN/3x8N3mTTLIYZzUrm/qDeFXsOusOgEXKvMLFJpxINM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiK+IMqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiK+IMqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8DB1F000FF;
	Sat, 12 Sep 2026 08:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203368;
	bh=j7N0ixmy8TpfLamCmUMXtV0VLAFUu9tW7sUCrFrXo/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiK+IMqt4MjNY7HiNZPS+5lDMcid6LOZHtOhtBWYi4Oqaq21SQHcPnLc/sCQESPth
	 bsFNEKc1Bwh353zWtGHcEk613vwbyOZTmJ8qrmJpwlephjqYdwmh2x1dx5xlxEJpGz
	 DKy4dKziDBOhrqe0QrqFQsvJ3BN2HRTZWXBh5VmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1394/1815] super: fix dying superblock warning messages
Date: Sat, 12 Sep 2026 08:52:24 +0200
Message-ID: <20260912065721.749241040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ffdcc6a2e0deb..d94f3a3e988df 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -2018,7 +2018,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 	int ret;
 
 	if (!super_lock_excl(sb)) {
-		WARN_ON_ONCE("Dying superblock while freezing!");
+		WARN_ONCE(1, "Dying superblock while freezing!");
 		return -EINVAL;
 	}
 	atomic_inc(&sb->s_active);
@@ -2182,7 +2182,7 @@ int thaw_super(struct super_block *sb, enum freeze_holder who,
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



