Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D21D4248AF;
	Thu, 16 Jul 2026 13:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209700; cv=none; b=Q6DmrHBGuEd/Ea7ytwfsrryNkiDRlxA8OTPDz/0vg9FzftbxsZNQ5r8/rk7R0ziOjXKFoBjqVHLhKmg2KcNUYlcl+FGs2l/f6563fZYqM+WKZ8GGU7CkdG03Xqgcejoy4nlhQ0hIpMiHf1aQHMnwzoGArNjXt0Mq2xW50jIkY8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209700; c=relaxed/simple;
	bh=HNnBx0wBc7qpd7nS98xFFLvKMIncHNtv4YJC8t8vmWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ow3skJ54D0NcLBLhB5TGC0lHQNfUwGm0zSIShF7f0zXlRPIrsAw3KCqk4FhjdgODkB/BqkICfP6227iGnQ990fZOoM2qe8wx7CDqlBcFkZsKgeOsllU17wn6QRizuQg45p2Fw4LvyhlK0Ixp5d8Dd6JJhO2NgJc88a0tmGglaCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgQPuic+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgQPuic+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C8A1F00A3A;
	Thu, 16 Jul 2026 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209681;
	bh=K7Fo5raYZwRLExxryP9UAnU0eRGUSE9R+ih/JJwJf14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgQPuic+R9aKa+AP0b89PodCgi7mN86VTcP3Iq5OXGxNRBsQNLCuO4IFe2HHRbNAu
	 2GFPWtpDjXZAvwkkFT8GbJ/wq+rXInlLQOKPZfDckIO0ArvEYfT9VxLLrkDURHm8km
	 hlPM6+Ux+bxqeAfBrH4T/Ck4kSxQldLdm+e7K66Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217eb327242d08197efb@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 7.1 278/518] hfs/hfsplus: zero-initialize buffer in hfs_bnode_read
Date: Thu, 16 Jul 2026 15:29:06 +0200
Message-ID: <20260716133053.896565620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 	u32 bytes_read;
 	u32 bytes_to_read;
 
+	memset(buf, 0, len);
+
 	if (!is_bnode_offset_valid(node, off))
 		return;
 
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -25,6 +25,8 @@ void hfs_bnode_read(struct hfs_bnode *no
 	struct page **pagep;
 	u32 l;
 
+	memset(buf, 0, len);
+
 	if (!is_bnode_offset_valid(node, off))
 		return;
 


