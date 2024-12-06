Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4411465AB;
	Fri,  6 Dec 2024 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498668; cv=none; b=fF+2QvErbcvBChmguEFsSPsSsP1QmvgqUTx9W6Op3vFTV2Xt073Fz5fnUTK4zwLPbGQUEbv1f/QYLcqmxFnXkSAY6Ywt9eEUNfW8Iq4VR0u9YE1p/eg05AVnPLz8DtBFUH38ut+lX2yBhYb8k+/cRtbNRjs45b0Mwnl+irM5ahw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498668; c=relaxed/simple;
	bh=j/Zb0GzUW6ARws7RZX5FhmWNuHrbjG+hjroxcZ1aMs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH/v3WEuchkvA7me/aMC0us045GY16U3uRS01iZBuYDHYYq1WCB8uIC3J5x7G3ZLhcfsNFIg4aw7GhMZtA/FIg70sDkAN7+3IxVeb9L0euCsuQGPd9qLmCEoR1jceYQr3MTXG6kkFip9XP/fM+/5MSypApLx/xEkfhR4PL0oQ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jv64u77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jv64u77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE03C4CED1;
	Fri,  6 Dec 2024 15:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498668;
	bh=j/Zb0GzUW6ARws7RZX5FhmWNuHrbjG+hjroxcZ1aMs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jv64u77covHS50BufilB/dT94KCYHGVOcdMoz/ryubjc+Z1nZHupVbX27OC8U0vL
	 91Uc+BEeH3HgsVOycA6Lyw/IRmxiVI4++dmPUBQuyRYfBVpEUWiIqB/GfMaNV9AUVW
	 BJY1na6m95c5RMTeH82ylKG8hk3gp8q8ttd/LhI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 651/676] ovl: properly handle large files in ovl_security_fileattr
Date: Fri,  6 Dec 2024 15:37:50 +0100
Message-ID: <20241206143718.798493526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -741,8 +741,13 @@ static int ovl_security_fileattr(const s
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
 


