Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3B34322F1;
	Sat, 12 Sep 2026 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227078; cv=none; b=KjouOgaRU+g+7d97vBURs3HvZ9qiWrg5y+7gaBawhhBD8QAKeJsF/ZOKBXK6ReZr6+FvYVMmzIz+1ri7klXURL0LAGqk3eL2VWCyTNUzU2rWLYmZgqFlKRwKyBdGXUyAId8LIDRRtCxPZueqFNLi1qsNYcq6pqPtjzashmfGDOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227078; c=relaxed/simple;
	bh=bFNDUEINkFB3bJDIaMFCl6+1TRTGgf6IwvJthISQA9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXMcpKRz6AjlcU17/+YJ79hiZGBZLmHr+i4USEGUuo+hDfHvqU7p2VvFuLm2VZI6rWyk6eAypajrrFBJ8WYgQMH6mwUJfA6bY3jaM3kdxmqxeiL2aXPo9KIEwWfYoTm6cIC9WqsfOZRdv0eA41Wyc94N3sCG3qhC6M9i4piJbYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS1gA2Xf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS1gA2Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A641F000FF;
	Sat, 12 Sep 2026 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227076;
	bh=zmg9aIrsXqMpWVWqIIyLCKtomYtSEZuOt/db5C9Z57o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kS1gA2Xfb45ZPrOQ+fUWwlAhh05OpCKZVfhZeRioJ4MDJQA91q/z9uCbWwGcZqlVw
	 T9YYlSKvg1sq8OlAjTcKHena8HUiDeLsM5GBXSSQ75f++z3eXdkOzPyUctNM8KSIqI
	 vOHY8VFyP74nZ51CD0uG2axZELXXar4vadKzUq8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 0064/1191] ceph: bound xattr value length in __build_xattrs()
Date: Sat, 12 Sep 2026 08:46:32 +0200
Message-ID: <20260912065549.594868921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 68d541754d6cd3bb98d1fd8314f57e5eb533557d upstream.

__build_xattrs() decodes the MDS-supplied xattr blob one attribute at a
time. For each attribute it reads a 32-bit name length, advances past the
name bytes, reads a 32-bit value length, records the value pointer, and
advances past the value bytes. The two length fields are read with
ceph_decode_32_safe(), but the value bytes themselves are advanced over
with a bare "p += len" and no ceph_decode_need() check that "len" bytes
remain in the blob.

For every attribute except the last, the next iteration's
ceph_decode_32_safe() on the following name length implicitly verifies
that the previous value did not run past the blob end. The final
attribute has no successor, so its decoded value length is never checked
against the blob bounds. A malicious or compromised metadata server can
set the last attribute's value length larger than the bytes actually
present in the blob.

The blob is a dedicated kvmalloc() allocation sized to the wire length
(ceph_buffer_new() in ceph_fill_inode()). __set_xattr() records the
oversized length in xattr->val_len verbatim, and a later getxattr(2) runs
memcpy(value, xattr->val, xattr->val_len) into a user-supplied buffer,
copying bytes past the end of the allocation back to user space.

Impact: a malicious metadata server discloses adjacent kernel heap bytes
to a local user via getxattr(2) on a CephFS file. Add the missing
ceph_decode_need() so an out-of-bounds value length on the final
attribute fails the decode and returns -EIO instead of being stored.

Cc: stable@vger.kernel.org
Fixes: 355da1eb7a1f ("ceph: inode operations")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -811,6 +811,7 @@ start:
 			name = p;
 			p += len;
 			ceph_decode_32_safe(&p, end, len, bad);
+			ceph_decode_need(&p, end, len, bad);
 			val = p;
 			p += len;
 


