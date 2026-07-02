Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2443438A6;
	Thu,  2 Jul 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010893; cv=none; b=axzRpcI97dfNHpNPaYtuE2/GNdnkUI7SinoQz4xnm19BNdxWQJbrTEHPJCABU9wA5mQ9L49tsbpBHtFIQlXYcLaHWx2GxZb1xu5ii0rpauB+uB5Oyb2q5vBpepJ3fgrb1dtoQPZ7kclIrTeG2XVcQCf69sBGS8Z3ixU+MOFRYLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010893; c=relaxed/simple;
	bh=bZcPNc+5Cm+4QpL3lBXdaTihk3BvwjHAkpOKYUKJem4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EudOxnEKSONO8nm6HY4uEUfGqej7BWUOYrorkDW5quOBdvE55C2JYumK+de+kSEO/ZMeXvGig9j2lYMQ9ib4Ngx6Vg1vDYuBvW4CKT8Z+p/RLTdQ/Tgasd9cjJYRzisY9Bau+X0YYRJVqsDc11F4fLlupvseD+MfGlqZijxDn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/9+dkxu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/9+dkxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F261F000E9;
	Thu,  2 Jul 2026 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010892;
	bh=dPiqUHLf0ymm74BL4hg+SGmX8zMa1dl+UeA81bFoJ3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/9+dkxudTrcwd+5Aei3tnTVy54CU0ylCNWeZJb0BqtmgLU4U5T5F9+C3IBC9xVIw
	 5zuScA9wMEOZPDkCdzQCHbaFWUvJmNDkWOq08gZRqNWOELVa87GCYDUUjcoCnWAGjk
	 az5a9PsqicV7bNygV6YcDiOUDRCwyeunuxOa522E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/175] eventpoll: use hlist_is_singular_node() in __ep_remove()
Date: Thu,  2 Jul 2026 18:19:37 +0200
Message-ID: <20260702155117.391018560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 3d9fd0abc94d8cd430cc7cd7d37ce5e5aae2cd2b ]

Replace the open-coded "epi is the only entry in file->f_ep" check
with hlist_is_singular_node(). Same semantics, and the helper avoids
the head-cacheline access in the common false case.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-1-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8a556560a5b2f2..4f05d12a05031a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -745,7 +745,7 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 
 	to_free = NULL;
 	head = file->f_ep;
-	if (head->first == &epi->fllink && !epi->fllink.next) {
+	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
 		WRITE_ONCE(file->f_ep, NULL);
 		if (!is_file_epoll(file)) {
-- 
2.53.0



