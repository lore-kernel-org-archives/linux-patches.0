Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCD656C658;
	Wed,  9 Sep 2026 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962941; cv=none; b=EfBsfguJIcGz9PoPLwL0Xx7JPhMKobiZShNXnLiL8lUIUE86E1P9Y26ekr4WKf3yMPjWkQs9t4/i1kFZwNAPIAah06zq8BMALjwrpBVNT7z+eVceqfTDLjjEIhNUh2M/9ekwWi8azoJBqZDFwg1QxWHX5ileM2hllRvLIO93zZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962941; c=relaxed/simple;
	bh=Vkm1U6BNxtGYXkWXmO5E5BdErsnwka4FYjezf9x9Kl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoJJGbkhdSKSDxcp8JeIBao236hGN8EKVsEcj71MVtPg2vbVysdrVFaYmSeQR1o9vxRzhGmj/1NH+ps+azkGasC9Jw5ivD7Q/X5ET/73Loaa7gqQc+L9n7JPSxnT6bMAwtFmUX7OZYBJVAOZubecOCZxVXdyBpsxKx97NHLGGoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCTMH1/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCTMH1/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5711F00A3A;
	Wed,  9 Sep 2026 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962940;
	bh=DBwLzP9pEEstRCfuXMockAVBsSDow8C431uqkKoneKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCTMH1/z4klkO9jVwYvuNZyzL/9FMLdNtK4Vr081fOZQagjN7DAISi7GHCjigSSp8
	 MqyCps0JFzr1Ox4wQ2EeTeIjTN5ng+5SjsmlgKbRHFr00pdKAh+jboFHF5lil7IOhL
	 QS332TCDJiAIeR4C+aMKY6isadx+Xg8/quqr9fm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 465/556] f2fs: fix to off-by-one issue in f2fs_zero_post_eof_page()
Date: Wed,  9 Sep 2026 15:42:25 +0200
Message-ID: <20260909134246.916124197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit b2205d3cfd6c76fd5c5443ee9fdb498cfb0e1c66 upstream.

Otherwise, it will drop one more page after new_size which is not
necessary.

Cc: stable@kernel.org
Fixes: ba8dac350faf ("f2fs: fix to zero post-eof page")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -50,7 +50,7 @@ static void f2fs_zero_post_eof_page(stru
 	if (lock)
 		filemap_invalidate_lock(inode->i_mapping);
 	/* zero or drop pages only in range of [old_size, new_size] */
-	truncate_inode_pages_range(inode->i_mapping, old_size, new_size);
+	truncate_inode_pages_range(inode->i_mapping, old_size, new_size - 1);
 	if (lock)
 		filemap_invalidate_unlock(inode->i_mapping);
 }


