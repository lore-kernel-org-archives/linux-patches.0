Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D417A1F2B88;
	Tue, 25 Aug 2026 13:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666224; cv=none; b=ixbZcIILDo0nexID8iwGANfVysoOYgW0Ob6pCIn/GEzOJAZYz86rAq1/GfiadipmVu1Emuabw3TW4ZG/D0aS8IWEpb86I+V/u06YTCEu5HdH1zNE6pEKZ/5WVmZboE7jc9W79I4XZCKe4nkmh8ZWg9C5s+yaoYFKnHwsS61BSYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666224; c=relaxed/simple;
	bh=Laz2dWNBBqFXdIouGBti+lueBa1amD7CaK5CNGFCWIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jy/kwdFdXk0uGqIQ3n99PaqY79g3ByiXrXFMKNWFcZw69c5hPeX4BTtrX4mam2IKLyJk2fTfUcN3JLT/diQ4dAX5BtISWqW09+jVDhmL1MjXAbseiFtL/FccR5am4bfKhjct8K/smFlTR911wXuUFbwJ8VpuLcOC0XnxYPCTyQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8fDWXht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8fDWXht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E8C1F000E9;
	Tue, 25 Aug 2026 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666223;
	bh=nZU1RELV5LUVG3Gva5S/8ocnjjY5BPPpPLYiDaYZkR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8fDWXhthHF/1haxANt4EcIYQn+ikDkiUwYbz8jA7Wd7FtpCKZTP55Z6Zt0WMaBxs
	 iMg76i+AzFnYFHdwyCYs3OQj5lVrPGmh06mq1VxeJbHuFfIC8+0FggKrnMAskGjbxF
	 2KTkFDu3JZ/HHFQR3Kam0PvL19bRPmbLv4T9qN5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 08/76] ext4: clear error before retrying inode xattr space fallback
Date: Tue, 25 Aug 2026 15:26:01 +0200
Message-ID: <20260825132541.865941695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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
@@ -2790,6 +2790,7 @@ retry:
 		    s_min_extra_isize) {
 			tried_min_extra_isize++;
 			new_extra_isize = s_min_extra_isize;
+			error = 0;
 			goto retry;
 		}
 		goto cleanup;


