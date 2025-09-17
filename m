Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F31B3925;
	Wed, 17 Sep 2025 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113354; cv=none; b=UM6a60vuM70lzGm50sNr59Ko9rkW4r3ovhpTqVi1bsParHQ/5g+MwDQh4w47eRXP8I1kf0jzM6v6tyo78hTbqK3X7Ze2OfhnV5YTB5q1DO0fVTXrrrdzWTrOejsMgcx2S7RH+hJ8I3QvPLF3gA6IsHxwKHtYFG+ANRNTitV7msk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113354; c=relaxed/simple;
	bh=704V2ZBsByqLSUyTUfUNh5aUx8J4rwklABWWYmKzIDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj+uvxYEkYkKNBnkgc/0u7fW1DN4f7rOu824WCTkynney1g5KtELiSRK6a3v8q4oNlQXwAz0ylFI4FcpW50BwqAWiDYWX9vX7nV2TBOogBnjReLMDPqn42R3tQjQJt8hWokLmJPLH9APmUcWcoj91PTJ1r0diEUByLjQrSpTyvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLn1ekdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLn1ekdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F7FC4CEF5;
	Wed, 17 Sep 2025 12:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113354;
	bh=704V2ZBsByqLSUyTUfUNh5aUx8J4rwklABWWYmKzIDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLn1ekdB65sUb8iSoQ6lIFgw7x55a2x+YVFXqdtB/HZZZkWdvbbpru60pLqIsigve
	 9QZVeIq3E7bkcsMQSC29mbDWsK1vAy5CHO7RIIucGPnJ3D1qdXutpGy8WzSedCDTY4
	 fl8StXjP82H845UxJV1T9eynZttvRFqmG7/OZGQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 059/140] fuse: do not allow mapping a non-regular backing file
Date: Wed, 17 Sep 2025 14:33:51 +0200
Message-ID: <20250917123345.748816532@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Amir Goldstein <amir73il@gmail.com>

commit e9c8da670e749f7dedc53e3af54a87b041918092 upstream.

We do not support passthrough operations other than read/write on
regular file, so allowing non-regular backing files makes no sense.

Fixes: efad7153bf93 ("fuse: allow O_PATH fd for FUSE_DEV_IOC_BACKING_OPEN")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/passthrough.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -233,6 +233,11 @@ int fuse_backing_open(struct fuse_conn *
 	if (!file)
 		goto out;
 
+	/* read/write/splice/mmap passthrough only relevant for regular files */
+	res = d_is_dir(file->f_path.dentry) ? -EISDIR : -EINVAL;
+	if (!d_is_reg(file->f_path.dentry))
+		goto out_fput;
+
 	backing_sb = file_inode(file)->i_sb;
 	res = -ELOOP;
 	if (backing_sb->s_stack_depth >= fc->max_stack_depth)


