Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5B14FE2E6;
	Wed, 30 Sep 2026 16:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784249; cv=none; b=kOvdhY23dX6I6/zsRT9IPOMus+psv4DVsbgFZTu5WbDSyWOMo81XS2eGPxeH4kHm8V9PEk8rWCZnisQiEznJ/i/uMCl/oRTAJqmHBv6y9Hu6RIEvK6dEK2GDm8kmcc6YazMhgWMaj1SuTFWHF9eIrg8l0BgZ497gh27xKDzNXcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784249; c=relaxed/simple;
	bh=j2Kq/DgfVpcXnEeAfRy3rwK0r1naRO715DX0CTDl3Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXtxKYUl+tnTiQRp5I+r7spLg9C0FdpLk4Cgqseo9NNvYX+l4iw41616bGp7Z3qWM8qKNsz+NYKBQ8DNxuY8LTPxpMohdq7/bSRmUjA2aJs71/Q3t/X9tOv7cODyJhYkfTjye/3JVZcvOlJ5C7P9fQzSlLuF8ITroQLkESFa6Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M94aUq37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M94aUq37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23381F000FF;
	Wed, 30 Sep 2026 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784244;
	bh=kuAqpjrpLX2exLlJQEa9gF8Td6MM5MW9baK1wHm3VNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M94aUq37ITwSGtQNAzQgRU8b5tMOdwmUCB2zFiNkY8TSFASlpXe4KBWPiWuJvIR40
	 AifnEyMyZJI1SN9kC28LQRcINdj0wYqXsHlR8z3u7+MJ/DE47CmqKMi+kTGRnCftER
	 HIR93p3N42FR1tMVfokmnujzwX2FroZ+mxHLwQ9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anders Larsen <al@alarsen.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/982] qnx4: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:26 +0200
Message-ID: <20260930152418.306877973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c7d911ea1cc9a63b07e52f5e75b263be0615b289 ]

qnx4 uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-4-hch@lst.de
Acked-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/qnx4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 391ea402920d9..b921e56b36e68 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -195,7 +195,8 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 		return -ENOMEM;
 	s->s_fs_info = qs;
 
-	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
+	if (!sb_set_blocksize(s, QNX4_BLOCK_SIZE))
+		return -EINVAL;
 
 	s->s_op = &qnx4_sops;
 	s->s_magic = QNX4_SUPER_MAGIC;
-- 
2.53.0



