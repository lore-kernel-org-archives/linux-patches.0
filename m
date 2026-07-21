Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E69C43C05F;
	Tue, 21 Jul 2026 21:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671121; cv=none; b=GO8kAkjQUzaooBFKMDyJw5WYTeLVdCj04E26VqBxtKw35d0+rRKQbQgiHBmbu2uJrccu3PbJLkr7bnkM9Wng5xAw37kw9NO/NgwhWDG59fwBlPDe4+ILPcbQhfOcBmfPbNbwQ2Cp6rLKMRIWPWsama/xEPPhqKDuXm0wz43Dyac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671121; c=relaxed/simple;
	bh=phGCDCnQFiHfsjMDGtGe4m9iPYCz8NgN2Kd6w2ZtCxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6KXjihxGy/BS++nyN6/Zo9HZQOvsikavYVo/0QRZRWdns+dw9GnbGyBA42LuSErOhnnXyXevSUvoA2kvA/5R9sdX5IKsYdLU7Ec/3Ghukju8zSrxmx+at7dBmg+3hVmfZjcIVqMCkEE8v2zldR1UEdthwWuykqM4GdoWOsQHyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYPZMtNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYPZMtNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F393E1F00A3D;
	Tue, 21 Jul 2026 21:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671119;
	bh=9VoY6ZuVCFodF12qP4xk1rB3FjXKAZ66V95nZolIkN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYPZMtNzxij7JNaU+O0UiCSKuSXtnL92v0M+PBSKkZ5VYOof3d7RE/h6ocMQVSRZc
	 iMDAcHimUrp++JtN8eotaZqC1jHkBP2eI36gau5UF7bFevMogeHAnpF5wyOd4+FvUj
	 2M1JKne7aZXieRejwANa2vQl0CkdER8ogrda4FXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217eb327242d08197efb@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 5.15 124/843] hfs/hfsplus: zero-initialize buffer in hfs_bnode_read
Date: Tue, 21 Jul 2026 17:15:59 +0200
Message-ID: <20260721152408.797720086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


