Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B4F3D903F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301097; cv=none; b=ddoWFiIknZcyLlZGXEgUbj7R8J/clW6qQuCF7NwTucyVyvrVt7LbC3NpRhw5jUZ+0jfpP8DTYY9hSxntCxrs/n2nxA3PuWUHzEv6XFPoZ+aFQJnfcQ7sz/AEJp7rjbzP09Aw7UBPoXrZXsNGbvHwDEQ3c0+VKbbW5NSecCnqcPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301097; c=relaxed/simple;
	bh=h2TKtrj+8rGSw4amenWeK+UZZ9XDKmHzELBa5BjL5AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTF7hxxf/UkDQv39OgTA7klmaStFFADG8xkrhTRqZTFS6WJLb6y/F7cO3yeiyguy7hNvVu4dpofWgDoLxN8po/khkzfKtjyoraj2eDqbBuU7SVTMFAhXuw+x7QY0f/8aI7d02AQz+YmDPiJfcPXDqEA1L2ZXsywWt4SXaoEAgtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNwViG7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNwViG7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EA1C116D0;
	Sat, 28 Feb 2026 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301097;
	bh=h2TKtrj+8rGSw4amenWeK+UZZ9XDKmHzELBa5BjL5AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNwViG7x3EMyhu38SR3m5cbIpmC4LhyhxsN+5GlavjpVW8jcbHWOY0srqo+R1kqxH
	 1UcyRquoZhoHjb9cjbXJzvB/ooHyyZtr4PhGpTRF3o/Vl6DLG9HvLxhDCBbbNSpj/A
	 /3dlWdWxysxx79nem+cE6G4YApr5sIFKF+4iA88kxRY5cKyFfs6mdAEnFHt0/si/+2
	 dFOXVFP8hz7c7C33BS73L29w3lj2xnklk6Z1QxmNqxe14HCtJPHg36i0byEurDJ995
	 kGqyrNwXR6edQgdySZGWAW+0YmQNOMXbB3r7FP1pqhAg8Idr0qvsMY+TqHmk4nJW9n
	 IkroBWnIk4zMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Chen <me@linux.beauty>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/752] ext4: mark group extend fast-commit ineligible
Date: Sat, 28 Feb 2026 12:39:20 -0500
Message-ID: <20260228174750.1542406-249-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Chen <me@linux.beauty>

[ Upstream commit 1f8dd813a1c771b13c303f73d876164bc9b327cc ]

Fast commits only log operations that have dedicated replay support.
EXT4_IOC_GROUP_EXTEND grows the filesystem to the end of the last
block group and updates the same on-disk metadata without going
through the fast commit tracking paths.
In practice these operations are rare and usually followed by further
updates, but mixing them into a fast commit makes the overall
semantics harder to reason about and risks replay gaps if new call
sites appear.

Teach ext4 to mark the filesystem fast-commit ineligible when
EXT4_IOC_GROUP_EXTEND grows the filesystem.
This forces those transactions to fall back to a full commit,
ensuring that the group extension changes are captured by the normal
journal rather than partially encoded in fast commit TLVs.
This change should not affect common workloads but makes online
resize via GROUP_EXTEND safer and easier to reason about under fast
commit.

Testing:
1. prepare:
    dd if=/dev/zero of=/root/fc_resize.img bs=1M count=0 seek=256
    mkfs.ext4 -O fast_commit -F /root/fc_resize.img
    mkdir -p /mnt/fc_resize && mount -t ext4 -o loop /root/fc_resize.img /mnt/fc_resize
2. Extended the filesystem to the end of the last block group using a
   helper that calls EXT4_IOC_GROUP_EXTEND on the mounted filesystem
   and checked fc_info:
    ./group_extend_helper /mnt/fc_resize
    cat /proc/fs/ext4/loop0/fc_info
   shows the "Resize" ineligible reason increased.
3. Fsynced a file on the resized filesystem and confirmed that the fast
   commit ineligible counter incremented for the resize transaction:
    touch /mnt/fc_resize/file
    /root/fsync_file /mnt/fc_resize/file
    sync
    cat /proc/fs/ext4/loop0/fc_info

Signed-off-by: Li Chen <me@linux.beauty>
Link: https://patch.msgid.link/20251211115146.897420-6-me@linux.beauty
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d26914fa0cb46..acc28aa5744b1 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1612,6 +1612,8 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
 		if (EXT4_SB(sb)->s_journal) {
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_RESIZE,
+						NULL);
 			jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 			err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal, 0);
 			jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
-- 
2.51.0

