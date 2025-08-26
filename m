Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11B6338F51;
	Tue, 26 Aug 2025 11:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207072; cv=none; b=n+tc8UTRs4580etLfdPxh/cBgm3VIa1Rke1JjIMWv4+WZ19gwDhpMbxm6Zfpf6bzKr7FykLL2oS5YX/s5eMBCgvw4388AYGQD/pyfOqVqpGJTp7TcmeTz2ZheYc3sGU0ymQuKkxePhZQ3T9fo3VJ1TU6cAWCEQVUihUh0OSoyqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207072; c=relaxed/simple;
	bh=wBcak2O8EDa+56oC2kSjJj1irIgimLjiNZsTo9Wgbv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS49+fRF5FS1ZdUnF+poce+G6eJ60U/2ClZCql9GEE3dQ0tcihU/kpAGFHBvIUBpFhy/eXwInJ6Lpr3s7V2JpngRuOzQN03/Qz8qFNaC+qkUc4hfqh/FRvqC9Z4cFOSgDSigWqNU3m3ZybesoEfiJ+tpeDyPeN5jbvgu2jtNsI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRhhOoBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRhhOoBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBFCC4CEF4;
	Tue, 26 Aug 2025 11:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207072;
	bh=wBcak2O8EDa+56oC2kSjJj1irIgimLjiNZsTo9Wgbv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRhhOoBvt0UcazrqCseNKkx5uhV3/pASwNLpzBIHM5ZUFuB2IdoZTIw6vP7JA4dsw
	 Id6tnKEKPYvpnSmVWGXesZjbwR3DMSUGlCGRV/4j4Ntp128xLjuC6BaeqC1LK4T7aG
	 BUdepNJPiR7ThpE9a4PDA22oslXzVfXzO/VtIPTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 040/457] ext4: fix reserved gdt blocks handling in fsmap
Date: Tue, 26 Aug 2025 13:05:24 +0200
Message-ID: <20250826110938.337762530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


