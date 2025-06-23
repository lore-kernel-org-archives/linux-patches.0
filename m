Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E602517AF;
	Mon, 23 Jun 2025 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685004; cv=none; b=esmnKX5iavyCEkRmw8/C0Iy3q0XWOAqliW1SqBzPikIrPmNbbQFD+qLj48Qg09yyL4ucN+hKXjRwGVggk1EmUBMbA8HzP8N5/lMa2fwfRlCA146wL7ySR5fqZMNoYSuSIOWuPoNqmdXVUGfJjzrAcfUZw+rPeEOjtuinFpWnSz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685004; c=relaxed/simple;
	bh=U2Bbx8UB5UKB65zPsQtfMC1Jz+OcO317cTB6whwlcIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZMw0ePbqHCyprztiNXqEYZj4RcYWIV283ALDLY/fn/a258G8vBA9xW7mR5czCcPfsHcEhIBssWsvxDRbSsbeSOwCKvzVVrAEGo4CW9BRBmp+L6Qc7DArR8dz7f1/W7PaJHhf4stMpEOsYxxCZyIuw2F7tyc/fct2mJDj75vIRwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OzWaz1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OzWaz1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29917C4CEF0;
	Mon, 23 Jun 2025 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685003;
	bh=U2Bbx8UB5UKB65zPsQtfMC1Jz+OcO317cTB6whwlcIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OzWaz1nmnMTzrYU09gTGRk6rVECnFNoz6H2tqLc7B+N3q2l22pVSQIVRXyOliVPu
	 HYNPGnExTtAZa1A6M7UHvIzdELJQlvVf1PR+KvkGFYjMPBAUamIw3xZOJh4+dUsVKs
	 u8ydyB32RqqHFQ7qElcKxCKHPLmMVEVyMo4CsGc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Schoenick <johns@valvesoftware.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.15 168/592] ovl: Fix nested backing file paths
Date: Mon, 23 Jun 2025 15:02:06 +0200
Message-ID: <20250623130704.275055519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 	ovl_revert_creds(old_cred);
 


