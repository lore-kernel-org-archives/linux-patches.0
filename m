Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351CD37DE9B;
	Thu, 20 Aug 2026 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247847; cv=none; b=a3h9qXVwQw9eaGaosOH1Wp6pnU7QcA92o9YKUeql9JFT/wDHtWkWVKfiQFL7ud2JBtCDC6Iymqz0/BUxDjF3wE6mI+Vlaf+Qmdg2dK+u6utLhj+550zajoJ0EBTSodnz6kcr+p/ON9m4vpLzf4V0HawZYytF9RqfIwoj8gWq6fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247847; c=relaxed/simple;
	bh=jP/KyCQnew2Qn1Rp54p7Q8SdJjAs+awWWxXtfP5wskA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiP2UzE8mXQ5d6N5e5AnBFHsbxgfnVSerdHhdcs+oBDtfD4x0dGWG5eEsCa/1VM1Yb63bwsTs/r9XLN37yGe+P+20BjaVTOiW7q7XbEmLbnPSjtXziSFArxvHxvDarGDe9U8MvF0vBjXNaupIrNJhC7H4Gb5cdVh8ekqsI/2qGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiwE7UCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiwE7UCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902C91F000E9;
	Thu, 20 Aug 2026 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247846;
	bh=6k+DLZwGjJyPJQw0qkQZYaLMYMwJhXq9MZdlKncPwMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiwE7UCR2HeARNVtI0VTJM8EHRVtrbAzfvPK8iONnb+eoWRnr6oxCkRFFCctxIaGW
	 Q6FMSiPUu5wtjJQkTEhP+LdVbiNh9uronNeidKmjHquui0Wjld5eQt78pPTFyVlFBk
	 LyDOm7gsdyrupiNlUXLkSKjx3foriEeH9y070IQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/303] fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()
Date: Thu, 20 Aug 2026 16:52:24 +0200
Message-ID: <20260820145253.442331801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46757c3052ef9..d0f97caa20211 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -494,7 +494,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 		return -EFAULT;
 	policy.version = version;
 
-	if (!inode_owner_or_capable(&init_user_ns, inode))
+	if (!inode_owner_or_capable(file_mnt_user_ns(filp), inode))
 		return -EACCES;
 
 	ret = mnt_want_write_file(filp);
-- 
2.53.0



