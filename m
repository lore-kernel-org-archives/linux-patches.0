Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B393F9F3C;
	Sat, 12 Sep 2026 09:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204465; cv=none; b=aNP0oWEUyY7M0tExDzVJypV+7awaDpxlQROnTUPlxg7yKTVcZ7R6mfn9TBMCU38LqTRL07QqJ1Vyevljkx8LEjL50NTBBjxL2CTbhuh6D+QRiDOzSNerCAh6huvqW/K/Rbf4wEGXmtT5aXQcHzuk+MRHWAEZUfZGN9ydbhc2tXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204465; c=relaxed/simple;
	bh=6V2CTTNMmsbP7yRkPzLPnnr7A0HNlbpfV0W2X/zQ2is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ4H2IVudrZ1o+CQwgPpT4moTmULoZcw8CyRy9geCxAmdw+wkdFFYwPN486VnNHdTptg6mEXwrHeRPrUoHFWGaz9Gs/lFWq08Rv+Qg2q2iJjWIDNR7ZIHQQ2KKZ4RxLPf06yhDaB11LWU3YSJqX3Fc6Gj4lziM77YUUv41SEgGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjmASvmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjmASvmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C0C1F000FF;
	Sat, 12 Sep 2026 09:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204463;
	bh=5SpWqvTrCCKvKboOApOOf3THauG5bkI0YZWH9oo+oPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjmASvmUyQ09vli0MGSbwkYX6msKbgvRDk8GJjgyMfxUj8LSJrqcG3mVs1nt+wpk6
	 VJHO7fCQl15t5QQRyj5Rmv72vLxWh1pSSq7HBGfQBWyr9Oua/9nhj1lPF2jdfJayRX
	 eJW4UjHw/POUg6lWdmuVq4dAgiu0iQXvpQP5qXSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1601/1815] ntfs: validate final EA attribute size
Date: Sat, 12 Sep 2026 08:55:51 +0200
Message-ID: <20260912065726.575043564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 650a2751c9ae179fe0d8e5b5194a2b1c0d09412c ]

A replacement first removes the existing EA record, then adds the
replacement.  Check the size of that final $EA stream before mutating
the current stream.

This avoids committing the shortened $EA stream or $EA_INFORMATION before
discovering that the replacement exceeds the AttrDef size limit.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 0cd192752b7cd..0eba3f41c7bb9 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -250,6 +250,14 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 			goto out;
 		}
 
+		/* Check the final $EA size before removing the old entry. */
+		if (val_size &&
+		    ntfs_attr_size_bounds_check(ni->vol, AT_EA,
+					ea_info_qsize - ea_size + new_ea_size)) {
+			err = -EFBIG;
+			goto out;
+		}
+
 		p_ea = (struct ea_attr *)(ea_buf + ea_off);
 
 		if (val_size &&
@@ -285,6 +293,12 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 			err = -ENODATA;
 			goto out;
 		}
+
+		if (ntfs_attr_size_bounds_check(ni->vol, AT_EA,
+					ea_info_qsize + new_ea_size)) {
+			err = -EFBIG;
+			goto out;
+		}
 	}
 	kvfree(ea_buf);
 
@@ -312,8 +326,7 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 	p_ea_info->ea_length = cpu_to_le16(ea_packed);
 	p_ea_info->ea_query_length = cpu_to_le32(ea_info_qsize + new_ea_size);
 
-	if (ea_packed > 0xffff ||
-	    ntfs_attr_size_bounds_check(ni->vol, AT_EA, new_ea_size)) {
+	if (ea_packed > 0xffff) {
 		err = -EFBIG;
 		goto out;
 	}
-- 
2.53.0



