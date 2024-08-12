Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AEE184551;
	Mon, 12 Aug 2024 16:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478819; cv=none; b=MfMGqeOLUunsd39scvs4iaiG7+TcGwdxFllSTWyAQ9W3OXG81/2qrLqB5S0QoBl75GZAsutnXGJWwZyNI/mgovZ7z3dNHXt4kV3wlEImOJqcuYSRk6qnGEuhhKi+4KacG27U0LwrKmPmvzvbNAiFkkxzVm9Zs0DBaJOlkGZyE3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478819; c=relaxed/simple;
	bh=MKW+m4+NY9L8Zi4JQrOIqPIciIo+gYzLgP1eSh5+At0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lObeY+N31YZSPyqMeo7Otn6TSwvzRLibaTttWSRt83HhAgP65FNSDBcZQXKlJK5fMu722reSdi0Bp9b0Q17H/JN0DahobKzNlkYiVxUkVqFETUyMpj0A/2+B090dN3B5RjizeNQdzfIdjgrWDFxLcYgsh2jPKlA4lrp/5K/elgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I43jqzcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I43jqzcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE36C32782;
	Mon, 12 Aug 2024 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478819;
	bh=MKW+m4+NY9L8Zi4JQrOIqPIciIo+gYzLgP1eSh5+At0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I43jqzcfOakXK0XIEyMjwpIs1VTdf22yg13RzF2MXmC84RRDsjA3cX1tKE7JYYbqp
	 mBF/cIc2HpJC8Z9dxkzpbe5vtzH21zKEcW5EelmWnypT3pFXOJUsZcfMdFuSLHQ/Um
	 0Qa1vsyX3dUCWehyg5f5YWukWQKKoqDktu6ogXwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+eaba5abe296837a640c0@syzkaller.appspotmail.com
Subject: [PATCH 6.1 046/150] ext4: fix uninitialized variable in ext4_inlinedir_to_tree
Date: Mon, 12 Aug 2024 18:02:07 +0200
Message-ID: <20240812160126.943236138@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaxi Shen <shenxiaxi26@gmail.com>

[ Upstream commit 8dc9c3da79c84b13fdb135e2fb0a149a8175bffe ]

Syzbot has found an uninit-value bug in ext4_inlinedir_to_tree

This error happens because ext4_inlinedir_to_tree does not
handle the case when ext4fs_dirhash returns an error

This can be avoided by checking the return value of ext4fs_dirhash
and propagating the error,
similar to how it's done with ext4_htree_store_dirent

Signed-off-by: Xiaxi Shen <shenxiaxi26@gmail.com>
Reported-and-tested-by: syzbot+eaba5abe296837a640c0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eaba5abe296837a640c0
Link: https://patch.msgid.link/20240501033017.220000-1-shenxiaxi26@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 3a91be1d9bbe7..ee9d2faa5218f 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1439,7 +1439,11 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			hinfo->hash = EXT4_DIRENT_HASH(de);
 			hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
 		} else {
-			ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
+			err = ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
+			if (err) {
+				ret = err;
+				goto out;
+			}
 		}
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
-- 
2.43.0



