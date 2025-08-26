Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EE221B9DA;
	Tue, 26 Aug 2025 13:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213441; cv=none; b=kktNTaOKlldeqr4S+XcelGN96J/6g3nO41gUT2FZDVGeP3PvDR9UJABKyKGleMNtVu9Bs/a+5gXeB3xWgNrIdvvdPBFi/n/PnrYEiWqxSZTz15I9HKkmVw+XI37+Grh9gSQrmsPL5wEBGHJvlUq0wrzzdwEMxytbvsD127w6V6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213441; c=relaxed/simple;
	bh=7uI0Gkf5YCdBa/khWVSQFJU1gJmDPdJ07S3A3b5og4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4t64rnlDnFHYVSaGbeiW5sa0OK+jvH4bE8uKzh5qvtpQ2YQnZ7ReMrGSp5Ren3O7gF6uTxNQeZZXRQa44A3STUK6r75UYYCZn8uH7sYSMeECGL/TOJTZ3hXtuDJp4mWE11wq5S9/tmo+8zEyz9j9Lvjf+msc+yREDO4vyvSE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAgsYSpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAgsYSpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABB0C4CEF1;
	Tue, 26 Aug 2025 13:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213441;
	bh=7uI0Gkf5YCdBa/khWVSQFJU1gJmDPdJ07S3A3b5og4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAgsYSpVK2rf10KfHhWiAR4rlqHjHByDwX1dMNvUADPdmFSrVBwe66/NhjBh0ZW9B
	 uy3SQnEMBsnykGa6mPUbsTWfo0ne6mTs8Ft7/mVkDB0hMveNbM2/IfzX6pnwyF+xge
	 32x6S12TnOlcdEN4Lm1AtK5OwiRLT8eSuBZBwi4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 350/587] ext4: fix reserved gdt blocks handling in fsmap
Date: Tue, 26 Aug 2025 13:08:19 +0200
Message-ID: <20250826111001.817706380@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 3ffbdd1f1165f1b2d6a94d1b1aabef57120deaf7 upstream.

In some cases like small FSes with no meta_bg and where the resize
doesn't need extra gdt blocks as it can fit in the current one,
s_reserved_gdt_blocks is set as 0, which causes fsmap to emit a 0
length entry, which is incorrect.

  $ mkfs.ext4 -b 65536 -O bigalloc /dev/sda 5G
  $ mount /dev/sda /mnt/scratch
  $ xfs_io -c "fsmap -d" /mnt/scartch

        0: 253:48 [0..127]: static fs metadata 128
        1: 253:48 [128..255]: special 102:1 128
        2: 253:48 [256..255]: special 102:2 0     <---- 0 len entry
        3: 253:48 [256..383]: special 102:3 128

Fix this by adding a check for this case.

Cc: stable@kernel.org
Fixes: 0c9ec4beecac ("ext4: support GETFSMAP ioctls")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Link: https://patch.msgid.link/08781b796453a5770112aa96ad14c864fbf31935.1754377641.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fsmap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -393,6 +393,14 @@ static unsigned int ext4_getfsmap_find_s
 	/* Reserved GDT blocks */
 	if (!ext4_has_feature_meta_bg(sb) || metagroup < first_meta_bg) {
 		len = le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
+
+		/*
+		 * mkfs.ext4 can set s_reserved_gdt_blocks as 0 in some cases,
+		 * check for that.
+		 */
+		if (!len)
+			return 0;
+
 		error = ext4_getfsmap_fill(meta_list, fsb, len,
 					   EXT4_FMR_OWN_RESV_GDT);
 		if (error)


