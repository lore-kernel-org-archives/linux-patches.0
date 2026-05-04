Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFC83D6484;
	Mon,  4 May 2026 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904223; cv=none; b=rWPunjfDe0KCRZrqr8slrj+NxInBOzQ218w/Et24aKqjYshECq2eIy2Ng+VTF4ZTrDNY/T242oPV41trmrApKgABd+Jw1L5yNb4SibeX20HigJ6u6m04JTHLMZlfYBAsY3x1dm63iPtdWi91xBv3k+wskd5+K14dGkpCO8fj6gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904223; c=relaxed/simple;
	bh=4AhOORJ8BizF22mehPQuCZMteL2EBRTr0uv+5wMy+Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YID/qz1lWmvve36b5JawE4Ndy0y1/5Jti01lQSBiPpSv2KO0Id5jSHy0MLp66OeIVRq36X2CudLn0wQFF8IgDn0iPyYcS4kCBPLiO0wUsS3IY2QrvOA+WTDRLGX7NHU2XyXplWPCyXl/bqWq5CQ1y/q8hbElfOfM8pnw0HJVTBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKGwpr+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKGwpr+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6168FC2BCB8;
	Mon,  4 May 2026 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904223;
	bh=4AhOORJ8BizF22mehPQuCZMteL2EBRTr0uv+5wMy+Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKGwpr+KiHsf4tgAvkxWPhR+QUTQM6zWJ9zF2AA+1//zVQcJfC4PYSAatTrx8Yhnx
	 syIjNDgP5ZkMvfk164tC1ui8LzuDyl3LDz283/O1+y1l8a8N9UpDDe7k3kULNHK9tW
	 gRwnx1OwUp9YqXfEv9DuAvFLtABjTMIPYaAx4FNc=
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
Subject: [PATCH 6.18 198/275] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
Date: Mon,  4 May 2026 15:52:18 +0200
Message-ID: <20260504135150.431868205@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


