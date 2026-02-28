Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48045379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301923; cv=none; b=gTcnpkocJj6XWmRvQ1kaInahY/8mnFeswaDAOl6xUVi0RHzGMq9TQ75VIesOVFjc6u9I2NtKVgLVOlaDz1ycf9ss3Niyw8/0QT2EYhgWVbl6MOX5IcFyawzTKUtbrY2hG7vheaXpX/7EbDToV2dprj9I1Dr3X5SWfIwVwS2vsYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301923; c=relaxed/simple;
	bh=YgcqZTjjgYuEQxfF6CilW98Z77ePfvOf922XEaM7c2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCJtF/K8MraMjHL1HWmEYXvJCY/Vi4jBy1ZrezM6qnW48NWjRROJjl71XtdxivC24ZQP9mdXUYjvdCEa6iT8HgTF+NsEn40IcgHG7E7XVpQWqooleKK9z2gyx0sEoWsmJXtVIQNSMuMdGL7uI3O+tD3+3HFh+Kz682ni3kegXik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFfpZYQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFfpZYQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0B6C116D0;
	Sat, 28 Feb 2026 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301923;
	bh=YgcqZTjjgYuEQxfF6CilW98Z77ePfvOf922XEaM7c2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFfpZYQjudW5m3snVQ0IvzzM6sjLc3r7k9+Sb1MMN+n5lJCixSxjwPs0wPiDkpezf
	 NS0eEDHygUyVI151XFEUitWukkmiw+XtWYQUPDPKB/r7JyCuRbOATaEJfCmb+CFzen
	 w5n42gBh5JnF/hIs+GlcGQTRpjeNmy559cRivSlaT0qmatb1DRyMe7PU1svjUi+TfA
	 WnD/WSZbcccSA5k5aJp7IVzGgtbHEGx1AA3lDfF2yZlyVvqMUhYNdcpTE5u/I9KQKL
	 OCoh8C7sgC4hmwXiRZ3q+q7+BIWkFoR1P29sqf9A0NZ3t2rt3/ypmIleY21CDbHLn3
	 zmjtw8O0hiFlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/385] fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
Date: Sat, 28 Feb 2026 12:59:39 -0500
Message-ID: <20260228180011.1568201-357-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit b2bc7c44ed1779fc9eaab9a186db0f0d01439622 ]

In the 'DeleteIndexEntryRoot' case of the 'do_action' function, the
entry size ('esize') is retrieved from the log record without adequate
bounds checking.

Specifically, the code calculates the end of the entry ('e2') using:
    e2 = Add2Ptr(e1, esize);

It then calculates the size for memmove using 'PtrOffset(e2, ...)',
which subtracts the end pointer from the buffer limit. If 'esize' is
maliciously large, 'e2' exceeds the used buffer size. This results in
a negative offset which, when cast to size_t for memmove, interprets
as a massive unsigned integer, leading to a heap buffer overflow.

This commit adds a check to ensure that the entry size ('esize') strictly
fits within the remaining used space of the index header before performing
memory operations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index d0d530f4e2b95..5afe00972924c 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3431,6 +3431,9 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		e1 = Add2Ptr(attr, le16_to_cpu(lrh->attr_off));
 		esize = le16_to_cpu(e1->size);
+		if (PtrOffset(e1, Add2Ptr(hdr, used)) < esize)
+			goto dirty_vol;
+
 		e2 = Add2Ptr(e1, esize);
 
 		memmove(e1, e2, PtrOffset(e2, Add2Ptr(hdr, used)));
-- 
2.51.0

