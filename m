Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048F43BBE1;
	Mon, 15 Apr 2024 14:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191459; cv=none; b=g1L8Lkae/V11r6z3uDoKeD5T7w9SSLSpdB3JXETKMhtrbZ6TG3SN6WvHZkpnYGWFB/Bb7TCcuyUWFrUtnlFt4gcQ9pbmYoXe8xspmj69IACkHI/4pHuMZ/n+y4xLPyZP6sQQQTdrEP1G/o2hA3UU0K1tZ92mP3esPxCRayg2tXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191459; c=relaxed/simple;
	bh=MeGEpVLi6a1JRMu4Q2ytxS3rHEiQjcu9+N7TaSzuUxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEBv+HMNCYg2Xxo1N/m+t1CubJGu7IGEFekOiLU3BthPfqLQ1rovy7xWvw6aMyF2DnU6b3mQHjggk9OjWR7ZN0TKs8JPnPe5P0siHYPguZPD3iVt3XZADq5qEu6D9icWrQp2fZqeZqUX79rJ3MiZYxPZdwQKGkEIWidMJw2aSYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v343Bk45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v343Bk45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFA3C113CC;
	Mon, 15 Apr 2024 14:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191458;
	bh=MeGEpVLi6a1JRMu4Q2ytxS3rHEiQjcu9+N7TaSzuUxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v343Bk45sJ6SLRbTGduAp3x2i508rlK7VnmfyX+vIjJBbr7pyt+r3EoSnlt2lSPl+
	 M+iWrwUo6It3t+apwQyNBPCCYerIr2dq0SOwjvOefhyz6OkAMktfp+vRB1OaWgGnhT
	 Iu7aJ7w1ioStC/h+aT9m5hYBBbvVQ0eEmzBLCMx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9a5b0ced8b1bfb238b56@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.8 150/172] kernfs: annotate different lockdep class for of->mutex of writable files
Date: Mon, 15 Apr 2024 16:20:49 +0200
Message-ID: <20240415142004.923773939@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 16b52bbee4823b01ab7fe3919373c981a38f3797 upstream.

The writable file /sys/power/resume may call vfs lookup helpers for
arbitrary paths and readonly files can be read by overlayfs from vfs
helpers when sysfs is a lower layer of overalyfs.

To avoid a lockdep warning of circular dependency between overlayfs
inode lock and kernfs of->mutex, use a different lockdep class for
writable and readonly kernfs files.

Reported-by: syzbot+9a5b0ced8b1bfb238b56@syzkaller.appspotmail.com
Fixes: 0fedefd4c4e3 ("kernfs: sysfs: support custom llseek method for sysfs entries")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/file.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -634,11 +634,18 @@ static int kernfs_fop_open(struct inode
 	 * each file a separate locking class.  Let's differentiate on
 	 * whether the file has mmap or not for now.
 	 *
-	 * Both paths of the branch look the same.  They're supposed to
+	 * For similar reasons, writable and readonly files are given different
+	 * lockdep key, because the writable file /sys/power/resume may call vfs
+	 * lookup helpers for arbitrary paths and readonly files can be read by
+	 * overlayfs from vfs helpers when sysfs is a lower layer of overalyfs.
+	 *
+	 * All three cases look the same.  They're supposed to
 	 * look that way and give @of->mutex different static lockdep keys.
 	 */
 	if (has_mmap)
 		mutex_init(&of->mutex);
+	else if (file->f_mode & FMODE_WRITE)
+		mutex_init(&of->mutex);
 	else
 		mutex_init(&of->mutex);
 


