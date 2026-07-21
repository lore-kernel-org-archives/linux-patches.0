Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7284582D8;
	Tue, 21 Jul 2026 21:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667860; cv=none; b=mom6UYX+5Kvbih/BOz5WGxZYhySQPIAYS4VsTdzZ5/tefmDVF+7x0BWJeMaeawWfLuWV8DjFFP2Gkke20tWh+7H68gr3IO7EG8ysFrDCfRep5TMxiX1+SCVaQ8V2oI55hdExIbGHMlV9RxMLafHqcPNHcjpb2jiLpr4m7qCiuPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667860; c=relaxed/simple;
	bh=x4U5AbInp9itkMmuDAdcS6wO5TFV3xN+oCldgwKkfA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyKgqfgDaKbihBpn69YB8uWkDePCZLBSASFUlkt8EGxAY1m6HuBr8ezzOpdmLhf4m7DrVSbiB8yclm6RLDuRxlO5B5Ik2mqEWQln36NswfI7TnRO+w42lwfl0Th7EwVeXbJOJRVISYuJelNL8DWE9o858FxxmBhcbGjI73aJQnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iT53Qu6o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iT53Qu6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1167F1F00A3A;
	Tue, 21 Jul 2026 21:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667856;
	bh=eYmRlWRp5GHCwuTbpaQbjliku18GULq5cYuFq5mqZ4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iT53Qu6oH/rWNMSZcDCeBvftABBShMhnaJAxp8qxoG1B16eueg8uE/XRZayTs/4II
	 IiX7Ctp4pLKfPpliGh4NM2YRlxDfj0QyHr/SyshLzJNC20pggtDGteqZF4QMlsx+Gl
	 PCzb88tmtp+9ECiLvf0FpoKrMC1LquO84/XSn9cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6df204b70bf3261691c5@syzkaller.appspotmail.com,
	syzbot+e76bf3d19b85350571ac@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1219/1266] hfs/hfsplus: fix u32 overflow in check_and_correct_requested_length
Date: Tue, 21 Jul 2026 17:27:36 +0200
Message-ID: <20260721152509.080848901@linuxfoundation.org>
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

[ Upstream commit 966cb76fb2857a4242cab6ea2ea17acf818a3da7 ]

check_and_correct_requested_length() compares (off + len) against
node_size using u32 arithmetic.  When the caller passes a large len
value (e.g. from an underflowed subtraction in hfs_brec_remove()),
off + len can wrap past 2^32 and produce a small result, causing the
bounds check to pass when it should fail.

For example, with off=14 and len=0xFFFFFFF2 (underflowed from
data_off - keyoffset - size in hfs_brec_remove), off + len wraps to 6,
which is less than a typical node_size of 512, so the check passes and
the subsequent memmove reads ~4GB past the node buffer.

Fix this by widening the addition to u64 before comparing against
node_size.  This prevents the u32 wrap while keeping the logic
straightforward.

Reported-by: syzbot+6df204b70bf3261691c5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6df204b70bf3261691c5
Tested-by: syzbot+6df204b70bf3261691c5@syzkaller.appspotmail.com
Reported-by: syzbot+e76bf3d19b85350571ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e76bf3d19b85350571ac
Tested-by: syzbot+e76bf3d19b85350571ac@syzkaller.appspotmail.com
Fixes: a431930c9bac ("hfs: fix slab-out-of-bounds in hfs_bnode_read()")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260505111300.3592757-2-tristmd@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfs/bnode.c          |    2 +-
 fs/hfsplus/hfsplus_fs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -41,7 +41,7 @@ u32 check_and_correct_requested_length(s
 
 	node_size = node->tree->node_size;
 
-	if ((off + len) > node_size) {
+	if ((u64)off + len > node_size) {
 		u32 new_len = node_size - off;
 
 		pr_err("requested length has been corrected: "
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -613,7 +613,7 @@ u32 check_and_correct_requested_length(s
 
 	node_size = node->tree->node_size;
 
-	if ((off + len) > node_size) {
+	if ((u64)off + len > node_size) {
 		u32 new_len = node_size - off;
 
 		pr_err("requested length has been corrected: "


