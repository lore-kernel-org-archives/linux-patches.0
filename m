Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87223191F93;
	Sat, 12 Sep 2026 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223220; cv=none; b=G3MWNGfzyrkEtA23YNmp0U5WTjBOWZwFgGCMOATMNKQ6hKx7jpOjtmeGSuDuhE77b6KrOIUwD8I/UV7dKZFsQXgnWVEyWaP+tSVnZ56qbUHsQ3HIohVNYQyzhbvFPm+h3+38AfHBBF0/sRxGFiFsEZK5qX1G0MwZX6a+6OFzkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223220; c=relaxed/simple;
	bh=OOs486A1H22IP/oxlAdUhoV/ns0UUZzNWkZ1nLLhUnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwRCZTTQz0B7jwYhUDpMSt5e1/nqZRkbP8w657CTloAYoweT1x2ZOJaE6X+EQzX/k/YwYGIYN6yECbRtihqS/ubWBRdSDrERYJ1J7zNB+kO/wvZ0NQa8ngVs+AtJyyBLr0dY83yapdOHzJQZyS4DslhNvcww7Eoe77TlHRoe8nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APndbhHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APndbhHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92211F000FF;
	Sat, 12 Sep 2026 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223219;
	bh=o7h8RBoCXDJfjqs/SBjJ+0O4jr0FSSEfsa1q4/l33cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APndbhHR4Ni8nzK5gR9ekYR57gfWQ4RgNiUA0/ZMR2o+UtuY14ECSdTWgQdmM0Fa+
	 6GIzb0lyYTW4BAwpTlBGOBlMujEJ4KM04XQTF1trg8/DWOFeWBsR/hUGfIQp0a5Sht
	 cqjNx3nb6fpdzsrQ//21QCPbCbxSA/DvsP6o+8Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com,
	Nirbhay Sharma <nirbhay.lkd@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0745/1424] fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list
Date: Sat, 12 Sep 2026 08:52:57 +0200
Message-ID: <20260912065623.981407979@linuxfoundation.org>
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

From: Nirbhay Sharma <nirbhay.lkd@gmail.com>

[ Upstream commit 5f33da04e6ceee849e76e6592cc283c72fef7af9 ]

The call to kmalloc() to allocate the attribute list buffer is given a
size of al_aligned(rs). This size can be larger than the data
subsequently copied into the buffer, leaving trailing bytes uninitialized.

This can trigger a KMSAN "uninit-value" warning if that memory is
later accessed.

Fix this by using kzalloc() instead, which ensures the entire
allocated buffer is zero-initialized, preventing the warning.

Reported-by: syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83c9dd5c0dcf6184fdbf
Signed-off-by: Nirbhay Sharma <nirbhay.lkd@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 7c4841e2a627 ("fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 09556c01cf610..776f7a9a7a828 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -824,7 +824,7 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	 * Skip estimating exact memory requirement.
 	 * Looks like one record_size is always enough.
 	 */
-	le = kmalloc(al_aligned(rs), GFP_NOFS);
+	le = kzalloc(al_aligned(rs), GFP_NOFS);
 	if (!le)
 		return -ENOMEM;
 
-- 
2.53.0



