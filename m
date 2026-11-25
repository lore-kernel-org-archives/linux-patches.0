Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622930;
	b=ttnrOXwEvxQMgGj5A6xRGGzZLmii/7h5zL/U4SqOqTMAtkew8oRWs9DjCftIF0zFihHR
	 t9dlS3udiciRCD4P9M86syuFGD9cqYWGKhX+b10MEpQd16OMsiPrKRvmgUaMErNRvcRBq
	 TD1smGlw24asGBh7IVX6dYQJM5h+JkBw+ZGnwR5gKIQ6Dk9/7+I7EzpBXyYKmY94sqzDh
	 PyQJ2XWFnK0hAHxvS0JC3H6pXsA1H9xdOCf9XxrIojbzsFGxOsIsa0QEfJ879fNYVuRzd
	 r0GCD0N1czfqdpEMPQ2XmHhRYcLhKReEE82ltmFuiLgRXtiHhT0fdaglNg06IWaEX7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O6LZ5Udi4NQ9Yu/oWtysLQll/A8Dbz3Z55M0qvFuRSk=;
	b=CdFLa/gvBiyvVYyUeMaVnQKRIO8/EzMo/+J/jyAixPUsolxc5SXVcGBtMyqzExYtNLew
	 w0Q9LQKMlM6JurVVVX3JDXHulyZi50PjPjoIovNnobHQSKSQc4gd+oPoDFLbxFTv6zKbi
	 cIa4S4KTisymUGRyPd5SzzWzixDJUnvtjq2R06n9jj1SHE5C7Fb5s4n9LmC7U/xNupsdn
	 +jZuHoCp1mZzQMakg2iP1moDbrTIkwiKUl5BGRIfi2drX2n5XmbTPDGlmXyJGw7bSgRSl
	 uhisY1ya4BQGDCEfkFkhnEhN7OkCWJg/6U6NK+eMtuco9g113IJg8vp0GnNfMl6IOCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14oObWfl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F59606A31E;
	Wed, 25 Nov 2026 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14oObWfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E2B1F000C0;
	Wed, 25 Nov 2026 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622929;
	bh=O6LZ5Udi4NQ9Yu/oWtysLQll/A8Dbz3Z55M0qvFuRSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14oObWfliIYbsy5xBkAM8bd8NfT/IltweJcoueV8mTV7NMDEi0nSekI5l5/RWzRlY
	 r2InCgpI43jfph3bSphLDWdMCrwCz++4XmvV+wXCMUuqAl5EQblIkGpA5jN61QQIiy
	 12vRmTfGApTNGkPtDhygFKkoHrU/ib2CnKCxIDCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 688/990] coda: honor the append state of each write
Date: Wed, 25 Nov 2026 15:34:15 +0100
Message-ID: <20261125143838.204100568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


