Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CB147D46D;
	Thu, 20 Aug 2026 16:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243259; cv=none; b=H+pCuJoxQa/gPE+N+fsMIYo3sS3a5Xh0UEJ6VayqIa77Rw8PQYzTOCksTnkv4t9ts1/btT6PADwI880U7+NDsijBsCDJ8yNAO8WFWgxP37eoNpabjINzX/SDA15vY75h94p3dWIkcbwPQHtlOZwxQGLjGSSBP8RUVtyCNDIfgHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243259; c=relaxed/simple;
	bh=RczUCzJirqXFxodQX4Qp7QAQc9oFdp5oHARFJYe3gN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2kwq9Z4jaDapZxP49YuV0WdDFw8Q/X3WQpAAnnwAY7tSCOZSBzULid7OpVekvL+Pe+JDuCGluSOLPMxi0f+KNwEvxOPv3R/+LAoj5/igs8D33yzn3WorsnfRYcq1HcSepg+Kz4UGpmWpwHunmHwHye3h8bF/6cSGm/YRfzaWWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziYhxIhO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziYhxIhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264F51F00A3A;
	Thu, 20 Aug 2026 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243254;
	bh=fp3wbs2ijl1AaaJ/9T9gSZVhxMzkzT0gg+YZF1JcYMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziYhxIhOBqTObeuv1bdDqavtmZE7xJe2me2y0MVavGRP2YACbTriFRnEYZqykVwfy
	 QU9hs6cnjaS+PsQjv6riTaER8y70TrGVrDcIJuSFZsjzWLtkqRxjPWhEcj6hbTjrOz
	 Fxqge3DBthXO62xuSilR6Bh1BdbDCxouSQfH0CAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/272] fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()
Date: Thu, 20 Aug 2026 16:53:08 +0200
Message-ID: <20260820145231.370231323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/crypto/policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index cad34dbe8e298..42da1f9e6492b 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -465,7 +465,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 		return -EFAULT;
 	policy.version = version;
 
-	if (!inode_owner_or_capable(&init_user_ns, inode))
+	if (!inode_owner_or_capable(file_mnt_user_ns(filp), inode))
 		return -EACCES;
 
 	ret = mnt_want_write_file(filp);
-- 
2.53.0



