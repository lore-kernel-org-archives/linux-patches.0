Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDF4389108;
	Tue, 10 Mar 2026 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142053; cv=none; b=oRXdYsRgiIgyoP4xXX2OxR7FJ/CQdvagwj1yLcAZGIIQJzi5Ch0VOgCrga4JAWtpmUNDX8dP4PotELTMYJ0rM9/VDWYmFy2XqLiZ5jhWt6LYLgSBjvqggFOkJvEvuYO5IQmsIXisIUBExvlg4hgjUzblzeY75F6ESpjh1SKcmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142053; c=relaxed/simple;
	bh=1bangbAQX2AqFoYs24wOW40X/eOC4NEEtJpSmSVC4mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auUKyik7l+wwNrxLgftGBKh7tC6aaggbn/Vmyf5Z/RMXVNV2xBjEJrQ+fSyO4ZeBo331B9u2Tu/TPFj5fohI6pjSuZUKGDkU1YuSiMR1PWm3S7asJQLN2EKIqET/bFB3GxzyhrPzuI2fawuFivLXLYYHXoYFB6VWdzyx+eBve4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3V8s+bQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3V8s+bQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81800C19423;
	Tue, 10 Mar 2026 11:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142053;
	bh=1bangbAQX2AqFoYs24wOW40X/eOC4NEEtJpSmSVC4mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3V8s+bQMM7mlzjigZrr23XJi88e1R4yTrj/l+8PtBQIsiFtClCd3NPj5ErtQM+bI
	 szW9DhVRD0p7wWW4zLS+2OjuVH7YUdumuNEMEU8TOA0RCvEqvTspa+BJjxqKZZDat8
	 A3udCWviu6nSnL0LgleZzOXsFs54FBbzs9e/24rOYwcOc2btggd243WXpfpUxvcXZM
	 akZsmQnvDahcoXb0uX0zchFe8kX8FiOfDt8W/RfmqmkrkUHu3LWJQYjrDcWWqaA4hW
	 sE/kgG+XfOrPBurSIJ2iMhHlrfDyH/3r0IVcWe4pqHp6TTTPr1YCBTuqoDWl36kig0
	 GXfW2MaFMULPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 179/314] Squashfs: check metadata block offset is within range
Date: Tue, 10 Mar 2026 07:17:18 -0400
Message-ID: <f9db5af9aea7e3db103a5a4649e8c4001df473d4.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Phillip Lougher <phillip@squashfs.org.uk>

commit fdb24a820a5832ec4532273282cbd4f22c291a0d upstream.

Syzkaller reports a "general protection fault in squashfs_copy_data"

This is ultimately caused by a corrupted index look-up table, which
produces a negative metadata block offset.

This is subsequently passed to squashfs_copy_data (via
squashfs_read_metadata) where the negative offset causes an out of bounds
access.

The fix is to check that the offset is within range in
squashfs_read_metadata.  This will trap this and other cases.

Link: https://lkml.kernel.org/r/20260217050955.138351-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Reported-by: syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/699234e2.a70a0220.2c38d7.00e2.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 181260e72680c..92fb857d2c761 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -344,6 +344,9 @@ int squashfs_read_metadata(struct super_block *sb, void *buffer,
 	if (unlikely(length < 0))
 		return -EIO;
 
+	if (unlikely(*offset < 0 || *offset >= SQUASHFS_METADATA_SIZE))
+		return -EIO;
+
 	while (length) {
 		entry = squashfs_cache_get(sb, msblk->block_cache, *block, 0);
 		if (entry->error) {
-- 
2.51.0

