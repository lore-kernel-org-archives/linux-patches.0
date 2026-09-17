Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476B64FB9C3;
	Thu, 17 Sep 2026 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658822; cv=none; b=X+vo2aTSXyAvQXpEF9NxsnDdWIflYccgFH+oYD4PhXYSPO4wIMqbUWwiJL3UmgOY5AQsPxWVZVQShQKYK9kuVafZ/wC6Z9Mj3UCa3zq407m/LesASb8ONxoQ7u+XwgBEAh1K/+YeusFuC94+uaOCzuDfa2u26yLRjIlG3fxSZmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658822; c=relaxed/simple;
	bh=HjoFK/Th/fRVberONkA7dQIQDm5JsdvLhzkWs6ymbHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EStafq54q+L086tjooVsKGNiSm1axL0mpI8h3o9+LWBLh+gi6wL5/x/dERJIMEKN82VbG2GNatbu6DooKED8MQFjfA41ZLwXuTPfgVG6/ii0Q6vTblUJ7sksIh8D22TxE14zbxA4lAyn6E1WSfONKUCXIAbEtQwDeNSzrLF9EZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyT+0LKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyT+0LKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F751F00893;
	Thu, 17 Sep 2026 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658808;
	bh=fdZ2KxW6cWoGbPhNVzPzybx9J7XiPp3aqp/xGB1NDVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyT+0LKcpUF3NQLtRiOkRVkD1toc2DMrPORD7Q/Ub9lMbQAzqoaYnAh0f2GxHkpem
	 LFxOXgJupQdElTBo8KV+aTCBn4babRyAORugZJBBLP7sFN03gkQ86sEAKLokTLrM2c
	 i4LBECekH5Zky8mA1j1jS+OeDvfn4TiOYH1kLkWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Tighe <dennis.tighe@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 047/733] ntfs: bound $AttrDef table walk to the loaded table size
Date: Thu, 17 Sep 2026 16:05:55 +0100
Message-ID: <20260917151351.946094736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Tighe <dennis.tighe@gmail.com>

[ Upstream commit c8504fc1245f5322af5fa5c325ab05f9cf792b87 ]

ntfs_attr_find_in_attrdef() walks the in-memory $AttrDef table, but the
loop condition bounds only the start of each entry, not the whole entry:

	for (ad = vol->attrdef; (u8 *)ad - (u8 *)vol->attrdef <
			vol->attrdef_size && ad->type; ++ad)

struct attr_def is 160 bytes; the guard reads ad->type at offset 128 and
the loop body reads further fields. vol->attrdef is kvzalloc(i_size),
where i_size is the on-disk $AttrDef data size, checked in
load_and_init_attrdef() only as 0 < i_size <= 0x7fffffff. A volume whose
$AttrDef data size is smaller than one entry (e.g. 120 bytes) makes the
read of ad->type run past the allocation. Creating a file reaches this
through ntfs_attr_size_bounds_check() and reads out of bounds:

  BUG: KASAN: slab-out-of-bounds in ntfs_attr_find_in_attrdef+0x66/0xa0
  Read of size 4 at addr ffff888005833280 by task init/1
   ntfs_attr_find_in_attrdef
   ntfs_attr_size_bounds_check
   ntfs_attr_can_be_non_resident
   ntfs_attr_add

Require the whole entry to lie within attrdef_size in the loop guard, and
reject at mount a $AttrDef too small to hold one attr_def entry.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dennis Tighe <dennis.tighe@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 4 ++--
 fs/ntfs/super.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 9e41ba97e024d..918ff4db75f73 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1732,8 +1732,8 @@ static struct attr_def *ntfs_attr_find_in_attrdef(const struct ntfs_volume *vol,
 	struct attr_def *ad;
 
 	WARN_ON(!type);
-	for (ad = vol->attrdef; (u8 *)ad - (u8 *)vol->attrdef <
-			vol->attrdef_size && ad->type; ++ad) {
+	for (ad = vol->attrdef; (u8 *)ad - (u8 *)vol->attrdef <=
+	     vol->attrdef_size - (s32)sizeof(*ad) && ad->type; ++ad) {
 		/* We have not found it yet, carry on searching. */
 		if (likely(le32_to_cpu(ad->type) < le32_to_cpu(type)))
 			continue;
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index d287140b3fc61..242f6f9b5598e 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1241,9 +1241,9 @@ static bool load_and_init_attrdef(struct ntfs_volume *vol)
 		goto failed;
 	}
 	NInoSetSparseDisabled(NTFS_I(ino));
-	/* The size of FILE_AttrDef must be above 0 and fit inside 31 bits. */
+	/* FILE_AttrDef must hold at least one entry and fit inside 31 bits. */
 	i_size = i_size_read(ino);
-	if (i_size <= 0 || i_size > 0x7fffffff)
+	if (i_size < (s64)sizeof(struct attr_def) || i_size > 0x7fffffff)
 		goto iput_failed;
 	vol->attrdef = kvzalloc(i_size, GFP_NOFS);
 	if (!vol->attrdef)
-- 
2.53.0



