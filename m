Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6A147A885;
	Tue, 25 Aug 2026 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664611; cv=none; b=Fl/2ep22wodRqgtanZiyCxzxj0C9sptHIHV3F0kRvLAaKdfY4fzC+aqrOBK5tUCcWFnR3az3mzx/VnVdSmuKM8lHix9RMl8z1hYsBVZAltcnG5wZs/7qrkmrTYRNlDJUwl57H0mifLg5sdvL8Ut+x0y38+E/YF+PZRpRiNYunnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664611; c=relaxed/simple;
	bh=l0jNzFMsKGyqPc2dsQVUgzCvU102v4ajmPg+FJduDKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmR84RyBDaiFpGvqycf0ee7yeHIBRZ+7QI3LA3Ba8qZIVtUgR1GF0v1BdsQ4+ZlAFe9pbAJjPI0aqHjiGeqse9sPIklEqIa/JfrV+kRFcGFAhz4qtm9FSzgNMAnAAmFORuSWqM4FmX2JjuTAjt6VaVBfvC+yAhOhn/X69zSOuQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3DNhiIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3DNhiIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C9A1F000E9;
	Tue, 25 Aug 2026 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664608;
	bh=WPR9CTuK0YZX+6vMtjJxTw7Kpv9FkP7qVZDa7g/XFSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3DNhiIJjp5XEA6Gkrjb0bAPwOe8SJmprDkTbY8veDw//PK0nVH7KXpBTETaNNVRA
	 2z1FX04g1xartFaq/WTzAWnZtZlamRkVQllQMhOSBJHgIQ1Bw4f867FwOkFZUC9PHo
	 pgix296C65z/cnV1dhd9tL4AEZQgxA+XrMHJgAKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.2 27/82] ext4: clear error before retrying inode xattr space fallback
Date: Tue, 25 Aug 2026 15:25:14 +0200
Message-ID: <20260825132542.572801055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

commit 409a7f12a0933ff2c617fa814c76cef0bd1d457a upstream.

When ext4_xattr_make_inode_space() returns -ENOSPC,
ext4_expand_extra_isize_ea() can retry the expansion with
s_min_extra_isize.  If that retry succeeds by finding enough ibody free
space, control jumps directly to the shift label.

The previous -ENOSPC is still stored in error in that path, so the
function can update i_extra_isize but still return -ENOSPC to the
caller.  Clear error before retrying so a successful fallback expansion
returns success.

Reproduced with an ext4 image using 1 KiB blocks, project quota support,
256-byte inodes, and min_extra_isize/want_extra_isize set to 32.
FS_IOC_FSSETXATTR failures dropped from 802 to 86 after the fix.

Fixes: 69f3a3039b0d ("ext4: introduce ITAIL helper")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/tencent_192F8A699EFD21126E02101131C9546F3C08@qq.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2841,6 +2841,7 @@ retry:
 		    s_min_extra_isize) {
 			tried_min_extra_isize++;
 			new_extra_isize = s_min_extra_isize;
+			error = 0;
 			goto retry;
 		}
 		goto cleanup;


