Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C4210E0;
	Tue, 26 Aug 2025 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218028; cv=none; b=uadlUudRuyxfUg+sM5ITTP6KjytOe1MLXa3+sUOJ8R1NZdXiFshzRfnxSPS4WiYbtTzakPvqVsjVRtPUd3QKxeEbgTqHS7lXOyuyaJnaZe+4WfsFZ7QzjxlO92CgPSXmvLMcd619WlsnVPPoPHDSRNlDtY3R5EA7WI776NHG6WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218028; c=relaxed/simple;
	bh=wt0tV6Y+R6A3TCvHJq8Fz+HQtE50zpTp5Xz8PBbQxPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqCMjn3/zrSevTsjDrOtRVfFM1cOyJ2qtJiNI7ztwXczQ0ZnK8HZfc45qP/f5JAu/Ev58vx1H1cUxex+hcLmPSahsX/3zj9S+Dk89XFNrn+oPU/E24qJQQsrskwnsoUGMjo69RmkOLAwZuuv6VsRh3vCJSO/vIUJyZXSyY2wHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shSIFZw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shSIFZw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C59C4CEF1;
	Tue, 26 Aug 2025 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218028;
	bh=wt0tV6Y+R6A3TCvHJq8Fz+HQtE50zpTp5Xz8PBbQxPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shSIFZw0u94iXbc+psftz25P5JV1poHCTS5GrOSYzjGY1j796H7TbUi+4DguyttlE
	 4lgkOAriEMwOnfd3zWxUQuLpk6W3xe78ljLs73PnS2RAUEcdkPsxysDhs6z4fvvLbO
	 0hh0zCmElKT6DebX9PV3HTN4BeSi9fTRs3aIZQPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 365/523] ext4: fix reserved gdt blocks handling in fsmap
Date: Tue, 26 Aug 2025 13:09:35 +0200
Message-ID: <20250826110933.473043858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


