Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BB8357D1D;
	Sat, 12 Sep 2026 19:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240205; cv=none; b=KrbVXFZESwf48ZJOLDu1rbFje8aE88xfjnwiqd67MYh7MYeT1VbtOx5Qvwhn9PRElLeU5nuMLuQ8o+CNOKy+Z8lW7REashj0NaLu/N7chbRWApbJnzAo+/pG2GkHkHMrxqjTM0TjNa/3tczAoN9rciTxZaDM0g1K+LfV3ghZ6bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240205; c=relaxed/simple;
	bh=sxF1PVhI4p4IWOx9C34NEOLA91yGIt6Cpu/DSTsw90g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7dLfxvLa8aQ8QAoKknCaE6TWSH6g2Xpfs1Cv3hk+fF2CeAmPiXatNkyBJw0EdT11Iclh10O4DapMq3a/hZzEtvDLqoffDo7WnWz2k4ZFJMLg3/szfTonM52Kl5XSZjzNw3RlNRsQYwTvoobgZG9GLL+n/sPLyjOPymsszOxDlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjwIMFbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjwIMFbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BCE1F000FF;
	Sat, 12 Sep 2026 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240204;
	bh=BLb8n9SdXlxhHVEJRWuYPzmrPF2fVLVGUgP4A7Nz41k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjwIMFbWMdg5gM8dNW8oLkXMJQvuw+Q4y8vYnOmvm4CKzCKh0yet4lsau7B4HuF09
	 uecCKn0yZCPHG7IaNBQLttQiLvFJpmpDZwY1ytuzJTGa+yvZosEFUcSYu3YBrsl6m9
	 IF7Vjj/WJ5DAvWrIfcYXgzQMEH+w4MwceOiP+yUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Yuejie Shi <syjcnss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 822/935] Squashfs: check block offset is not negative
Date: Sat, 12 Sep 2026 09:04:12 +0200
Message-ID: <20260912065545.680799684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit e300eb5002925b29be803d2661af07266cfa267e ]

If a negative offset is read off disk (for example the offset into the
decompressed fragment block), this will cause squashfs_copy_data() to
perform an out of bounds access.

Fix by checking if offset is negative, and returning 0.  This matches
existing behaviour where an offset beyond the block returns 0 bytes
copied.

To trigger this out of bounds access requires a crafted Squashfs
filesystem and CAP_SYS_ADMIN to mount it.  Unprivileged users will not be
able to mount such a filesystem, but once mounted, an unprivileged user
can trigger the out of bounds access by reading the crafted file with the
negative offset.

Link: https://lore.kernel.org/20260807162951.672510-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Yuejie Shi <syjcnss@gmail.com>
Closes: https://lore.kernel.org/all/20260803032735.81785-1-syjcnss@gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 25bf038b880ab..2091af7416327 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -295,7 +295,7 @@ int squashfs_copy_data(void *buffer, struct squashfs_cache_entry *entry,
 {
 	int remaining = length;
 
-	if (length == 0)
+	if (length == 0 || offset < 0)
 		return 0;
 	else if (buffer == NULL)
 		return min(length, entry->length - offset);
-- 
2.53.0



