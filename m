Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4966115957C;
	Mon, 29 Jan 2024 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548447; cv=none; b=FZoORbcMLB439WBf7A9IIxtsUwSSnei51XgS6fXeMiaOPktrYllHsArmNYsTlQsGP40gZPe7yPnMW2xryrFVPjpVpEP3l2fWWW5n75tmqOp9PhO8XJME11b9lNcs6hQlSbwH7uQq5XrGGl4k7rpe9Gi4stXgYinfhZXbvd3ksmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548447; c=relaxed/simple;
	bh=YdKFUKm5wHclTPFXbuwKYPmD1kUG8u0GmWf3uKYO3tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tv45ywEi3L9j9qOQC8FyiRTwA1HWSinzw+/68qie19L3HN/YHeqNLRBWQ6oFg8aqUahdUfuTlvtA4EZ56/bU6S3N8ppzjkannw+nYc/b7gXLEIKQqV1y5sE5UubmVSSaAn0W685vYw6aE6mCc4+ppZLaByLKXRiy0bxvIRMwhzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KE4HKdLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KE4HKdLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2A5C433C7;
	Mon, 29 Jan 2024 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548447;
	bh=YdKFUKm5wHclTPFXbuwKYPmD1kUG8u0GmWf3uKYO3tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KE4HKdLhwTpSru/8BgkrzeOKVhswmIOM0ksxSkUGhKAW8Oz+SqVfKRXigHBQojMaC
	 zTY3LHUhW2uZOa2FQGpybCGu1Y7KERVdFUmbk+5E2VSWZLxx0nqxq81ka5xKZk+9h6
	 EbEFrPuDY3MXLOZ4EkPvrgLghVffW7yDylahy4/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 030/331] ext4: allow for the last group to be marked as trimmed
Date: Mon, 29 Jan 2024 09:01:34 -0800
Message-ID: <20240129170015.838499081@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Suraj Jitindar Singh <surajjs@amazon.com>

commit 7c784d624819acbeefb0018bac89e632467cca5a upstream.

The ext4 filesystem tracks the trim status of blocks at the group
level.  When an entire group has been trimmed then it is marked as
such and subsequent trim invocations with the same minimum trim size
will not be attempted on that group unless it is marked as able to be
trimmed again such as when a block is freed.

Currently the last group can't be marked as trimmed due to incorrect
logic in ext4_last_grp_cluster(). ext4_last_grp_cluster() is supposed
to return the zero based index of the last cluster in a group. This is
then used by ext4_try_to_trim_range() to determine if the trim
operation spans the entire group and as such if the trim status of the
group should be recorded.

ext4_last_grp_cluster() takes a 0 based group index, thus the valid
values for grp are 0..(ext4_get_groups_count - 1). Any group index
less than (ext4_get_groups_count - 1) is not the last group and must
have EXT4_CLUSTERS_PER_GROUP(sb) clusters. For the last group we need
to calculate the number of clusters based on the number of blocks in
the group. Finally subtract 1 from the number of clusters as zero
based indexing is expected.  Rearrange the function slightly to make
it clear what we are calculating and returning.

Reproducer:
// Create file system where the last group has fewer blocks than
// blocks per group
$ mkfs.ext4 -b 4096 -g 8192 /dev/nvme0n1 8191
$ mount /dev/nvme0n1 /mnt

Before Patch:
$ fstrim -v /mnt
/mnt: 25.9 MiB (27156480 bytes) trimmed
// Group not marked as trimmed so second invocation still discards blocks
$ fstrim -v /mnt
/mnt: 25.9 MiB (27156480 bytes) trimmed

After Patch:
fstrim -v /mnt
/mnt: 25.9 MiB (27156480 bytes) trimmed
// Group marked as trimmed so second invocation DOESN'T discard any blocks
fstrim -v /mnt
/mnt: 0 B (0 bytes) trimmed

Fixes: 45e4ab320c9b ("ext4: move setting of trimmed bit into ext4_try_to_trim_range()")
Cc:  <stable@vger.kernel.org> # 4.19+
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231213051635.37731-1-surajjs@amazon.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6887,11 +6887,16 @@ __acquires(bitlock)
 static ext4_grpblk_t ext4_last_grp_cluster(struct super_block *sb,
 					   ext4_group_t grp)
 {
-	if (grp < ext4_get_groups_count(sb))
-		return EXT4_CLUSTERS_PER_GROUP(sb) - 1;
-	return (ext4_blocks_count(EXT4_SB(sb)->s_es) -
-		ext4_group_first_block_no(sb, grp) - 1) >>
-					EXT4_CLUSTER_BITS(sb);
+	unsigned long nr_clusters_in_group;
+
+	if (grp < (ext4_get_groups_count(sb) - 1))
+		nr_clusters_in_group = EXT4_CLUSTERS_PER_GROUP(sb);
+	else
+		nr_clusters_in_group = (ext4_blocks_count(EXT4_SB(sb)->s_es) -
+					ext4_group_first_block_no(sb, grp))
+				       >> EXT4_CLUSTER_BITS(sb);
+
+	return nr_clusters_in_group - 1;
 }
 
 static bool ext4_trim_interrupted(void)


