Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7FB2135B8;
	Tue, 26 Aug 2025 11:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208231; cv=none; b=Ts/kzxNPcy9QUzE1V2akewthE9OrZk8a8qCCwDGQvbGv8CbKdi8lDIXKK7vjjM2ywlobYuIQ6mqzKUD6520tu7pKlg6iJxCY8ZeNDgu5EvNsAzs11Vg9K/aXFwyJVuJu5f4FJAi7dbFf+22p44NFMQyC1ibjeZevrKLBoQqnpAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208231; c=relaxed/simple;
	bh=DFquoXEJzH6RDc76dJCoMU/nhRQMrkmhAEBuaYieb8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi9RrpB8c09TKiKEJE5XW1tohx8bC9TAYbjLiVRQw7KbzsF8aU6pBttexxfz38sEVjT59v10me1MWiuX956M3QXB2mQp2oJU3bFurxx/dqJbdi5wvYH64/BhB0iHJPwsqLaFubL+uEWtLjyi2u0IysIpkAcXunrojCu0P/99JbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvIBXX/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvIBXX/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3651C4CEF1;
	Tue, 26 Aug 2025 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208231;
	bh=DFquoXEJzH6RDc76dJCoMU/nhRQMrkmhAEBuaYieb8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvIBXX/Kyk24+IhjpFlLV+uI39gBZqW+QdwjIVpmQb6xKPTSQFC058ec9sIx26r3h
	 NgaSkyPo/NNE6VPEa+LurQN6Qr/+M0r8vHScD8X7+CqMrLapswQvKX9jmXAcVSEZc+
	 Vu5rQO1X9CQySRKiVqT0dxgKLDWGNrAqalBrpwkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 031/322] ext4: fix reserved gdt blocks handling in fsmap
Date: Tue, 26 Aug 2025 13:07:26 +0200
Message-ID: <20250826110916.101690815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


