Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A7242D9B;
	Wed, 25 Feb 2026 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982846; cv=none; b=ObAOWwSpLz12YfJckrI+WeJ2T8Tki2jiG77rX38FBZeVf5NtT6B3Yvec57sVNZzuTzQnjn9yPdYgVjz0u+opycsKPgUviuPXPTA+j4+FaQ2Q+o5v4bgvPVkxfhHAxzMYfv8U2A3h13v+HUj7pW/I7RGmYG7gsjad/SVZH/2JJkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982846; c=relaxed/simple;
	bh=RGbCbpqPfk1bvEW77yVi1OAn4n8V9JfwDQZJ3KktTOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GisJmQQl4s0/VnbxahfREslFz9qfL6tIgSy5mQFknrx44jnqpcJTPyp9vhEFDrCXEqvOoGdvUjC6lofNUfeirntnyUUqIbZ2oD/EfcwhyA193aWa6wq4lOsNNKoU6TVcWofShOk/nA2X3kBt2ZrK/kWkRXaO62Jk91IHUi6xr8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkfRDhY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkfRDhY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B0BC116D0;
	Wed, 25 Feb 2026 01:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982846;
	bh=RGbCbpqPfk1bvEW77yVi1OAn4n8V9JfwDQZJ3KktTOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkfRDhY2x7q3D6CEg9Hr61Ikcmcla2WR5VWVozl6k3qfmEVhI7D/Bkom1eDfvxr4W
	 ytLsOOB4KH9Rx7HQyWsCe9ZNyFiwD46jqaF2jaSE/EZVNkJTIl7KFoMdi6WrWNuhgL
	 P6+bn5FFkxGRuAH3AtIOKVyOfSCA0ByTZfxfvTaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+046b605f01802054bff0@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 019/781] gfs2: Fix slab-use-after-free in qd_put
Date: Tue, 24 Feb 2026 17:12:08 -0800
Message-ID: <20260225012400.173411529@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 22150a7d401d9e9169b9b68e05bed95f7f49bf69 ]

Commit a475c5dd16e5 ("gfs2: Free quota data objects synchronously")
started freeing quota data objects during filesystem shutdown instead of
putting them back onto the LRU list, but it failed to remove these
objects from the LRU list, causing LRU list corruption.  This caused
use-after-free when the shrinker (gfs2_qd_shrink_scan) tried to access
already-freed objects on the LRU list.

Fix this by removing qd objects from the LRU list before freeing them in
qd_put().

Initial fix from Deepanshu Kartikey <kartikey406@gmail.com>.

Fixes: a475c5dd16e5 ("gfs2: Free quota data objects synchronously")
Reported-by: syzbot+046b605f01802054bff0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=046b605f01802054bff0
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b1692f12a602a..2b499b554e876 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -334,6 +334,7 @@ static void qd_put(struct gfs2_quota_data *qd)
 		lockref_mark_dead(&qd->qd_lockref);
 		spin_unlock(&qd->qd_lockref.lock);
 
+		list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
 		gfs2_qd_dispose(qd);
 		return;
 	}
-- 
2.51.0



