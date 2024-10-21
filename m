Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4945A1F472E;
	Mon, 21 Oct 2024 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507301; cv=none; b=V2iLDxTqQxkMDGIHwx3Ynk+yiiq+3WBlU4E+yvAvelDZaIdaWKecoF7/2NVB81uTd32WrdbJ00wqDW/xF4IPTtrbLMFos8/Il2rUW0Z2WNIA7d56xI5hxNqBqu8VYTiSBFHlknCZ7FZoFsKcUgmflJICSpZqG23OHDUTzEPfNJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507301; c=relaxed/simple;
	bh=hsjPfk90fLfS9Tjd5gEA5YptzFBHerY7aWjbwS4OjXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hywPiNg3r3GuqA8G9rTsECFAJBqO/7gmmTwJnW4M9gQOly9gb/0+atMGKBcQ19foAXJfYETyLVi/wm+/1StIqGHe96mS7rPdvxunJTMc7Rb0c3S8vT6xB1Zl2qUsB4s+almjlkb/pdAXGxUX0bFSt/mDZMgG4f7uhGa+LF23W8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2omc14a2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2omc14a2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD827C4CEC3;
	Mon, 21 Oct 2024 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507301;
	bh=hsjPfk90fLfS9Tjd5gEA5YptzFBHerY7aWjbwS4OjXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2omc14a2KLSHQTRk/whQ/DOtuNsdWw+OFJH8EYJJZE91ovDtQOVS+HOD17JfU2UFp
	 AXt8bQ6jpwi5dbfeHxy+H7DzJoYxQkDwtXWQUZSswnRNr04fbvAtbnNUnn83DYlC6v
	 e4hLJNBQ/sZY9HDz2qFeivCIsgRnqC8PEPb2VrNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 32/91] fat: fix uninitialized variable
Date: Mon, 21 Oct 2024 12:24:46 +0200
Message-ID: <20241021102251.079326176@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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
@@ -1037,7 +1037,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+			     __func__, new_i_pos);
 	}
 	goto out;
 }


