Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C71F09A5;
	Wed, 17 Sep 2025 12:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112772; cv=none; b=quRg9skN3TljsHdl9BxgMg1/rDw4qo5Rl8BirXlv9Nq0+taHWm6/rWtt/mhxVzd1HrsDzMSqcukPI0SaYK1Yy/4Y41dHlJcL9j+WR3QSFBIy1kbsMfv9iYOZOdAf46djsXXHqMPksjy0puH/7l162gs6dVR9UlZhz4DbAoDoMpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112772; c=relaxed/simple;
	bh=vj9VLr3ilFDwK36sXPb7FYLh/NWicj4ZSAoiWnJjN60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ/jQHxkiDHGnhBTQbIYhTRIOE80E4trjm9uWKdEIRS4K47hDn647kJbNLtMGKdCdQQQLlXnONWacrFi8XFwDUJ+Vjr31yIs9ev2ZAoBqHMQv8CxcirjaWKp/HZP4eWzMvkTb1tb/BKRUEPvTfY6QDw+m+CVsws+ev67bKdTZ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHelgds0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHelgds0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F6EC4CEF5;
	Wed, 17 Sep 2025 12:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112772;
	bh=vj9VLr3ilFDwK36sXPb7FYLh/NWicj4ZSAoiWnJjN60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHelgds0mqNCymXN5w/SLMaE5Vr4ubNWOiVh8xss5wQS+Bl7Urs+jQmwtIWtf8ZvU
	 KVLRgLgj5LhktQ4Pg9mhf3BkZ0xbWDqN58Iwv/uNETExSzZjiKMilznU/QA9KWnU6K
	 b86ZKUlVJhbAKAtDSQ8T8XDksnf3XslbVxoR/QYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.16 073/189] fuse: do not allow mapping a non-regular backing file
Date: Wed, 17 Sep 2025 14:33:03 +0200
Message-ID: <20250917123353.653059502@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -237,6 +237,11 @@ int fuse_backing_open(struct fuse_conn *
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


