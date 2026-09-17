Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368D3CC314;
	Thu, 17 Sep 2026 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666445; cv=none; b=XCrEiNzUR8DVSEe7CbShBdSDBudxqAe4pUz2KRXhhKL/z/xrMlO86CxejCtyOqJCiGHBzHgOQdsK8fKNNaroZrYYK2CnIr42DZuPLzsknT2Lk9pmCidHKXEqVHJbV2BfKO+swbN1EWTkcdplG69ZUaewLC8T8P9KeGOPJO//oSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666445; c=relaxed/simple;
	bh=A5xA8HwP1kgNMy4MZXSUYIkD9hfBpoe33NnUj98/Jg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAY2/bGzuP3LBzM0i4+mGvm8QKHQy8IqwW4yrIK8TcJjruJKhz8QcI9tVEi24VD3z1RR0e2F5lLhJ34uaFIfKO1Zp34RNEG00LSUL4yRNGwaQYOcMw149rh0ty5iLGMYbQaPra9UT4dsv8yPbcVbVDF6iRfyIqWOi9tLNQx3y1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpyBGdII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpyBGdII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744661F00893;
	Thu, 17 Sep 2026 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666444;
	bh=0gEeRKhqB2vi2WnhzpazY0o9Wm84J6MXWWg5bf7Xl6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpyBGdIIS07UGBmZv4/gMh63omdlrSfX4T/tQ6OGlTD+5Lhw4v2xNSxWI0P+S99hC
	 +pI4ZD90+EVmhrLaOAQs1bPsq4d4VgIwh6keS+yAD1btZP0ZQG23Q3PiPUZHPcYkx3
	 ROd0j6WofPLRXeFYp3OHSU0VJxDTRMKAc2jZQI7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 1022/1250] netfs: Fix uninitialized return value in netfs_unbuffered_write()
Date: Thu, 17 Sep 2026 16:13:37 +0100
Message-ID: <20260917151619.756100155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit f18e8774f4d3137fa0a5fb8ffa83d59a719666d8 upstream.

If preparation of the first subrequest fails,
netfs_unbuffered_write() exits its loop before ret is initialized. The
empty-iterator check can do the same.

For synchronous writes, netfs_unbuffered_write_iter_locked() may then
return an unrelated error instead of wreq->error. This is reachable
through CIFS if cifs_prepare_write() fails to reopen the file or obtain
credits.

Initialize ret to 0 so the caller returns wreq->error if no data was
written, or the number of bytes already written otherwise.

Found with Clang's -Wconditional-uninitialized.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-2-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/direct_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index c16fbad286a1..b04019097ab8 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -95,7 +95,7 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 {
 	struct netfs_io_subrequest *subreq = NULL;
 	struct netfs_io_stream *stream = &wreq->io_streams[0];
-	int ret;
+	int ret = 0;
 
 	_enter("%llx", wreq->len);
 
-- 
2.55.0



