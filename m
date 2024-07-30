Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C221A617E;
	Tue, 30 Jul 2024 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356471; cv=none; b=ltipCexs4Bw9RL1SPZQdfW4N912VA3BwPc6PSetnhLzS7/wRR12HQ3pCkJdBFFBAjKK5Oy5DLaNh61cP/VvLxtwDgat6ogdKQIUpa3SM1bGmWItS4GNN4Xvfi0KYYKEafc4LP7DI9zfa1277br+7+UzZMYtPGqKIjYrrZk01CIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356471; c=relaxed/simple;
	bh=ekHbwnfq+iPpcBnREENs2OM2lWW/Kw6Wm2DdG9/N4Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEal0In2rfkAZjI5mrSPy3rRqbqDxyGBXTl9kTDrRoWmvmUym+mvMlZ7zumFvZFi3YMxjiaK/vs4Wrt+qintqRxQdfTaRHMg6KEOxWUVOOOoj7Ek+USc2VebOmAojaL/7figP0b693pCVgWTlw/uSAvWCWmZsEHBw971cVoLvm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4TeQC5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4TeQC5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E41AC32782;
	Tue, 30 Jul 2024 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356471;
	bh=ekHbwnfq+iPpcBnREENs2OM2lWW/Kw6Wm2DdG9/N4Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4TeQC5UMaDb5BhqVFjmw5Xqi8aO1g0Q60XjniDk7CmknYO8NmUH5su++tvO86Cdg
	 oeR2FpBr7//p8jYcFbBgqq0J5BhY2VFCfnSOuP9183ru1touruabIpj6YhIXVjN/1F
	 4whX5RGbP23ARQJwuaWebWk/mKjs/pMPwc5O2J/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31185aa54170f7fc1f5@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/568] udf: Fix bogus checksum computation in udf_rename()
Date: Tue, 30 Jul 2024 17:44:03 +0200
Message-ID: <20240730151645.190551901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index ae55ab8859b6d..605f182da42cb 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -874,8 +874,6 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (has_diriter) {
 		diriter.fi.icb.extLocation =
 					cpu_to_lelb(UDF_I(new_dir)->i_location);
-		udf_update_tag((char *)&diriter.fi,
-			       udf_dir_entry_len(&diriter.fi));
 		udf_fiiter_write_fi(&diriter, NULL);
 		udf_fiiter_release(&diriter);
 
-- 
2.43.0



