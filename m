Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10DE1474A9;
	Fri,  6 Dec 2024 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496233; cv=none; b=e3PZhB/X4W0/BeuxaxBgh7XPySbBuDNOIOiujp2LHmyPf5ow8PG1FZYyCO5Fo02Tvkscdm4CtZD/KYhE94CwXjoHjW3VVhNVpcU+NhWEhEsahQODal3fzG+HJSBdKHrGsbCf+sLp5zA5eRZgoJa1G/WuWYWLcGAY1UnRxtZ35fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496233; c=relaxed/simple;
	bh=z1iHs/ihgPPtrTiwKhTf5BBYscSsVCB135HDcWIAHAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh5UnoHK70bkdwTaaWj9mNrts/wTibusqkeN+32+IVLl9YBs6K1BNtMPjHlsrYlHWflG3vHgH1trWNcdasHtR6M0d6vVZU2wcRH+0+5UI8pzkzYsEQhdmdR02x1GmhZ5AmdTB3H4oVzV6lOzcoznSXvJw26fq0E2WLS2RMNQyec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1eBlUwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1eBlUwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11915C4CED1;
	Fri,  6 Dec 2024 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496233;
	bh=z1iHs/ihgPPtrTiwKhTf5BBYscSsVCB135HDcWIAHAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1eBlUwkaE5vFcdVxA0f7FrExbIDQ8R4dEPmAOQJNzYwPJyA76MY5Axz4gQ7oQmF4
	 gQW4YOMI/Og/Fj9dQyc6OlClHcQEd4dWByZOFENgC8UQ1sA3VEyvmxV3PH9U69bEw7
	 xugz2iYr0Bu9XCqANf8m1nnfx4IH1bug1bCIh9Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 092/146] ovl: properly handle large files in ovl_security_fileattr
Date: Fri,  6 Dec 2024 15:37:03 +0100
Message-ID: <20241206143531.196887955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Oleksandr Tymoshenko <ovt@google.com>

commit 3b6b99ef15ea37635604992ede9ebcccef38a239 upstream.

dentry_open in ovl_security_fileattr fails for any file
larger than 2GB if open method of the underlying filesystem
calls generic_file_open (e.g. fusefs).

The issue can be reproduce using the following script:
(passthrough_ll is an example app from libfuse).

  $ D=/opt/test/mnt
  $ mkdir -p ${D}/{source,base,top/uppr,top/work,ovlfs}
  $ dd if=/dev/zero of=${D}/source/zero.bin bs=1G count=2
  $ passthrough_ll -o source=${D}/source ${D}/base
  $ mount -t overlay overlay \
      -olowerdir=${D}/base,upperdir=${D}/top/uppr,workdir=${D}/top/work \
      ${D}/ovlfs
  $ chmod 0777 ${D}/mnt/ovlfs/zero.bin

Running this script results in "Value too large for defined data type"
error message from chmod.

Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -616,8 +616,13 @@ static int ovl_security_fileattr(const s
 	struct file *file;
 	unsigned int cmd;
 	int err;
+	unsigned int flags;
 
-	file = dentry_open(realpath, O_RDONLY, current_cred());
+	flags = O_RDONLY;
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
+
+	file = dentry_open(realpath, flags, current_cred());
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 


