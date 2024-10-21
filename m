Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0EB1E4908;
	Mon, 21 Oct 2024 10:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506552; cv=none; b=qtpC9CUbfi8cbyGoFo8ZoD7itfowYlUXJ7QaQtw4BjyrsKx9VR13xigswK//dtolBWPcQRPd1ymRtvhpjMFsYB/A3YhJBzoMTefQ/cS3hKVt7gNT/75YF925ehrWr8eoA22mBwoK1dd1P1IE1KGnx+KHcYxxFcP4VjL4rg7ygnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506552; c=relaxed/simple;
	bh=kBXDhlVLZB9dqJADAZLL9qZ3gVBhLVCFsU0kh9Hrhcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjoAPTXUnA+3LDbKillPwgJuCI5vvGySKEbGsgX28wCXgWqTzsJdV3r4vB/pqfHyFEZBhZ9M1uEtrDok/HAn7igziHECb20djlW577+x+DdhwCCoYt2C7P3wgrC51f4j6i4CNuoKzuIR94flhTQQdaK/3LHbamhrGdNhr/fVyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ch++bGFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ch++bGFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A49C4CEC3;
	Mon, 21 Oct 2024 10:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506552;
	bh=kBXDhlVLZB9dqJADAZLL9qZ3gVBhLVCFsU0kh9Hrhcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ch++bGFEBq9lU/ndMpmP5VlsWPebvAygQpdqS8KSElX63SluB5kQUl7bXauKyHqPQ
	 qLwmSCHPPK0/Ywx+cxcHq/4OTvUBVljXSWx2Y1/Yn0p0D0hvIuK+MbLQzjyxHycaCF
	 HNOEqA4Rxt88TvCnTh/3RO/t+dBUFUQQ371Ry+zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Roi Martin <jroi.martin@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 001/135] btrfs: fix uninitialized pointer free in add_inode_ref()
Date: Mon, 21 Oct 2024 12:22:37 +0200
Message-ID: <20241021102259.385709578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roi Martin <jroi.martin@gmail.com>

commit 66691c6e2f18d2aa4b22ffb624b9bdc97e9979e4 upstream.

The add_inode_ref() function does not initialize the "name" struct when
it is declared.  If any of the following calls to "read_one_inode()
returns NULL,

	dir = read_one_inode(root, parent_objectid);
	if (!dir) {
		ret = -ENOENT;
		goto out;
	}

	inode = read_one_inode(root, inode_objectid);
	if (!inode) {
		ret = -EIO;
		goto out;
	}

then "name.name" would be freed on "out" before being initialized.

out:
	...
	kfree(name.name);

This issue was reported by Coverity with CID 1526744.

Fixes: e43eec81c516 ("btrfs: use struct qstr instead of name and namelen pairs")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Roi Martin <jroi.martin@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1374,7 +1374,7 @@ static noinline int add_inode_ref(struct
 	struct inode *inode = NULL;
 	unsigned long ref_ptr;
 	unsigned long ref_end;
-	struct fscrypt_str name;
+	struct fscrypt_str name = { 0 };
 	int ret;
 	int log_ref_ver = 0;
 	u64 parent_objectid;


