Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F070E51A73A;
	Wed, 30 Sep 2026 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790729; cv=none; b=DmirakysMNl67XWc9Bw3w/dEqkU/WPMHAn8z2Xca8hPI4W0X4/Yv6zHzfhOYtErM4/EhxWOt6K1HN0mlA4V1s3IWfV9i2AFLajFhFF/2OsIZMlARGfHhC0AFK/RJIG+zzDiEe2ZK9PqfF5uhezILdMsmExtTQFC0/NpfpYmsc94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790729; c=relaxed/simple;
	bh=ncWI1msMqJjyqVd3Phz2KnL/C55livpvsKwFDbYU7MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ihs4l/fUln8evjkAzOIW3vI2BVlqQgoiBTnmJeh4LmWFMicXAv7laEgYfAXQlL8zwdQTatTjXmL5z0G7HsSNGVah0jAaIpPF1xHswwnaaAEbS+fuRi9GJg56h8HUIH9PFE4P2c98TzaYqH6j5kqgx1VjflTxVxf6RVdVPSUthNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3wK+cUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3wK+cUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B1C1F000FF;
	Wed, 30 Sep 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790727;
	bh=WvD6LIVzOJWyJrqRX8ZcWoHpW5ka7n/KvaZ4AGJKG8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3wK+cUliL2iL7IvtWvtPdVuRrqsQyFARUQWWT40mI7OvP2K+3U4mrvkbTHRvSWfI
	 qF6rYIzaSwdapTgpbuAXAD7QKGe9zwb91fVHrcRM537VvQXtd+hc3mINhqT5dCPSAm
	 HkbhIZY1hXq1c/zsrUsAW3N5eIW5mQO/GQWaP2mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/752] jfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:43 +0200
Message-ID: <20260930152359.303429575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 05107f5602751fcfd3d108c1f579eb45aabead52 ]

jfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-5-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 9030aeaf0f886..d5f0b21b5f03b 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -529,7 +529,8 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	/*
 	 * Initialize blocksize to 4K.
 	 */
-	sb_set_blocksize(sb, PSIZE);
+	if (!sb_set_blocksize(sb, PSIZE))
+		goto out_unload;
 
 	/*
 	 * Set method vectors.
-- 
2.53.0



