Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1CE12F379;
	Tue, 14 May 2024 10:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682384; cv=none; b=gZmZWUjviVJHJbeyAh7uuNLYo78YEMh+EocPfXzbDRoPIskhpKnoBuFphJwgcipnyErKcXY98VcKpr9N/WUF7fw6wIKCY8KpkVvVrrTeDnNhO7y86PVNYFMvl0DCR9KttIivSacE44RIuyks4XInB9ROz9NHEmLo/s7r2tsH0IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682384; c=relaxed/simple;
	bh=ZhE8GSioVYy/DZMI9leWLF7F8LlVQ8nvpEpnSmfsHsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uozlL8ozzgo9AkWmklIomRlWyKKbmtTPt2xDa3/3dpvq16hEcRbnVoUNjZ0eA17WZRjG1do3Q0e2o/UJKfeLFtzGl/lc+XcPqhWRVGD7gAe9RUdaFAhATIV9UMBIQFw6mUonACUpfPd64pRRLpXuCHWUqNXLKf0h/jQ12BMdrbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNtb2h6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNtb2h6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4806C2BD10;
	Tue, 14 May 2024 10:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682384;
	bh=ZhE8GSioVYy/DZMI9leWLF7F8LlVQ8nvpEpnSmfsHsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNtb2h6edMHxQtVfORQwR14VIqgLe5grCK2eIJlmTXHIuTkaZrKJ+R6sD7F1dMnTX
	 tMXZGdFPRmljS4g2hMLsUBzQ6CpOwNfpyVZXJNndXRvCZouUmrl9ZOGxx8RrINWr8q
	 +CLxMEC3oQ9n0+bcNknWxngnUdSh4OB2gdcchpQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <sfrench@samba.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfs@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 052/336] Fix a potential infinite loop in extract_user_to_sg()
Date: Tue, 14 May 2024 12:14:16 +0200
Message-ID: <20240514101040.570567087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6a30653b604aaad1bf0f2e74b068ceb8b6fc7aea ]

Fix extract_user_to_sg() so that it will break out of the loop if
iov_iter_extract_pages() returns 0 rather than looping around forever.

[Note that I've included two fixes lines as the function got moved to a
different file and renamed]

Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Fixes: f5f82cd18732 ("Move netfs_extract_iter_to_sg() to lib/scatterlist.c")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: netfs@lists.linux.dev
Link: https://lore.kernel.org/r/1967121.1714034372@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 68b45c82c37a6..7bc2220fea805 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1124,7 +1124,7 @@ static ssize_t extract_user_to_sg(struct iov_iter *iter,
 	do {
 		res = iov_iter_extract_pages(iter, &pages, maxsize, sg_max,
 					     extraction_flags, &off);
-		if (res < 0)
+		if (res <= 0)
 			goto failed;
 
 		len = res;
-- 
2.43.0



