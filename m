Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4724E355034;
	Tue,  6 Jan 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720216; cv=none; b=MaT3HvOVnmFA5kJ7I/8snI7zWYKNjQgAvGvdWu1NkUV+0s3A0XJAfv0R/CgKxKMKu6+RXyftivxX43/g51GbKoCSlm/D/cNEh/hbSn626O7078dCW7kNKV0HQ9/sgo48BMG9RwfhDCNui002Ps0Lydnp9zEK+NVytlKNhVb8MJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720216; c=relaxed/simple;
	bh=WlmwkoY6pgzzOc7ZUrzK4CMFK/2apJSwxuUcCd1Z5QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXGVLwocZoHT46y/92dBuDjwv+F7oyFNdPzPknRTgbguAm9+RkovPij7v+e/LrMlG9aOE7Csn4oen24UJF0FxTs5N4O4EzA1edSLBfS97qpyg4u5KYO/S0tRUpK60WzdnKWIzRUxjf7PVAFI7CvABI0nL8HqqJM6Umw+T+gxGVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlOXgsNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlOXgsNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7709C116C6;
	Tue,  6 Jan 2026 17:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720216;
	bh=WlmwkoY6pgzzOc7ZUrzK4CMFK/2apJSwxuUcCd1Z5QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlOXgsNbZsI2Ckh7svDBxzrnoKcrrkTJSm+Eihl4hSfDxp573QjQFC0+CwSEOpsOE
	 YNKR05lAd3kYYmI1Ep30qPQkrAUkCEl6h54/ZGJkHaxCA+5PUFdBHwEj3oP+DOaWKZ
	 Oed7LQONRraB8iZso6v7q8PHJzWMGVpjqqnuuutI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 168/567] ext4: xattr: fix null pointer deref in ext4_raw_inode()
Date: Tue,  6 Jan 2026 17:59:10 +0100
Message-ID: <20260106170457.541287791@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karina Yankevich <k.yankevich@omp.ru>

commit b97cb7d6a051aa6ebd57906df0e26e9e36c26d14 upstream.

If ext4_get_inode_loc() fails (e.g. if it returns -EFSCORRUPTED),
iloc.bh will remain set to NULL. Since ext4_xattr_inode_dec_ref_all()
lacks error checking, this will lead to a null pointer dereference
in ext4_raw_inode(), called right after ext4_get_inode_loc().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
Cc: stable@kernel.org
Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Message-ID: <20251022093253.3546296-1-k.yankevich@omp.ru>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1174,7 +1174,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
 	if (block_csum)
 		end = (void *)bh->b_data + bh->b_size;
 	else {
-		ext4_get_inode_loc(parent, &iloc);
+		err = ext4_get_inode_loc(parent, &iloc);
+		if (err) {
+			EXT4_ERROR_INODE(parent, "parent inode loc (error %d)", err);
+			return;
+		}
 		end = (void *)ext4_raw_inode(&iloc) + EXT4_SB(parent->i_sb)->s_inode_size;
 	}
 


