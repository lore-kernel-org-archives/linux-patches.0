Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150CBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4125C4339B;
	Tue,  7 Mar 2023 18:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214429;
	bh=0VEvw8YGLPU3czJW+o90Dw9ceDo8GXqgNmImZkTvuCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSTVytlTrtDyj3Pj1IFsmU+dlBkBrb5zxHQ25P+l0y6DQSZb2JoCLPAArRqUIhZc3
	 dh1Ae3hHR0PZ0gadyZORzs/fhP52n7MbKRoT2ftXyJEdBt3op56qhQiPk0Cj+LpAlC
	 qJ31maDfw5j7FzVLwddBZkCi2PsyxdqbnVSzKjR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 819/885] fuse: add inode/permission checks to fileattr_get/fileattr_set
Date: Tue,  7 Mar 2023 18:02:33 +0100
Message-Id: <20230307170037.432963300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

commit 1cc4606d19e3710bfab3f6704b87ff9580493c69 upstream.

It looks like these checks were accidentally lost during the conversion to
fileattr API.

Fixes: 72227eac177d ("fuse: convert to fileattr")
Cc: <stable@vger.kernel.org> # v5.13
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -419,6 +419,12 @@ static struct fuse_file *fuse_priv_ioctl
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	bool isdir = S_ISDIR(inode->i_mode);
 
+	if (!fuse_allow_current_process(fm->fc))
+		return ERR_PTR(-EACCES);
+
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!S_ISREG(inode->i_mode) && !isdir)
 		return ERR_PTR(-ENOTTY);
 


