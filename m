Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9926F314D04;
	Wed,  3 Dec 2025 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776550; cv=none; b=fDzaN7Q4wjtfeCAMdx0nVkst4gnmSEaG8Stf6qwkK4aEkdFgIC8KjYsaE5M11cGnzSlGhV5mJitzq9KcvPiTePKXx3sDHwsiIw9SnGCmIAUk7qya9DCRso2stwZkStdkETzjI4b8kDa2Pg5iriICMePzSy7d5WSkTJTkBg2iZ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776550; c=relaxed/simple;
	bh=sXEFM1Bapz7VuHILneRm2q6a4CrTANymWvi8B9wE1Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGKJVZjr+SkDBkN5OIV/mT87hgr0R5L1zmcXcXoLe8vTStwjQMY8RkSIbbg6QTlFpKQ7E7ivxi1GYZ8gAM/m6t2Pe1Meim8iQlFl0hvi+mXFx9fWHbho+d0Nr+d4ZCK34urE5bQbRqTvJ3wDhCnCph3hQXA2K+y7NbwN/Zl/LS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eb/MxSQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eb/MxSQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DDEC4CEF5;
	Wed,  3 Dec 2025 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776549;
	bh=sXEFM1Bapz7VuHILneRm2q6a4CrTANymWvi8B9wE1Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eb/MxSQfhHoStN4axPXLQ9f9qCFwX/c6U4LcQ2vubGR5hMySxxkKiMpIMi9TUvPkN
	 dHv5MCcWe/E1KIf9uFRTP8qS2AE77OR8+tSj9+bFLX5DRp9GyXBaXxNY8NnxVV5F2i
	 EArkLSmkfiRQTOzo7RGWALwQzfaGSHWriMFYxBDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 217/300] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Wed,  3 Dec 2025 16:27:01 +0100
Message-ID: <20251203152408.662971011@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit f2c1f631630e01821fe4c3fdf6077bc7a8284f82 upstream.

sb_min_blocksize() may return 0. Check its return value to avoid
accessing the filesystem super block when sb->s_blocksize is 0.

Cc: stable@vger.kernel.org # v6.15
Fixes: 719c1e1829166d ("exfat: add super block operations")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Link: https://patch.msgid.link/20251104125009.2111925-3-yangyongpeng.storage@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -416,7 +416,10 @@ static int exfat_read_boot_sector(struct
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	/* set block size to read super block */
-	sb_min_blocksize(sb, 512);
+	if (!sb_min_blocksize(sb, 512)) {
+		exfat_err(sb, "unable to set blocksize");
+		return -EINVAL;
+	}
 
 	/* read boot sector */
 	sbi->boot_bh = sb_bread(sb, 0);


