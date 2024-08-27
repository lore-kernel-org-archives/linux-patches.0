Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F711C4601;
	Tue, 27 Aug 2024 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770413; cv=none; b=GbxwXU74AEao3tAa2rh50CFHWkpDWFEh1kHf9YsY1f/XZHqWgxiUSKzXJOp1x3IOpfYOxfFUPx3diobSF20FEtfxP/f/PKnVz1nURMv2+RQw4vMDxFZ3ozdUSgdBz8COdGReUmAeG2vtm0PQpiwX31HgGmtZYYBACPSnaHAmYto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770413; c=relaxed/simple;
	bh=4xByt+8LZcikY/OwOsViZ0MYbK9KCCg5qIt7cpd8gwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Umqvo+EFjOqUrajJo8/7RsykIROk6+JuR/ko2RYxoeSV23nSdaK7qSyl13LM70mwKOsgAOvfBrDarOabdNXa6pMeQnkOqTi00oR8NDAez6AgOtetO1bdcW7d7pswOwkMU/0WRXF4jzGsikAXMOCC8WZE4TatB29R5IYv11JheSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNW7HmMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNW7HmMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A92DC61053;
	Tue, 27 Aug 2024 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770412;
	bh=4xByt+8LZcikY/OwOsViZ0MYbK9KCCg5qIt7cpd8gwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNW7HmMyoKj2gkpRFNhuO6OG/CVG1+FZhLz7DEyMozpFvJMGcwTPLT44JLHFKGQKt
	 MaaZXSxPozuklMZy2GY+qSQJ4D0WP5971WrGAlI4Op1y0MAqgiQybxH2mNb7cLrFpG
	 hlJP3VL6AX/q+s4a2mXWSIZMeODlenynVHcc8JnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/341] btrfs: send: handle unexpected data in header buffer in begin_cmd()
Date: Tue, 27 Aug 2024 16:37:01 +0200
Message-ID: <20240827143850.643093209@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit e80e3f732cf53c64b0d811e1581470d67f6c3228 ]

Change BUG_ON to a proper error handling in the unlikely case of seeing
data when the command is started. This is supposed to be reset when the
command is finished (send_cmd, send_encoded_extent).

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 651f0865bb0df..b153f6a96fc8c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -777,7 +777,12 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
 	if (WARN_ON(!sctx->send_buf))
 		return -EINVAL;
 
-	BUG_ON(sctx->send_size);
+	if (unlikely(sctx->send_size != 0)) {
+		btrfs_err(sctx->send_root->fs_info,
+			  "send: command header buffer not empty cmd %d offset %llu",
+			  cmd, sctx->send_off);
+		return -EINVAL;
+	}
 
 	sctx->send_size += sizeof(*hdr);
 	hdr = (struct btrfs_cmd_header *)sctx->send_buf;
-- 
2.43.0



