Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E68A257437;
	Fri, 17 Oct 2025 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716098; cv=none; b=eZr96WcEHV4YdptJGO5iPIdy/m5KgoSwAqRFwDPrDMkmzSsknD8zAz3/Rysz87isCoL0RVrGgKJdpePwLOgzbQJsmDYbhScszBvpzqAKgGaz58a2Abg5KHXfV2LNle1lF2Dzr9HuX/t9nj3i93KZ8VMKgFZ3cg5sERw0b8RGK9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716098; c=relaxed/simple;
	bh=iERE1/Jb2HJn4+EENqyhvOBZ9nwmQjC9I6rgC6hLOFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxBPSIU/GzwFN+VBnPwGiptnuycYcAyTfRKfMU7rhx8Zk7yeuaDakDVXE141WtrPcQZJsfS2TGZ+e6nTrFEeZE7UYnhJRfxlB77aw02xwh01RDorsV+ai7G7U9G+2LIgvhszlzmgvpJcWQ9TJVAL1i7RwlAWni+sYjQmFtY4n30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1feZ3om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1feZ3om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD95C113D0;
	Fri, 17 Oct 2025 15:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716097;
	bh=iERE1/Jb2HJn4+EENqyhvOBZ9nwmQjC9I6rgC6hLOFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1feZ3omm6dq33wMVrFJ+CGhUXpflEC6L7TDI6X2QcC0b6j04kW32NiXtJt3xA+8H
	 /5zCMjBwFIOh2c625qU5a+tmpUZ9NwGn7n2M6ywXL+u04E6oLdREpO7oHHoqG51vRe
	 5hF8w1kYshGMkkdSAJdRaCHo4+K7LbYsgMiz7k1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Grigoryev <Vitaly.Grigoryev@kaspersky.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/276] fs: ntfs3: Fix integer overflow in run_unpack()
Date: Fri, 17 Oct 2025 16:52:44 +0200
Message-ID: <20251017145145.078427558@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

From: Vitaly Grigoryev <Vitaly.Grigoryev@kaspersky.com>

[ Upstream commit 736fc7bf5f68f6b74a0925b7e072c571838657d2 ]

The MFT record relative to the file being opened contains its runlist,
an array containing information about the file's location on the physical
disk. Analysis of all Call Stack paths showed that the values of the
runlist array, from which LCNs are calculated, are not validated before
run_unpack function.

The run_unpack function decodes the compressed runlist data format
from MFT attributes (for example, $DATA), converting them into a runs_tree
structure, which describes the mapping of virtual clusters (VCN) to
logical clusters (LCN). The NTFS3 subsystem also has a shortcut for
deleting files from MFT records - in this case, the RUN_DEALLOCATE
command is sent to the run_unpack input, and the function logic
provides that all data transferred to the runlist about file or
directory is deleted without creating a runs_tree structure.

Substituting the runlist in the $DATA attribute of the MFT record for an
arbitrary file can lead either to access to arbitrary data on the disk
bypassing access checks to them (since the inode access check
occurs above) or to destruction of arbitrary data on the disk.

Add overflow check for addition operation.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Vitaly Grigoryev <Vitaly.Grigoryev@kaspersky.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/run.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index 6940ee5432ba3..52ce16218b299 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -9,6 +9,7 @@
 #include <linux/blkdev.h>
 #include <linux/fs.h>
 #include <linux/log2.h>
+#include <linux/overflow.h>
 
 #include "debug.h"
 #include "ntfs.h"
@@ -935,12 +936,16 @@ int run_unpack(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
 
 			if (!dlcn)
 				return -EINVAL;
-			lcn = prev_lcn + dlcn;
+
+			if (check_add_overflow(prev_lcn, dlcn, &lcn))
+				return -EINVAL;
 			prev_lcn = lcn;
 		} else
 			return -EINVAL;
 
-		next_vcn = vcn64 + len;
+		if (check_add_overflow(vcn64, len, &next_vcn))
+			return -EINVAL;
+
 		/* Check boundary. */
 		if (next_vcn > evcn + 1)
 			return -EINVAL;
@@ -1101,7 +1106,8 @@ int run_get_highest_vcn(CLST vcn, const u8 *run_buf, u64 *highest_vcn)
 			return -EINVAL;
 
 		run_buf += size_size + offset_size;
-		vcn64 += len;
+		if (check_add_overflow(vcn64, len, &vcn64))
+			return -EINVAL;
 
 #ifndef CONFIG_NTFS3_64BIT_CLUSTER
 		if (vcn64 > 0x100000000ull)
-- 
2.51.0



