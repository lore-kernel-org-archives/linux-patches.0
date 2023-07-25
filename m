Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3091EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED149C433C8;
	Tue, 25 Jul 2023 10:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282143;
	bh=u0s5v0cHR+hs5cNgLiIluV/YDq29nb9yExBQ2TG2pYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVtZFqM2SKF6bXBf4Lv6hj7gxLMTHVXc3Y26AL08W24wCCRY+/1jWi6z2XY9sua9f
	 i13e+6fTcydbPwsRRcj6m4dJVzmMYLfNroXGK4MH/gvS+7furuQvN32G9xGRBt224/
	 8BAiqAyYO2NjjvRsYRP06kC84qJ1hORVyvB4OZ5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Katz <jkatz@eitmlabs.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.4 023/227] fuse: ioctl: translate ENOSYS in outarg
Date: Tue, 25 Jul 2023 12:43:10 +0200
Message-ID: <20230725104515.758129877@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miklos Szeredi <mszeredi@redhat.com>

commit 6a567e920fd0451bf29abc418df96c3365925770 upstream.

Fuse shouldn't return ENOSYS from its ioctl implementation. If userspace
responds with ENOSYS it should be translated to ENOTTY.

There are two ways to return an error from the IOCTL request:

 - fuse_out_header.error
 - fuse_ioctl_out.result

Commit 02c0cab8e734 ("fuse: ioctl: translate ENOSYS") already fixed this
issue for the first case, but missed the second case.  This patch fixes the
second case.

Reported-by: Jonathan Katz <jkatz@eitmlabs.org>
Closes: https://lore.kernel.org/all/CALKgVmcC1VUV_gJVq70n--omMJZUb4HSh_FqvLTHgNBc+HCLFQ@mail.gmail.com/
Fixes: 02c0cab8e734 ("fuse: ioctl: translate ENOSYS")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/ioctl.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -9,14 +9,23 @@
 #include <linux/compat.h>
 #include <linux/fileattr.h>
 
-static ssize_t fuse_send_ioctl(struct fuse_mount *fm, struct fuse_args *args)
+static ssize_t fuse_send_ioctl(struct fuse_mount *fm, struct fuse_args *args,
+			       struct fuse_ioctl_out *outarg)
 {
-	ssize_t ret = fuse_simple_request(fm, args);
+	ssize_t ret;
+
+	args->out_args[0].size = sizeof(*outarg);
+	args->out_args[0].value = outarg;
+
+	ret = fuse_simple_request(fm, args);
 
 	/* Translate ENOSYS, which shouldn't be returned from fs */
 	if (ret == -ENOSYS)
 		ret = -ENOTTY;
 
+	if (ret >= 0 && outarg->result == -ENOSYS)
+		outarg->result = -ENOTTY;
+
 	return ret;
 }
 
@@ -264,13 +273,11 @@ long fuse_do_ioctl(struct file *file, un
 	}
 
 	ap.args.out_numargs = 2;
-	ap.args.out_args[0].size = sizeof(outarg);
-	ap.args.out_args[0].value = &outarg;
 	ap.args.out_args[1].size = out_size;
 	ap.args.out_pages = true;
 	ap.args.out_argvar = true;
 
-	transferred = fuse_send_ioctl(fm, &ap.args);
+	transferred = fuse_send_ioctl(fm, &ap.args, &outarg);
 	err = transferred;
 	if (transferred < 0)
 		goto out;
@@ -399,12 +406,10 @@ static int fuse_priv_ioctl(struct inode
 	args.in_args[1].size = inarg.in_size;
 	args.in_args[1].value = ptr;
 	args.out_numargs = 2;
-	args.out_args[0].size = sizeof(outarg);
-	args.out_args[0].value = &outarg;
 	args.out_args[1].size = inarg.out_size;
 	args.out_args[1].value = ptr;
 
-	err = fuse_send_ioctl(fm, &args);
+	err = fuse_send_ioctl(fm, &args, &outarg);
 	if (!err) {
 		if (outarg.result < 0)
 			err = outarg.result;


