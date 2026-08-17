Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DE63A961E;
	Mon, 17 Aug 2026 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975315; cv=none; b=I5X/RWJBes5skUCI2P1zr5moZgm9ZAB4ZOLdinjWhZr5agcDkMzVmVDyVPZVSEjUWNUCrLcBi6qVt65bA1NwuU47kAsql5xvGIxI/SjY85HCrldkcFE92IIDrWsfiryPXQWt4g2dFduCTLSsINUEd8+WN1Ar5bNq8N5YIqy3Cvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975315; c=relaxed/simple;
	bh=W+y/vMqcmG1Fh4Ippqi1fAag0oeze4KlnhJv512h/co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqvYt7nWRan4tKjEY8kyhRSv49j/ANX+1tAcmvmYiglw7KfV0rBvORBMBbBC3pOB9eD8fgWuc3XJ4Ogohhyam9+0lCf+7VbroDNzsHhoneJ0p+msd4bzgEB3tNahM4vHit27S2yajdqvTidGsD3lE2hy4UBRKUNQ6+mQVorhyv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnJwe3bS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnJwe3bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBC01F000E9;
	Mon, 17 Aug 2026 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975313;
	bh=1zuObJKdMS4guABSTbS8dukmDiO5B0+d07A/n1Kyq/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnJwe3bSnrF10KTx638Iv1VS6daTKB68R9E/Jrr/TdXteOOA5qiXD61PGcQEHKY2B
	 6M2u2++YhFnIJfERkRrD1ZRfn0SbdthDOkj88uWgJ0/VytCPqkT0xhx0Hu1baArC7o
	 vmBfzAKio9Fvpzjr4Or/sU+ew1UZUxsRpx1A3IiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 235/250] fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()
Date: Mon, 17 Aug 2026 15:33:16 +0200
Message-ID: <20260817132546.089870767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
@@ -534,7 +534,7 @@ int fscrypt_ioctl_set_policy(struct file
 		return -EFAULT;
 	policy.version = version;
 
-	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+	if (!inode_owner_or_capable(file_mnt_idmap(filp), inode))
 		return -EACCES;
 
 	ret = mnt_want_write_file(filp);


