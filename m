Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADA1338F4F;
	Tue,  2 Sep 2025 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820556; cv=none; b=nyehNpWIr/hvws+WXh6Ai08Mzvog6wf7Az1wrb8Yp6wO8qyTTIV//Kci/xo3aSYBf/f5mBE2yOmODOKaT1qVIA9vz8tUS36QP7IPXTd+dzmWPp6jD06nmnBrottUG6I7NclpEqt2shfveutpY+Riyd78BR8bdDsuil0pYOYLnjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820556; c=relaxed/simple;
	bh=pu9YYuDigYkX4IahGK59nZKhiOg0pvRzGp7VcDPL4lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QS+Fk+x3yrCBiJFZnG0knayivki4v9+j3C06ckYp9M2ShEGC1KckDnxE5EzdO1Pm0l92ZlhZlOOTHzZfdZNk45qwlbPXNfvPPVkkHkQ39oDv+Gs5Sq6q0sWGpbaGhXu0IrYnC1M+VlmWdrORA3Cm7nmwDuS0PdhlZUXFIqXm5Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hl8BCLsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hl8BCLsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCD2C4CEF7;
	Tue,  2 Sep 2025 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820556;
	bh=pu9YYuDigYkX4IahGK59nZKhiOg0pvRzGp7VcDPL4lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hl8BCLswUlIPMOBpm21qI7M2W/Wug+YblOgJR1xT0PqOimg2zaQ/uDB2oT1CbHWiK
	 /crYrUp46m6U0TUHMtNZsz85aK3qj2CqbqGcqSHHMx1GmEN2vfmy50WXTCuWHN48/s
	 HFh64mV1W9h+aDfBHMn27S+DpV6Ff512lu3UNVSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 08/33] udf: Fix directory iteration for longer tail extents
Date: Tue,  2 Sep 2025 15:21:26 +0200
Message-ID: <20250902131927.378207870@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jan Kara <jack@suse.cz>

commit 1ea1cd11c72d1405a6b98440a9d5ea82dfa07166 upstream.

When directory's last extent has more that one block and its length is
not multiple of a block side, the code wrongly decided to move to the
next extent instead of processing the last partial block. This led to
directory corruption. Fix the rounding issue.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/directory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -171,7 +171,7 @@ static struct buffer_head *udf_fiiter_br
 static int udf_fiiter_advance_blk(struct udf_fileident_iter *iter)
 {
 	iter->loffset++;
-	if (iter->loffset < iter->elen >> iter->dir->i_blkbits)
+	if (iter->loffset < DIV_ROUND_UP(iter->elen, 1<<iter->dir->i_blkbits))
 		return 0;
 
 	iter->loffset = 0;


