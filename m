Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625606;
	b=iMoUsJhBQVUY7q575N81OK24n/H7l8fBnasAioyB3CuPyI5bEeShYPnxqlNuB7Zcr12m
	 zl2zAfuI0BNa9gxjHAue9y9pv1rXmwzOgE+FgvYxUpPb7caysW+6P+/biJ3LjeKTFW+Kk
	 hw14Tz1/Y28R0Op7ZxqdbnExLU1/5nJrkxuWQDfHV6Q0+QTZSB6dN/8vtaFsxzIDmzdvd
	 vknABWeNr33/N596fPas47QKAqg9gin07dotMZ/uxR5na4BvEcLMCwWwebRhy1FhJ3U+N
	 6IOsHLI20eX+7ztzDbGUd42jXAKYZ8MSp1J1//77k/Bd8B5XVMuDhx0Hsd7HUdJSOGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VAftaFRvxg/dz7VLRtRIp8drCre5+mTpDL2AywZzoas=;
	b=x+Rgf4MTBEuUj3rp4PbQATVj3iSihvDtofPej0ARqFAHNGq6eFhfza6csLAOeLzKqUq3
	 MbRMRD8OJ7jsIHNLUcR5vZWdkHQ5SrOLgU5tWsNWiAdRP25gWRKy1i3jdoZdzJjDypbT2
	 k1987+ajfzT1AN8W4XPrWI7rquEKf0sG5U/3ftuGp8N6a5nydnaSu4gdRFCaajonHNp4t
	 6po8hePzSI/gy1ERlEkrZn+PHdy9GN6evbk/p9GohV40Rc9vOj0HCxR+650mpRN9u0+aL
	 eRWbmpVVPZyypYdNAVqoFiz6oo0jh8qJcmtwBEe/J8A9/lLEMl0vz3R9BqGUKklfXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALHcBtHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7140606A33B;
	Wed, 25 Nov 2026 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALHcBtHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1687A1F000D8;
	Wed, 25 Nov 2026 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625606;
	bh=VAftaFRvxg/dz7VLRtRIp8drCre5+mTpDL2AywZzoas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALHcBtHq/JgOgznxQgSRB1v+rZz7pTlpz1wttRYsbSeH1uZ9Qaf3AePyODwgqXKMS
	 pLpktPtB1qPtzKDcH/1BHpQjVGqFFoZqFHn7LqqYJSFTQRo1oWRwjJBAbVjoWGczC3
	 nFmwPLMwpKk76TfzzMo0KXF1rNWpe9lPuD79jv0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 573/816] coda: honor the append state of each write
Date: Wed, 25 Nov 2026 15:35:21 +0100
Message-ID: <20261125143902.444156913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


