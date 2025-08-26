Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9053090E0;
	Tue, 26 Aug 2025 13:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213446; cv=none; b=lwuw+zK/kjN3ZWLn7l8PguM+lKAzcTZvyyEKgxZroCAzdxqa3sW3fpYNSjQDeTLA0M2CKf3rHPE+V+eZIDf7bY98laZNZQHGrkmbo4XBbdFJGc5HST1PvL2MFSQxZ8pa6sDJlBb6HFK5txDXnToD4clCQWe+DzgJGWvd3ehjzUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213446; c=relaxed/simple;
	bh=ri4xp+351xR2M9JJj3QdDyqK/myoqFelbnDrImvJJdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTcq9MiyK6mc23F+8ShlaDqOnXisKxNZjVV75Rs/b6R/AS2GQpDGsR+ZXGKFErNYSeIm5jLUmYk2FsaxtonkgdQI6TUsofZu5Xk0lr1H2EQG6+hffaMHtrZUqhAKbHN2lzgtsAaLuz183C6XvAkW8OLSBR9Hnckk4Jou17yz+EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omKkJt9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omKkJt9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC4DC4CEF1;
	Tue, 26 Aug 2025 13:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213446;
	bh=ri4xp+351xR2M9JJj3QdDyqK/myoqFelbnDrImvJJdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omKkJt9wRiS6ebtvMA0oIebEiNbSBT3URxYXv+gns0zdAEa4n5wvwwx69Kc/BPcuB
	 +aiDHxn6KHVVt3Q8bJssqlwQOI/QiftP9UOjFy9k3DoVMnj1Kw3SBIQYRWfVWmuont
	 e875cPmT2qGmSDwyb28WWQqNox2DZvrnLVjL2HTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 352/587] ext4: use kmalloc_array() for array space allocation
Date: Tue, 26 Aug 2025 13:08:21 +0200
Message-ID: <20250826111001.868911289@linuxfoundation.org>
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

From: Liao Yuanhong <liaoyuanhong@vivo.com>

commit 76dba1fe277f6befd6ef650e1946f626c547387a upstream.

Replace kmalloc(size * sizeof) with kmalloc_array() for safer memory
allocation and overflow prevention.

Cc: stable@kernel.org
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Link: https://patch.msgid.link/20250811125816.570142-1-liaoyuanhong@vivo.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -590,8 +590,9 @@ int ext4_init_orphan_info(struct super_b
 	}
 	oi->of_blocks = inode->i_size >> sb->s_blocksize_bits;
 	oi->of_csum_seed = EXT4_I(inode)->i_csum_seed;
-	oi->of_binfo = kmalloc(oi->of_blocks*sizeof(struct ext4_orphan_block),
-			       GFP_KERNEL);
+	oi->of_binfo = kmalloc_array(oi->of_blocks,
+				     sizeof(struct ext4_orphan_block),
+				     GFP_KERNEL);
 	if (!oi->of_binfo) {
 		ret = -ENOMEM;
 		goto out_put;


