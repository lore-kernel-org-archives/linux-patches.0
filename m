Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04E31C695;
	Thu,  2 Jul 2026 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011308; cv=none; b=SYqIBhpQz6ThdKRgTMZwbf7R2Xw17WoAuxfjTDu0Mwm9zKEc943xv6WS06l6g7RL6uOiM1y8CUY8R6W3wSAtT7sEG11glMdbo7Ow/3UXWgsiRF8I5iTHpKqvFXDAD2/37mtRjS8uzbJnL1J7JvrNFzJGGz+sI0OulXNsqmknIOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011308; c=relaxed/simple;
	bh=gLMWIIpu0bq6XZffRdAyjSGUQduMYRhkjsbLVyzkFrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZVdbZPNgtqJJ0qLOxsdL4xGWSt/bh7+vyEJw8egH6oKYCPiCAmkEc+H0GMDLYMswXwlouEYMV8vOEzzVjWPIJtqjNKDWJBEuTAw3F6J+T7fuvJTLQuu4Q3ykJWBCRuIoCdscSl561uwGxEusvht49CUzrw5RE8Y9kS0639iMhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPj/vuuF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPj/vuuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B3D1F000E9;
	Thu,  2 Jul 2026 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011307;
	bh=P0xbvNB580ggDpwxjS/ajbpJKqdbJF09w/VJF/Kd5K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPj/vuuFrqc3tv3CM3bZQcKfqkHUtjlU0+EQiMF9wd1bt9D1gnPkA6pmoTvJR3NP1
	 Fae9uXfMHWDhbhqS+TYnxamfEArtZmjt2ignUgeiRlrMzMHVfXKFH9G9HLzmZTkiEt
	 3rKlwXQuaP7Gfi4fvWtLbikY8B4UzeLclOXlaTzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 060/108] f2fs: pass correct iostat type for single node writes
Date: Thu,  2 Jul 2026 18:20:57 +0200
Message-ID: <20260702155113.351025228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

commit fcb05c26c2a67953b420739b85f49386efc9b6c0 upstream.

f2fs_write_single_node_folio() takes an io_type argument, but still
passes FS_GC_NODE_IO to __write_node_folio() unconditionally.

This was harmless while the helper was only used by
f2fs_move_node_folio(), whose caller passes FS_GC_NODE_IO. However,
commit fe9b8b30b971 ("f2fs: fix inline data not being written to disk
in writeback path") made f2fs_inline_data_fiemap() call the helper with
FS_NODE_IO for FIEMAP_FLAG_SYNC.

Honor the caller supplied io_type so inline-data FIEMAP sync writeback is
accounted as normal node IO instead of GC node IO, while the GC path
continues to pass FS_GC_NODE_IO explicitly.

Cc: stable@kernel.org
Fixes: fe9b8b30b971 ("f2fs: fix inline data not being written to disk in writeback path")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1853,7 +1853,7 @@ int f2fs_write_single_node_folio(struct
 	}
 
 	if (!__write_node_folio(node_folio, false, false, NULL,
-				&wbc, false, FS_GC_NODE_IO, NULL))
+				&wbc, false, io_type, NULL))
 		err = -EAGAIN;
 	goto release_folio;
 out_folio:


