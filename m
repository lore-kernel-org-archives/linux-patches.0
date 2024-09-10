Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB56191F9F;
	Tue, 10 Sep 2024 10:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962517; cv=none; b=OrUpTrvVgVMBu59+Rxq0Sp8Z3jUJGBhi/yv4v5H89TehVe+MW099L227NfPvVAyf8L5haYo1CUR6uxMKKAybdWTlquS5zQVjTc2G+S9i/AO4au3qXQVyWpm7Sfr/IwC/qpUSMpFEQmdVMyBP41zqwXhnfZpgC7I0JWxtPbqCjkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962517; c=relaxed/simple;
	bh=IBoP8DOlB3myNeorUUofsUh0aIydHA/wEMxzvM8unek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw9nqTBsCo+Uhwy3uWDwbklrQaEIfB+rdYAJLSOvKC8rw83RW8LQZYVfQA92Qu62J5fw/mAlNHAwdzNs/CRAS4HSMWnPU/hG7JYdiw4OVNjlmqfiraQ89yRFs1TdfK08JeS3CJ/Kfdzy8JsvGSLJP6cRYqNt/8vEKU6S1Rygad4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9R8o48f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9R8o48f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66958C4CEC3;
	Tue, 10 Sep 2024 10:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962516;
	bh=IBoP8DOlB3myNeorUUofsUh0aIydHA/wEMxzvM8unek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9R8o48fALR6PxoI/wFX4r4OQRByJuMMDJEo0OoCSPwLsY2nsaUAPdEUTOeMjdsgO
	 HpK8Nnf12bS5c6k1w6FhgUMcUZU1Dbg/o50E3elP9XK5C/A9RnnpQLlZTtoTyy/WYQ
	 TMCUoBbt2bOEcKEHFEecbmOz3l+M5DU6NEL9Gp9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 034/121] fuse: use unsigned type for getxattr/listxattr size truncation
Date: Tue, 10 Sep 2024 11:31:49 +0200
Message-ID: <20240910092547.351785604@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit b18915248a15eae7d901262f108d6ff0ffb4ffc1 upstream.

The existing code uses min_t(ssize_t, outarg.size, XATTR_LIST_MAX) when
parsing the FUSE daemon's response to a zero-length getxattr/listxattr
request.
On 32-bit kernels, where ssize_t and outarg.size are the same size, this is
wrong: The min_t() will pass through any size values that are negative when
interpreted as signed.
fuse_listxattr() will then return this userspace-supplied negative value,
which callers will treat as an error value.

This kind of bug pattern can lead to fairly bad security bugs because of
how error codes are used in the Linux kernel. If a caller were to convert
the numeric error into an error pointer, like so:

    struct foo *func(...) {
      int len = fuse_getxattr(..., NULL, 0);
      if (len < 0)
        return ERR_PTR(len);
      ...
    }

then it would end up returning this userspace-supplied negative value cast
to a pointer - but the caller of this function wouldn't recognize it as an
error pointer (IS_ERR_VALUE() only detects values in the narrow range in
which legitimate errno values are), and so it would just be treated as a
kernel pointer.

I think there is at least one theoretical codepath where this could happen,
but that path would involve virtio-fs with submounts plus some weird
SELinux configuration, so I think it's probably not a concern in practice.

Cc: stable@vger.kernel.org # v4.9
Fixes: 63401ccdb2ca ("fuse: limit xattr returned size")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -79,7 +79,7 @@ ssize_t fuse_getxattr(struct inode *inod
 	}
 	ret = fuse_simple_request(fc, &args);
 	if (!ret && !size)
-		ret = min_t(ssize_t, outarg.size, XATTR_SIZE_MAX);
+		ret = min_t(size_t, outarg.size, XATTR_SIZE_MAX);
 	if (ret == -ENOSYS) {
 		fc->no_getxattr = 1;
 		ret = -EOPNOTSUPP;
@@ -141,7 +141,7 @@ ssize_t fuse_listxattr(struct dentry *en
 	}
 	ret = fuse_simple_request(fc, &args);
 	if (!ret && !size)
-		ret = min_t(ssize_t, outarg.size, XATTR_LIST_MAX);
+		ret = min_t(size_t, outarg.size, XATTR_LIST_MAX);
 	if (ret > 0 && size)
 		ret = fuse_verify_xattr_list(list, ret);
 	if (ret == -ENOSYS) {


