Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370013DD53E;
	Mon,  4 May 2026 14:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903434; cv=none; b=V68UowM/sB2KrPUxmWmQuVKHIblvMEoO9zSCOs7I5kuEKJMaRXSPL40p/Vi+MNaau4sppJlst7C4RGF5eN+ES5IVS7iTQmN3SOy3zhh3aWLcrNr2Pd1DIKP7n2lEurGldW4m60EBM6fmE4qz9Z8Qq7ilD2gjLQJ9dEnshJMsoyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903434; c=relaxed/simple;
	bh=H3uV8qjzMISIZuX5kaup6W/yNANppGfJuPq+k1m+7/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0it6FLMCyyM0Ab6Yh9A9uYysj9dOdOXrjf+H+09Bx+h+UqrF3Hqy7oIrLMI70oFdmLvmVsrYCI5DQohfFJlkVonmivp6EBQdPb6uK/hAylH0jPdqytIKc7K9oF+WccO+YofTyl4ne0ZIvq+hlVhrK+S/qGHjPXA1VP33galzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdGRzypM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdGRzypM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F93C2BCB8;
	Mon,  4 May 2026 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903434;
	bh=H3uV8qjzMISIZuX5kaup6W/yNANppGfJuPq+k1m+7/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdGRzypMQ47i8ml0v7doN9MW6RtJTdxQjjkbENsaaDWcmm+WW7uzFIZ4AH5UAgkrC
	 XEXceZnyiosz1dWXy0RUeGvzIgwoeHj8rVDZJoQiH4ZFdpyhSRPjbP0qGpCjmngXLt
	 LbTkRWn2POD1B6OnDAa1TbWoEfAAzrKZLznP2yM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohei Koyama <skoyama@ddn.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.0 232/307] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
Date: Mon,  4 May 2026 15:51:57 +0200
Message-ID: <20260504135151.579379892@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sohei Koyama <skoyama@ddn.com>

commit 77d059519382bd66283e6a4e83ee186e87e7708f upstream.

The commit c8e008b60492 ("ext4: ignore xattrs past end")
introduced a refcount leak in when block_csum is false.

ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
get iloc.bh, but never releases it with brelse().

Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
Signed-off-by: Sohei Koyama <skoyama@ddn.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260406074830.8480-1-skoyama@ddn.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1165,7 +1165,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
 {
 	struct inode *ea_inode;
 	struct ext4_xattr_entry *entry;
-	struct ext4_iloc iloc;
+	struct ext4_iloc iloc = { .bh = NULL };
 	bool dirty = false;
 	unsigned int ea_ino;
 	int err;
@@ -1260,6 +1260,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
 			ext4_warning_inode(parent,
 					   "handle dirty metadata err=%d", err);
 	}
+
+	brelse(iloc.bh);
 }
 
 /*


