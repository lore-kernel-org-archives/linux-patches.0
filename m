Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09963EC54B;
	Thu, 15 Jan 2026 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499436; cv=none; b=edNPZ3ShMW39JQEv/5Xcd3oIRxgSNiKWThBgFqp/X7SJFCe8pXFrNA30KV0xQOE1uo4AKjs69UP4yh7R77kPY8dQv4jDV1lLm9iV2tI1BZciPKs+mHkPQqpQhaSuQaQgiM2UPxo5rSbx9cT76hcGM8bsKewSPfLBK2Grgqi4FZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499436; c=relaxed/simple;
	bh=xz3SpHTub45nU+XTPFST1YipSoA7aQFsMSiKPS3hYOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnYBrCfEjJtygvA6UrJC5TXAPHZOwGCa7Qy2GEmW9PGVwZuvMh3wPOV5hzHKIRYH4Go34Ma1p/Yxgcw4izfekBFCVYDk/OflzX+IOVosWXPkGNyQ6pJXlXkzmzmMws97ZAhCbg080gYTqnTgETtUCUYv41ZIMo3RW5NShTd/C6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnF1RKQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnF1RKQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20E8C16AAE;
	Thu, 15 Jan 2026 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499436;
	bh=xz3SpHTub45nU+XTPFST1YipSoA7aQFsMSiKPS3hYOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnF1RKQUz3G73MaonRNOAnFvd88BObzQ+BgIazwdGQpbo/jtJ+S8sh03AArVPYnuR
	 xs6i5Vpp28WyTIT6uz6HEYHATddtDrkj5x6wvaERZ5mpNc0zYZsQtWV9CAtrWmAJ19
	 k+FG30bzcGdPlAMBpMWnrCcl+8wtjdKtMlhCW7qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 225/451] ext4: xattr: fix null pointer deref in ext4_raw_inode()
Date: Thu, 15 Jan 2026 17:47:06 +0100
Message-ID: <20260115164239.036173676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1134,7 +1134,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
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
 


