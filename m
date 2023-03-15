Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C804431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB8EC433EF;
	Wed, 15 Mar 2023 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883465;
	bh=nrg8pWrR1jyw/2cG4nAiN4f762OvN7Mxbh9oWcnMej0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXpC8Shik/VeHf8u4rnfFJxc60xMkR1j/23KLJUntovyOvQHFO8h+Kzabn8uLgu1H
	 +G3eJhCR+7dt13DYC/0r7yFTripo9iFYJtLAP9p4l+1pdXR62F+I3Go2yaUM84CDze
	 BOwtp+mQR9NpAWCT63QM7JLjDO2hhXUkYKci2Rro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.1 001/143] fs: prevent out-of-bounds array speculation when closing a file descriptor
Date: Wed, 15 Mar 2023 13:11:27 +0100
Message-Id: <20230315115740.482493679@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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
@@ -642,6 +642,7 @@ static struct file *pick_file(struct fil
 	if (fd >= fdt->max_fds)
 		return NULL;
 
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (file) {
 		rcu_assign_pointer(fdt->fd[fd], NULL);


