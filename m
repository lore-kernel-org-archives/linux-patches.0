Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EA21EEA55;
	Tue, 26 Aug 2025 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216679; cv=none; b=BHT4RSoiRoaHhLn3hkWwY3y0unD1hRsqeowcoG86yx0Tdw3s1MThjo5vewzWxOSzTk1ixEeDUqUz0FumcogRZAi+EnqP3L6Cw2gT+C8Nx48GFuf+oEMIREbx8DYdN+4rSDwoJrlHaknd1gppG1VS3Z4y7JuCvgpJCcsqzXXkNC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216679; c=relaxed/simple;
	bh=E8arlKsTUKT5S2EQ55UasQO9tHpBpZ05czHWBqBE4Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ot+Dtn6oRpZjaGqsmBdUMUpLMoLp1JpYrXrD2jKowwlNVdQw153l2/2w2Jum3JEo0NHUV2lDtOtNWvJOPikH3XRAMpebGDv/9KLy9JImQ4a92b8fMkUDdSoGymbONa+6NxOxiD3qO5CMLUoJTZD2NgoAp+ZfkkPxtLGd1CMFF0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2onOCEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2onOCEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B058C4CEF1;
	Tue, 26 Aug 2025 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216679;
	bh=E8arlKsTUKT5S2EQ55UasQO9tHpBpZ05czHWBqBE4Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2onOCEP+l6+P8HS5t1n9aXYtl3x86org8svot0OAq+QOZGIrLvPmuoBUlUjsUyFi
	 1t/VNu+0GsoPGEspM7bmPgBHqGoomQa9RUTY0EfAOeFiasj8wc+Ge4WWZ4XUeTFoEc
	 8PVZNsL/kcFCBrroBJQp5FpBGIQIsX4fZ/aJm75k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 471/644] ext4: use kmalloc_array() for array space allocation
Date: Tue, 26 Aug 2025 13:09:22 +0200
Message-ID: <20250826110958.154006578@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


