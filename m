Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DF01FECAB;
	Tue, 26 Aug 2025 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208238; cv=none; b=MXLmcZZPg6wczifq2qXSsxG1FWbuuFrnguu+9tg8mtltVIxOAaiAoua6DPzh3OOXhF4VKjywBQZ23q5pSeTOxBrs/BQ3gEkZzUT8BVVxlYbsl3yB5EiISTpASpbJbHTp/1X+4y6LbnpeMz3a6ynyLRtcaBrgWxDQFdmvN+fuKyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208238; c=relaxed/simple;
	bh=Ck+HW+HP0ucWGm9GrrJhQWgmGaH+WHEmbv8W4vczGXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6F9gefX1zyCFfXIxm62FEY8NEmL4645v3rDU8l1bFawAyf63usoz4FeZiOPRfn38CGONEYjowgP5/e+V5/P7n94K7tzOS4r6T/NRLgpTV3pcn0pjoDV2y+bMvgo/unLhOq1P8ZJYc7J5yvslQMIGRNi9GB5VfOuVV5LdQ/TfQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4nKBqC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4nKBqC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B14C4CEF1;
	Tue, 26 Aug 2025 11:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208238;
	bh=Ck+HW+HP0ucWGm9GrrJhQWgmGaH+WHEmbv8W4vczGXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4nKBqC7gzj1kHp08YXvOdTfaFHl2270AbBj8f44v1XhfMwqmL4rplvppJeEQj89M
	 9cmv0418UruAB9En5dTPgzFrxTx+wPj6PaGohLchnLsrv7G8e/0sSvub714neNt8BK
	 4ybM9H3X6wf8rdudfmXThE2YbW78LKJWeRXMOadc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 033/322] ext4: use kmalloc_array() for array space allocation
Date: Tue, 26 Aug 2025 13:07:28 +0200
Message-ID: <20250826110916.158720106@linuxfoundation.org>
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


