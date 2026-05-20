Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C683F4DFC;
	Wed, 20 May 2026 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296610; cv=none; b=ijZ3qUkW72M65MX4rQiZufANV2/IdNXi73hZ8i7LZkKWUvsXhMrElbOQZk0fZM70GwbvdKe1DlgC9MV1SKqPg43RsLmuX2S8EKspx3BGFvi0hxrXcJJJhI52rsqvIvIpXqzAXy4EtKaAyOSUostBftKRm2/m138i26UjEKDtNpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296610; c=relaxed/simple;
	bh=V4tjfvU118CGXC7Nyk/4Lc23N/g2Z+nLKgO099FwFKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzlPhykqDsoRObSsG5ZHpIXILnc1MUH/uGTGFmPBqeN82fEtnvSLvZuaIAJs0eO8alGKWff1fmATjKMJ8zZeDOR/ayYOc/7KRcBYJGHG43M11KqPWSyrkdcI5g6gbJMDW/8gUCHl0zg1QEZD8O3faTGKXfxlkzZPDUAAFcDbsxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BF2VFELt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BF2VFELt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD1F1F000E9;
	Wed, 20 May 2026 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296609;
	bh=t/nIWMapKtH6dS25UqF9kYfZEE+5GOv9pDoYsx8R0Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BF2VFELtaH80ymuRe2r3K0NAzcYlZoIrczls06BM8MdFNE2uZhxhQKiZQYnUwbBN7
	 9zgD0c1EvZIT9wVIgFgVDuFKn5DvQz7LQ5eCSsEFkYju4Urt6KmKxQVzIyh/VOCpj5
	 lbC6NY1IlSgvSm6EZvKMVov150vchBaVafmv0YHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0862/1146] eventpoll: use hlist_is_singular_node() in __ep_remove()
Date: Wed, 20 May 2026 18:18:32 +0200
Message-ID: <20260520162207.747363156@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 3d9fd0abc94d8cd430cc7cd7d37ce5e5aae2cd2b ]

Replace the open-coded "epi is the only entry in file->f_ep" check
with hlist_is_singular_node(). Same semantics, and the helper avoids
the head-cacheline access in the common false case.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-1-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4b43bf41296d4..3f960473840a6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -856,7 +856,7 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 
 	to_free = NULL;
 	head = file->f_ep;
-	if (head->first == &epi->fllink && !epi->fllink.next) {
+	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
 		WRITE_ONCE(file->f_ep, NULL);
 		if (!is_file_epoll(file)) {
-- 
2.53.0



