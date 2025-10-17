Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147BA330B28;
	Fri, 17 Oct 2025 15:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715852; cv=none; b=rFzwoLUQiinqIRH/jW4gtggaH7tXOXc7/paQ0ixbHYbeGZCZsnOSn3HY7lkP1UwDhGI7Mg0PyeskyB5WVp47fVY32BOHzchQvpk3qnUz0Rn97JnH5NUp2yMYr3Ul1ftiqYeWOayiGa7ev75tBYgZ4z4ihsL5HuxcB/ZVIn6xPpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715852; c=relaxed/simple;
	bh=cazlg7xiAYvneiHJXyMG6pfAsAfaUyvXPcYH5zrteeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElijljNuq7ZViFrl28DaRoLlRcSwKWIhvc2jndEpzSg9O5qxAQVVrFwMQ7a5Zne3wvpBXXDgBnoHVnzSxQsjdLAFKmQfbAyrCstFr6S5JVjOBO7hASGAhqnhZmbmcUs8qcmC5hTMy7kePl7bvRlqVJ8rcNbQA3VAgyDPlso9png=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Id72Ligv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Id72Ligv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D88BC4CEE7;
	Fri, 17 Oct 2025 15:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715852;
	bh=cazlg7xiAYvneiHJXyMG6pfAsAfaUyvXPcYH5zrteeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Id72Ligvd6a67sEZeSm2b3dRw+ROVAdqmn1HVloxiCGLULXcO+q4kmvSt83gO65Bb
	 kC9LnyQk8jlhZtv7cLhPaH9XOBd+wWyGrjmZzxOTRJXtYL04tRzPfju4llpIPMEtIz
	 eHXiFJLVoZ9OxS3FQLjgIlgkyh2sjhRt0Z2XDoO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 359/371] copy_file_range: limit size if in compat mode
Date: Fri, 17 Oct 2025 16:55:34 +0200
Message-ID: <20251017145215.076250110@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit f8f59a2c05dc16d19432e3154a9ac7bc385f4b92 ]

If the process runs in 32-bit compat mode, copy_file_range results can be
in the in-band error range.  In this case limit copy length to MAX_RW_COUNT
to prevent a signed overflow.

Reported-by: Florian Weimer <fweimer@redhat.com>
Closes: https://lore.kernel.org/all/lhuh5ynl8z5.fsf@oldenburg.str.redhat.com/
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://lore.kernel.org/20250813151107.99856-1-mszeredi@redhat.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c5b6265d984ba..833bae068770a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1576,6 +1576,13 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (len == 0)
 		return 0;
 
+	/*
+	 * Make sure return value doesn't overflow in 32bit compat mode.  Also
+	 * limit the size for all cases except when calling ->copy_file_range().
+	 */
+	if (splice || !file_out->f_op->copy_file_range || in_compat_syscall())
+		len = min_t(size_t, MAX_RW_COUNT, len);
+
 	file_start_write(file_out);
 
 	/*
@@ -1589,9 +1596,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 						      len, flags);
 	} else if (!splice && file_in->f_op->remap_file_range && samesb) {
 		ret = file_in->f_op->remap_file_range(file_in, pos_in,
-				file_out, pos_out,
-				min_t(loff_t, MAX_RW_COUNT, len),
-				REMAP_FILE_CAN_SHORTEN);
+				file_out, pos_out, len, REMAP_FILE_CAN_SHORTEN);
 		/* fallback to splice */
 		if (ret <= 0)
 			splice = true;
@@ -1624,8 +1629,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * to splicing from input file, while file_start_write() is held on
 	 * the output file on a different sb.
 	 */
-	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
-			       min_t(size_t, len, MAX_RW_COUNT), 0);
+	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out, len, 0);
 done:
 	if (ret > 0) {
 		fsnotify_access(file_in);
-- 
2.51.0



