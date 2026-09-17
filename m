Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB6E3783CC;
	Thu, 17 Sep 2026 16:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663862; cv=none; b=TAYGpOiqfWu3LuttR4saLm1qc8rhIBLH3HAUV0xqzi4E2iKznODwXQ0uIAuwU/50o8eTYaxb3vLOBXkeE0/6E3zt+M+dLgjSfrOTmw0LPJFF4y3GkNwdPe8t0qwcRHIfjysUNh6HoHmefHHSB2unJTUrulaEgbcbAvXMKQSHLNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663862; c=relaxed/simple;
	bh=UcjNO0eRN8QY0hSxMLNlbpW9yI0NmUK6OdtWRCwZh7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQHq4LmpCOmVkP5TyHVArApvLPjqbaPHxc9FhRPfcMRk9KQF/q5ms/OSQiTNLuD4y++QhdGu5rH8kCLOT8kyYZhwGGveDgWsdpt9GpdbrTBxawv/WKN7K7oBRELjF03nabgyVcsOJxct6jfgZZEkGQgLmZxsNOWMBjJELVKENBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha0DCzxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha0DCzxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5671F000FF;
	Thu, 17 Sep 2026 16:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663861;
	bh=jA7gx7gDD1ossLKN/O1u9wqdYnfO1uD+o5zq234QIhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ha0DCzxVQbeoApFwAHxGrG+ri10pBRKAZlTcgQX8rxrXRiP2IEqazESpPH2/MvLxO
	 Cq62a3e1WY+PikYDC9CfMO5E5KsQh2yWMYabtincRp3d8LrYuGzXe2pkh8Zpt50by1
	 XUmfAwbhC1ZML7vwWgvpC9SdjWMCIov0UHCoKgic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0180/1250] jfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:35 +0100
Message-ID: <20260917151556.982925103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 3cfb86c5a36e8..20b66fb022244 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -491,7 +491,8 @@ static int jfs_fill_super(struct super_block *sb, struct fs_context *fc)
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



