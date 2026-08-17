Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADBE442124;
	Mon, 17 Aug 2026 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978753; cv=none; b=M3L7/Paiw5I0UliB9+fE1Frk2n0akHxAmOR1pgZptcNJ4EHpf160u0ZE7NYIdQzSsQAPdOmh4t0ocjKhQXrQQb6vJhrDWwqtRe2T0Z43nnmnOok1kdP/2PB0ow3X0xDriCypd6dZop2exN1MHrLYEifrHHrgc6bUL2jwlps9YqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978753; c=relaxed/simple;
	bh=bi+JDoTrN9LRlkSVlf1WXLqvtHI8tjQ/+mcl685jKdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiCD+8qMxVXF/jpuX4GEwsCAcvbAP1sxqo8XwRvFdPWMixJnAkiUPhFd2X1FXNy0F9NnsiHW0v3MyxG57Vhm2xUOiLMsJ03mhCBb/ee7eiDROWt5wT6ihJUgJyYA67PVMPZko9c6DFko1qUtsKYubhwqcWrflg8ai5C4Cj60VG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogOcW5OT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogOcW5OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158EF1F000E9;
	Mon, 17 Aug 2026 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978751;
	bh=6b8sLfJH1ILXNNpEvQy+OzHAvoXKLQ59ySFnfosM1zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogOcW5OTVoMCI793U/Ppv0EV/ZMCIajfY/2WGGUj7J1asSx05bHpp+6RSdIyMNjL1
	 WV53Ltmhf8DzbLWHYMv5v0JfTJc1NknQx0SDnKy3AZYqLKNFMnBTL7+npOnH/iuAfD
	 w/dCDigXEl3SRMzGtbkg7EnHh6/iocmJhSinSIew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 145/156] fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()
Date: Mon, 17 Aug 2026 15:34:39 +0200
Message-ID: <20260817132540.394671712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -505,7 +505,7 @@ int fscrypt_ioctl_set_policy(struct file
 		return -EFAULT;
 	policy.version = version;
 
-	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+	if (!inode_owner_or_capable(file_mnt_idmap(filp), inode))
 		return -EACCES;
 
 	ret = mnt_want_write_file(filp);


