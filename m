Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C051F76C3;
	Tue,  3 Dec 2024 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239873; cv=none; b=Lw91WobtiB9FCt89N7CvEGuxosEIcnddjjlmHbXGpRp0Rywjt7H3dKjrDfY4Va6sx83MLLNl6ldI5d1B+PA0vp6jlJQfO3w8yDSjt+SVjSh2VhXAKItabBro3Yc6tpmXr+WbyqrvmDdsVdfh81+I/RzR/LlTyIRMrVqvZMMfNiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239873; c=relaxed/simple;
	bh=c9s/1MyX5Jx3lnSUSYvuvQ/31f7GELpy6mSKmzJBzy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw271f0Pj1TPscnRJBprwvO8HUQgmvkynUAZT9BSQJk10E3EL6eQHiFV1Bf5WYktPXcRjfHhLqp8LQk6l3lufCLIUoI+axWIkqJnEj/OnbpnNvrMF30HGHv+bQIV/jkI4AvlYZm5zLSeF+1eX3pvr+hoB3UqyJoS7c7yY2j7+T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1mqykWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1mqykWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E334C4CED8;
	Tue,  3 Dec 2024 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239873;
	bh=c9s/1MyX5Jx3lnSUSYvuvQ/31f7GELpy6mSKmzJBzy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1mqykWasHCp4Lk3wigMyWKIsEEkvSaTvmj+oukSCTxwByJle7GQ+EcZYYd/XTDvH
	 bLgeSM/kHKRjy8b1V9DuFzUFzzbCjlgdMXeZ7FFOZLx7z3G22KSau6ts+Tny6jrO48
	 Aa+TvILCoDe2yRGgvIvyswkBJTHKSV2UMki0Xsc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 746/817] smb: client: handle max length for SMB symlinks
Date: Tue,  3 Dec 2024 15:45:18 +0100
Message-ID: <20241203144025.116702767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 0812340811e45ec4039d409049be53056182a552 upstream.

We can't use PATH_MAX for SMB symlinks because

  (1) Windows Server will fail FSCTL_SET_REPARSE_POINT with
      STATUS_IO_REPARSE_DATA_INVALID when input buffer is larger than
      16K, as specified in MS-FSA 2.1.5.10.37.

  (2) The client won't be able to parse large SMB responses that
      includes SMB symlink path within SMB2_CREATE or SMB2_IOCTL
      responses.

Fix this by defining a maximum length value (4060) for SMB symlinks
that both client and server can handle.

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    5 ++++-
 fs/smb/client/reparse.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -35,6 +35,9 @@ int smb2_create_reparse_symlink(const un
 	u16 len, plen;
 	int rc = 0;
 
+	if (strlen(symname) > REPARSE_SYM_PATH_MAX)
+		return -ENAMETOOLONG;
+
 	sym = kstrdup(symname, GFP_KERNEL);
 	if (!sym)
 		return -ENOMEM;
@@ -64,7 +67,7 @@ int smb2_create_reparse_symlink(const un
 	if (rc < 0)
 		goto out;
 
-	plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
+	plen = 2 * UniStrnlen((wchar_t *)path, REPARSE_SYM_PATH_MAX);
 	len = sizeof(*buf) + plen * 2;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf) {
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -12,6 +12,8 @@
 #include "fs_context.h"
 #include "cifsglob.h"
 
+#define REPARSE_SYM_PATH_MAX 4060
+
 /*
  * Used only by cifs.ko to ignore reparse points from files when client or
  * server doesn't support FSCTL_GET_REPARSE_POINT.


