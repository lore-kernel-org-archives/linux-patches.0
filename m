Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85114431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBD7C433D2;
	Wed, 15 Mar 2023 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882519;
	bh=z/iFusAiSLpPLwdVFESAgq2RXBmDbfYvFSycz6MVXJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/6yj6FQMOEfHVVpAsSe0Ya4I6hDUwwk1ezC99DpC7AN1q/VK/B1U56/IYkt9Ghwo
	 aaQxhLt59T230tM5Ox8HTvvo4jOfYDPUAnNpHGstH7DP+DeMajRuo1QCH+u/3YxPlb
	 bGCpoMzai8fpPavDNFhhcZdXN5OyWjvG5WRHiMAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 01/39] fs: prevent out-of-bounds array speculation when closing a file descriptor
Date: Wed, 15 Mar 2023 13:12:15 +0100
Message-Id: <20230315115721.295721286@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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
@@ -627,6 +627,7 @@ int __close_fd(struct files_struct *file
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
 		goto out_unlock;
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;


