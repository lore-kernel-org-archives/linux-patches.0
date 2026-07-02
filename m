Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9747022D7B9;
	Thu,  2 Jul 2026 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011594; cv=none; b=RqZIHwmU4yDb8brAEMMsNb1MqWgfcL9C5qO7HidqENBfsjEJl8555L5RhECvpW/dCYfRZhCyJWaeCfcWqL1QJ0Ptrirye8SPLnmAuXKz12gEH21F+D2aNoBzheg6I+GEw0Gvhn4amKQy41oaARnzTqJDSjIJpddLJDF7wnRNRFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011594; c=relaxed/simple;
	bh=4OGlcEaF4Ay0xtPxP8Cb1FWKL3piMa0fzN8zbeQLMHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVNWWQCHGfzB4P+WmIBitcaCtmvoDAklWGoZuZ/Iw2CugofiSndxSRrc7SxhUxbotn0uREZQ8J1C/NkWClFatbzrwQeENd3fnHdUDsx8UEIFSApU4gyBgaSbm8APaUM3y1dyAexlU60VoxHafHQBZ6wJY8f8U1FxaYDMW/fKvGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTiseI2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTiseI2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087D21F00A3A;
	Thu,  2 Jul 2026 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011593;
	bh=IjGmQub+g9kIu+GMTt8SpxXCdi0ffaFboxkOD4e6jrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTiseI2Cp/tyETzAHKGb4Sq3q4ktOJsCNzk4lhAMQlrdG7XqECkLjw5i+ioZRzgDd
	 YmlEMqYZTs5vScAFLmqU552kW63KlKBM+iP6NQF9o8KgJ1ngjaP3WdQKNjpQATSInB
	 Q29oQrkX6VRW/aRjBX7gc6Sw+w59WMMuAf1KKp0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.1 060/120] f2fs: pass correct iostat type for single node writes
Date: Thu,  2 Jul 2026 18:20:56 +0200
Message-ID: <20260702155114.204049359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1875,7 +1875,7 @@ int f2fs_write_single_node_folio(struct
 	}
 
 	if (!__write_node_folio(node_folio, false, false, NULL,
-				&wbc, false, FS_GC_NODE_IO, NULL))
+				&wbc, false, io_type, NULL))
 		err = -EAGAIN;
 	goto release_folio;
 out_folio:


