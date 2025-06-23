Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9600219D084;
	Mon, 23 Jun 2025 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714904; cv=none; b=GE84kSCEA6Ye/thG0c3sR7GxDyAzt3bu3gyFKJct5tiQQ8BdjWK870CZcfF0+P42IiKzwKPExumiMHbyGGghUdza7UGmjfcj1o3EIi0AX8d+HF04C6uI99wPro0oh7JCKfb/0fAIaAt3L17j8Ot/Tv7sT3hTIRGswI34FIlnrgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714904; c=relaxed/simple;
	bh=jRmmgP3Xp5j0a4bFk5SMA6Lvtcv0nefXfUUvzCz+VGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2Yego53xS0dzAmqRzM50jTqou7kVnSHgiNNOZCBnEBnHSdzSexVcm4Ek+xVr/0e6O5hPaBE7hQu69/Z5xkokGwfiZC5IcrIkBgYCk9P0dxOYnnm+uOgXAB3PYyrSEEQpsnXeZqFjCxOxL2MRQJpZbgFdV1+65HZQGPw1KSNxDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nh5MRcjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nh5MRcjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB4EC4CEEA;
	Mon, 23 Jun 2025 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714904;
	bh=jRmmgP3Xp5j0a4bFk5SMA6Lvtcv0nefXfUUvzCz+VGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nh5MRcjdNju4HyCq/7bTBmb2zesZ08Y4u8peT0BMVAQcmAJLYV8oM6r1GQ28nHNnu
	 gnhOLOmJxvms7c9LFYpA/LP1M2dN0+Sg5ZGu3Q5S0p333KPI8+FYwPhzkyJCpCAXPa
	 Fd3bycz277E9WWzBlSvHXh5S5LlAEW4S0EkOwb8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Schoenick <johns@valvesoftware.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 138/414] ovl: Fix nested backing file paths
Date: Mon, 23 Jun 2025 15:04:35 +0200
Message-ID: <20250623130645.504107701@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Almeida <andrealmeid@igalia.com>

commit 924577e4f6ca473de1528953a0e13505fae61d7b upstream.

When the lowerdir of an overlayfs is a merged directory of another
overlayfs, ovl_open_realfile() will fail to open the real file and point
to a lower dentry copy, without the proper parent path. After this,
d_path() will then display the path incorrectly as if the file is placed
in the root directory.

This bug can be triggered with the following setup:

 mkdir -p ovl-A/lower ovl-A/upper ovl-A/merge ovl-A/work
 mkdir -p ovl-B/upper ovl-B/merge ovl-B/work

 cp /bin/cat ovl-A/lower/

 mount -t overlay overlay -o \
 lowerdir=ovl-A/lower,upperdir=ovl-A/upper,workdir=ovl-A/work \
 ovl-A/merge

 mount -t overlay overlay -o \
 lowerdir=ovl-A/merge,upperdir=ovl-B/upper,workdir=ovl-B/work \
 ovl-B/merge

 ovl-A/merge/cat /proc/self/maps | grep --color cat
 ovl-B/merge/cat /proc/self/maps | grep --color cat

The first cat will correctly show `/ovl-A/merge/cat`, while the second
one shows just `/cat`.

To fix that, uses file_user_path() inside of backing_file_open() to get
the correct file path for the dentry.

Co-developed-by: John Schoenick <johns@valvesoftware.com>
Signed-off-by: John Schoenick <johns@valvesoftware.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Fixes: def3ae83da02 ("fs: store real path instead of fake path in backing file f_path")
Cc: <stable@vger.kernel.org> # v6.7
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -48,8 +48,8 @@ static struct file *ovl_open_realfile(co
 		if (!inode_owner_or_capable(real_idmap, realinode))
 			flags &= ~O_NOATIME;
 
-		realfile = backing_file_open(&file->f_path, flags, realpath,
-					     current_cred());
+		realfile = backing_file_open(file_user_path((struct file *) file),
+					     flags, realpath, current_cred());
 	}
 	revert_creds(old_cred);
 


