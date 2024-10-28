Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C4C2AF07;
	Mon, 28 Oct 2024 06:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098222; cv=none; b=Dgjt2ozi+7C7a+NN3DvCGYEEnywnhZh3w8PItBPki8VBOfM7zi4ru/bNeOSp2rZ6A+mcdu+h0bWITtskBZrFtM8RIEovebw3McLzEgfmmuF9QJB9Cv76W/gI6qUxa8LwVnTMX2zAmSwk1QhLvtBU306oft/7sauq+Fmmxvj1dzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098222; c=relaxed/simple;
	bh=2adRbBkWn+2e8Rlhhw7fh65RDkLDSxRV3FRmcevKoec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MY0QSJyuhvdSN7nxNiWEqaAhW5HMN+h5FFOgubQgwLa8sBV5d6/SwIV8xeZWKrO3z3be24ky0pPIt3Jm8EO7/gXZaRIZrhkDWaa0AoR8RcaWuagFJrrk1H/t+BkP/Cke1+uGfG691VFucg/j81wCmN84/a++e/okdgxkU57odJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUnD8ust; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUnD8ust"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE10C4CEC3;
	Mon, 28 Oct 2024 06:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098222;
	bh=2adRbBkWn+2e8Rlhhw7fh65RDkLDSxRV3FRmcevKoec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wUnD8usthRKFcFU1EOwSfRO+OnzEhMtEXu74PbGZ4lF7Un5gloRGTozT+pkzjSU8/
	 qzuD0rRWtoFre+E5Xd5Y/MaH0kP0wgwkk/CV7XiXddf8RpvSAufiZlF+RCXanYg4jf
	 61R2XjZYfbT9Wcj/xDvTuBHlhC1V8QVGrUhKAyp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.com>,
	Gianfranco Trad <gianf.trad@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 130/261] udf: fix uninit-value use in udf_get_fileshortad
Date: Mon, 28 Oct 2024 07:24:32 +0100
Message-ID: <20241028062315.296380430@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianfranco Trad <gianf.trad@gmail.com>

[ Upstream commit 264db9d666ad9a35075cc9ed9ec09d021580fbb1 ]

Check for overflow when computing alen in udf_current_aext to mitigate
later uninit-value use in udf_get_fileshortad KMSAN bug[1].
After applying the patch reproducer did not trigger any issue[2].

[1] https://syzkaller.appspot.com/bug?extid=8901c4560b7ab5c2f9df
[2] https://syzkaller.appspot.com/x/log.txt?x=10242227980000

Reported-by: syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8901c4560b7ab5c2f9df
Tested-by: syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com
Suggested-by: Jan Kara <jack@suse.com>
Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240925074613.8475-3-gianf.trad@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 80dae442ecd72..53511c726d575 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2257,12 +2257,15 @@ int udf_current_aext(struct inode *inode, struct extent_position *epos,
 		alen = udf_file_entry_alloc_offset(inode) +
 							iinfo->i_lenAlloc;
 	} else {
+		struct allocExtDesc *header =
+			(struct allocExtDesc *)epos->bh->b_data;
+
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
-		alen = sizeof(struct allocExtDesc) +
-			le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->
-							lengthAllocDescs);
+		if (check_add_overflow(sizeof(struct allocExtDesc),
+				le32_to_cpu(header->lengthAllocDescs), &alen))
+			return -1;
 	}
 
 	switch (iinfo->i_alloc_type) {
-- 
2.43.0



