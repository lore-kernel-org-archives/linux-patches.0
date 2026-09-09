Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3A2566C53;
	Wed,  9 Sep 2026 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964273; cv=none; b=DxyiwXbFEnuNu+SKBE2PNGYbm27doCihc/2G5WXdv//RMxZkgkkNYSGSTw407N2wDRglaG8xmccw9StcuBAyeE3yKtSEAy1AbTa7U1IvV4U8fV6kppTppIzmLkifEpUF6xi4uBTbTLZb6/HyUA0HLRySkbnEMnASNo/f5Wt9S1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964273; c=relaxed/simple;
	bh=Zp6jhkdYRRTkEc/CbhfDZo64EpiXAfi5L1hnMWCn94Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z65s5X8C8wMl74kfOJ2Hk+6C6lseOlspfSTbLr8izXa/JlbEvP3SgVHPWox5Y7390L6dIhz56Pe0/HZ+y4QMPiyokn6BVB037Z1f0r1nuI6xiG8O8hz3TIdGvbU1J8iNUbvQ2L/N+SFWGm3ryW/Tw310Ed67e93ZW4jGxahJ1W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yS6N6bDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yS6N6bDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA451F00A3A;
	Wed,  9 Sep 2026 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964272;
	bh=T0UYo7kHP0Weh3NYyS52mb77wUcD9U4K/XlxjU5ZbDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yS6N6bDclpGCFy5IScwQMW9Quom/9HDRBnYPplletw8tTv6pI2vifbgSjS3yhQqef
	 obI9/q/jBErx8WUX6hr66b9iuTNdJFxn/HU7sGv8kJ5WySRqgCIZ4rj3oLxWoillwC
	 SX26pXDKA8P02vzIqqJQko59ZUj6UltoDdilOs40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 367/583] f2fs: fix to pass folio->index to f2fs_sanity_check_node_footer()
Date: Wed,  9 Sep 2026 15:40:52 +0200
Message-ID: <20260909134250.755886897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 7e188e9f9437ab47c3237d609f1b26348d6fea1a upstream.

Otherwise in f2fs_sanity_check_node_footer(), it will check the
same nid incorrectly.

Cc: stable@kernel.org
Fixes: 0a736109c9d2 ("f2fs: fix to do sanity check on node footer in __write_node_folio()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1767,7 +1767,7 @@ static bool __write_node_folio(struct fo
 	/* get old block addr of this node page */
 	nid = nid_of_node(folio);
 
-	if (f2fs_sanity_check_node_footer(sbi, folio, nid,
+	if (f2fs_sanity_check_node_footer(sbi, folio, folio->index,
 					NODE_TYPE_REGULAR, false)) {
 		f2fs_handle_critical_error(sbi, STOP_CP_REASON_CORRUPTED_NID);
 		goto redirty_out;


