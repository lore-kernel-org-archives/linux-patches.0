Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EC346444;
	Tue, 10 Sep 2024 09:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961010; cv=none; b=EGYjPNjF4/ajPn+lgXGG9p5Q4WpWHSSCUWCtWa9nNJ4QSys3+F6Gyt6Fv5LCBOR5ISqVh086nLgWY4/wEvBu/Ndw1gPLO2T0L83a3vE5YBc1OId8ZKYrB5wokyAotwlze2lpVy8srWRaTcj4Svog3oiegMm4qx96J3muux+pyns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961010; c=relaxed/simple;
	bh=oocNm9dgaajSwYGTtWzrbTNIi6RkD6/YlKiCSMo/MvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMhC22YGeJQ0xGTc1kEX1sjOlkwLYLICtggvUcETwqRYO/xJuHoioCnXDevG04feAY1ZnQwbBKUl9bA3dlGBE+Eek87QnV909bikz6jAZ1FsX7ET2wMWj8yxla5oxF4kwgQL3LFCPXF9ad0eB85CrLEoMGgp+KZTBwzz/QJbAsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBTLhWDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBTLhWDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4342C4CEC3;
	Tue, 10 Sep 2024 09:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961010;
	bh=oocNm9dgaajSwYGTtWzrbTNIi6RkD6/YlKiCSMo/MvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBTLhWDQ7hJ4lU8aClj3aARYyl6ID6Qney84AVu/SIWSqiKpyMaKkVYVpqjIMIsKX
	 vHKknWtFc3YDIMLeB9FfsjEr1pgJ5WrM0CKEfi4J6hS8w/nDLsoprFtLAqPmd/T/fW
	 dcyhk/QkJG+u3wVLrgwLxCZBex/QK1nmmah0HqyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 22/96] fuse: use unsigned type for getxattr/listxattr size truncation
Date: Tue, 10 Sep 2024 11:31:24 +0200
Message-ID: <20240910092542.414130483@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


