Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619492;
	b=PJkd3fKScQmHDrTtR/MqHmxZp4jJ8ULEc3qqwh7MUj7qoRiUmJj41bjhAptDAFBIeP+E
	 srbdVSE7IzKS6O+VaI0LZPRNUIaIsV6vkglElAgZvs7usHTATkiH/mDZxVpLKJ+zXHYlv
	 S7gsZqGZvqLVXYGijgnJerlfVQMe4JZU7Kbx1kGJhCBMpqVBalqeEyjCw4d40rWvhDbsg
	 qTzEQYIo78zyjKfonDaTJn1z/wwuDyeQ1JVfjfNe6HrC/lX99uas5bN1OlHFoqRPrzD6n
	 hqRDWx6gnrpLK2cgYJLopzbu/0q3K517uy4kWVN3QlaeTV2qt+j77H9ccX4pH6ukqjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SswOJmYAXe4oJBHUnFTIF7B2K7okJPc+P5SF+8QQvFE=;
	b=WJY13vhblU5CWKR2LEpvFYzNC50IzbMLUt1BmKGN/GCkGDXNP8nOn92ta2wJWXD/39e5
	 L6K39qbj/9KD83aP/gzAzDK/n3P4syMH/pToBEl6npCv5oYXdf5+uNKy5+6KmuseJzHxr
	 jjSnTiTM7Ps3I46ypITtQ94lPX4C31w7qAor2jSaSj79deCKxFjfgQLlreQnEwn7zogO2
	 Bi0i0IKdJQRvS4z5Q+q6eC/G8DbyHQjxs7cujm/8JSo2Xva+OsIozEfGonn0h2tuCp6gq
	 HrfGWf3XHGH3cLhHLu2go9G6EkPzd4dZFQFQoch28ttxB/9+ohWFDLymkVToAdkTIMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9nmiq+r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE8D606A31E;
	Wed, 25 Nov 2026 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9nmiq+r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41161F000D1;
	Wed, 25 Nov 2026 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619491;
	bh=SswOJmYAXe4oJBHUnFTIF7B2K7okJPc+P5SF+8QQvFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9nmiq+r5tGTi+Kjhz8qen/VVnSJhQKlvePfuYjtZqdgZsoSa/hCvO7sY8x3PI7Me
	 B+QaFufl4c1mZkwil8TlYSmuU5hrdh04AsMH9uUllaxriMTz6dGlsxCHe+Kgf5wCZg
	 3e1MtK5i6knY3OQO6dcjdhLhydufMLGdMMQTLv3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0614/1005] coda: honor the append state of each write
Date: Wed, 25 Nov 2026 15:32:32 +0100
Message-ID: <20261125143836.128464977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

commit 87ea037a9166a5842356ce68e3585fc6e756603b upstream.

coda_open() adds O_APPEND to the container file's f_flags after it has
been opened, without updating its cached f_iocb_flags. An O_APPEND write
can therefore overwrite existing data instead of appending. For example,
writing "Z" to a file containing "abc" produces "Zbc" rather than "abcZ".

Pass RWF_APPEND or RWF_NOAPPEND to vfs_iter_write() according to the
incoming IOCB_APPEND state. This also honors changes made with F_SETFL
and per-write append overrides instead of relying on the container's
open-time flags.

Fixes: 164f4064ca81 ("keep iocb_flags() result cached in struct file")
Cc: stable@vger.kernel.org # 6.9+
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261105051406.52442-1-dennylin0707@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coda/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -71,6 +71,7 @@ coda_file_write_iter(struct kiocb *iocb,
 	struct file *host_file = cfi->cfi_container;
 	loff_t ki_pos = iocb->ki_pos;
 	size_t count = iov_iter_count(to);
+	rwf_t flags = (iocb->ki_flags & IOCB_APPEND) ? RWF_APPEND : RWF_NOAPPEND;
 	ssize_t ret;
 
 	ret = venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
@@ -80,7 +81,7 @@ coda_file_write_iter(struct kiocb *iocb,
 		goto finish_write;
 
 	inode_lock(coda_inode);
-	ret = vfs_iter_write(cfi->cfi_container, to, &iocb->ki_pos, 0);
+	ret = vfs_iter_write(cfi->cfi_container, to, &iocb->ki_pos, flags);
 	coda_inode->i_size = file_inode(host_file)->i_size;
 	coda_inode->i_blocks = (coda_inode->i_size + 511) >> 9;
 	inode_set_mtime_to_ts(coda_inode, inode_set_ctime_current(coda_inode));


