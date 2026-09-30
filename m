Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A851FCC1;
	Wed, 30 Sep 2026 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792688; cv=none; b=Qa8TMyP3jvrsjKxWyyVWBehSpddN0yWR9fwKR7gBkyLpcg7FiA+xedUfaTgqprt54nEmtOccVpcxtkshdTthgkk15KxJip974QPbHHltzo87IHVQo8NNjfclcjp9zigg+S/gv+6wf0SJD2jjzyzyteSur+KAI7qrTY6Bn+htu/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792688; c=relaxed/simple;
	bh=g4HIqiGGp8Z8+gMXprx8SyHdkUyfD7IQArIlK5XGy/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFTFS+3WYDenwhoXJNvMcJy085Sd8us52sfFRHurpoTf1hu8mpyFUfb4qrLfCXZ+2LP/qXTEsSZOE0hUNsVAstj99yJtfOzwehCdiyqweH5X5p4s/Upk0thLpeb10AWj0Tmwz5ZXuJjpuV7dUnN1M6f5FVtHkzBWBVQzPAlRcdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjbMw56c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjbMw56c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C2C1F000FF;
	Wed, 30 Sep 2026 18:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792687;
	bh=Zq3rB7KQrRPmOz8peSHH3TPAQt5Zasu0duPTnF5Aj0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjbMw56cw89Xp+Dqd7RCwekq9f56/PC6HT3qliBjTcv566wUNFmaUr7CG6liSVsB+
	 lNzE1GBHHY0NACBoIux8FNkqxVnrrIxVEuH+v2qThY25lKok+65XZ+Rc517biM4zpD
	 mKYukEFCvnpKgTeRlmtxATYtosm24eiXwD/2zD3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Wentao Guan <guanwentao@uniontech.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 741/752] eventpoll: use hlist_is_singular_node() in __ep_remove()
Date: Wed, 30 Sep 2026 17:30:11 +0200
Message-ID: <20260930152414.252707028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 605963b245b2c436803cbbefddf5ee5cb326ceaa)
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9e63923196fc5..4a39ed132c3db 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -738,7 +738,7 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 
 	to_free = NULL;
 	head = file->f_ep;
-	if (head->first == &epi->fllink && !epi->fllink.next) {
+	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
 		WRITE_ONCE(file->f_ep, NULL);
 		if (!is_file_epoll(file)) {
-- 
2.53.0



