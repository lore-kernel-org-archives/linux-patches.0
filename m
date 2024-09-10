Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4223E18C932;
	Tue, 10 Sep 2024 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961350; cv=none; b=EUrCI+biLuBcK+neHElT59xOIjWIT37MMbSWsUNNzCHCGvdpZ0245WTgn5Yegu4nb3C6h14dD09AgQivI2K8IfLIUPAob3ASuPrGFsasBFimf0TTC07tY+9hlFfNbxHrIsxjOI/U3kYl+pt/+dxRREsKRqSs2OzK5uwOyOzM/yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961350; c=relaxed/simple;
	bh=jhnTmgIzkF43XdiOqv3yPZMmUMUs+GOpDOMnjEEUs60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEocKijqFcnUa0mHexpiKgxppfz9F2Xtf3gJLJlbcEu0Qf67prKsKwcEFg0W38FJIUhGIDgQ0Ki4GRUi8T5ZGKgbxdO/+8eFQ6CilbPy7u+SplwkWNojrkFi8BL9kR/rvCKuTFxjb/+eOF1KcBH0HzLDuRFrmln20N+M653MIFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEGdkcoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEGdkcoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2520C4CEC3;
	Tue, 10 Sep 2024 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961350;
	bh=jhnTmgIzkF43XdiOqv3yPZMmUMUs+GOpDOMnjEEUs60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEGdkcocf72z9nX4hRS8ZRazO46NFfU0/+HNUd9B7cYp+q3hRI9E5jFnCnWSF+tY5
	 lbGBrue5RR9JNGJ/++OUjDQFsiuecleYAUQLPo7tPWS5GSYrE80P/X5Zg4touu1qCQ
	 ax+fLv2kTWAg9LWAiOebWzMWWCQYrzaoZeTnwbGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.10 040/375] fuse: use unsigned type for getxattr/listxattr size truncation
Date: Tue, 10 Sep 2024 11:27:17 +0200
Message-ID: <20240910092623.582280444@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -81,7 +81,7 @@ ssize_t fuse_getxattr(struct inode *inod
 	}
 	ret = fuse_simple_request(fm, &args);
 	if (!ret && !size)
-		ret = min_t(ssize_t, outarg.size, XATTR_SIZE_MAX);
+		ret = min_t(size_t, outarg.size, XATTR_SIZE_MAX);
 	if (ret == -ENOSYS) {
 		fm->fc->no_getxattr = 1;
 		ret = -EOPNOTSUPP;
@@ -143,7 +143,7 @@ ssize_t fuse_listxattr(struct dentry *en
 	}
 	ret = fuse_simple_request(fm, &args);
 	if (!ret && !size)
-		ret = min_t(ssize_t, outarg.size, XATTR_LIST_MAX);
+		ret = min_t(size_t, outarg.size, XATTR_LIST_MAX);
 	if (ret > 0 && size)
 		ret = fuse_verify_xattr_list(list, ret);
 	if (ret == -ENOSYS) {


