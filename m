Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BEB35C6AC;
	Tue, 21 Jul 2026 22:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673254; cv=none; b=i1gsWmi5A59JjuhdbXPEyoC1cWkkM/KpP4I957VJUXLZszCMg1vS03QSJ3fHbnP0rqMY+oC2fAXDEsbC9No3+OvDseFgzg+GtffE81JspSDmngVdasYIj5ENOiZort0e3lNyCEUwwLIjSb5IkNOBMfNqAd2I6u8EpcXMfanWxuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673254; c=relaxed/simple;
	bh=ehDeAC+4T5KF81KrpRWSfgKfskoB0/ZSyc0um+ENS2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkZNNHr4JrL6ufHCLdrVTbrq7udmFS44B8VwmWbc1wLnN/QI8/uDjmWhsphiaGHw7l9LcHX4GLCYLq5Fn792TW3K5SbvJMqOUjGb7aZe3sX4+aSNjQlyoz6nSbcr+dBKXgtXruiFFALsMHUHcooBRfZN9shu8hGvpXD24gB4KEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5IolPnd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5IolPnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189FF1F000E9;
	Tue, 21 Jul 2026 22:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673253;
	bh=vS95PIo93TcAd9lnpPZ/LYjItsfZ82aIW5RHgPoaxu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5IolPndQkb5rtIiz9gBLSLmpqpngSZ9W6rSgmtv2fAgV1DbJaf5uk966JBYfMIMq
	 x2M/JNvAKpxGIlCaaY9DADZ9BXNeSKEpqkkki6JgEZCqjyzycznMmQyYbR0Ih1iGgS
	 rf4dJz02z7lPY3byBoJs+JHSapQBkTWU305HKhfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217eb327242d08197efb@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 5.10 094/699] hfs/hfsplus: zero-initialize buffer in hfs_bnode_read
Date: Tue, 21 Jul 2026 17:17:33 +0200
Message-ID: <20260721152357.822746676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -65,6 +65,8 @@ void hfs_bnode_read(struct hfs_bnode *no
 	int bytes_to_read;
 	void *vaddr;
 
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
 


