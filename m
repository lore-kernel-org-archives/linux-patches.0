Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9A233F5BE;
	Thu, 28 May 2026 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999873; cv=none; b=nlc+PZe7xK6dBduZt8W/erh6VbLnLx2J9JFp3/+888TbYamFzU2Yrz4jKrcHj5+uZtcH4n3WC5ewzHVhucV4xDQwWMg+om72D/ndszaKrBJ0cJLpe7fW21owIJfrjQhltfKung2n0QiTeqAxCLe7g5VrcJevGbpxWFyXSgLUi1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999873; c=relaxed/simple;
	bh=zKfmAQMqZbX19PpShB27uX0FnzWfpLufeDbckc/a1vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R51WShiuvw8N1CpGsyabXYUUMOrM7kzxwo1gsy04Eik3U8MjL6Sa9PxlE/XqzNNF+yrYfBYQ/IT3oKknsEx/XgIIU3bXeA40tcdOl9p1SciH44+QrAOaj8NvbwW6BUUx6EaCsekxjyr1yfOrXyr0m1ncZbpTTBFEuonJWAV2oFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKBzUb2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKBzUb2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23AD1F000E9;
	Thu, 28 May 2026 20:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999872;
	bh=O43rqhar/ADmg1TYHh90jdRXrlzkvavKeUZV/1/GI00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKBzUb2F0aASf9j261Mnjm1nwAIwGNoWDMbetCArHXXBnbVTKMme84vd6a2xnEVKY
	 MoUrFyMmbnr7s8YT3W+Sd6Ko5OUyCtQgFDkHsW8xyNvTnBXVC9r2WTSNLi9W/vqihX
	 nkASXDp41HL3anSdgoDvQHs0IfulaMUR3STJTID4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyoung Jang <graypanda.inzag@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/377] fs/statmount: fix slab out-of-bounds write in statmount_mnt_idmap
Date: Thu, 28 May 2026 21:47:38 +0200
Message-ID: <20260528194644.764001402@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junyoung Jang <graypanda.inzag@gmail.com>

[ Upstream commit a3bf0f28d4ba16e1f35f8c983bb04426b87e2a78 ]

statmount_mnt_idmap() writes one mapping with seq_printf() and then
manually advances seq->count to include the NUL separator.

If seq_printf() overflows, seq_set_overflow() sets seq->count to
seq->size. The manual seq->count++ changes this to seq->size + 1.
seq_has_overflowed() then no longer detects the overflow. The corrupted
count returns to statmount_string(), which later executes:

    seq->buf[seq->count++] = '\0';

This causes a 1-byte NULL out-of-bounds write on the dynamically
allocated seq buffer.

Fix this by checking for overflow immediately after seq_printf().

Fixes: 37c4a9590e1e ("statmount: allow to retrieve idmappings")
Signed-off-by: Junyoung Jang <graypanda.inzag@gmail.com>
Link: https://patch.msgid.link/20260504112649.1862936-1-graypanda.inzag@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/mnt_idmapping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
index a37991fdb194d..3640230a4d43b 100644
--- a/fs/mnt_idmapping.c
+++ b/fs/mnt_idmapping.c
@@ -375,6 +375,8 @@ int statmount_mnt_idmap(struct mnt_idmap *idmap, struct seq_file *seq, bool uid_
 			continue;
 
 		seq_printf(seq, "%u %u %u", extent->first, lower, extent->count);
+		if (seq_has_overflowed(seq))
+			return -EAGAIN;
 
 		seq->count++; /* mappings are separated by \0 */
 		if (seq_has_overflowed(seq))
-- 
2.53.0



