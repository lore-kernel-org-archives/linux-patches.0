Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF5B1F9A94;
	Tue,  3 Dec 2024 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242688; cv=none; b=JB3/XWIpOs3UHOUtBNAU+cBKumpvPMfnruwCtB1i2PypHR/Eai3f6i9EDVRsMFtjX3y4T2EtNSvzGJ8TJhDqeG5hYFxu++/knYyLPv6a37kTOQiPPazjZ37Z3I+74dG7jW23nxuCBNRr3uNSznWBXytFNSdsNEwAGzJvHfp62tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242688; c=relaxed/simple;
	bh=vjSoRr/ljWFK04RfUFGxqGWtgspNiqVh4HiWJj4OVr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzVLskOCHth5ypZWoqbKJMqW7bhaEnB8uuLJn1aDRefN1xj9uBOYUexjMH2pNoB4Tgl/inj4jAHgQnLdCTWfDBRLVHkye/epPkkG74tm/4mnRrpvumMhlc8sLY7BITYgQQGnE7JtlRyMQlc5NOhIAakVCJjwxTU45u0aNn1diKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdGnKhMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdGnKhMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B64C4CECF;
	Tue,  3 Dec 2024 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242687;
	bh=vjSoRr/ljWFK04RfUFGxqGWtgspNiqVh4HiWJj4OVr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdGnKhMnIIGnnjYWN2eNUGqwxqzHEa+qzqmNWUxtcjkyC0gtxuFNEKgSGJ+L1r0c9
	 f8Qi4y8k1UlvtnL/YkRwV/WOAK/Yygo3r5+F2s74SjQx4VmsgYAtYB2G2uxZCbf7C5
	 245TgqZxUis8j+Vb8I2IQjb+139I/Wr6gBQjpoHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 752/826] smb: client: handle max length for SMB symlinks
Date: Tue,  3 Dec 2024 15:47:59 +0100
Message-ID: <20241203144813.097373708@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


