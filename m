Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E290D4322E5;
	Mon, 17 Aug 2026 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978346; cv=none; b=FSU/8RqclH7FNBfF66qDEIM7fEL7+NtoTYG8WNMm9/eUuhZo3GwD4ga5Xr7qD/nRF8BM9Gbdo+zPZsf+WilFY1klhoI6vMX71clNxCD+xleqr9mIUfkLwAjf9rlGDhaYGdWHg68tx+kTw0TqA5VVt6w7wSvLzcG5xmkmd31OU8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978346; c=relaxed/simple;
	bh=rJQsGxNQK0fEo1S8T1/vAhYP4NZLgGc90hQeNZHNaWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8UxrslMWQcFc4opHay9I+0i5E9Oy7RBicxs3SFQaC3WPYQNIJ5J5dsZzFPq9N3AfFfOs2skQCMycdVOm/jLJJ9pXuyWD9LVilQC2DVHYrCDyX63ZEyzECFVfMeTuw4rzeDxqmXW6dtJ7d1yFMu1NGFSy6qHf1nFOwvCQr0+RbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsbHOjvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsbHOjvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121961F000E9;
	Mon, 17 Aug 2026 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978344;
	bh=TbaiYdGmdfbmP822qoBGr5g+sK+m63q4ctT+qThCDw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsbHOjviEkmUoimicJfZR8rBSMqV8Bb3/7YICGdTDeGwJSBub40Lx0U/tp2sijTX2
	 Ol7cS7Z+KZno4nn/zD0JzfA2hXVWErZRhrzUkGrlEEqitd1/O2yBRvzOhvcTecrVFL
	 q5PGZ7qj8hIpFPT5RLTu97gS7WA/kVPx3jSG21y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 169/181] fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()
Date: Mon, 17 Aug 2026 15:34:23 +0200
Message-ID: <20260817132542.333762199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

commit cf6c993c0feca7984797e634deba3c80342e199a upstream.

fscrypt_ioctl_set_policy() calls inode_owner_or_capable() with
&nop_mnt_idmap before allowing an encryption policy to be set, instead
of the idmap of the mount the ioctl was issued on.

fscrypt is used by filesystems that support idmapped mounts (e.g. ext4,
f2fs), so on such a mount this compares the caller's fsuid against the
unmapped on-disk owner rather than the mapped owner: the actual owner
can be wrongly denied with -EACCES and an unrelated caller wrongly
allowed.  Use file_mnt_idmap(filp) instead.

Fixes: 14f3db5542e6 ("ext4: support idmapped mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Link: https://patch.msgid.link/20260725080004.929328-1-zhanxusheng1024@gmail.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/crypto/policy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -532,7 +532,7 @@ int fscrypt_ioctl_set_policy(struct file
 		return -EFAULT;
 	policy.version = version;
 
-	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+	if (!inode_owner_or_capable(file_mnt_idmap(filp), inode))
 		return -EACCES;
 
 	ret = mnt_want_write_file(filp);


