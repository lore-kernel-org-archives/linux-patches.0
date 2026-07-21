Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C60352029;
	Tue, 21 Jul 2026 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670093; cv=none; b=KiQ4dm2l+TSjEyWbOyE6R1CUesLbk/6NDZaFOP5qkXlSWSYKaKJuFl+AH8dkQ4QtLwZOV9gdVeqnpJifUFuuJ9ElrvFL+XTziRN2hcEcL26wrpUiVYbMhD8alcdUpDNSllFXZUHcmocyRKf60oVgUtg+3htmVCAra46LxNlLkiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670093; c=relaxed/simple;
	bh=fbNTvMC6GLaLpVneA5Lyj+H/S9UmzhMynuqaFxP5+iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doXlz8WreiL/Smul290lEkUAq3ABuWLeGl8NTlGMbIkvHDwcWN3ZCWREPXcXklTOtdXXVaDA1aJX4EW4v7rDHG1ylo4gaSPdsIXGAidOWANwHp48oHkMzHKamtTpHyF5VFQs+jvNk6vd4Oul/aKI/qgnZOuPmPjUMowvVXU41K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBJJnihw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBJJnihw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFB91F000E9;
	Tue, 21 Jul 2026 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670092;
	bh=eXoC0/4V60yDLar/LO/O56sixSNeRJTy6YVrQKV/fNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBJJnihwJIMV4b+kKlgQir51xZHQOtL77cynfwVkjzX7asNdCeUYAjFmiSjoXcqL3
	 uQI4EREqHYDnyht2VUaH9JWR/4b8VFyhnrK7oVV06g4fF3kM5KW+b6l5xFSZIryNd2
	 4YaqL55aK5DM8u7uGCT/yLX+AZgOEWRLVthjind4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0803/1067] ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Tue, 21 Jul 2026 17:23:24 +0200
Message-ID: <20260721152442.525490391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 93c8c6ea90be9e9df8fe14048ad4e3caad0770a6 upstream.

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does not
fully initialize it.  This can lead to use of uninitialized bits during
quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Link: https://lore.kernel.org/20260418131048.1052507-1-tristmd@gmail.com
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(stru
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;


