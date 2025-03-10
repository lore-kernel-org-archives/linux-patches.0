Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B4122D799;
	Mon, 10 Mar 2025 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627625; cv=none; b=oMy0SJY01w+GRX/LeMeePt47dn8MUFvHuThcGsgJPrhAbjT0iPu9qyBPa92ERAY9+0TuNlhhVvlJB7NDqCsXE+QlB5c+QpBalRlBQm6yyxvUkL2osHlI/Kh+JdnaQVC1Kl8ZNJOJRgo4bt+3aDXCoTl2cD3svdZMgqgUpku7FoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627625; c=relaxed/simple;
	bh=Uy+GMTaz8xPiDzu7l7C+Y7qpwlxmVBd8iEDrVR8hEB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0344zbA6cOTveq0Rp8OfbFNPnZnP4lShNmHQj7i8S6s8WgXTnNP5DE+keTwFK1VOSK1Iv+YaFmNVxtqT00KOri1tTsF2u+I0X9ALO0DpUM0fgikBZkKYuKCYlBCc3pgKR8vQ6JvdnMdHve35nPYGHCa5YdGbwKV5ELfGN6TGrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEsb8gEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEsb8gEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4E2C4CEE5;
	Mon, 10 Mar 2025 17:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627625;
	bh=Uy+GMTaz8xPiDzu7l7C+Y7qpwlxmVBd8iEDrVR8hEB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEsb8gEjJf0xjeqJz6DhmhiOs9aia0QOLIPH+30xkPoDAaRBJw0o08RuCCq6bxDlO
	 qPdMBueths2xaw2MOzOO2Nt+VokNBsHYpqhYPgPFzExzS8biFxcxLYwLZws1ZFN39Y
	 FM987UfYgvCS0pOOU1vLisNpujeNQ/Ti6pPAhdPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/269] exfat: fix just enough dentries but allocate a new cluster to dir
Date: Mon, 10 Mar 2025 18:05:47 +0100
Message-ID: <20250310170505.433728870@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 6697f819a10b238ccf01998c3f203d65d8374696 ]

This commit fixes the condition for allocating cluster to parent
directory to avoid allocating new cluster to parent directory when
there are just enough empty directory entries at the end of the
parent directory.

Fixes: af02c72d0b62 ("exfat: convert exfat_find_empty_entry() to use dentry cache")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 337197ece5995..e47a5ddfc79b3 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -237,7 +237,7 @@ static int exfat_search_empty_slot(struct super_block *sb,
 		dentry = 0;
 	}
 
-	while (dentry + num_entries < total_entries &&
+	while (dentry + num_entries <= total_entries &&
 	       clu.dir != EXFAT_EOF_CLUSTER) {
 		i = dentry & (dentries_per_clu - 1);
 
-- 
2.39.5



