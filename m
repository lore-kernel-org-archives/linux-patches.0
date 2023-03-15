Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39E03C02
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5C5C433D2;
	Wed, 15 Mar 2023 12:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882461;
	bh=6jqiyopOE3KYmbpyF80v1HR77rGXBe+ANsl6F5vijz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNuCW4OV8pJITl0BZzv9DDJ6kPQq5YoinW0wdRwyerfjlSYB8u5Yuf3d2h3665imd
	 It8LnlaMUD2dzHwmtw9f0TOQyopBZb8IKTFcqbzMVEg+qH+31afed6+l3/T0R7ZH9Q
	 C0fKOtTAmC/SYkJbKG0CmKMOio6qg6pp0EtoDnPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.14 01/21] fs: prevent out-of-bounds array speculation when closing a file descriptor
Date: Wed, 15 Mar 2023 13:12:24 +0100
Message-Id: <20230315115718.858146846@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115718.796692048@linuxfoundation.org>
References: <20230315115718.796692048@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Theodore Ts'o <tytso@mit.edu>

commit 609d54441493c99f21c1823dfd66fa7f4c512ff4 upstream.

Google-Bug-Id: 114199369
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -629,6 +629,7 @@ int __close_fd(struct files_struct *file
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
 		goto out_unlock;
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;


