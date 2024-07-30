Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16CE1A618F;
	Tue, 30 Jul 2024 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356161; cv=none; b=uE5ap/7iO9/j0tSe/Tv/69vtaMKsOq5N887D/az4sov8TsiuYKu8joz1CexgPuhIQRYssQCTYE1qUoXCUmSUYZi2tQFMi/z7o9UAtDT2bJ4mAKkq3kQdREdoGjYpIPEPHt1455GgZ7zFHZyyl3QwMeE5/2rPJvxumKpfExhwEcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356161; c=relaxed/simple;
	bh=FX/0yMa8AkOGhfd7vaMw3oGxSkoDQLLyCOsrJ9ZVMJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXTqBu1Ro8+3KN1LnatHA1kVRUEOjoH3ubYj6dSN+lQNMGldy3RrEW7I0Y2GR1EG47EFrLCyocFHsR7BIa8V8YzHAeTEtP7I5ZZTRwC9rL3MpK9ydJnAJwwN3idRDjxVItzdHQ2qhVyqutytpC+lmMDtghnITR7Tza0UGnbAiqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEgxDexj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEgxDexj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CABC32782;
	Tue, 30 Jul 2024 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356161;
	bh=FX/0yMa8AkOGhfd7vaMw3oGxSkoDQLLyCOsrJ9ZVMJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEgxDexjXv7RJ3FMhuVCuuVFI6mpKR+auqiH8FP0MwYbfLuNrku/Q94KKsTyZLmw6
	 Csn4/PjnWHr2FxsJfAKySS3aKSX5jlwXx8msoP0kvzn3kAqaQZrH6L8tUbvaT90lPt
	 EBNLOsBEtENEhHRVeqaw+vgIUocC+uA4oIvqxEWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/440] ext4: fix infinite loop when replaying fast_commit
Date: Tue, 30 Jul 2024 17:46:37 +0200
Message-ID: <20240730151622.276997607@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

[ Upstream commit 907c3fe532253a6ef4eb9c4d67efb71fab58c706 ]

When doing fast_commit replay an infinite loop may occur due to an
uninitialized extent_status struct.  ext4_ext_determine_insert_hole() does
not detect the replay and calls ext4_es_find_extent_range(), which will
return immediately without initializing the 'es' variable.

Because 'es' contains garbage, an integer overflow may happen causing an
infinite loop in this function, easily reproducible using fstest generic/039.

This commit fixes this issue by unconditionally initializing the structure
in function ext4_es_find_extent_range().

Thanks to Zhang Yi, for figuring out the real problem!

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20240515082857.32730-1-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 470d29fb407a5..9766d3b21ca2e 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -312,6 +312,8 @@ void ext4_es_find_extent_range(struct inode *inode,
 			       ext4_lblk_t lblk, ext4_lblk_t end,
 			       struct extent_status *es)
 {
+	es->es_lblk = es->es_len = es->es_pblk = 0;
+
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return;
 
-- 
2.43.0



