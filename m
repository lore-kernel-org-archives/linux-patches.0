Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B2E1E0B84;
	Wed,  6 Nov 2024 13:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898793; cv=none; b=VfNf89xTakuAmVxlgTGcBY1sRnHCViugdW+Ope32fmZThSeL9nck5YbH+S0Kd9giu/r+mxhCGV9DDKoulfPlL+eSN8PflIaoAV9a6EN1C1B4FyzA3CfSqlMLcdl2lJsVWsBbwHItc4d6EX5ewipoooIJw5BT7y3xAB0P6ZsZdcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898793; c=relaxed/simple;
	bh=AEj7Y2/ikqS9eTLbR5QcCUt/emNtW+icxd8bMW4fpkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWKfMD3S6V8j0dSeJW6MdLypFf8GMafUcRui6Tg06zWyuIg0HciehWEinjKh6837XHhPPXJ7J9Qf0cOGAIETqb0vCNrxbbuEAW+QA/99RWCVKoqyH7nZ4Fq2s8mhHGQgO+EKO4Oud1Bq910W7qmpVsDOlF592tVJ8K/YniQ9BT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cydfHser; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cydfHser"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FF9C4CECD;
	Wed,  6 Nov 2024 13:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898793;
	bh=AEj7Y2/ikqS9eTLbR5QcCUt/emNtW+icxd8bMW4fpkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cydfHserk4TuafJfVCBccgvkIbg4JeSxJF7xS71fcltI2Uyb1QVqGwRaITOIzO05K
	 hk48VHRna9qpCKPGy6IZM5KSHtNEEyOgWkxZlqTOyGoERYS7MS1vdKJmgY4WItwQ8o
	 ka/nI4kuCBnrzyMTZC+noiTRL1DmwjrDGbyLGl5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 358/462] fat: fix uninitialized variable
Date: Wed,  6 Nov 2024 13:04:11 +0100
Message-ID: <20241106120340.373740812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 963a7f4d3b90ee195b895ca06b95757fcba02d1a upstream.

syszbot produced this with a corrupted fs image.  In theory, however an IO
error would trigger this also.

This affects just an error report, so should not be a serious error.

Link: https://lkml.kernel.org/r/87r08wjsnh.fsf@mail.parknet.co.jp
Link: https://lkml.kernel.org/r/66ff2c95.050a0220.49194.03e9.GAE@google.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fat/namei_vfat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1019,7 +1019,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+			     __func__, new_i_pos);
 	}
 	goto out;
 }


