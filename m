Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3053546C8;
	Wed, 20 May 2026 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299241; cv=none; b=U9I2/qGcvtHmuOZp2CSYBWhxbaAYPlL8lVk/0FT20imTpmSIaYzAUg4/npAbbRuh+x988ZuVBoUpUqBDoonINfG0k+MgSv+4OowQk/ulMvzh509Q7X6rAMRViyUBSI6XXTWDH9h23NTZeGS6DLBvWdY/ay0zrnXLGaDgwkBMieQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299241; c=relaxed/simple;
	bh=ecZWy2ABmoB58WgdpwNrd+u1fRRJfSVM8aXFcx9HhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsINYJYC9Epz3+XBgOvefTTm+qOfbCXXzFAh7YDPLLjxnrDYCAQNwh8BV+Ke9XC4N4BEa/vNecHG1kwP+v/uFKNPKpLJvlKv2I5y2yNxc/q9wO9mMuSKY4G+hNRp1zQ08/3M8AgxX3FqKVWSKAGrKam+AQdBYk4FBu0M3Z078jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBwcou0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBwcou0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3108D1F000E9;
	Wed, 20 May 2026 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299240;
	bh=5DjJ1dgirjKyFIuKfvo9K5MfA9Bb/jWY1f9WQabrrtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBwcou0AIvheiMmMaB/qHbbvoin07v06WwSTuA5JKZDuISj/Lc2LEtfIkbqjtjR+Z
	 IIhyzUyYLeWT9LU+MoPIEbARw+KY1SOt9r55xC5v9Winh1jGRNVboaXTOOwL7ifPLT
	 9luvQw7/Ylx/23Vdc5+TICxMft/v/s59uVDvxlNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 717/957] eventpoll: use hlist_is_singular_node() in __ep_remove()
Date: Wed, 20 May 2026 18:20:00 +0200
Message-ID: <20260520162150.097560015@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a8e30414d996c..23602de08fed2 100644
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



