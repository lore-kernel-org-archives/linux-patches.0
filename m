Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2849394783;
	Tue, 21 Jul 2026 20:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665211; cv=none; b=f+YJzcZ0V0HWfeyW8JG6HuYZIng+iM4RlL5qtxejiIPbhSAlJFhVz0fwXKzsxYJ3SIpePK2dEdAaD6w4CWplINg7cjX8IWLuHK7KoSZpfJ5iMB5dZh90+6dK+NDADBwC+ngvNWTAorlVelUaF/6ybX1MbP2Mz7KL9GaR6L4SIGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665211; c=relaxed/simple;
	bh=bGheoGdO0KSvIdU/2nJ4LDT2fBaTASqvo8fU/T/1TCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC7OGXpYB+opIsSKTTVu5OGh9HolVIKDqOLxqkfx41VV4xJNzTbktB5iZ2Nu+v2mZRZFFAAzPCXimurY6DmmVYKUTg+p+3QWLNQnzcHxnK+8kcMkjoZdAhLwb3jnc1lOuwM7AIrriLIzU2eLhR62S/ioPm0u0JoiD9CaeHxANik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IR7kiKnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IR7kiKnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCF31F00A3F;
	Tue, 21 Jul 2026 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665209;
	bh=gqBK7gwobFYbN7QnYhZCIDkkgXjLShfT3djlXy8Rohw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IR7kiKnDKl7VDEw4Hxp6yvayG/mz0SA9QtuG+8uq5Y0Zw7icPddWfJNyGUTKRL2Bn
	 qJXN1XToZenEZuSY/KDU27kFn5JgTOIGhaUz1lplee9ziIJl5hU+i4QgVIyhe9w+Ap
	 6UhjTMb0bHLRqdG8ZKfsfFpCpVrWjVjQO04NYCFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217eb327242d08197efb@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 6.6 0217/1266] hfs/hfsplus: zero-initialize buffer in hfs_bnode_read
Date: Tue, 21 Jul 2026 17:10:54 +0200
Message-ID: <20260721152446.675077296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit d67aadee19ffdf3cc8520c5a4f4d5b2916d30baf upstream.

hfs_bnode_read() can return early without writing to the output buffer
when is_bnode_offset_valid() fails or when check_and_correct_requested_
length() corrects the length to zero.  Callers such as hfs_bnode_read_
u16() and hfs_bnode_read_u8() pass stack-allocated buffers and use the
result unconditionally, leading to KMSAN uninit-value reports.

Rather than initializing at each individual call site, zero the buffer
at the start of hfs_bnode_read() before any validation checks.  This
ensures all callers in both hfs and hfsplus get a deterministic zero
value regardless of which early-return path is taken.

Reported-by: syzbot+217eb327242d08197efb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=217eb327242d08197efb
Tested-by: syzbot+217eb327242d08197efb@syzkaller.appspotmail.com
Fixes: a431930c9bac ("hfs: fix slab-out-of-bounds in hfs_bnode_read()")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260505111300.3592757-3-tristmd@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfs/bnode.c     |    2 ++
 fs/hfsplus/bnode.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -64,6 +64,8 @@ void hfs_bnode_read(struct hfs_bnode *no
 	int bytes_read;
 	int bytes_to_read;
 
+	memset(buf, 0, len);
+
 	if (!is_bnode_offset_valid(node, off))
 		return;
 
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -25,6 +25,8 @@ void hfs_bnode_read(struct hfs_bnode *no
 	struct page **pagep;
 	int l;
 
+	memset(buf, 0, len);
+
 	if (!is_bnode_offset_valid(node, off))
 		return;
 


