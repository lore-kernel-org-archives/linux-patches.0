Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D645D226545;
	Thu, 12 Dec 2024 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020641; cv=none; b=JtUB7JTVl1blv+LU6E8LmPR570Gn14tP1O84KiodZivN21i/jTz4mR72WL7NQM0xXrRPdNEeFciEZfkyFrNPcDEVpanWhSALWQ241ApaelpROk8WAoz1mrJTNrsxHG530M2p0QOl1FHnYmK7ZLeumrfrbsvMwAZpZJj1K7WWE+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020641; c=relaxed/simple;
	bh=6tV71f/ybmjl762N2GcDWmstXEWajcgHQiuu8bj0L7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZkWMtJvVMHn4nv+UB1jCkOjOxO/yZtMf/dCL1cWsYeMhqFIyfPXZDXzO80lAmlspQe9+HK5LY1T15T1FGCIm0xGGxTB1JEiT758fPYsZVLUk+eU/Zo3UNojynz+dx/MDby/I78BUsm4m26ghYhHj4ot8sK+5VftG1srn4oLnK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZaFGa8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZaFGa8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC58DC4CECE;
	Thu, 12 Dec 2024 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020641;
	bh=6tV71f/ybmjl762N2GcDWmstXEWajcgHQiuu8bj0L7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZaFGa8vapDnB8FP7cCJFUDZVdjrSV0KY47k7ETMd1liv2tMvMrtVN8i6fxy49l/b
	 dJq5rI+l64b8T3PBTM3rwDOSH2aSYJmSvd2QwS/LMbKVLdnnZkQ8I/+CiY+KWj+Krf
	 87lBF7L8Wd5BgzH0pCdrZ5J2/hwM0QteWKrt4lLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 492/772] ovl: properly handle large files in ovl_security_fileattr
Date: Thu, 12 Dec 2024 15:57:17 +0100
Message-ID: <20241212144410.281864316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -593,8 +593,13 @@ static int ovl_security_fileattr(const s
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
 


