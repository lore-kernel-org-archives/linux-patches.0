Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A867C3F23C9;
	Mon, 17 Aug 2026 13:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974653; cv=none; b=fz5t9gHKgUvESSblgbPuDz5oqbcguXY3BZcklQynaDzuY+zlIrawlYxD9SRrTtgaHhzqBbQ5Yhv6EuAdrB6bjh/V+z0Ys+5X2xcJtJjVpRYRv6tkKHBF414qpvutrrJnL52HMTxoDxEIc7eUC6rPHI+mIecC/QebdT5x/CjIiOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974653; c=relaxed/simple;
	bh=7h+/ZxqA8cp/30drwj+Az6tmzy7quLj9/QbwgfGLwuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f88fVYU3/SFMT/eGtfK/ZapYooWv2iUbQp7pr1zFFqhsZ9BoX9agWEXsBdjhZ41rlsHOmS/aLV2eehh7+PPX0BOp/AQ97MfFDosuV/p8CIMlQgUiEScEyS+dBma56HyaqHmVC8qTbljzFihgp1SqcJopR5vCLQsaTGyQ+h9LhTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A30fmZ65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A30fmZ65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82E41F000E9;
	Mon, 17 Aug 2026 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974649;
	bh=QqeH4UitMIhX5DUMcoJLHsOKNRHkCcZ6rLlaDDAiLJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A30fmZ65jePVdURVkVWw488WodZoWxPNoIHI4xuuru94F8fPM2e72LtVnx66ZiI7v
	 EbhfTwih8XDpKObJqhpouDLWK32E6dlb86eupi8e84tNAqptlcxuLJiIr0YY7Vhy8O
	 VStVi+O3bseOrPEs7qZEF7KFGjAr3UYdg32hnu+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.1 257/271] fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()
Date: Mon, 17 Aug 2026 15:33:02 +0200
Message-ID: <20260817132547.310224224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


