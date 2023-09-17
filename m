Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CFC63BB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95D3C433C7;
	Sun, 17 Sep 2023 19:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980488;
	bh=egCKt7TXu4Qc0ilwWMzuAlfaKrdnwpfhWv2GYIPtfu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zsi1u6OYrwKGoQ1Kep5F2lwy+GKLfQ/2Ux1S9upicA6AtN+Gjt7ikW8x7lQwC/y6/
	 DlDG7smYm6nUPD91f6I6uoE2WFKAgbxB40zMSvxAv0A1gTNwURLW1/JZ102dIaoyxz
	 qv6goKOu4LV8K457wBIw7ywgXSusk+pefGsI4yJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 207/285] btrfs: zoned: re-enable metadata over-commit for zoned mode
Date: Sun, 17 Sep 2023 21:13:27 +0200
Message-ID: <20230917191058.737926200@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 5b135b382a360f4c87cf8896d1465b0b07f10cb0 upstream.

Now that, we can re-enable metadata over-commit. As we moved the activation
from the reservation time to the write time, we no longer need to ensure
all the reserved bytes is properly activated.

Without the metadata over-commit, it suffers from lower performance because
it needs to flush the delalloc items more often and allocate more block
groups. Re-enabling metadata over-commit will solve the issue.

Fixes: 79417d040f4f ("btrfs: zoned: disable metadata overcommit for zoned")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -389,11 +389,7 @@ int btrfs_can_overcommit(struct btrfs_fs
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
-	if (test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags) &&
-	    (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
-		avail = 0;
-	else
-		avail = calc_available_free_space(fs_info, space_info, flush);
+	avail = calc_available_free_space(fs_info, space_info, flush);
 
 	if (used + bytes < space_info->total_bytes + avail)
 		return 1;


