Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8FE1DE4E0;
	Thu, 28 May 2026 20:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000873; cv=none; b=j37Ud3Llc3rr1rSGP4jew5q3sJkRLcDokOkz3G6RIUyzjHcIgYaXQYl9kxWZhxsCPWTA2PiZIWa9KbVQX37Rrh0rnJFMtSw3moUu2+iW7iq2nNHIkbrK4B5hcN0o5wx+tH0FcbzLLNwjvYxw292KbUUzNiykniPdM161SGzgbKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000873; c=relaxed/simple;
	bh=eXP/LnqQkNCnPB+YiDHdd9JCYxpMJWl6Y0AfPN/xlEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8TPrOGUymBHjb0ZblIC5i1eJaiEYwU7seAshaK9wFO5hkNAchWOAtrYU8N6fohdQ5PeIUk5rIqL6xjkIQOHtS4A4fa38hIL3/cd939ZrB8PUndTgHICO6dxXFSrm8Sm2BM2e4NwIXEi1zu+KoyqEgUacR2167//eWtldLMxJbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aG1SiSY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aG1SiSY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7CB1F000E9;
	Thu, 28 May 2026 20:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000872;
	bh=y9UPzARbhc+9F/7kqQPQWD5rrX/9aUbr/2H9SbAdXY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aG1SiSY09YWdPzMFHtaF/rh4wApjE+wfqNF7DO9EtjKpg0jxEzu8hfTsOy5yKL0Cc
	 BWGei1vgse3pV9ZCeovOEwGah9h4Wv7lxLSEgdtMMe3HmCIB9Noo1FDDJgizYxgce7
	 emQNZV7ZdCMnIm6CJ7EGgrNXDSowftamG0sKTUnI=
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
Subject: [PATCH 6.12 198/272] netfs: Fix partial invalidation of streaming-write folio
Date: Thu, 28 May 2026 21:49:32 +0200
Message-ID: <20260528194634.802483022@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

[ Upstream commit 6d91acc7fb85d33ea58fca9b964a32a453937f4b ]

In netfs_invalidate_folio(), if the region of a partial invalidation
overlaps the front (but not all) of a dirty write cached in a streaming
write page (dirty, but not uptodate, with the dirty region tracked by a
netfs_folio struct), the function modifies the dirty region - but
incorrectly as it moves the region forward by setting the start to the
start, not the end, of the invalidation region.

Fix this by setting finfo->dirty_offset to the end of the invalidation
region (iend).

Fixes: cce6bfa6ca0e ("netfs: Fix trimming of streaming-write folios in netfs_inval_folio()")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-21-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 488a4b1914300..9672904232ad5 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -267,7 +267,7 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 				goto erase_completely;
 			/* Move the start of the data. */
 			finfo->dirty_len = fend - iend;
-			finfo->dirty_offset = offset;
+			finfo->dirty_offset = iend;
 			trace_netfs_folio(folio, netfs_folio_trace_invalidate_front);
 			return;
 		}
-- 
2.53.0



