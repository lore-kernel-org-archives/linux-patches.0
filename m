Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C5339FEA;
	Fri, 24 Nov 2023 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+Butf8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7C1C433C8;
	Fri, 24 Nov 2023 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849354;
	bh=FOocsZtqORf81cYrBN/K7cxWbWdwO1J9/TALWdvxP6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+Butf8gSoPoGV0z29U0FYduSAhD3ByJWKrxQ4eFAcc3v2hwFszm/RYvMnmhw6oh9
	 iIKPYMSMWLpTKQv813HmCUTRnJcrZlBqsnab+BSShp46j0X4IWrlT37/rQHxfH3Q9u
	 icuVIl/K7RcKSxx9h53menVTaAcBICY6u2Q3nLpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+29c47e9e51895928698c@syzkaller.appspotmail.com,
	Juntong Deng <juntong.deng@outlook.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/530] gfs2: Fix slab-use-after-free in gfs2_qd_dealloc
Date: Fri, 24 Nov 2023 17:45:14 +0000
Message-ID: <20231124172032.599347695@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Juntong Deng <juntong.deng@outlook.com>

[ Upstream commit bdcb8aa434c6d36b5c215d02a9ef07551be25a37 ]

In gfs2_put_super(), whether withdrawn or not, the quota should
be cleaned up by gfs2_quota_cleanup().

Otherwise, struct gfs2_sbd will be freed before gfs2_qd_dealloc (rcu
callback) has run for all gfs2_quota_data objects, resulting in
use-after-free.

Also, gfs2_destroy_threads() and gfs2_quota_cleanup() is already called
by gfs2_make_fs_ro(), so in gfs2_put_super(), after calling
gfs2_make_fs_ro(), there is no need to call them again.

Reported-by: syzbot+29c47e9e51895928698c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=29c47e9e51895928698c
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 0dd5641990b90..5f4ebe279aaae 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -602,13 +602,15 @@ static void gfs2_put_super(struct super_block *sb)
 	}
 	spin_unlock(&sdp->sd_jindex_spin);
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly(sb))
 		gfs2_make_fs_ro(sdp);
-	}
-	if (gfs2_withdrawn(sdp)) {
-		gfs2_destroy_threads(sdp);
+	else {
+		if (gfs2_withdrawn(sdp))
+			gfs2_destroy_threads(sdp);
+
 		gfs2_quota_cleanup(sdp);
 	}
+
 	WARN_ON(gfs2_withdrawing(sdp));
 
 	/*  At this point, we're through modifying the disk  */
-- 
2.42.0



