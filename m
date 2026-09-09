Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF21A57F73E;
	Wed,  9 Sep 2026 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964241; cv=none; b=GX0lzwpjgLNKXtujzWgFOZ+rMX+BRXcDQAl8Awi6S2Muo/GsqmOBXja44gU/S6N7hilzJSwr81SzxI63Djzrs1aM8MDQ6chJc/LoXZsy7pHJYnBTm6STj9JtYb+UUW/hR1I5J6fPCcisUNVb1WKOHxJe/jcBkePISqek9lq9LmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964241; c=relaxed/simple;
	bh=HVYQgfCpng5Plwq0UQuHWxo7RlCU1mTlDuP9ME8kowM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLhB2gdCtrvXbTjPoLBzXA+C/VvAbMXvwiat/uLCOJiY2N36gWVwXsTlHUJAsjaCpHlua03nWxH0Mo2QvP+J2EEcPNFTNLgsSqeJeU9TNJBJAJTAoX0N4SnzlXimvqJKWsnTg4gvj2+6+gR8cgigIKOSELy8D+nm8pTnNwzsl74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9RfM9UZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9RfM9UZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144FB1F00A3A;
	Wed,  9 Sep 2026 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964240;
	bh=ejBLzuCBgRvW4PgL3w/p23MWc0HiP+HiZDv/+aAvFxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9RfM9UZROKeZht4VaU3xfLJuHSyzwtfvfp3sImYQ5fRAoaFWHPn1JZJvI2yd7jTB
	 5ySYce1lDZvhIvDVYtG1BuxvNleJEuo3A7XQiawBT+I90uKZbBvO1oHeqkpeEqpRvC
	 9Cst1DkE6hT6bGNKsZF0JUJlXUlDnsHjFi6dG+LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 354/583] f2fs: fix to avoid move_range and defragment on device_alias file
Date: Wed,  9 Sep 2026 15:40:39 +0200
Message-ID: <20260909134250.263434455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 1b4db09b7f10895dc1a0bc32704c7de05188fb1d upstream.

It's forbidden to migrate blocks of device alias file.

Cc: stable@kernel.org
Fixes: 128d333f0dff ("f2fs: introduce device aliasing file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3059,6 +3059,9 @@ static int f2fs_ioc_defragment(struct fi
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
+	if (IS_DEVICE_ALIASING(inode))
+		return -EOPNOTSUPP;
+
 	if (copy_from_user(&range, (struct f2fs_defragment __user *)arg,
 							sizeof(range)))
 		return -EFAULT;
@@ -3110,7 +3113,8 @@ static int f2fs_move_file_range(struct f
 	if (!S_ISREG(src->i_mode) || !S_ISREG(dst->i_mode))
 		return -EINVAL;
 
-	if (IS_ENCRYPTED(src) || IS_ENCRYPTED(dst))
+	if (IS_ENCRYPTED(src) || IS_ENCRYPTED(dst) ||
+		IS_DEVICE_ALIASING(src) || IS_DEVICE_ALIASING(dst))
 		return -EOPNOTSUPP;
 
 	if (pos_out < 0 || pos_in < 0)


