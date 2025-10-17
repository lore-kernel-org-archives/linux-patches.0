Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082BA33711F;
	Fri, 17 Oct 2025 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713983; cv=none; b=sFciETaZDLjEoCKIiY9gtbLxn4ComI94w2ZDVGprsMQqECKCr/SSwM3pY9k4H/1mNNXr8tavlrzqc9bOTo9eHm9i3Rv87B6t3NwNs8stQrBHbYr4IMVvfAakyco3b+a9Pyb+82ogA1ozPU38PWbvLBcT2Yj+HlB3vG5Pz3aA6AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713983; c=relaxed/simple;
	bh=0Ls6NTcYN7qTO3GT/Vt0PcG/SV10/ppn/Mpf/NH2OL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkB9X7ioNRUNotrcX5R87zKndY4c+WaJoW/uSnwNLI4s2ceh21ZhuuDsaebu14GJ4R1mIZKN5jNgEzw6pE41xe/xbuDlSVGu67vQ4JLdVLyQaUlthpyATgspfpMU7lR+p6cks+CIGpydZxio0rEHs3AXPPynZhlx6h7wk4B42i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBeF00BK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBeF00BK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82945C4CEE7;
	Fri, 17 Oct 2025 15:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713982;
	bh=0Ls6NTcYN7qTO3GT/Vt0PcG/SV10/ppn/Mpf/NH2OL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBeF00BKmheu0PMHxM4ujRWEcWwwSeuwNw6jQ8P6dysbhgAF6EC2N342MCyF2v9vs
	 Hw9BU5t4mZAFMSs1I0Y6d2loEvq4+8z4WwDDicKBqV/PLC1rOYseJQd/xvbYpt+MgG
	 V1FOvgEm+dMCMFoAn7UKhAZR4UZGNBWSciDMEIio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 155/201] ext4: free orphan info with kvfree
Date: Fri, 17 Oct 2025 16:53:36 +0200
Message-ID: <20251017145140.424696512@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 971843c511c3c2f6eda96c6b03442913bfee6148 upstream.

Orphan info is now getting allocated with kvmalloc_array(). Free it with
kvfree() instead of kfree() to avoid complaints from mm.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 0a6ce20c1564 ("ext4: verify orphan file size is not too big")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-ID: <20251007134936.7291-2-jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -513,7 +513,7 @@ void ext4_release_orphan_info(struct sup
 		return;
 	for (i = 0; i < oi->of_blocks; i++)
 		brelse(oi->of_binfo[i].ob_bh);
-	kfree(oi->of_binfo);
+	kvfree(oi->of_binfo);
 }
 
 static struct ext4_orphan_block_tail *ext4_orphan_block_tail(
@@ -638,7 +638,7 @@ int ext4_init_orphan_info(struct super_b
 out_free:
 	for (i--; i >= 0; i--)
 		brelse(oi->of_binfo[i].ob_bh);
-	kfree(oi->of_binfo);
+	kvfree(oi->of_binfo);
 out_put:
 	iput(inode);
 	return ret;


