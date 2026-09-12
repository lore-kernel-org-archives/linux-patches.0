Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE60023BD03;
	Sat, 12 Sep 2026 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225674; cv=none; b=YCf7nkET1lQaVgwkfUQ2UZWZDhgovgtEXGdXftfLhfPsD/oorjfBpZVHSjEq2UGzYcQZRlh6lLf40RfS21GngT3gN3RKc1V474er6QGZYWJq8Dc3eQ7VWsPy/VPUBkU07/2R3N4Knfj41WoyfuwpCCdF8zz69+BfE0gtKiSjXUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225674; c=relaxed/simple;
	bh=n79TElPMDDjxEVij88HFhnbTS5y6q8WjNG2Uhm4O6a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgCaaPw+gZ5ISupDzmGJ7MbRGLa3bSDFLSlUetv76sXuaqlVVEIViLY9i0RhnrMYDWVJ6sU131M72cH9F32LN2fflXpD5uXqE1DnHGNdSmkPuVWLVC+xKv5zbgN+/Fj2fUETWj3TwhDjcsvMghDVmiSm4ONJIKNKavU5dzcNmEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4n2u+XD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4n2u+XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D3F1F000FF;
	Sat, 12 Sep 2026 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225673;
	bh=4CUManz/JSD4JRfHgT43GLyDr7kTk5MftZnR6MqWJWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4n2u+XDgsnuw38OZwPfbQVw8oXKMGMTs9r+oVzjeMQwE0HIiEOl8wD0tq4G1lWH2
	 ZoHMuLMEA2XraNrBt+8jBKcfZG27vig+zCDk8ggHCq98ebHP6P03ty21y9EIAcy3am
	 Ag+9s4p2gUVt5qqGfkdl71I5S/s8BUXh0/qXPIPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1246/1424] ksmbd: Do not skip lock checks for single-byte ranges
Date: Sat, 12 Sep 2026 09:01:18 +0200
Message-ID: <20260912065635.186703829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit d40c24634fe077a0dc91fd11fccf44ce12b454d5 ]

check_lock_range() uses inclusive ranges. Its callers pass the end
offset as start + length - 1, so start == end represents a valid
single-byte range rather than an empty range.

The start == end shortcut therefore skips mandatory byte-range lock
checks for one-byte reads, writes, copychunk operations and one-byte
truncate ranges. A conflicting lock covering that byte is not checked
and the operation is allowed to proceed.

Remove the shortcut. The truncate size == inode->i_size case is already
handled by only calling check_lock_range() when the new size differs
from the current file size.

Fixes: 5d510ac31626 ("ksmbd: skip lock-range check on equal size to avoid size==0 underflow")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 69f807aff769c..d7c291bede3f8 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -333,9 +333,6 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
 	struct file_lock_context *ctx = locks_inode_context(file_inode(filp));
 	int error = 0;
 
-	if (start == end)
-		return 0;
-
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
-- 
2.53.0



