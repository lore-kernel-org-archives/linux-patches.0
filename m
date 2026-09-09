Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2FB58E2B0;
	Wed,  9 Sep 2026 14:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964369; cv=none; b=YVr6r5gS32FvYKJBaqS1T8r6lNs2jvalNlsq+PM64TNabIVDBjRBcbxS/4EYcNnjM6afD27TZhiC2K2zmVSvPU1t+1Buzci2YVwLKt8DdAwSRSXqLmhekn7CRSyHxBcdENQag7o2XoYeAZN/nDKIhCtzF7Uum11reHZvVXr1P/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964369; c=relaxed/simple;
	bh=QaN3m9bXjyIBZNl/f2hkMOgHelIbBe4PPF5FGZnpuvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkf+zrZdRu5/tWJK57vZx/X72HSR7kZkWUgrH7LFqCySngYxNXwKBAsfPK+Eqz6LaIDBZnKVEPHBVF1lFxZ1OPSul5i6IvOcf2Gn5zr+XarWbRnwYv/4fycljUBam8rbONPDEZ2af3/gaEyQi6NJNI+juP0p5agBQo80DoSMVlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSbN7PfI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSbN7PfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBDE1F00A3A;
	Wed,  9 Sep 2026 14:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964368;
	bh=su7CXejqQSs9PGEadQ6BKDRgKq9vTwlaqNdseIdVbLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSbN7PfIfjmcW6e7E/QiQobwySijZRj6Di7q6if/NRQ2RNxLxpsMwwFVgjIItS/MQ
	 am3hfwoyQsFjlfK9TRv5PxVtSMitlh46udwyqLH/iqOAq3/PijL4ryR1y3BRjIojQQ
	 T8S+4o6Bw3Yz3oRNwYgEqJ9BtwfBrX7vI/x5hnck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 356/583] f2fs: use the mount idmap for the owner check in f2fs_xattr_advise_set()
Date: Wed,  9 Sep 2026 15:40:41 +0200
Message-ID: <20260909134250.336476078@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit a54ffce4637acb0db8e695188a6c7f99f14c3576 upstream.

f2fs_xattr_advise_set() calls inode_owner_or_capable() with &nop_mnt_idmap
before allowing the "system.advise" xattr to be set, instead of the idmap
that the VFS passes to the ->set() handler.

f2fs supports idmapped mounts, so on such a mount this checks the caller's
fsuid against the unmapped on-disk owner rather than the mapped owner: the
actual owner can be wrongly denied with -EPERM and an unrelated caller
wrongly allowed.  Pass the handler's idmap instead.

Fixes: 01beba7957a2 ("fs: port inode_owner_or_capable() to mnt_idmap")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Acked-by: Christian Brauner (Amutable) <braurg>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -118,7 +118,7 @@ static int f2fs_xattr_advise_set(const s
 	unsigned char old_advise = F2FS_I(inode)->i_advise;
 	unsigned char new_advise;
 
-	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
 	if (value == NULL)
 		return -EINVAL;


