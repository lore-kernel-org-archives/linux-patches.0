Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158E319AD5A;
	Tue, 16 Jul 2024 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145994; cv=none; b=tYrtlXXP8v0cfAtGbKa5hLnE7KvyebbZS4vYLmZT1EEKNglmR33zCsT7DUaNUd7RJUCFNJQ6GBn8IJgdvyGXnepf7uCHcQTozbmLUE790uhKEmx+MiALcOuJiuy/g3PUvDRM+vhlyM7jUGYZjiNRpHpmpc3VIk5+iTjdZP8w3UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145994; c=relaxed/simple;
	bh=FSIpt4wm6ISxImkLTwg0ZdSxk7SFT9WpMQUO8VLor7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeYA8DoV5m0oQ434g02Dw2bhUhqT+KTnI9ZOdD9vz5pbNxMxGBM9wXMfhkCfEDJdrZk4IQFlSRnYKkLKS+Q/HEnlG/79Xs2IvOoXHBCtA7Au2mFk6vKzOf+7IRR0psLfoJy3b5W9YBFedPriJTlPBrtROhdm8bklAjVM9sLL19E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRVPLt5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRVPLt5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6254DC116B1;
	Tue, 16 Jul 2024 16:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145994;
	bh=FSIpt4wm6ISxImkLTwg0ZdSxk7SFT9WpMQUO8VLor7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRVPLt5zZq1JphSa8Xb4T3yYKvZPNjY2qHD78svIk2pDOIEQ+Zk+73cJz6TeLKo1n
	 71NvIBi/h4qOx4/V54VIWNevg0KfCQFFtfgD9TPjODNtpdm3y1zsy3wNJEr9p2X7yw
	 pitQaNksvGyDDIkIxnr38dfofGzwMcOKTmxFNIeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/144] orangefs: fix out-of-bounds fsid access
Date: Tue, 16 Jul 2024 17:31:32 +0200
Message-ID: <20240716152753.425925006@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 53e4efa470d5fc6a96662d2d3322cfc925818517 ]

Arnd Bergmann sent a patch to fsdevel, he says:

"orangefs_statfs() copies two consecutive fields of the superblock into
the statfs structure, which triggers a warning from the string fortification
helpers"

Jan Kara suggested an alternate way to do the patch to make it more readable.

I ran both ideas through xfstests and both seem fine. This patch
is based on Jan Kara's suggestion.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 2f2e430461b21..b48aef43b51d5 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -200,7 +200,8 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		     (long)new_op->downcall.resp.statfs.files_avail);
 
 	buf->f_type = sb->s_magic;
-	memcpy(&buf->f_fsid, &ORANGEFS_SB(sb)->fs_id, sizeof(buf->f_fsid));
+	buf->f_fsid.val[0] = ORANGEFS_SB(sb)->fs_id;
+	buf->f_fsid.val[1] = ORANGEFS_SB(sb)->id;
 	buf->f_bsize = new_op->downcall.resp.statfs.block_size;
 	buf->f_namelen = ORANGEFS_NAME_MAX;
 
-- 
2.43.0



