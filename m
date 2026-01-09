Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3422F359F8C;
	Fri,  9 Jan 2026 12:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960494; cv=none; b=aTHMbQzToSgdfcbojhMr1AlnFtoo9kpLeMqMFmNBLqOp1dk6kbq3A2Sln0l8bDfSu5BVQMHSuLYuUVk0ih4rP+Ze6O+RgaApfGICFNDciX12I4rf0tfB8C9sCDlCF/+lzHMfNPNEnA7sx5UehyEjfEvlAmAiwcx4k36q5MurSf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960494; c=relaxed/simple;
	bh=rLcQoBTcXIP6J9p18HEB+ieqiu9/zDACuD0i+b1wXpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCDeirI9kqzlpWItznoAZz0x105z4uNBe3xUyrz5zS423mpPgwCVf0a934Cq1X+wlemmfp2BesQe8Ye2BY6MHhgUNveb+SUeuLr3FC2m93DGURkcV2+VirF9VF1cJ1TE12aaQdW/lLBGeGlgolOCViy0rFYG6TouAhAjEDA2SgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enXwh5T1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enXwh5T1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF78DC4CEF1;
	Fri,  9 Jan 2026 12:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960494;
	bh=rLcQoBTcXIP6J9p18HEB+ieqiu9/zDACuD0i+b1wXpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enXwh5T1YzYXnNLYlHFziGrbzt7DJ/3/dAsg27bwPDJGmepfJeXEWfrd08r+v1fga
	 ThIIxsxdIZRwNfZuR9IDGFON368zn17PMxpRAL1iOZA8j3Evf1JXBwbGkWO2WNQYYY
	 kiULmWrPlSIk24WM6PtiO0jbMasf8g7LrNKgFI2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 422/737] ext4: xattr: fix null pointer deref in ext4_raw_inode()
Date: Fri,  9 Jan 2026 12:39:21 +0100
Message-ID: <20260109112149.869952856@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1191,7 +1191,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
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
 


