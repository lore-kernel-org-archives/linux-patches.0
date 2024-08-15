Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B801AC8AE;
	Thu, 15 Aug 2024 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730910; cv=none; b=ggRITfnne+KFjYePwf1wz7bi/KPmIt8GRiMFadU150FxKAuyERek+dFlsDAjR+5+LFOc4Q2Xn8+mUuMT06plfyFnZbt6L4a47GeKMkzIXv5iKcliR/3/g7IteTvp1waV4Zs572M9c5NV8EgY+atqfqmPtjV9LobjopTF9yD2tC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730910; c=relaxed/simple;
	bh=jIwXN2ibJiyLAK+Nka0JFM3vMCW4IkepeXpVEA1JRTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soBqld6k8cVsNt8sI204OxS9FWWsqJvIHL8dEPhJNxxUjzPPKl5nioTq8eawNx/gPPNkosnkOupvNBeKKpT1PIVT1Q7hJdOGDSRgqIJ9JJ5A5h4hkaxhxA+O+ba64xMHvERWs/xpwDJ5P5ThZHva8gKmKJZzEmXN8iDSTsvJbOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dn4hG9ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dn4hG9ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45935C4AF0D;
	Thu, 15 Aug 2024 14:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730910;
	bh=jIwXN2ibJiyLAK+Nka0JFM3vMCW4IkepeXpVEA1JRTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dn4hG9ry6OwHV6gi4ENA+o/pDjNNC+U8yWWbT2Hzs1PZLviXAeOBd2PJCzEWiMf+f
	 bS8LwHT0plaEPaEI6ZTcNpuiguRcqyFlJZ1Hl/+R5ToWqFyAI582vhjLK7oEqMYxWR
	 k/tHOpJJHNcjgeo0syb95E9TqeNi5aA+g0J70sUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b3b14fb9f8a14c5d0267@syzkaller.appspotmail.com
Subject: [PATCH 6.6 32/67] reiserfs: fix uninit-value in comp_keys
Date: Thu, 15 Aug 2024 15:25:46 +0200
Message-ID: <20240815131839.559446678@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit dd8f87f21dc3da2eaf46e7401173f935b90b13a8 ]

The cpu_key was not initialized in reiserfs_delete_solid_item(), which triggered
this issue.

Reported-and-tested-by:  <syzbot+b3b14fb9f8a14c5d0267@syzkaller.appspotmail.com>
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://lore.kernel.org/r/tencent_9EA7E746DE92DBC66049A62EDF6ED64CA706@qq.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/stree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 3676e02a0232a..4ab8cab6ea614 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1407,7 +1407,7 @@ void reiserfs_delete_solid_item(struct reiserfs_transaction_handle *th,
 	INITIALIZE_PATH(path);
 	int item_len = 0;
 	int tb_init = 0;
-	struct cpu_key cpu_key;
+	struct cpu_key cpu_key = {};
 	int retval;
 	int quota_cut_bytes = 0;
 
-- 
2.43.0



