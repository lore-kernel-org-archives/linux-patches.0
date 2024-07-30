Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1CB1552FE;
	Tue, 30 Jul 2024 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357007; cv=none; b=iAR9/WGObYWv/TuumNmJmZCI6HRKhYK4bIFIW4Ro/VJcPuRzdq5ZTOzKmBnXSpKDW+2OwsR/yCtzy3wjejOSzaGPDupdxX7nAnjC1ESYv0DTpYVKqYIe5A2Vt/b1F0yCpsinF2wDhHn3cxVMLHUS6NB60YRbiRIYlPgH8m5KiVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357007; c=relaxed/simple;
	bh=lWgh1GMR2TBsHM6JKgTtZQwFTurpjaS5KPJKyH7fLug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2RUtexcd2s0+l0nhHXCQNTUtGXHjpRhA0noYwTxJdndjSy+gAXjhl7360cVGfQjtMPMyVm4Z4mDvVCtY8Exue/JzYJgfaPf7Fg9SynBSjuEryM5eu+aYE8kW8xz8AG/rA0kk3dfBD6T5wkXY49qUAUpxpyCZBvRPjcHHWLTSB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s72Zreew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s72Zreew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8FCC32782;
	Tue, 30 Jul 2024 16:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357007;
	bh=lWgh1GMR2TBsHM6JKgTtZQwFTurpjaS5KPJKyH7fLug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s72Zreewwm6KpFCwmjXvegdfGizzRq0/c7fuYG51HM3W73/sAm/4gHviazeZc6aaF
	 1Jeyscoremq/TyD6TlyKiTUTQQ08reIYJVAdIE/t820CjqKLKbv/0NmR31IfIy6JEc
	 ILZ8H5OYRvJPv1X2+ijxhKfA4CgCouQhThqvbM24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31185aa54170f7fc1f5@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 200/809] udf: Fix bogus checksum computation in udf_rename()
Date: Tue, 30 Jul 2024 17:41:16 +0200
Message-ID: <20240730151732.506313272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 27ab33854873e6fb958cb074681a0107cc2ecc4c ]

Syzbot reports uninitialized memory access in udf_rename() when updating
checksum of '..' directory entry of a moved directory. This is indeed
true as we pass on-stack diriter.fi to the udf_update_tag() and because
that has only struct fileIdentDesc included in it and not the impUse or
name fields, the checksumming function is going to checksum random stack
contents beyond the end of the structure. This is actually harmless
because the following udf_fiiter_write_fi() will recompute the checksum
from on-disk buffers where everything is properly included. So all that
is needed is just removing the bogus calculation.

Fixes: e9109a92d2a9 ("udf: Convert udf_rename() to new directory iteration code")
Link: https://lore.kernel.org/all/000000000000cf405f060d8f75a9@google.com/T/
Link: https://patch.msgid.link/20240617154201.29512-1-jack@suse.cz
Reported-by: syzbot+d31185aa54170f7fc1f5@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 1308109fd42d9..78a603129dd58 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -876,8 +876,6 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (has_diriter) {
 		diriter.fi.icb.extLocation =
 					cpu_to_lelb(UDF_I(new_dir)->i_location);
-		udf_update_tag((char *)&diriter.fi,
-			       udf_dir_entry_len(&diriter.fi));
 		udf_fiiter_write_fi(&diriter, NULL);
 		udf_fiiter_release(&diriter);
 	}
-- 
2.43.0



