Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808D91A0712;
	Thu, 15 Aug 2024 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731776; cv=none; b=DYkrwNom39lC60CZlQ6kV/JS8j7mkd+pDdtsjb248cvfEcxzbQlJA5bx2vOcuP4Wx34N3fMY9uEJ+IrBppDK5u/M9lKLBMuBjaxHX6aed5HsBXimG/xDd/iZqJGSJLBlxP7wS9N325vGDnsSr/lfqRYifxC6W1X8bNdmInV+xh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731776; c=relaxed/simple;
	bh=yWacTcBgDeFodIvbBDbg+fWCTQMxGTRMXoukIsRrPpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ettxX2sPx5SEWHAnAD2ahZwQUK/tLqdF5r5R8iOZUyVLIl66s+/hWVtDdfBX9pLYiEZOwVsjZauWRybg/4YBgbSHK60OXusCXB+Yjnfo05p91u4j1Ot74+ykYXYSSBxDbRhIjVI1G9oZ1U8m1flgBm9ygImllcuRMgU+gYYwik8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trT+cWx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trT+cWx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92952C32786;
	Thu, 15 Aug 2024 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731776;
	bh=yWacTcBgDeFodIvbBDbg+fWCTQMxGTRMXoukIsRrPpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trT+cWx7DtiVeug4A4W1dxTjVm2zczEf23kjW2hXgOIFTLoQdZXbQ3Z8kH4lJ3AFO
	 DjDYFUVPd4suaYIVR8e41yQYcBpXTkO9ZTMv+CgzAt3135ECsxNFXRb6vyUxgHwBqq
	 HlxS5iX742kDFkh8ORfAud8HNIGF8ZvqYWKtxzks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/259] jbd2: avoid memleak in jbd2_journal_write_metadata_buffer
Date: Thu, 15 Aug 2024 15:25:37 +0200
Message-ID: <20240815131910.651046115@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit cc102aa24638b90e04364d64e4f58a1fa91a1976 ]

The new_bh is from alloc_buffer_head, we should call free_buffer_head to
free it in error case.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240514112438.1269037-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 81bd7b29a10b6..cfa21c29f3123 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -408,6 +408,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		if (!tmp) {
 			brelse(new_bh);
+			free_buffer_head(new_bh);
 			return -ENOMEM;
 		}
 		jbd_lock_bh_state(bh_in);
-- 
2.43.0



