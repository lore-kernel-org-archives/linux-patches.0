Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1504D3BFE3B;
	Thu, 15 Jan 2026 17:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498110; cv=none; b=FS8luoMvPjXghBHZhQ0p/x1/XJTGrWV7CHTqtZ49j3ufek+nud3Lbwv8vAeNbmIjseZhvBCtrhJVw4IBeuCeybwZ0B76X3PF/jjYDyGnBJGv1cj449rXqERevXiiNSpPU63xaeE0ndFdakNmQaLWZFJ4UaeYmbkfZe4cMRDkAXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498110; c=relaxed/simple;
	bh=Mt0k6bdguzT6rprkjhIureHscKRaMKExrAJacXdZnJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5QunQe5lMFHZf+dr7z2lAbNJ99BewIGe2KNunJDS8LjuYddsoe9Dx8a1d4EyW3zC8q3RnwofmhXzEHpMxXMSuqwzqPZYufQpExrUiaU29w289K6Pecp6UmeifCqcyzCzAQruW2FnkaTIes6F0gjG8zIPqKDkUBCMM/z8hwHO98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDdjaY+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDdjaY+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956DDC16AAE;
	Thu, 15 Jan 2026 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498110;
	bh=Mt0k6bdguzT6rprkjhIureHscKRaMKExrAJacXdZnJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDdjaY+ixaNlZbJA9KCRpsGpky2Sdcjy75S0WR9dZmhf2bHRWqBlgN3sNzc9Zsfnm
	 A/HJa1C2/LuJQhU0uH6mrhMRxG5OQVEoevyrYRTzS10Xb6NI3IqEcfgz8uTWahombb
	 6dWGCcgm42ZvAex57SBixAd0hdp60wthGd6Xn1WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 283/554] ext4: xattr: fix null pointer deref in ext4_raw_inode()
Date: Thu, 15 Jan 2026 17:45:49 +0100
Message-ID: <20260115164256.471493946@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -1138,7 +1138,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
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
 


