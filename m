Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D2F3B0598;
	Thu, 30 Jul 2026 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424815; cv=none; b=luQzliNzQgQPK1I9DRCghtK12uXyInvpsfSzCU+VhLDDRy4hMcS4YaBIApz1q/3DIZ8PwF+bRpZsEQjPpABdTaJqU+3Qm7UIN4N83gYRH+5lGZDoVcCX1YsOYLbsI7xgBt3uwYt9Aa7CDlQybKJJN+hVfxLlpu3OrAp8aREKtT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424815; c=relaxed/simple;
	bh=UQOdGyTN336Sv3KQcbIXwXwBfn7Tx/buWrvryLX8eq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRmqyCfgnfsFvZ98qhtCCFAtfhzE6l59MVji9s7tdX7lD78vD/q6aSCdlWrlq+xEx8BqDTzK/VG3yb0zgb2BXqAsO6RjatlN09vSC4FXsxC6BK94h+dcPnGAsEeK3y5YCXXOwav8MwILXqz8+3ow1cNb0ocJVbqevx3LIPjUFgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1QHMjDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1QHMjDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0731F000E9;
	Thu, 30 Jul 2026 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424814;
	bh=6OLrT0ccfswAUBaMb8J8MouknN2dGtS/MlhRwuqfPec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1QHMjDS5H+fXIqnbN4416tLELp7Yu+HORVaUomm/qL94gFr99tq5/Yalme+WHn0h
	 4HaayyeDlbL7DlNQp1B2mwKlzgfyiSRlWGbKvL07CfnZujYaDF7g8PYbGYCPKjrqBp
	 9QxiARs+7IttiYlVYNmwqI8qbyTRdLxfLzr3XkR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Luis Henriques <luis@igalia.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 526/675] fs: preserve ACL_DONT_CACHE state in forget_cached_acl()
Date: Thu, 30 Jul 2026 16:14:16 +0200
Message-ID: <20260730141456.324513872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 4b9a5458d02e214ef2b384124ca626e3e381d778 upstream.

The ACL_DONT_CACHE state is meant to be a constant state for the inode
for filesystems that want to opt out of posix acl caching.

Commit facd61053cff1 ("fuse: fixes after adapting to new posix acl api")
used this facility to opt out of posix acl caching for fuse inodes with
fuse server that does not negotiate FUSE_POSIX_ACL (fc->posix_acl).

The commit also takes care to gate the forget_all_cached_acls() call in
fuse_set_acl() on fc->posix_acl because there is no need for it, but
there are other placed in fuse code which call forget_all_cached_acls()
unconditional to fc->posix_acl and those cause the loss of the
ACL_DONT_CACHE state.

This is not only a functional bug. Properly timed, a get_acl() from this
fuse filesystem can return a stale cached value, as was observed in tests,
because set_acl() does not invalidate the unintentional acl cache.

We could fix this in fuse, but it actually makes no sense for the vfs
helper forget_cached_acl() to invalidate the ACL_DONT_CACHE state, so
let it not do that to fix fuse and future users of ACL_DONT_CACHE.

Fixes: facd61053cff1 ("fuse: fixes after adapting to new posix acl api")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260713220932.413004-2-amir73il@gmail.com
Reviewed-by: Luis Henriques <luis@igalia.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/posix_acl.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -93,6 +93,13 @@ static void __forget_cached_acl(struct p
 {
 	struct posix_acl *old;
 
+	/*
+	 * ACL_DONT_CACHE is expected to be a "const" value and xchg it with
+	 * ACL_NOT_CACHED would enable acl caching for the inode -
+	 * clearly not what the caller has intended.
+	 */
+	if (READ_ONCE(*p) == ACL_DONT_CACHE)
+		return;
 	old = xchg(p, ACL_NOT_CACHED);
 	if (!is_uncached_acl(old))
 		posix_acl_release(old);


