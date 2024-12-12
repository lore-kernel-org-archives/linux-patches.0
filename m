Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34C9222D64;
	Thu, 12 Dec 2024 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023081; cv=none; b=hLTGqLlMQVdXPcTFf+geWYMGNL32xuCCZUNwUP4v6BDhZFwcZTwo2V5AYKTm+iCvqmuGTuh/j7TXlh0d30cQc1T0uRO0mWDmnXey5oVRsv+ECmMfZ965J/4VyVgIDouOMWVJz3kQPbXnr1FZF6kgGwygNcUpSEBXI4momsK9aU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023081; c=relaxed/simple;
	bh=zazexL0u/dtF/LDIzEWaGdBTeUvmZPCcmWl8qcv7iac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3qseMWaDy600WeTMCk7xyZDt20o7LVNJ36WD8Iw8iId3HQ6WJvzDjJn3D82QWHo0MSDyvup3krZMxin4DLAbmcXgNN2p4GKEHL4DqUIHthGf1QgybgIrtzFOZhP0JAYpii8g318mNkq8M784+h/rM4VGG5LBZ1N/4jNqZPzeNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+DwV7fG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+DwV7fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344F8C4CEDF;
	Thu, 12 Dec 2024 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023081;
	bh=zazexL0u/dtF/LDIzEWaGdBTeUvmZPCcmWl8qcv7iac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+DwV7fGM4rQru0zRBaZcKQZxHTInM9pSuF5MlPGQU8UFcyShFhINh00IFiDPYYWg
	 WwNLGGH8FlRyuqKqjIOT+TCQ2Zn+D7ApGPOOjnWJVzZf+7nrultHsXYlM9Qq91TdVV
	 cfwDEFntF+UMppYQ8KNsn7xL9UKdxXElymxQr0Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.15 388/565] ovl: properly handle large files in ovl_security_fileattr
Date: Thu, 12 Dec 2024 15:59:43 +0100
Message-ID: <20241212144326.977965022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,8 +519,13 @@ static int ovl_security_fileattr(struct
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
 


