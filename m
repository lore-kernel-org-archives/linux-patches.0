Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC4630E82E;
	Thu, 28 May 2026 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998699; cv=none; b=HzRRxPXSj8K0YkKFgfvAwY9g4z75n0uVp7nGVqq8porPen3uOQXJsLZ+16WssGWYAjDZ/oNXZ52IdE469VHEansI6DAzXTrsA0Ukku9Cx/cJm2JqQTnuiyIqt38/IHebTWvUA9uq7haQTCEbY7krw3MzC+eXt0cEhmnXFWXtF3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998699; c=relaxed/simple;
	bh=IM+KN85peL13/2oE+MqsuNXf43qErU9ASxBYt4GliJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjX7Ix0qwah6aVWUz/bdukuDMwCpiffCj0h130CYkKgv4/nz0JvKNb/GD8U9i+qvUSuI94hTu906XlQ6Ssc6hX01OkVW+dPy9C/7AnIeySGxxvSxHm8cpDyVIsjOnxBAsG5X9EI2XoOfQ3A3YgkaqAAHeJM+VvyPM6TLaaW65Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mokFNMzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mokFNMzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2A01F000E9;
	Thu, 28 May 2026 20:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998698;
	bh=90qPoAZYnF7Z7YMpeC/MfSBe1lQ7HJhP7wW6gPoZ2OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mokFNMzusfO2JM2FKOkoQk6NpUsxDWLLMD7m33mM4XRzDC668R7ksS/dsejTnszyr
	 51Zz6rgeXT65OacwTsJIRWFdZs5SVsEdp5IeeIaN1a4jo+kKI1cqjcHLE3JpEF4vGa
	 nxbXu5F20GxlJ/6stdOckBuVtZPmiX/6A6n3Lm+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 265/461] netfs: Fix leak of request in netfs_write_begin() error handling
Date: Thu, 28 May 2026 21:46:34 +0200
Message-ID: <20260528194654.835468684@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5046a34f0643441f05b0253ea64e1a3af87efe14 ]

Fix netfs_write_begin() to not leak our ref on the request in the event
that we get an error from netfs_wait_for_read().

Fixes: 4090b31422a6 ("netfs: Add a function to consolidate beginning a read")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-19-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index e7ad511e494cc..004d426c02b41 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -687,9 +687,9 @@ int netfs_write_begin(struct netfs_inode *ctx,
 
 	netfs_read_to_pagecache(rreq, NULL);
 	ret = netfs_wait_for_read(rreq);
+	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	if (ret < 0)
 		goto error;
-	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 
 have_folio:
 	ret = folio_wait_private_2_killable(folio);
-- 
2.53.0



