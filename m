Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DD73A1E80;
	Sat, 17 Oct 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254419; cv=none; b=JEKXV5iCKEWvyM3DWMQb3BXF4V4IfB81ZLWmsmIcEvGchGZgqqn6KSwEBng4g/P5PUr99yZClynZhUpmD+ZuewTJiV1tAbFOM3qVs5hBqwHU/1xUx/j2yW0GBLSgCOiPK9KTFybkGiJXMmvCVFuc8lg1IKjAnma2oUkIp1xmCRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254419; c=relaxed/simple;
	bh=42kAh5dN7VaaeYS979gG6N5f2p8wb3tISodnZ0n04Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdIdaZJ+0stkJ3bGGxrfoo8Jlx046A+81+8ZCovW7SYaYJyK0AtpK02G21Vf/EAYA83TTEQ9x3yOqZwqHD8pKII6BLVn3FVisJ0HKb+GRa+sAFkujlEGkq4bU3BLt92lOW7+1LbEfvLGfaAHnadm1eUIFN0KL3hXnQczTwjyW5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaJ/bVgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaJ/bVgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA231F000C4;
	Sat, 17 Oct 2026 16:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254418;
	bh=41m0fnSE36jdfUHrWyX7dJHSszbT53+329WCBbGLf44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaJ/bVgTXqfsqUS/4p4Gkh1XHg9e09iz8elbPnVgUMqPJ+JzfHDLF0TX7Ry1bnnV5
	 avFyMsECUt1w2mbMOIIM25o/kn04ogTBsB6Mi63huKyDw2Lu2sWGE8sYUwPadN8m8Z
	 i2XjGRziF+PLSL6Jwgj7ujnKZkF763DINXXUTLac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 441/869] netfs: Fix netfs_create_write_req() to handle async cache object creation
Date: Sat, 17 Oct 2026 17:54:42 +0200
Message-ID: <20261017160048.451213451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit dbd6f56d975b23241b7bbb11bb8f562af548a0aa ]

netfs_create_write_req() will skip caching if the fscache cookie is
disabled, but this is a problem because async cache object creation might
not have got far enough yet that has been enabled - thereby causing the
call to fscache_begin_write_operation() to be skipped.

Fix this by removing the checks on the cookie and delegating this to
fscache_begin_write_operation().

Fixes: 7b589a9b45ae ("netfs: Fix handling of USE_PGPRIV2 and WRITE_TO_CACHE flags")
Closes: https://sashiko.dev/#/patchset/20260624115737.2964520-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-3-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 57d3a6b73836b..8143f84e60b4b 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -105,7 +105,7 @@ struct netfs_io_request *netfs_create_write_req(struct address_space *mapping,
 	_enter("R=%x", wreq->debug_id);
 
 	ictx = netfs_inode(wreq->inode);
-	if (is_buffered && netfs_is_cache_enabled(ictx))
+	if (is_buffered)
 		fscache_begin_write_operation(&wreq->cache_resources, netfs_i_cookie(ictx));
 	if (rolling_buffer_init(&wreq->buffer, wreq->debug_id, ITER_SOURCE) < 0)
 		goto nomem;
-- 
2.53.0



