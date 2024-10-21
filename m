Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97361EF086;
	Mon, 21 Oct 2024 10:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506885; cv=none; b=t3bOJwJxeYvbFH+Iv1/XtyS37pd5nOLsH3dAHWeWSr865Z+upxP/EWnZ0kTGwh8/s424n3bVYdBGRxF3NlFFdyX2gkckoc0z9ny6wynRBbhIByi+HBwlYyvlBAykZUb3PUh0HyTuZk4CzPygX99DrM/MKwNj9qVEcxaCxEqUzfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506885; c=relaxed/simple;
	bh=+zWLa8dwnYPOURvxvOLjSBLjQBDJ9V0Hm/DFsX7QlAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egM5DU09otg6c5rREpUNYpxPGpQVy6NFhzrIHarlVxdgEOoNCEZ8kj9Rhxc5ENmcMi7+qcg0lAt5cCmuV5st/M+54LAohhRiVHNPujTU7+K8Xyys2vwow4CKOLgCq8y2cQSMZc8FgEjrYZA8wzWKuvaIYdWXRGa/qN1eyMdwb9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8DltHFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8DltHFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234E3C4CEC7;
	Mon, 21 Oct 2024 10:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506884;
	bh=+zWLa8dwnYPOURvxvOLjSBLjQBDJ9V0Hm/DFsX7QlAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8DltHFrZP2aDKRv/JuDkXvI9yqKU78Yc16TPoTlQinuZkVplbDxHJiWeDrB7BpuF
	 F+BAFk2g4ComrHA7D4kHbfc1QOnigS0KCGrryi/Uy8SjrTy092LDkB6U/o9E+AlMM4
	 XOanb2FnTHEgRNKzPdInIAsAC0X7H23W9QdmwyzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 018/124] fat: fix uninitialized variable
Date: Mon, 21 Oct 2024 12:23:42 +0200
Message-ID: <20241021102257.428440446@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


