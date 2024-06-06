Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA0819754D;
	Thu,  6 Jun 2024 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682985; cv=none; b=ADKODHcozysZ2TiPkYHXjn/xY59QDl9QAmxrrA8KWKJu/5SoP15h+hORpx943ixC/WQDhTX6cK7WZ8VpYjzQY/HvcuDM++tItLLTDY2HtVHB2V+6bACkajrQy1ztNhyMBJWCrXntp4cH8AVVz0sshCee8E49/2fvl9MC/Oc1K4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682985; c=relaxed/simple;
	bh=AHDTXa7FmOCs9kOuyysHEoWHPUI60v0dRgnURjjfkdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4HqMX65I34P9cJMxnYpP18zUU2bYe5QSwWF7J/XV/62NUFHLsmO06MEEvePHq651DMnamMHj3e6eRJREfDdw5glUWLMpnyI/2v/7PIjJUXG93q4UbsUxwwN2lpRI4M4FZdoD5I8p3acrxj8WyHAEsutVZABB/nUN1DnVtdnXhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKyktE8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKyktE8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6245FC32781;
	Thu,  6 Jun 2024 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682985;
	bh=AHDTXa7FmOCs9kOuyysHEoWHPUI60v0dRgnURjjfkdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKyktE8dJ5bBZLSFkLuXyo25cmEnuLaovv5gZNVBQVbl4h+BDRRQt1jXj6zr+4GVy
	 F3b0890JwLr5gB4DnA02i4dB1dyXHJceyMWbQqtySmNbvs0SXVE3/4mT6M5Mz6M/3L
	 eBquIsT7yVeXxnqi1912G0xCwNEOOlSigvFF467I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 171/374] fs/ntfs3: Use 64 bit variable to avoid 32 bit overflow
Date: Thu,  6 Jun 2024 16:02:30 +0200
Message-ID: <20240606131657.626863283@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e931f6b630ffb22d66caab202a52aa8cbb10c649 ]

For example, in the expression:
	vbo = 2 * vbo + skip

Fixes: b46acd6a6a627 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 855519713bf79..4085fe30bf481 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1184,7 +1184,8 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 static int log_read_rst(struct ntfs_log *log, bool first,
 			struct restart_info *info)
 {
-	u32 skip, vbo;
+	u32 skip;
+	u64 vbo;
 	struct RESTART_HDR *r_page = NULL;
 
 	/* Determine which restart area we are looking for. */
-- 
2.43.0



