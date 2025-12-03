Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5832C323;
	Wed,  3 Dec 2025 16:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778232; cv=none; b=TckGHS26cHCbuTN803iGNB/rEGgUGgklr1Asy/XOZnLMc9XKPSToNTzRjdV62eCaQbCari91Rg1LprlUTQZEG6Il/8hMiLgM0YWbxcrFvmywwXqj68q8BYcRw3XP6IZOaCdJjflzCsCEPkSl2JI9tS9fEJpR8mp5/+yCm5UHzzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778232; c=relaxed/simple;
	bh=6Ip/ZlKcANsA6pjogT9jq7P3JIzgxB0YC6BbxAiyv9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrBa/f8bDmMmxKFWXYnSEs5Qs3/24EYx/jRv+pv5pqEOe3SROfIpVKICGL6KswVsMf63oFmOcX08agsqT/sldfTLPM2/eSaU9grCq9yZiLBilIdojWV0F73i7frh3S51Z4Ru2EKPB9I9Bu+hInUkBj+THT9jE76izxRTASNFXmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xje1v5Ax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xje1v5Ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74001C4CEF5;
	Wed,  3 Dec 2025 16:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778231;
	bh=6Ip/ZlKcANsA6pjogT9jq7P3JIzgxB0YC6BbxAiyv9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xje1v5Ax6d1l8sof/D3Vxr2mjftYrfbWo+QvkGVzos4SvjGxgkeDG88yeqvT6MmA6
	 e21b8FQ/TbSXUNMEthMSEj0VN5XsLv86JE3Qled+tird5b/z6UO4tYETsYa+zI1RBr
	 jkEq3VjolDHWWAUr2BkNxYlUEUC4HLBWnZijXQ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 284/392] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Wed,  3 Dec 2025 16:27:14 +0100
Message-ID: <20251203152424.609325661@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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


