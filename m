Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F802C9D;
	Mon, 23 Jun 2025 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713687; cv=none; b=UCPey/cnfOCVpgnhnoqFUJzZEo+qbZfWxCUVMpYZH+PMXZ4dLONl5crtJCMIvYanwpABFjAXQvu1xyVBykW0BaAHV80PXmvJiTwXTS2UKELyAP9KknuJrexK7bGTRAFgOBl0mUJAf4xk0KNzF/0Dq0vlh4qJqT1ga+NFHC7xiOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713687; c=relaxed/simple;
	bh=16QAxp7TIsMOu+Zg3ZGJqsp8RM+8BjrPiXaUjJxsS/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqczS+Vc+V5nRRqu65aguhUL+1JOZJnPYoL7BOfIRJLDfvbwRiLyIQT0X1tsVhXvJ2CaKV/vJcJp5igFE7YvZg3CmS2id5gnQcBdlnem95MKhnSoRlKS4JW9a5nChj5GlOdoV2VPIAszBuXgpHTHRNVzS4tnifQwmbRX3RRASTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRKe4+nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRKe4+nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F40DC4CEEA;
	Mon, 23 Jun 2025 21:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713687;
	bh=16QAxp7TIsMOu+Zg3ZGJqsp8RM+8BjrPiXaUjJxsS/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRKe4+nb1lcX+SIT5D1eSRZILQ5srW44DnYhGTYejJxbTr2L3sJz9r0rXSDtmZ6gQ
	 txqyKDxdn2uEJPvyKtFiY2s5XidVTMUvBxBdQ9F6eUr6po6dMktjZt2xhOJRcUKU6j
	 GzuY3lTcGCxHjo1ll1R7aBTLQue62//GPzb67DaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/508] ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
Date: Mon, 23 Jun 2025 15:02:42 +0200
Message-ID: <20250623130648.175574616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit cdc3ed3035d0fe934aa1d9b78ce256752fd3bb7d ]

If ocfs2_finish_quota_recovery() exits due to an error before passing all
rc_list elements to ocfs2_recover_local_quota_file() then it can lead to a
memory leak as rc_list may still contain elements that have to be freed.

Release all memory allocated by ocfs2_add_recovery_chunk() using
ocfs2_free_quota_recovery() instead of kfree().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20250402065628.706359-2-m.masimov@mt-integration.ru
Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 0ca8975a1df47..c7bda48b5fb21 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -671,7 +671,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	kfree(rec);
+	ocfs2_free_quota_recovery(rec);
 	return status;
 }
 
-- 
2.39.5



