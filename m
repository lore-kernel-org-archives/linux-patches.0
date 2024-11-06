Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F99E18C00E;
	Wed,  6 Nov 2024 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896095; cv=none; b=LmbE0877wUj1leXr/o5zSUfE7MQRw//UAciitZEd8is45v2XCAc938edIk0X+5GlB4b2++0VmYnXb1NT1BmQb3/BNAz8rUZCHYn5CPMhPvqM78v8E1mwWz2xyZ6aRaKhNwVqB2Iss0UGQK3aI4DKSq+a7LnuU44pR2rIJVmTspg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896095; c=relaxed/simple;
	bh=7hBObZ2L52trQVD0htV3zSZ5OxzpzUeNUhYwIg5gOJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmTRdYDcEaRGrAZ+qjv6M2DQGwMWCRSjgk/CbOZo+DfL1kXMlZY4qb1oTkSE0LeawxyjZ4hiuhBlxBwuOI20hnrt1ownW5SGE4bzOoVEIQiP5axivlYmqaSqUCOQ0fwAXhX+asnjoA34NMxcCtHcm77Km9W6t51OEbJ7jKTbXxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OszJNiTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OszJNiTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A63C4CECD;
	Wed,  6 Nov 2024 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896095;
	bh=7hBObZ2L52trQVD0htV3zSZ5OxzpzUeNUhYwIg5gOJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OszJNiTqslZa+iK26zYqHfOH/ebiqwq21X6Jm46YKZIjLXvgltoDDdo/+cwdW21nl
	 lUv06hWebQSDdIyEFMX+HeOEb6+9vSHhBYoho64QXPp4T6s2Drb3Wkjn/XF7xuLKBC
	 bG8tYqxqcuSEUQGIjGc7Tr2rhU/3174V6c9F1rsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9af29acd8f27fbce94bc@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 089/245] fs/ntfs3: Fix general protection fault in run_is_mapped_full
Date: Wed,  6 Nov 2024 13:02:22 +0100
Message-ID: <20241106120321.399742920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a33fb016e49e37aafab18dc3c8314d6399cb4727 ]

Fixed deleating of a non-resident attribute in ntfs_create_inode()
rollback.

Reported-by: syzbot+9af29acd8f27fbce94bc@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 56b6c4c6f528f..4804eb9628bb2 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1717,7 +1717,10 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	attr = ni_find_attr(ni, NULL, NULL, ATTR_EA, NULL, 0, NULL, NULL);
 	if (attr && attr->non_res) {
 		/* Delete ATTR_EA, if non-resident. */
-		attr_set_size(ni, ATTR_EA, NULL, 0, NULL, 0, NULL, false, NULL);
+		struct runs_tree run;
+		run_init(&run);
+		attr_set_size(ni, ATTR_EA, NULL, 0, &run, 0, NULL, false, NULL);
+		run_close(&run);
 	}
 
 	if (rp_inserted)
-- 
2.43.0



