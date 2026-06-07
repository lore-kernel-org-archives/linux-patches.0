Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D764A285CAE;
	Sun,  7 Jun 2026 10:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827103; cv=none; b=Bya4LxhlQlzQnKnWwUKjiKBeMVlNyZa/YL08oLUxVgWeyymtCvh8JbZC9hcBk0hcU2aMmlOqF96cQ032WuJxrbaJfx2eCgNplhjUmAXQwlm4eRyfxtGUBL1N5K6pM2Ft9buFqhZRJCQupjYvjStk21uRkHLeIZnCXGPG8SrIQ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827103; c=relaxed/simple;
	bh=e5BtVyWX9kLBaI+tBJ8d8ZDSFkSPR3+2EJMkAmJgp54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4nth+0cEDAKCy90yFAboD3+yMPkmauggstV0e4sKwRMFGcuzEXJzzDM5luU2gzwurnb7FvIt5+YwQ5oUdpNj+ZfBxoYwMdLFhttLe8414wEKZVHF9etKMEeJ4rvvJQ43NaADDj6MhKYVHAVPXB2tCp4kY0YLh43g66tA2pMUdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLgEteYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLgEteYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2788B1F00898;
	Sun,  7 Jun 2026 10:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827102;
	bh=JNwRqtCc/Fy0lucfpdeVEq1DCoYHWX0v1UWlKaCL6JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLgEteYs6tpHOzpnSsBv9ZHpkdDtrQZ+3ubIPR+YzojIaSqROnHC3XN4yroRA4LaQ
	 cGigqFK5dCY7x+tz8V90r4DVsu4tnY9FGrccp4zXLTmybMHmHk9LE9eEcPEmdJNGkt
	 eeqO69ed9nv1VoRXaHNz665tfvrYV5IyLBgO+N/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/315] ethtool: rss: fix falsely ignoring indir table updates
Date: Sun,  7 Jun 2026 11:57:07 +0200
Message-ID: <20260607095729.027688125@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8d60141a32875248ef71d49c9920fa5e2aa40b29 ]

rss_set_prep_indir() compares the new indirection table against the
current one to determine whether any update is needed. The memcmp
call passes data->indir_size as the length argument, but indir_size
is the number of u32 entries, not the byte count.

Fixes: c0ae03588bbb ("ethtool: rss: initial RSS_SET (indirection table handling)")
Link: https://patch.msgid.link/20260522230647.1705600-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 688c0e4bba69db..4877655f724419 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -684,7 +684,7 @@ rss_set_prep_indir(struct net_device *dev, struct genl_info *info,
 				ethtool_rxfh_indir_default(i, num_rx_rings);
 	}
 
-	*mod |= memcmp(rxfh->indir, data->indir_table, data->indir_size);
+	*mod |= memcmp(rxfh->indir, data->indir_table, alloc_size);
 
 	return 0;
 
-- 
2.53.0



